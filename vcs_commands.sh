echo Version control commands imported.

# branch name, vcs type
update_branch () {
    echo Updating branch...
    branch=$1
    if [ ! -n "$2" ]; then
        local version_control="hg"
    else
        local version_control=$2
    fi

    if [ $version_control == "hg" ]; then
        hg update $branch
    elif [ $version_control == "git" ]; then
        git checkout $branch
    else
        echo Unknown version control: \"$version_control\"
    fi
}

# remote repo, vcs type
clone_repo () {
    echo Cloning repo...
    if [ -n "$2" ]; then
        local version_control=$2
    else
        local version_control=$version_control
    fi
    $version_control clone $1
}

