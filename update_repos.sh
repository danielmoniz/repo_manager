#!/bin/bash

managed_projects=$( cat $0/../managed_projects.txt )
projects_dir=$( pwd )
hg_remote=https://hg.points.com/hgweb.cgi/
main_branch=dev_head
if [ ! -n "$WORKON_HOME" ]; then
    echo "Requires virtualenvwrapper. Install before continuing."
    exit
fi
virtualenvs=$WORKON_HOME

unclean_repos=()

prepare_virtualenv () {
    local repo_norm=$1
    local virtualenvs=$2
    local branch=$3

    # fill in with virtualenv code from below
}

for repo in $managed_projects; do
    echo --- $repo ---
    repo_norm=${repo//-/_}
    if [ ! -d "$repo" ] && [ ! -d $repo_norm ]; then
        echo "No repository present. Cloning..."
        hg clone $hg_remote$repo
        # replace - with _ for Python path compatibility
        mv $repo $repo_norm
        echo Moved $repo into $repo_norm

        # prepare new environment - should be own bash script!
        cd $virtualenvs
        virtualenv $repo_norm
        source $repo_norm/bin/activate
        pip install pip==1.4.1 # temporary fix for pip 1.5 with our cheeseshop
        cd -
        cd $repo_norm
        hg update $main_branch
        if [ -f "requirements.txt" ]; then
            requirements_file=requirements.txt
        elif [ -f "requirements/development.txt" ]; then 
            requirements_file=requirements/development.txt
        elif [ -f "requirements/base.txt" ]; then 
            requirements_file=requirements/base.txt
        fi
        if [ -n "$requirements_file" ]; then
            pip install -r $requirements_file
        else
            echo No requirements file found. Skipping pip install.
        fi
        deactivate
        
        cd $projects_dir
    fi
    cd $repo_norm
    if [ -f c ]; then
        rm c
    fi
    repo_status=$( hg status )
    repo_status_first_column=( $( hg status | cut -c 1 ) )
    if [ "$repo_status" = "" ] || [ "${repo_status_first_column}" = "?" ]; then
        echo -n Pulling and updating $repo...
        hg pull -uq 
        echo Done.
    else
        echo Not pulling repo $repo, repository is not clean.
        unclean_repos+=($repo_norm)
    fi
    cd $projects_dir
done

echo -------

if [ ! "$unclean_repos" = "" ]; then
    echo The following repos are unclean and were not updated:
    printf '%s\n' "${unclean_repos[@]}"
else
    echo All repositories pulled and updated.
fi
