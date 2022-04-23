face global PhantomSelection black,green+F

decl -hidden str-list phantom_selections
decl -hidden range-specs phantom_selections_ranges

addhl global/ ranges phantom_selections_ranges

def -hidden phantom-selection-store-and-highlight %{
    set window phantom_selections %reg{^}
    set window phantom_selections_ranges %val{timestamp}
    eval -no-hooks -draft -itersel %{
        set -add window phantom_selections_ranges "%val{selection_desc}|PhantomSelection"
    }
}

def -hidden phantom-selection-iterate-impl -params 1 %{
    eval -save-regs ^ %{
        reg ^ %opt{phantom_selections}

        try %{ exec <a-z>a }
        exec %arg{1}
        # keep the main selection and put all the other in the mark
        try %{
            # A proposed change to Kakoune swaps <space> with "," (and
            # <a-space> with <a-,>). Try both to make sure we clear selections
            # both with and without this breaking change. Pad them with <esc>
            # to cancel out the key with the other behavior.
            eval -draft %{
                exec -save-regs '' '<a-space><esc><a-,><esc>Z'
                phantom-selection-store-and-highlight
            }
            exec <space><esc>,<esc>
        }
    }
}

def phantom-selection-iterate-next -docstring "
Turn secondary selections into phantoms and select the next phantom
" %{
    phantom-selection-iterate-impl ')'
}

def phantom-selection-iterate-prev -docstring "
Turn secondary selections into phantoms and select the previous phantom
" %{
    phantom-selection-iterate-impl '('
}

def phantom-selection-clear -docstring "
Remove all phantom selections
" %{
    unset window phantom_selections
    unset window phantom_selections_ranges
}

def phantom-selection-select-all -docstring "
Select all phantom selections
" %{
    eval -save-regs ^ %{
        reg ^ %opt{phantom_selections}
        try %{
            exec <a-z>a
            echo ""
        }
    }
}

def phantom-selection-add-selection -docstring "
Create phantoms out of the current selections
" %{
    eval -draft -save-regs ^ %{
        reg ^ %opt{phantom_selections}
        try %{ exec "<a-z>a" }
        exec -save-regs '' "Z"
        phantom-selection-store-and-highlight
    }
}

