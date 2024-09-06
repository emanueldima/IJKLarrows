# IJKLarrows

A Karabiner-like, key remapping utility for macOS, doing the following:
- transforms any Right Cmd+I/J/K/L keypress into a Up/Left/Down/Right Arrow keypress.
- (optionally) switches the ` and § keys

Tested on macOS Sierra, El Capitan, Sonoma.

### Build and run

Compile it with XCode and run the resulting app (with sudo).

```
swiftc -O IJKLarrows/main.swift -o arrows
./arrows
```

You may also get into XCode and build or run it from the UI.

### Options

Use the `--tilde` command line to remap the `§` key to `~` and viceversa.

You may want to run it with `nohup ./arrows &`, which will keep it running
even after the terminal ends. To kill it, use `pkill arrows`.

### Troubleshooting

If not working try to add the program in the list of applications allowed to
control the computer (Settings > Privacy and Security > Accessibility)
