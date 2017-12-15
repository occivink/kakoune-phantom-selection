set-face PhantomSelection black,green
declare-option -hidden range-specs phantom_selections

define-command -hidden phantom-sel-set-option-from-marks %{
    set-option buffer phantom_selections %sh{
        printf %s "$kak_reg_s" | sed -e 's/\([:@]\)/|PhantomSelection\1/g' -e 's/\(.*\)@.*%\(.*\)/\2:\1/'
    }
}

define-command -hidden phantom-sel-iterate-impl -params ..1 %{
    try %{
        execute-keys \"s<a-z>a
        execute-keys %arg{1}
        set-register s ''
        phantom-sel-iterate-impl
    } catch %{
        try %{
            execute-keys -draft -save-regs '' <a-space>\"sZ
            execute-keys <space>
            phantom-sel-set-option-from-marks
            add-highlighter window ranges phantom_selections
        }
    }
}

define-command phantom-sel-iterate-next %{
    phantom-sel-iterate-impl \'
}

define-command phantom-sel-iterate-prev %{
    phantom-sel-iterate-impl <a-'>
}

define-command phantom-sel-clear %{
    try %{
        execute-keys \"s<a-z>a
        echo
        set-register s ''
        unset-option buffer phantom_selections
        remove-highlighter window/hlranges_phantom_selections
    }
}

define-command phantom-sel-append %{
    evaluate-commands -draft -save-regs '' %{
        try %{ execute-keys \"s<a-z>a }
        execute-keys \"sZ
    }
    phantom-sel-set-option-from-marks
    try %{ add-highlighter window ranges phantom_selections }
}
