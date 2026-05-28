# NeoVim

Code editor within your terminal!

This can be installed with winget:

```powershell
winget install neovim.neovim
```

## VI Mode in PSReadLine

This provides VI like keyboard shortcuts in your terminal!

```powershell
Set-PSReadLineOption -EditMode Vi
```

✅ How Vi Mode Works in PowerShell

Vi mode gives you two modes:

1. Insert Mode

This is the normal typing mode.

You start here by default.

Same as typing into Vim after pressing i.

2. Command Mode (Normal Mode)

Hit Esc to enter it.

Now your keystrokes act like Vim commands.

Examples:

Navigation
Key	Action
h / j / k / l	left / down / up / right
b	back one word
w	forward one word
0	start of line
$	end of line
Editing
Key	Action
x	delete character under cursor
dw	delete word
dd	delete the entire line
u	undo the last action
p	paste deleted text
Switching back

i → insert mode at cursor

a → append after cursor

I → insert at beginning of line

A → insert at end of line

🔥 Best Part: Vim Search + History

You can use / to search your command history, just like searching a file in Vim.

Example:

Press Esc

Hit /

Type a command fragment

Press Enter

Navigate through matches with n and N

This is legitimately powerful.











## Plugins

https://github.com/junegunn/vim-plug

## Notes

### Open and edit
nvim .\script.ps1     # open a file
nvim .                # open a directory (file explorer)

Core motions:

Insert: i (before), A (end of line), o (new line below)

Save/Quit: :w save, :q quit, :wq save+quit, :q! discard

Edit: dd delete line, yy yank line, p paste, u undo, Ctrl+r redo

Move: h j k l, w/b word jump, 0/$ line start/end, gg/G file top/bottom

Search: /text then n/N next/prev

Select: v (char), V (line); then y copy or d cut

Splits/buffers:

:vsplit / :split

:bn / :bp next/prev buffer, :bd close buffer

### Make PowerShell life easier (tiny config)

Create an init file:

ni -Force $env:LOCALAPPDATA\nvim\init.lua
nvim $env:LOCALAPPDATA\nvim\init.lua

Paste this minimal setup:

-- ~/.config/nvim/init.lua  (Windows: $env:LOCALAPPDATA\nvim\init.lua)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"   -- use Windows clipboard
vim.opt.mouse = "a"

-- file explorer on <Space>e
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":Ex<CR>")

-- better PS1 syntax (plugin) - optional:
-- 1) install vim-plug (one-time):
--    iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni -Path $env:LOCALAPPDATA\nvim\autoload\plug.vim -Force
-- 2) add below, save, then run :PlugInstall inside nvim
vim.cmd([[
call plug#begin()
Plug 'PProvost/vim-ps1'
call plug#end()
]])

Then (inside Neovim) run:

:PlugInstall

### Make it easy to launch from PowerShell

Add to your PowerShell profile:

notepad $PROFILE

Put:

Set-Alias vi nvim
Set-Alias vim nvim
$env:EDITOR = 'nvim'
function e { param([Parameter(ValueFromRemainingArguments)]$Path) if ($Path){ nvim @Path } else { nvim } }

Now:

vi .\script.ps1
e .

### Quick workflows you’ll actually use

Go to line: :42<Enter>

Find/replace (file): :%s/old/new/g

Format JSON quick (inside nvim): select with V… then :!jq .

Open last edit spot: ` (backtick) then . (or gi to insert at last edit)

If you want linting/IntelliSense later, we can wire up the PowerShell LSP— but this is enough to be productive today.
