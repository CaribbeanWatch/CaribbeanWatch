
test2:
	docker run -v $(PWD)/tmp/output:/home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/output -v $(PWD)/tmp/cache:/home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/cache -w /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/ -a stdout -t caribbeanwatch /bin/bash -c 'git pull; /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/mercator/update.py -j 1 -r curacao-daily'

test:
	docker run -v /Users/asc/src/CaribbeanWatch/tmp/output:/home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/output -v /Users/asc/src/CaribbeanWatch/tmp/cache:/home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/cache -w /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/ -a stdout -t caribbeanwatch /bin/bash -c 'git pull; /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/mercator/update.py -j 1 -r caribbean_basin-ssh-daily'

build:
	docker build -t caribbeanwatch -f ./Dockerfile .

update:
	docker run -v $(PWD)/tmp/output:/home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/output -v $(PWD)/tmp/cache:/home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/cache -w /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/ -a stdout -t caribbeanwatch git pull

store.tar.enc:
	@echo Ensure logged into travis with: travis login --org
	travis whoami
	cp -p ~/.common/.ssh/caribbean_watch_repos  ~/.common/.ssh/caribbean_watch_cache_repos  ~/.common/.ssh/candylab-updater  ~/.common/.ssh/namecheap_candylab_updater_rsa  ~/.common/.twitterapi/twitter_secret.py ~/.common/config/cmems/cmems_secret.py ~/.common/config/travis/namecheap_ssh_config .
	tar cpf store.tar caribbean_watch_repos caribbean_watch_cache_repos candylab-updater namecheap_candylab_updater_rsa twitter_secret.py cmems_secret.py namecheap_ssh_config
	rm caribbean_watch_repos caribbean_watch_cache_repos candylab-updater namecheap_candylab_updater_rsa twitter_secret.py cmems_secret.py namecheap_ssh_config
	travis encrypt-file store.tar
	rm store.tar

.PHONY: store.tar.enc

