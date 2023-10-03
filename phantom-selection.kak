provide-module phantom-selection %{

set-face global PhantomSelection black,green+F

declare-option -hidden str-list phantom_selections
declare-option -hidden range-specs phantom_selections_ranges

add-highlighter global/ ranges phantom_selections_ranges

define-command -hidden phantom-selection-store-and-highlight %{
    set window phantom_selections %reg{^}
    set window phantom_selections_ranges %val{timestamp}
    eval -no-hooks -draft -itersel %{
        set -add window phantom_selections_ranges "%val{selection_desc}|PhantomSelection"
    }
}

define-command -hidden phantom-selection-iterate-impl -params 1 %{
    eval -save-regs ^ %{
        reg ^ %opt{phantom_selections}
        try %{
            exec z
            exec %arg{1}
            # keep the main selection and put all the other in the mark
            # a recent change to Kakoune swaps <space> with "," (and
            # <a-space> with <a-,>). Try both to make sure we clear selections
            # both with and without this breaking change. Pad them with <esc>
            # to cancel out the key with the other behavior.
            exec -save-regs '' 'Z'
            phantom-selection-store-and-highlight
            exec '<space><esc><,><esc>'
        } catch %{
            fail 'No phantom selections'
        }
    }
}

define-command phantom-selection-iterate-next -docstring "
Turn secondary selections into phantoms and select the next phantom
" %{
    phantom-selection-iterate-impl ')'
}

define-command phantom-selection-iterate-prev -docstring "
Turn secondary selections into phantoms and select the previous phantom
" %{
    phantom-selection-iterate-impl '('
}

define-command phantom-selection-clear -docstring "
Remove all phantom selections
" %{
    unset window phantom_selections
    unset window phantom_selections_ranges
}

define-command phantom-selection-select-all -docstring "
Select all phantom selections
" %{
    eval -save-regs ^ %{
        reg ^ %opt{phantom_selections}
        try %{
            exec z
            echo ""
        } catch %{
            fail 'No phantom selections'
        }
    }
}

define-command phantom-selection-add-selection -docstring "
Create phantoms out of the current selections
" %{
    eval -draft -save-regs ^ %{
        reg ^ %opt{phantom_selections}
        try %{ exec "<a-z>a" }
        exec -save-regs '' "Z"
        phantom-selection-store-and-highlight
    }
}

}

require-module phantom-selection
