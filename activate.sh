#!/bin/bash

set -e
set -x

ssh caribbeanwatch_repo "cd ~/caribbeanwatch_repo_nonbare/ && git pull"

ssh caribbeanwatch_repo "rsync -av --exclude=.git ~/caribbeanwatch_repo_nonbare/images/ ~/caribbeanwatch.candylab.org/images/"


