## NEO-TREE
From your Neo-tree kickstart configuration, here are the default shortcuts available:

When Neo-tree is focused:

1. Toggle hidden files:
- `H` - Toggle hidden files/dotfiles
- `.` - Toggle hidden files (alternative)

2. File operations:
- `a` - Add a file or directory
- `d` - Delete
- `r` - Rename
- `c` - Copy
- `m` - Move
- `y` - Copy name to clipboard
- `Y` - Copy relative path to clipboard
- `gy` - Copy absolute path to clipboard
- `<enter>` or `o` - Open file/folder
- `s` - Open file in split
- `v` - Open file in vertical split

3. Navigation:
- `<C-x>` - Close node
- `<C-v>` - Open in vertical split
- `<C-s>` - Open in horizontal split
- `<C-t>` - Open in new tab
- `<` - Navigate to previous source
- `>` - Navigate to next source

4. Filesystem operations:
- `A` - Add directory
- `/` - Start fuzzy finder
- `#` - Fuzzy sorter
- `D` - Delete (with confirmation)

5. Tree manipulation:
- `<BS>` - Close node
- `z` - Close all nodes
- `Z` - Close all nodes recursively
- `R` - Refresh

6. Opening/Closing:
- `<leader>e` - Toggle Neo-tree (from anywhere in Vim)
- `q` - Close Neo-tree window
- `<Esc>` - Close Neo-tree window

To see all available mappings while in Neo-tree, you can press `?` to open the help menu.

## GENERAL

- `<C-f>` in command mode lets you edit the command with normal/insert modes

- `<C-a>` in insert mode pastes the last text you inserted. Useful when you can’t perfectly fit the . command on all occurrences

- `cis` changes the current sentence. Helps a lot in editing paragraphs of text. Doesn't work well with code (see comment below by u/Cid227)

- `o` and <S-O> adds a new line after/before the current line. This was the wow command for me

- `!motion` will put you in the command mode with the range captured in the motion. You can then type a cmdline command and it will filter the range through. Example: sorting a list of a method arguments, each separated on an individual line (in command mode) !i(sort

- `!!` similar to above, but on the current line only

- `_` is the same as the carret, takes you the first character on the line

- `ZZ` (save and close) and ZQ (close without saving) sped up my workflow significantly. Can be applied on splits

- `Apply` a macro (e.g. q) on a selected range using :’<,’> norm @q

- `:s/old/new/gc` will ask you before replacing each occurrence. Super useful when refactoring big files

- `<C-o>` in insert mode for executing a single norrmal mode command

- `<C-o>` in normal mode last jump

- `gi` last insert, `gv` last visual, `g;` last place, `g,` next place --> changes 

- `+` next line first character `-` previos line first character
