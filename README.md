repo_management
===============

A script to manage cloning repositories, updating and creating virtual environments, etc. 
Automatically maps dashes in repository/project names to underscores for better
Python compatibility.

Run the script from a directory containing project repositories. This repo, and
its scripts, can be anywhere.

Currently only compatible with Mercurial (git support to be added).

Currently designed for Python projects, and therefore will attempt to build a
virtualenv for each project if a requirements file is present.
