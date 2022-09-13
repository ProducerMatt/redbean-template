#!/bin/sh
# /*─────────────────────────────────────────────────────────────────╗
# │ To the extent possible under law, Matthew Pherigo has waived     │
# │ all copyright and related or neighboring rights to this file,    │
# │ as it is written in the following disclaimers:                   │
# │   • http://unlicense.org/                                        │
# ╚─────────────────────────────────────────────────────────────────*/
OUT="redbean.com" # Change me!
OUT_CMD="./${OUT}" # called with "build.sh run"

#OUT_CMD="./${OUT} -SSS" # extra-sandboxed version of redbean
# NOTE: https://redbean.dev/#security

RB_VERSION="2.0.18"

# Use default redbean if on M1 Mac. Else use ASAN
# NOTE(ProducerMatt): This code block exists because of ASAN crashes on M1.
# Once they're fixed we can go back to default ASAN on all systems.
if which arch 2>/dev/null && [ "$(arch)" != "x86_64" ]; then
    RB_MODE= # default
else
    RB_MODE="asan-" # Memory hardening goodness for bug/exploit prevention
fi
# leave RB_MODE empty for default, or use one of tiny-, asan-, original-,
# static-, unsecure-, original-tinylinux-

RB_URL="https://redbean.dev/redbean-${RB_MODE}${RB_VERSION}.com"
STOCK=".rb-${RB_MODE}${RB_VERSION}_stock.com"
ZIP_URL="https://redbean.dev/zip.com"
SQLITE_URL="https://redbean.dev/sqlite3.com"
DEFINITIONS_URL="https://raw.githubusercontent.com/jart/cosmopolitan/d76dfadc7a0a9a5b7500d697e15a64c70d53eb12/tool/net/definitions.lua"

_Fetch() {
    # $1 = target filesystem location
    # $2 = URL
    echo "Getting $1 from $2"
    if command -v wget >/dev/null 2>&1; then
        wget -NqcO ".tmp" $2 || exit
    elif command -v curl >/dev/null 2>&1; then
        curl -so ".tmp" -z ".tmp" $2 || exit
    elif command -v fetch >/dev/null 2>&1; then
        fetch -mo ".tmp" $2 || exit
    else echo "No downloaders!"; exit 1;
    fi
    mv -f ".tmp" $1
}
_Init () {
    u=`umask`;
    umask 222;
    _Fetch "$STOCK" "$RB_URL";
    _Fetch "zip.com" "$ZIP_URL";
    chmod +x "zip.com"
    _Fetch "sqlite.com" "$SQLITE_URL";
    chmod +x "sqlite.com"
    mkdir -m 755 -p definitions
    _Fetch "definitions/redbean.lua" "$DEFINITIONS_URL"
    umask $u;
}
_Pack () {
    # TODO: skip if no changed files in srv since last update?
    #       test if directory exists and has anything in it, if not fail
    cp -f $STOCK $OUT
    chmod u+w $OUT
    chmod +x $OUT

    # NOTE: zip's structure is dependent on the relative paths of the files.
    #       so calling from the root of the source file's directory is important
    #       if you want files like `.lua` to be in the right place.
    cd srv/
    ../zip.com -r "../$OUT" `ls -A`
    cd ..
}
_Clean () {
    rm -f zip.com sqlite.com $STOCK $OUT definitions/redbean.lua .tmp
    [ "$(ls -A definitions)" ] || rm -rf definitions
}

case "$1" in
    init )
        _Init;
        ;;
    pack )
        _Pack;
        ;;
    run )
        _Pack;
        exec $OUT_CMD;
        ;;
    clean )
        _Clean;
        ;;
    * )
        echo "a builder for redbean projects"
        echo "- '$0 init': fetch redbean, zip and sqlite"
        echo "- '$0 pack': pack "./srv/" into a new redbean, overwriting the old"
        echo "- '$0 run': pack, then execute with a customizable command"
        echo "- '$0 clean': delete all downloaded and generated files"
        ;;
esac
