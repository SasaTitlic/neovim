# Vim Regular Expression Cheat Sheet

## Basic Patterns
- `.`     - Any single character
- `*`     - Match 0 or more of previous character
- `\+`    - Match 1 or more of previous character
- `\?`    - Match 0 or 1 of previous character
- `\{n,m}` - Match between n and m of previous character
- `^`     - Start of line
- `$`     - End of line
- `\<`    - Start of word
- `\>`    - End of word

## Character Classes
- `[abc]`   - Match any of these characters
- `[^abc]`  - Match any character except these
- `[a-z]`   - Match any lowercase letter
- `[A-Z]`   - Match any uppercase letter
- `[0-9]`   - Match any digit
- `\w`      - Word character [a-zA-Z0-9_]
- `\W`      - Non-word character
- `\d`      - Digit [0-9]
- `\D`      - Non-digit
- `\s`      - Whitespace (space, tab)
- `\S`      - Non-whitespace

## Grouping and References
- `\(pattern\)`  - Capture group
- `\1` to `\9`   - Back reference to captured group
- `\|`          - Alternation (OR)
- `\(\)`        - Empty group
- `\(pattern\)\+` - Group occurs one or more times

## Special Pattern Modifiers
- `\c`    - Case insensitive
- `\C`    - Case sensitive
- `\v`    - Very magic (more regex-like syntax)
- `\V`    - Very nomagic (literal matching)
- `\m`    - Magic (default)
- `\M`    - Nomagic

## Common Usage Patterns

### Search Commands
```vim
/pattern       " Search forward
?pattern       " Search backward
/pattern/e     " Move cursor to end of match
/pattern/+2    " Move cursor 2 lines after match
```

### Substitution
```vim
:%s/old/new/         " Replace first occurrence on each line
:%s/old/new/g        " Replace all occurrences
:%s/old/new/gc       " Replace with confirmation
:%s/old/new/gi       " Replace all, case insensitive
```

### Examples

```vim
" Match word boundaries
/\<word\>

" Case insensitive search
/\cpattern

" Capture and swap
:%s/\(foo\)\(bar\)/\2\1/g

" Match empty lines
/^$

" Match lines with only whitespace
/^\s*$

" Match word with optional 's'
/words\?

" Match either 'foo' or 'bar'
/foo\|bar

" Match whole word 'vim' case insensitive
/\c\<vim\>
```

## Tips
1. Use `\v` (very magic) at the start of pattern to make regex more familiar:
   ```vim
   /\v(foo|bar)      " Instead of /\(foo\|bar\)
   ```

2. Use `\V` (very nomagic) to match literally:
   ```vim
   /\V<.>            " Matches literal '<.>' not 'any character'
   ```

3. Common Substitutions:
   ```vim
   :%s/\s\+$//       " Remove trailing whitespace
   :%s/^\n\+/\r/     " Remove multiple blank lines
   :%s/\r//g         " Remove Windows carriage returns
   ```
# Understanding Nested Capture Groups in Vim

## Basic Structure
Capture groups in very magic mode (`\v`) are created using parentheses `()`. When nesting these groups, each opening parenthesis creates a new group number, counted from left to right.

## Numbering Rule
Groups are numbered based on the position of their opening parenthesis `(` from left to right, regardless of nesting level.

## Examples

### Simple Nesting
```vim
/\v((foo)(bar))

Group numbering:
1. ((foo)(bar))  - captures 'foobar'
2. (foo)         - captures 'foo'
3. (bar)         - captures 'bar'

Usage:
:%s/\v((foo)(bar))/\2-\3/g    
" 'foobar' becomes 'foo-bar'
```

### Email Pattern
```vim
/\v(([a-z]+)@([a-z]+)\.com)

Group numbering:
1. (([a-z]+)@([a-z]+)\.com)  - captures 'user@domain.com'
2. ([a-z]+)                  - captures 'user'
3. ([a-z]+)                  - captures 'domain'

Usage:
:%s/\v(([a-z]+)@([a-z]+)\.com)/[\3]:\2/g
" 'user@domain.com' becomes '[domain]:user'
```

### Complex Nesting
```vim
/\v(((\w+):)(\w+))

Group numbering:
1. (((\w+):)(\w+))  - captures 'key:value'
2. ((\w+):)         - captures 'key:'
3. (\w+)            - captures 'key'
4. (\w+)            - captures 'value'

Usage:
:%s/\v(((\w+):)(\w+))/\3=\4/g
" 'key:value' becomes 'key=value'
```

### HTML Tag Pattern
```vim
/\v(<(\w+)([^>]*>.*</\2)>)

Group numbering:
1. (<(\w+)([^>]*>.*</\2)>)  - captures entire tag
2. (\w+)                     - captures tag name
3. ([^>]*>.*</\2)           - captures attributes and content

Usage:
:%s/\v(<(\w+)([^>]*>.*</\2)>)/[\2]\3/g
" '<div class="foo">content</div>' becomes '[div] class="foo">content</div>'
```

## Best Practices

1. Keep nesting shallow when possible
2. Use meaningful groups that you plan to reference
3. Comment your regex patterns for complex captures
4. Test with `:s///p` first (prints what would change without making changes)

## Common Pitfalls

1. Forgetting group numbers start from the left
2. Not escaping special characters when needed
3. Assuming groups are numbered by nesting depth
4. Using too many capture groups when some aren't needed
