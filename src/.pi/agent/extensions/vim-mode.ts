/**
 * Vim Mode Extension
 *
 * Full vim-style modal editing for pi's input editor.
 *
 * Modes:
 *   INSERT  - Normal text input (default)
 *   NORMAL  - Vim navigation and commands
 *
 * Normal mode commands:
 *   Navigation:
 *     h/j/k/l     - left/down/up/right
 *     w/b         - word forward/backward
 *     e           - end of word
 *     0/^         - line start
 *     $           - line end
 *     gg          - start of buffer
 *     G           - end of buffer
 *
 *   Insert:
 *     i           - insert at cursor
 *     a           - append after cursor
 *     A           - append at end of line
 *     I           - insert at start of line
 *     o           - open line below
 *     O           - open line above
 *
 *   Delete:
 *     x           - delete char forward
 *     X           - delete char backward
 *     D           - delete to end of line
 *     dd          - delete line
 *     dw          - delete word forward
 *     db          - delete word backward
 *     d$          - delete to end of line
 *     d0          - delete to start of line
 *
 *   Change:
 *     C           - change to end of line
 *     cc/S        - change entire line
 *     cw          - change word forward
 *     cb          - change word backward
 *     c$          - change to end of line
 *     c0          - change to start of line
 *
 *   Other:
 *     u           - undo
 *     p           - paste (yank)
 *     r<char>     - replace char under cursor
 *
 *   Newline (insert mode):
 *     Ctrl+J      - insert newline (works in all terminals)
 *
 * Toggle vim mode: /vim or Ctrl+Alt+V
 */

