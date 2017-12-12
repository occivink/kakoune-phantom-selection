# kakoune-interactive-itersel

[kakoune](http://kakoune.org) plugin to interactively iterate over the current selections one by one.

[![demo](https://asciinema.org/a/138332.png)](https://asciinema.org/a/138332)

## Install

Add `interactive-itersel.kak` to your autoload dir: `~/.config/kak/autoload/`, or source it manually.

## Usage

With multiple selections, call `interactive-itersel`. The first selection will remain, and the others will be put in a "dormant" state (but still visible). Then, it is possible to iterate over all the dormant selections by simply calling `interactive-itersel` again.
Calling `interactive-itersel-clear` will remove all the dormant selections.

The face `InteractiveItersel` can be customized (black on green background by default).

I suggest the following mappings:
```
map -docstring "itersel" global user r :interactive-itersel<ret>
map -docstring "itersel" global user <a-r> :interactive-itersel-clear<ret>
map global insert <a-r> "<a-;>,r" # jump to the next selection while staying in insert mode
```

## Trivia

This was suggested as a primitive by @rouanth on 2017-01-19
([#1115](https://github.com/mawww/kakoune/issues/1115))
and was followed by an implementation by patching the kakoune source code
([#1116](https://github.com/mawww/kakoune/pull/1116)).
The suggested keybinding in the patch was `^`.

* [#1115](https://github.com/mawww/kakoune/issues/1115): Binding to copy selections vertically to equal substrings
* [#1116](https://github.com/mawww/kakoune/pull/1116): Keybinding for copying selections on matching substrings vertically

## License

Unlicense
