# IJKLarrows

A Karabiner-like, key remapping utility for macOS, doing the following:
- transforms any Right Cmd+I/J/K/L keypress into a Up/Left/Down/Right Arrow keypress.
- (optionally) switches the ` and § keys

Tested on macOS Sierra, El Capitan, Sonoma.

Usage: compile it with XCode and run the resulting app (with sudo).

```
swiftc -O IJKLarrows/main.swift -o arrows
./arrows
```

Options:
use the `--tilde` command line to remap the `§` key to `~` and viceversa.

You may want to run it with `nohup ./arrows &`, which will keep it running
even after the terminal ends. To kill it, use `pkill arrows`.
