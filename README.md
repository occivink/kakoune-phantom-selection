# kakoune-phantom-selection

[kakoune](http://kakoune.org) plugin to work on multiple selection one by one.

[![demo](https://asciinema.org/a/TODO.png)](https://asciinema.org/a/TODO)

## Install

Add `phantom-selection.kak` to your autoload dir: `~/.config/kak/autoload/`, or source it manually.

## Usage

With multiple selections, call `phantom-sel-iterate-next` or `phantom-sel-iterate-prev`. The main selection will remain, and the others will be put in a "dormant" state (but still visible). You can then cycle back and forwards by calling these commands again.  
You can build the phantom selections using normal kakoune primitives or by calling `phantom_sel_add_selection` to add the current one. This is useful when the selections you want are heterogenous and do not share obvious similarities.  
Finally, calling `phantom-sel-select-all` will restore all the dormant selection, and `phantom-sel-clear` will remove them instead.  

The face `InteractiveItersel` can be customized (black on green background by default), and the register used (p by default) with the option `phantom_sel_register`

I suggest the following mappings:
```
map -docstring "itersel" global user r :interactive-itersel<ret>
map -docstring "itersel" global user <a-r> :interactive-itersel-clear<ret>
map global insert <a-r> "<a-;>,r" # jump to the next selection while staying in insert mode
```

Binding the iteration commands in insert mode is especially useful when you want to fill them with different content.

## License

Unlicense
