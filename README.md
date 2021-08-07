# kakoune-phantom-selection

[kakoune](http://kakoune.org) plugin to work on multiple selection one by one. Just a thin wrapper around marks to solve a common use-case.

[![demo](https://asciinema.org/a/152289.png)](https://asciinema.org/a/152289)

## Setup

Add `phantom-selection.kak` to your autoload dir: `~/.config/kak/autoload/`, or source it manually.

## Usage

With multiple selections, call `phantom-selection-iterate-next` or `phantom-selection-iterate-prev`. The main selection will remain, and the others will be put in a "dormant" state (but still visible). You can then cycle back and forwards by calling these commands again.  
You can build the phantom selections using normal kakoune primitives or by calling `phantom-selection-add-selection` to add the current ones. This is useful when the selections you want do not share obvious similarities.  
Finally, calling `phantom-selection-select-all` will restore all the dormant selection, and `phantom-selection-clear` will remove them instead.  

I personally use the following mappings, since I don't find `select onto` too useful. You can use `user` mode instead of `normal`.
```
map global normal f     ": phantom-selection-add-selection<ret>"
map global normal F     ": phantom-selection-select-all; phantom-selection-clear<ret>"
map global normal <a-f> ": phantom-selection-iterate-next<ret>"
map global normal <a-F> ": phantom-selection-iterate-prev<ret>"

# this would be nice, but currrently doesn't work
# see https://github.com/mawww/kakoune/issues/1916
#map global insert <a-f> "<a-;>: phantom-selection-iterate-next<ret>"
#map global insert <a-F> "<a-;>: phantom-selection-iterate-prev<ret>"
# so instead, have an approximate version that uses 'i'
map global insert <a-f> "<esc>: phantom-selection-iterate-next<ret>i"
map global insert <a-F> "<esc>: phantom-selection-iterate-prev<ret>i"
```

## Customization

The script can be modified by changing the value of the face `PhantomSelection` (default `black,green+F`), you probably want to keep the face 'final' by setting the `+F` attribute.

## License

Unlicense
