#!/bin/bash

FI_VERSION=3.16.0
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
    "clean")
    fi_clean;;
    *)
    echo "usage: $0 get | clean";;
esac

# return to the working directory
popd > /dev/null
