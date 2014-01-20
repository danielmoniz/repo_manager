#!/bin/bash

function hello {
    local HELLO=World
    echo $HELLO
}

pip_file=pip.freeze
project_dir=../
virtualenvs="~/.virtualenvs/"
if [ -n "$WORKON_HOME" ]; then
    virtualenvs=$WORKON_HOME
fi
echo Looking for virtualenvs in: $virtualenvs
echo -------------

cd $project_dir

if [ -f "$pip_file" ]; then
    echo $pip_file file exists!
    mv $pip_file pip.freeze.bk
else
    echo $pip_file does not exist!
fi

for i in $( ls ); do
    if [ -d "$i" ]; then
        if [ -d ~/dev/virtualenvs/$i/ ]; then
                ~/dev/virtualenvs/$i/bin/pip freeze >> pip.freeze
            echo Generating pip freeze for $i...
        else
            echo $i: no virtualenv exists
        fi
    fi
done

# if pip freeze file exists, remove non-unique items from file.
if [ -f $pip_file ]; then
    vim -c "sort u|wq" $pip_file
fi

# finally, remove backup file
#rm $pip_file.bk

