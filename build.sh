#!/bin/sh
OUT="redbean.com" # Change me!

RB_VERSION="2.0.15"
RB_MODE="asan-" # Memory hardening goodness for bug/exploit prevention
RB_URL="https://redbean.dev/redbean-${RB_MODE}${RB_VERSION}.com"
STOCK=".rb-${RB_MODE}${RB_VERSION}_stock.com"
ZIP_URL="https://redbean.dev/zip.com"
SQLITE_URL="https://redbean.dev/sqlite3.com"

_Fetch() {
    # $1 = target filesystem location
    # $2 = URL
    echo "Getting $1 from $2"
    if command -v wget >/dev/null 2>&1; then
        wget -qcO ".tmp" $2 || exit
    elif command -v curl >/dev/null 2>&1; then
        curl -Rso ".tmp" $2 || exit
    elif command -v fetch >/dev/null 2>&1; then
        fetch -o ".tmp" $2 || exit
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
    ../zip.com -R "../$OUT" * .*
    cd ..
}

case "$1" in
    init )
        _Init;
        ;;
    pack )
        _Pack;
        ;;
esac
