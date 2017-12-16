declare-option str phantom_selection_register p
set-face PhantomSelection black,green

declare-option -hidden range-specs phantom_selections

define-command -hidden phantom-sel-set-option-from-mark %{
    eval "set-option buffer phantom_selections \%sh{
        printf \%s \"$kak_reg_%opt{phantom_selection_register}\" | sed -e 's/\([:@]\)/|PhantomSelection\1/g' -e 's/\(.*\)@.*\%\(.*\)/\2:\1/'
    }"
}

define-command -hidden phantom-sel-iterate-impl -params ..1 %{
    try %{
        execute-keys "\"%opt{phantom_selection_register}<a-z>a"
        execute-keys %arg{1}
        set-register %opt{phantom_selection_register} ''
        phantom-sel-iterate-impl
    } catch %{
        try %{
            execute-keys -draft -save-regs '' "<a-space>\"%opt{phantom_selection_register}Z"
            execute-keys <space>
            phantom-sel-set-option-from-mark
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
    set-register %opt{phantom_selection_register} ''
    unset-option buffer phantom_selections
    remove-highlighter window/hlranges_phantom_selections
}

define-command phantom-sel-select-all %{
    try %{
        execute-keys "\"%opt{phantom_selection_register}<a-z>a"
        echo
    }
}

define-command phantom-sel-add-selection %{
    evaluate-commands -draft -save-regs '' %{
        try %{ execute-keys "\"%opt{phantom_selection_register}<a-z>a" }
        execute-keys "\"%opt{phantom_selection_register}Z"
    }
    phantom-sel-set-option-from-mark
    try %{ add-highlighter window ranges phantom_selections }
}
