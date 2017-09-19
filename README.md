# kakoune-interactive-itersel

[kakoune](http://kakoune.org) plugin to interactively iterate over the current selections one by one.

See this [asciinema](https://asciinema.org/a/138332) for a quick demo.

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

## License

Unlicense
