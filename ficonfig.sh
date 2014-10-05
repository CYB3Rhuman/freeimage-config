#!/bin/bash

FI_VERSION=3.15.4
FI_ARCHIVE="FreeImage${FI_VERSION//./}.zip"

function fi_get {
    if [ -d "FreeImage" ]; then
        echo "FreeImage directory already exists"
    else
        if [ ! -e $FI_ARCHIVE ]; then
            wget "http://sourceforge.net/projects/freeimage/files/Source%20Distribution/$FI_VERSION/$FI_ARCHIVE"
        fi
        unzip $FI_ARCHIVE
    fi
}

function fi_build {
    if [ -d "FreeImage" ]; then
        cd FreeImage
        make clean
        make
    else
        echo "FreeImage directory not found"
    fi
}

function fi_analyze {
    if [ -d "FreeImage" ]; then
        if [ -e "FreeImage/Makefile.srcs" ] || [ -e "FreeImage/Source/Plugin.h" ]; then
            FI_LIBRARIES=$(grep INCLUDE "FreeImage/Makefile.srcs" | sed -e 's/^.*-ISource //g' \
                -e 's/-ISource\///g' -e 's/\/[A-z]*//g' -e 's/Metadata \|FreeImageToolkit //g' | \
                awk 'BEGIN{RS=ORS=" "}!a[$0]++' | tr -d '\n')
            FI_PLUGINS=$(egrep 'void DLL_CALLCONV Init.*\(Plugin \*plugin, int format_id\);' \
                "FreeImage/Source/Plugin.h" | sed -e 's/^.*Init//g' -e 's/(Plugin.*$//g' | tr '\n' ' ')
            
            echo "Libraries: $FI_LIBRARIES"
            echo "Plugins: $FI_PLUGINS"
        else
            echo "Cannot find important FreeImage files, please run 'clean' and 'get'"
        fi
    else
        echo "FreeImage directory not found"
    fi
}

function fi_clean {
    rm -rf FreeImage
    rm -f $FI_ARCHIVE
}

# interrupt on first error
set -e

# save working directory
pushd $(pwd) > /dev/null

# cd to a dir containing the script
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# do something based on first argument
case $1 in
    "get")
    fi_get;;
    "build")
    fi_build;;
    "analyze")
    fi_analyze;;
    "clean")
    fi_clean;;
    *)
    echo "usage: $0"
    echo "                      get"
    echo "                      build"
    echo "                      analyze"
    echo "                      clean";;
esac

# return to the working directory
popd > /dev/null
