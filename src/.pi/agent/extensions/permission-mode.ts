/**
 * Permission Mode Extension
 *
 * Claude Code-style permission system with three modes:
 * - Confirm: Confirm bash, write, edit (read always allowed)
 * - Allow Edits: Auto-approve write/edit, confirm bash only
 * - YOLO: No confirmations
 *
 * Bash commands can be "allowed always" by prefix for the session.
 * Cycle modes with /permission or Ctrl+Shift+M.
 */

import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

type PermissionMode = "confirm" | "allow-edits" | "yolo";

const MODE_LABELS: Record<PermissionMode, string> = {
	confirm: "Confirm",
	"allow-edits": "Allow Edits",
	yolo: "YOLO",
};

const MODES: PermissionMode[] = ["confirm", "allow-edits", "yolo"];

function extractCommandPrefix(command: string): string {
	// Get the first word/binary of a command as the prefix
	// Handles pipes, &&, semicolons — takes the first segment
	const trimmed = command.trim();
	const firstSegment = trimmed.split(/[|;&]/).at(0)?.trim() ?? trimmed;
	const parts = firstSegment.split(/\s+/);
	return parts[0] ?? trimmed;
}

function matchesAllowedPrefix(command: string, allowedPrefixes: Set<string>): boolean {
	const trimmed = command.trim();
	for (const prefix of allowedPrefixes) {
		if (trimmed === prefix || trimmed.startsWith(prefix + " ") || trimmed.startsWith(prefix + "\t")) {
			return true;
		}
	}
	return false;
}

export default function (pi: ExtensionAPI) {
	let mode: PermissionMode = "confirm";
	let allowedBashPrefixes = new Set<string>();

	function updateStatus(ctx: ExtensionContext): void {
		const theme = ctx.ui.theme;
		const label = MODE_LABELS[mode];
		const color = mode === "yolo" ? "error" : mode === "allow-edits" ? "warning" : "success";
		ctx.ui.setStatus("permission-mode", theme.fg(color, `🔒 ${label}`));
	}

	function cycleMode(ctx: ExtensionContext): void {
		const currentIndex = MODES.indexOf(mode);
		mode = MODES[(currentIndex + 1) % MODES.length];
		allowedBashPrefixes = new Set();
		ctx.ui.notify(`Permission mode: ${MODE_LABELS[mode]}`, "info");
		updateStatus(ctx);
	}

	// Command to cycle or set mode
	pi.registerCommand("permission", {
		description: "Cycle permission mode (Confirm → Allow Edits → YOLO)",
		getArgumentCompletions: (prefix: string) => {
			const items = MODES.map((m) => ({ value: m, label: `${m} — ${MODE_LABELS[m]}` }));
			const filtered = items.filter((i) => i.value.startsWith(prefix));
			return filtered.length > 0 ? filtered : null;
		},
		handler: async (args, ctx) => {
			if (args && MODES.includes(args as PermissionMode)) {
				mode = args as PermissionMode;
				allowedBashPrefixes = new Set();
				ctx.ui.notify(`Permission mode: ${MODE_LABELS[mode]}`, "info");
				updateStatus(ctx);
			} else {
				cycleMode(ctx);
			}
		},
	});

	// Keyboard shortcut
	pi.registerShortcut("ctrl+shift+m", {
		description: "Cycle permission mode",
		handler: async (ctx) => cycleMode(ctx),
	});

	// Show status on session start
	pi.on("session_start", async (_event, ctx) => {
		mode = "confirm";
		allowedBashPrefixes = new Set();
		updateStatus(ctx);
	});

	// Permission gate
	pi.on("tool_call", async (event, ctx) => {
		// Read is always allowed
		if (event.toolName === "read" || event.toolName === "grep" || event.toolName === "find" || event.toolName === "ls") {
			return undefined;
		}

		// YOLO mode: allow everything
		if (mode === "yolo") {
			return undefined;
		}

		// Allow Edits mode: auto-approve write and edit
		if (mode === "allow-edits" && (event.toolName === "write" || event.toolName === "edit")) {
			return undefined;
		}

		// Non-interactive mode: block by default
		if (!ctx.hasUI) {
			return { block: true, reason: "Blocked: no UI for confirmation (non-interactive mode)" };
		}

		// Build the prompt based on tool type
		let description: string;

		if (isToolCallEventType("bash", event)) {
			const command = event.input.command;

			// Check if this command prefix is already allowed
			if (matchesAllowedPrefix(command, allowedBashPrefixes)) {
				return undefined;
			}

			description = `bash: ${command}`;

			// Bash gets Y/n/a (allow always)
			const prefix = extractCommandPrefix(command);
			const choice = await ctx.ui.select(`⚡ ${description}`, [
				"Yes — allow once",
				"No — block",
				`Always — allow \`${prefix}\` for this session`,
			]);

			if (choice?.startsWith("Always")) {
				allowedBashPrefixes.add(prefix);
				return undefined;
			} else if (choice?.startsWith("Yes")) {
				return undefined;
			} else {
				return { block: true, reason: "Blocked by user" };
			}
		}

		if (isToolCallEventType("write", event)) {
			description = `write: ${event.input.path}`;
		} else if (isToolCallEventType("edit", event)) {
			description = `edit: ${event.input.path}`;
		} else {
			// Unknown tool — confirm
			description = `${event.toolName}`;
		}

		// Write/edit/other get Y/n
		const ok = await ctx.ui.confirm("Allow?", description);
		if (!ok) {
			return { block: true, reason: "Blocked by user" };
		}

		return undefined;
	});
}
