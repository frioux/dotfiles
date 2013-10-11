# Str class can count on bpan.bash

shopt -s expand_aliases

Str:methods() {
    echo chomp empty? len trim
}

# Str s=abc
Str() {
    [ -z "$1" ] && die

    local name="$1"
    local value="$2"
    if [[ "$name" =~ \= ]]; then
        local tmp="$name"
        name="${tmp%%=*}"
        value="${tmp#*=}"
    fi
    eval "$name=\"$value\""

    local method
    for method in `Str:methods`; do
        eval "alias $name.$method='Str:$method \"\$$name\"'"
    done
}

Str:len() {
    local s="$1"
    echo ${#s}
}

Str:empty?() {
    [ -z "$1" ] && echo true || echo false
}

Str:chomp() {
    echo -n $1
}
