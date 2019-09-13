#!/bin/bash

set -e
set -x

ssh namecheap "cd ~/caribbeanwatch_repo_nonbare/ && git pull"

ssh namecheap "rsync -av --exclude=.git ~/caribbeanwatch_repo_nonbare/images/ ~/caribbeanwatch.candylab.org/images/"

