PROGNAME=${0##*/}
if [ $(($#)) -lt 1 ] ; then
    echo "$PROGNAME: make Microsoft and Borland import libraries from a dll"
    echo "Usage: $PROGNAME dllname.dll -l libname -d deffile"
    exit 1
fi

function dumpargs
{
    for dd in "$@"; do
        eval echo "$dd =	\\\"\$$dd\\\""
    done
}

DLLNAME=$1
shift

while getopts ":d:l:" opt; do
    case $opt in
        d) DEFNAME="$OPTARG" ;;
		l) LIBNAME="$OPTARG" ;;
        \?) ;;
    esac
done
shift $(($OPTIND -1))

LIBNAME=${LIBNAME:-${DLLNAME%.dll}}
LIBNAME=${LIBNAME%.a}
LIBNAME=${LIBNAME%.dll}
DEFNAME=${DEFNAME:-${DLLNAME%.dll}}
DEFNAME=${DEFNAME%.def}
# echo $DEFNAME
if ! [ -s $DLLNAME ]; then
    echo "Error: Dynamic library $DLLNAME does not exist."
    exit 1
fi
# echo DLLNAME: $DLLNAME
# Build MSVC import library
echo "Creating Microsoft import library: $LIBNAME.lib"
DEFNAME=$DEFNAME.def
if ! [ -s $DEFNAME ]; then
     pexports $DLLNAME > $DEFNAME	
fi
if ! [ -s $DEFNAME ]; then
       echo "Error: Definition file $DEFNAME does not exist."
	exit 1
fi
if type -p lib.exe >/dev/null ; then
#dumpargs LIBNAME DEFNAME DLLNAME
    lib.exe /VERBOSE /MACHINE:I386 /DEF:$DEFNAME /OUT:$LIBNAME.lib /NAME:$DLLNAME
    rm -f $LIBNAME.exp
else
    echo "Error: lib.exe not found"
fi

# Build Borland CC import library
echo 
echo "Creating Borland import library: $LIBNAME-bcc.lib"
# strip dash of version number
#DLLNONAME=${DLLNAME%.dll}
#DLLNONAME=$(echo $DLLNONAME | tr -d "-").dll
#if ! [ "$DLLNAME" = "$DLLNONAME" ]; then
#	cp -fp $DLLNAME $DLLNONAME
#fi
PATH=/cygdrive/e/progra~1/borland/bcc/bin:$PATH
if type -p implib.exe >/dev/null ; then
#    impdef $LIBNAME-bcc.def $DLLNONAME
#	sed -i.bak -e "/@/s/ *\([^ ]*\) *@.*; */_\1=/" $LIBNAME-bcc.def
    implib.exe -a -c -f $LIBNAME-bcc.lib $DLLNAME
#	coff2omf.exe $LIBNAME.lib $LIBNAME-bcc.lib
else
    echo "implib.exe not found"
fi
