declare-option str phantom_sel_register p
set-face PhantomSelection black,green

declare-option -hidden range-specs phantom_selections
declare-option -hidden str phantom_sel_buffer

define-command -hidden phantom-sel-set-option-from-mark %{
    evaluate-commands -buffer %opt{phantom_sel_buffer} "unset-option buffer phantom_selections"
    eval -draft %{
        set-option buffer phantom_selections %val{timestamp}
        exec "\"%opt{phantom_sel_register}z"
        eval -itersel %{
            set-option -add buffer phantom_selections "%val{selection_desc}|PhantomSelection"
        }
    }
    set-option global phantom_sel_buffer %val{bufname}
    try %{ add-highlighter window ranges phantom_selections }
}

define-command -hidden phantom-sel-iterate-impl -params 1 %{
    # iterate if we've already started
    try %{
        execute-keys "\"%opt{phantom_sel_register}<a-z>a"
        execute-keys %arg{1}
    }
    # keep the main selection and put all the other in the mark
    try %{
        execute-keys -draft -save-regs '' "<a-space>\"%opt{phantom_sel_register}Z"
        execute-keys <space>
        phantom-sel-set-option-from-mark
    }
}

define-command phantom-sel-iterate-next %{
    phantom-sel-iterate-impl \'
}

define-command phantom-sel-iterate-prev %{
    phantom-sel-iterate-impl <a-'>
}

define-command phantom-sel-clear %{
    set-register %opt{phantom_sel_register} ''
    evaluate-commands -buffer %opt{phantom_sel_buffer} "unset-option buffer phantom_selections"
    set-option global phantom_sel_buffer ''
    unset-option buffer phantom_selections
    remove-highlighter window/hlranges_phantom_selections
}

define-command phantom-sel-select-all %{
    try %{
        execute-keys "\"%opt{phantom_sel_register}<a-z>a"
        echo
    }
}

define-command phantom-sel-add-selection %{
    evaluate-commands -draft -save-regs '' %{
        try %{ execute-keys "\"%opt{phantom_sel_register}<a-z>a" }
        execute-keys "\"%opt{phantom_sel_register}Z"
    }
    phantom-sel-set-option-from-mark
}