import { CustomEditor, type ExtensionAPI, type ExtensionContext } from "@mariozechner/pi-coding-agent";
import { matchesKey, truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";

// Terminal escape sequences
const SEQ = {
	left: "\x1b[D",
	right: "\x1b[C",
	up: "\x1b[A",
	down: "\x1b[B",
	home: "\x1b[H",
	end: "\x1b[F",
	delete: "\x1b[3~",
	backspace: "\x7f",
	wordRight: "\x1bf",    // alt+f
	wordLeft: "\x1bb",     // alt+b
	deleteWordFwd: "\x1bd", // alt+d
	deleteWordBwd: "\x17",  // ctrl+w
	deleteToEnd: "\x0b",    // ctrl+k
	deleteToStart: "\x15",  // ctrl+u
	undo: "\x1f",           // ctrl+_ (ctrl+-)
	yank: "\x19",           // ctrl+y
	newline: "\x1b[13;2u",  // shift+enter (kitty protocol)
} as const;

type Mode = "normal" | "insert";
type PendingOp = "d" | "c" | "g" | "r" | null;

class VimEditor extends CustomEditor {
	private mode: Mode = "insert";
	private pending: PendingOp = null;

	private insertNewLine(): void {
		// Call addNewLine() directly on Editor — bypasses terminal sequence issues
		(this as any).addNewLine();
	}

	handleInput(data: string): void {
		// Escape: insert → normal, normal → pass through (abort agent etc.)
		if (matchesKey(data, "escape")) {
			if (this.mode === "insert") {
				this.mode = "normal";
				this.pending = null;
				return;
			}
			this.pending = null;
			super.handleInput(data);
			return;
		}

		// Ctrl+J inserts newline in both modes (universal, works in tmux)
		if (matchesKey(data, "ctrl+j")) {
			if (this.mode === "normal") {
				// In normal mode, behave like 'o' — open line below
				super.handleInput(SEQ.end);
				this.insertNewLine();
				this.mode = "insert";
			} else {
				this.insertNewLine();
			}
			return;
		}

		// Insert mode: pass everything through to default editor
		if (this.mode === "insert") {
			super.handleInput(data);
			return;
		}

		// Normal mode
		this.handleNormalMode(data);
	}

	private handleNormalMode(data: string): void {
		// Handle pending operator + motion
		if (this.pending === "r") {
			this.handleReplace(data);
			return;
		}

		if (this.pending === "g") {
			this.handleGPending(data);
			return;
		}

		if (this.pending === "d") {
			this.handleDeleteMotion(data);
			return;
		}

		if (this.pending === "c") {
			this.handleChangeMotion(data);
			return;
		}

		// Single-key commands
		switch (data) {
			// Navigation
			case "h": super.handleInput(SEQ.left); return;
			case "j": super.handleInput(SEQ.down); return;
			case "k": super.handleInput(SEQ.up); return;
			case "l": super.handleInput(SEQ.right); return;
			case "w": super.handleInput(SEQ.wordRight); return;
			case "b": super.handleInput(SEQ.wordLeft); return;
			case "e": super.handleInput(SEQ.wordRight); return; // approximate
			case "0": super.handleInput(SEQ.home); return;
			case "^": super.handleInput(SEQ.home); return;
			case "$": super.handleInput(SEQ.end); return;
			case "G": {
				// Go to end: press down many times (approximate with end-of-buffer)
				for (let i = 0; i < 1000; i++) super.handleInput(SEQ.down);
				super.handleInput(SEQ.end);
				return;
			}

			// Enter insert mode
			case "i":
				this.mode = "insert";
				return;
			case "a":
				this.mode = "insert";
				super.handleInput(SEQ.right);
				return;
			case "A":
				this.mode = "insert";
				super.handleInput(SEQ.end);
				return;
			case "I":
				this.mode = "insert";
				super.handleInput(SEQ.home);
				return;
			case "o":
				super.handleInput(SEQ.end);
				this.insertNewLine();
				this.mode = "insert";
				return;
			case "O":
				super.handleInput(SEQ.home);
				this.insertNewLine();
				super.handleInput(SEQ.up);
				this.mode = "insert";
				return;

			// Delete
			case "x": super.handleInput(SEQ.delete); return;
			case "X": super.handleInput(SEQ.backspace); return;
			case "D": super.handleInput(SEQ.deleteToEnd); return;

			// Change
			case "C":
				super.handleInput(SEQ.deleteToEnd);
				this.mode = "insert";
				return;
			case "S":
				super.handleInput(SEQ.home);
				super.handleInput(SEQ.deleteToEnd);
				this.mode = "insert";
				return;

			// Other
			case "u": super.handleInput(SEQ.undo); return;
			case "p": super.handleInput(SEQ.yank); return;

			// Pending operators
			case "d": this.pending = "d"; return;
			case "c": this.pending = "c"; return;
			case "g": this.pending = "g"; return;
			case "r": this.pending = "r"; return;

			default:
				// Pass control sequences (ctrl+c, etc.) through, ignore printable chars
				if (data.length === 1 && data.charCodeAt(0) >= 32) return;
				super.handleInput(data);
				return;
		}
	}

	private handleReplace(data: string): void {
		this.pending = null;
		if (data.length === 1 && data.charCodeAt(0) >= 32) {
			super.handleInput(SEQ.delete);
			super.handleInput(data);
			super.handleInput(SEQ.left);
		}
	}

	private handleGPending(data: string): void {
		this.pending = null;
		if (data === "g") {
			// gg - go to start of buffer
			for (let i = 0; i < 1000; i++) super.handleInput(SEQ.up);
			super.handleInput(SEQ.home);
		}
		// Any other key after g is ignored
	}

	private handleDeleteMotion(data: string): void {
		this.pending = null;
		switch (data) {
			case "d":
				// dd - delete line
				super.handleInput(SEQ.home);
				super.handleInput(SEQ.deleteToEnd);
				// Also delete the newline if possible
				super.handleInput(SEQ.delete);
				return;
			case "w": super.handleInput(SEQ.deleteWordFwd); return;
			case "b": super.handleInput(SEQ.deleteWordBwd); return;
			case "$": super.handleInput(SEQ.deleteToEnd); return;
			case "0": super.handleInput(SEQ.deleteToStart); return;
			default: return; // Invalid motion, cancel
		}
	}

	private handleChangeMotion(data: string): void {
		this.pending = null;
		switch (data) {
			case "c":
				// cc - change line
				super.handleInput(SEQ.home);
				super.handleInput(SEQ.deleteToEnd);
				this.mode = "insert";
				return;
			case "w":
				super.handleInput(SEQ.deleteWordFwd);
				this.mode = "insert";
				return;
			case "b":
				super.handleInput(SEQ.deleteWordBwd);
				this.mode = "insert";
				return;
			case "$":
				super.handleInput(SEQ.deleteToEnd);
				this.mode = "insert";
				return;
			case "0":
				super.handleInput(SEQ.deleteToStart);
				this.mode = "insert";
				return;
			default: return; // Invalid motion, cancel
		}
	}

	render(width: number): string[] {
		const lines = super.render(width);
		if (lines.length === 0) return lines;

		// Add mode indicator to bottom border
		const label = this.mode === "normal"
			? (this.pending ? ` NORMAL (${this.pending}) ` : " NORMAL ")
			: " INSERT ";
		const last = lines.length - 1;
		if (visibleWidth(lines[last]!) >= label.length + 2) {
			lines[last] = truncateToWidth(lines[last]!, width - label.length, "") + label;
		}
		return lines;
	}
}

export default function (pi: ExtensionAPI) {
	let enabled = true;

	function updateStatus(ctx: ExtensionContext): void {
		if (enabled) {
			ctx.ui.setStatus("vim-mode", ctx.ui.theme.fg("accent", "vim"));
		} else {
			ctx.ui.setStatus("vim-mode", undefined);
		}
	}

	function toggle(ctx: ExtensionContext): void {
		enabled = !enabled;
		if (enabled) {
			ctx.ui.setEditorComponent((tui, theme, kb) => new VimEditor(tui, theme, kb));
			ctx.ui.notify("Vim mode enabled", "info");
		} else {
			ctx.ui.setEditorComponent(undefined);
			ctx.ui.notify("Vim mode disabled", "info");
		}
		updateStatus(ctx);
	}

	pi.registerCommand("vim", {
		description: "Toggle vim mode",
		handler: async (_args, ctx) => toggle(ctx),
	});

	pi.registerShortcut("ctrl+alt+v", {
		description: "Toggle vim mode",
		handler: async (ctx) => toggle(ctx),
	});

	pi.on("session_start", async (_event, ctx) => {
		if (enabled) {
			ctx.ui.setEditorComponent((tui, theme, kb) => new VimEditor(tui, theme, kb));
		}
		updateStatus(ctx);
	});
}
