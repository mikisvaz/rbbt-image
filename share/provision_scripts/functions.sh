_var_content(){
    var=$1
    eval echo "$"$(echo $var)
}

_append_with_colon(){
    var=$1
    value=$2

    current=`_var_content $var`

    if ! echo $current | grep "\(^\|:\)$value\(:\|$\)" >/dev/null 2>&1; then
        eval $(echo $var)="\"$current:$value\""
    fi
}

_append_with_space(){
    var=$1
    value=$2

    current=`_var_content $var`

    if ! echo $current | grep "\(^\| \)$value\( \|$\)" >/dev/null 2>&1; then
        eval $(echo $var)="\"$current:$value\""
    fi
}

_prepend_with_colon(){
    var=$1
    value=$2

    current=`_var_content $var`

    if ! echo $current | grep "\(^\|:\)$value\(:\|$\)" >/dev/null 2>&1; then
        eval $(echo $var)="\"$value:$current\""
    fi
}

_prepend_with_space(){
    var=$1
    value=$2

    current=`_var_content $var`

    if ! echo $current | grep "\(^\| \)$value\( \|$\)" >/dev/null 2>&1; then
        eval $(echo $var)="\"$value $current\""
    fi
}

_add_path(){
  _prepend_with_colon PATH "${1%/}"
}

_add_libpath(){
  _prepend_with_colon LD_LIBRARY_PATH "${1%/}"
  _prepend_with_colon LD_RUN_PATH "${1%/}"
}

