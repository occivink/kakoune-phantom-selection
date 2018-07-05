declare-option str phantom_sel_register p
set-face global PhantomSelection black,green

declare-option -hidden range-specs phantom_selections
declare-option -hidden str phantom_sel_buffer

define-command -hidden phantom-sel-set-option-from-mark %{
    evaluate-commands -buffer %opt{phantom_sel_buffer} "unset-option buffer phantom_selections"
    eval -draft %{
        set-option buffer phantom_selections %val{timestamp}
        exec """%opt{phantom_sel_register}z"
        eval -itersel %{
            set-option -add buffer phantom_selections "%val{selection_desc}|PhantomSelection"
        }
    }
    set-option global phantom_sel_buffer %val{bufname}
    try %{ add-highlighter window/ ranges phantom_selections }
}

define-command -hidden phantom-sel-iterate-impl -params 1 %{
    # iterate if we've already started
    try %{
        exec """%opt{phantom_sel_register}<a-z>a"
    }
    exec %arg{1}
    # keep the main selection and put all the other in the mark
    try %{
        exec -draft -save-regs '' "<a-space>""%opt{phantom_sel_register}Z"
        exec <space>
        phantom-sel-set-option-from-mark
    }
}

define-command phantom-sel-iterate-next -docstring "
Turn secondary selections into phantoms and select the next phantom
" %{
    phantom-sel-iterate-impl )
}

define-command phantom-sel-iterate-prev -docstring "
Turn secondary selections into phantoms and select the previous phantom
" %{
    phantom-sel-iterate-impl (
}

define-command phantom-sel-clear -docstring "
Remove all phantom selections
" %{
    set-register %opt{phantom_sel_register} ''
    eval -buffer %opt{phantom_sel_buffer} "unset-option buffer phantom_selections"
    set-option global phantom_sel_buffer ''
    unset-option buffer phantom_selections
    remove-highlighter window/hlranges_phantom_selections
}

define-command phantom-sel-select-all -docstring "
Select all phantom selections
" %{
    try %{
        exec """%opt{phantom_sel_register}<a-z>a"
        echo
    }
}

define-command phantom-sel-add-selection -docstring "
Create phantoms out of the current selections
" %{
    eval -draft -save-regs '' %{
        try %{ exec """%opt{phantom_sel_register}<a-z>a" }
        exec """%opt{phantom_sel_register}Z"
    }
    phantom-sel-set-option-from-mark
}
