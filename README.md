# vim-rwx

Simple netrw replacement

Edit a directory and use `gf` as usual, plus these:

- `cp` to copy filename under cursor
- `mv` to move filename under cursor
- `rm` to remove filename under cursor
- `mk` to `mkdir`
- `cd` to `:lcd` to the directory you're editing

These commands call `:RWX ...` which is just a wrapper around `:!...`
that refreshes the listing; `:RWX! ...` will delete any buffers in the
argument list beforehand, useful for destructive commands like `mv` and `rm`.
