# -*- mode: sh; -*-
# pyv is a tool like virtualenvwrapper that uses subshells instead of virtualenvs activate/deactivate scripts
#
# Andreas Linz
# www.klingt.net

# WORKON_HOME is the path to the folder that contains the virtual environments
PYENVS=${PYENVS:-$WORKON_HOME}
# PROJECT_HOME is the path to the folder where the projects are located

pyv_check() {
    local VE='virtualenv'
    hash $VE
    if [ "$?" -ne 0 ]; then
        echo "Could not find $VE!"
        return 1
    fi
    if [ -z ${PYENVS:+PYENVS} ]; then
        echo "PYENVS envrionment variable is not set!"
        return 1
    fi
}

pyv_help() {
    echo "pyv [option] <name/path>
    Omitting the option will activate the evironment <name>.

    -l, --list      list the pyenvs in \"$PYENVS\"
    -c, --create <name> [options]
        calls \`virtualenv\` with [options] to create the pyenv <name> in \"$PYENVS\".
    -e, --exec      runs command(s) in pyenv <name>
    -r, --remove <name> [<name> ...]
        removes one or more pyenvs
    -h, --help      prints this help message
    "
}

pyv_list() {
    for D in $(ls -A $PYENVS); do
        if [ -d "$PYENVS/$D" ]; then
            echo $D
        fi
    done
}

pyv_remove() {
    for PE in "$@"; do
        if [ -n "$(pyv_list | grep -- "$PE")" ]; then
            local PYENVPATH="$PYENVS/$PE"
            if [ -d "$PYENVPATH" ]; then
                rm -rv $PYENVPATH
            else
                echo "$PYENVPATH is not a directory!"
            fi 
        else
            echo "Could not find \"$PE\" in \"$PYENVS\"!"
            return 1
        fi
    done
}

pyv_exec() {
    local PYENVPATH=''
    if [ -d "$1" ]; then
        PYENVPATH="$1"
    else
        pyv_list | grep -- "$1" > /dev/null
        if [ $? -eq 0 ]; then PYENVPATH="$PYENVS/$1"; fi
    fi
    if [ -z "$PYENVPATH" ]; then
        echo "Could not find pyenv \"$1\""
        return 1
    fi
    $SHELL -c "PATH=$PYENVPATH/bin:$PATH;\
export VIRTUAL_ENV=$1;\
${@:2}"
}

pyv_start() {
    if [ -z "$1" ]; then
        echo 'You have to specify a pyenv!'
    fi
    local PYENVPATH=''
    if [ -d "$1" ]; then
        PYENVPATH="$1"
    else
        pyv_list | grep -- "$1" > /dev/null
        if [ $? -eq 0 ]; then PYENVPATH="$PYENVS/$1"; fi
    fi
    if [ -z "$PYENVPATH" ]; then
        echo "Could not find pyenv \"$1\""
        return 1
    fi
    if [ -e $PYENVPATH/.project ]; then 
        local PROJECTPATH="$(head --lines 1 $PYENVPATH/.project)"
    fi
    $SHELL -c "PATH=$PYENVPATH/bin:$PATH;\
export VIRTUAL_ENV=$1;\
if [ -n $PROJECTPATH ]; then cd $PROJECTPATH; fi;\
$SHELL -i"
}

pyv() {
    pyv_check
    if [ $? -ne 0 ]; then return 1; fi
    case "$1" in
    "-c" | "--create")
# calls virtualenv with the first argument appended to the $PYENVS path as project path
        virtualenv ${@:3} -- "$PYENVS/$2"
        if [ -n ${PROJECT_HOME+PROJECT_HOME} ]; then
            mkdir "$PROJECT_HOME/$2"
            echo "$PROJECT_HOME/$2" > "$PYENVS/$2/.project"
        fi
        ;;
    "-l" | "--list")
        pyv_list
        ;;
    "-h" | "--help")
        pyv_help
        ;;
    "-e" | "--exec")
        pyv_exec ${@:2}
        ;;
    "-r" | "--remove")
        pyv_remove "${@:2}"
        ;;
    *)
        pyv_start "$@"
        ;;
    esac
}

#pyv $@
