try %{
    require-module phantom-selection
} catch %{
    source phantom-selection.kak
    require-module phantom-selection
}

define-command assert-selections-are -params 2 %{
    eval %sh{
        if [ "$1" != "$kak_quoted_selections" ]; then
            printf 'fail "Check %s failed"\n' "$2"
        fi
    }
}

edit -scratch *phantom-selection-test-1*
exec ifoo<space>bar<space>baz<esc>
exec '%s\w+<ret>'
phantom-selection-add-selection

phantom-selection-iterate-next
assert-selections-are "'foo'" 1
phantom-selection-iterate-next
assert-selections-are "'bar'" 2
phantom-selection-iterate-next
assert-selections-are "'baz'" 3
phantom-selection-iterate-next
assert-selections-are "'foo'" 4

phantom-selection-iterate-prev
assert-selections-are "'baz'" 5
phantom-selection-iterate-prev
assert-selections-are "'bar'" 6
phantom-selection-iterate-prev
assert-selections-are "'foo'" 7

phantom-selection-select-all
assert-selections-are "'foo' 'bar' 'baz'" 8

exec 'gg'
# all operations should be noop after clearing
phantom-selection-clear
assert-selections-are "'f'" 9
phantom-selection-iterate-next
assert-selections-are "'f'" 10
phantom-selection-iterate-prev
assert-selections-are "'f'" 11
phantom-selection-select-all
assert-selections-are "'f'" 12

delete-buffer
