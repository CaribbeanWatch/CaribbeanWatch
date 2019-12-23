#!/bin/bash

set -e
set -x

# Pull latest data - already there?
ssh caribbeanwatch_repo "cd ~/caribbeanwatch_repo_nonbare/ && git pull"

# Transfer latest image and animations to live space
ssh caribbeanwatch_repo "rsync -av --exclude=.git ~/caribbeanwatch_repo_nonbare/images/ ~/caribbeanwatch.candylab.org/images/"

# Clean up cache repo
ssh caribbeanwatch_repo "~/clear_history-caribbeanwatch_cache"

