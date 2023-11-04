# dotfiles

## Usage

Install dependencies

```
brew bundle install --file Brewfile
```

Run dot.py - it'll traverse the `./src` directory and symlink everything into `$HOME`

```
./dot
```

## Extras

Somethings can't be symlinked in like browser extention settings. You'll find those in `./extra`
