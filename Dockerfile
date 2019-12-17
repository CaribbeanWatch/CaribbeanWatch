
##############################################################################
#
#  Copyright (C) 2017-2018 Dr Adam S. Candy.
#  
#  CaribbeanWatch:  Up-to-date daily mean surface currents of the
#                   regional Caribbean Sea. By @adamcandy, TU Delft with
#                   NIOZ using data assimilation MercatorOcean, CMEMS_EU.
#  
#                   Web: https://candylab.org/caribbeanwatch
#  
#                   Contact: Dr Adam S. Candy, adam@candylab.org
#  
#  This file is part of the CaribbeanWatch project.
#  
#  Please see the AUTHORS file in the main source directory for a full list
#  of contributors.
#  
#  CaribbeanWatch is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  
#  CaribbeanWatch is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#  
#  You should have received a copy of the GNU Lesser General Public License
#  along with CaribbeanWatch. If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

# DockerFile for a CaribbeanWatch development container
ARG TRAVIS_JOB_NUMBER="undefined"
ARG repoaddress="undefined"

# Use a Xenial base image
FROM ubuntu:xenial

# This DockerFile is looked after by
MAINTAINER Adam Candy <adam@candylab.org>

# Install required packages
RUN apt-get update && apt-get install -y \
        git \
        #build-essential \
        #libnetcdf-dev \
        #netcdf-bin \
        #python-setuptools \
        #python-dev \
        python3-pip \
        python3-scipy \
        python3-numpy \
        python3-matplotlib \
				python3-mpltoolkits.basemap \
        python3-shapely \
        #python-pyproj \
        #python-gdal \
        #gdal-bin \
        #python3-imaging \
				python3-pil \
        python3-netcdf4 \
				ffmpeg \
				python3-oauth \
				python3-oauth2client \
				python3-oauthlib \
				python3-requests-oauthlib
				#\
				#texlive-full

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Upgrade pip
RUN pip3 install -i https://pypi.python.org/simple/ --upgrade pip setuptools

# Install ScientificPython
#RUN pip install --force-reinstall --ignore-installed --no-binary --no-cache-dir --no-binary :all: ScientificPython

# Update dap and shapely with recent versions
#RUN pip install Pydap==3.2.1
#RUN pip install -U geos
#RUN pip install --no-binary :all: Shapely==1.5.9
RUN pip3 install motu-client
RUN pip3 install requests_oauthlib
RUN pip3 install fiona
RUN pip3 install tweepy
RUN pip3 install cloudpickle

# Add a user
RUN adduser --disabled-password --gecos "" caribbeanwatch

# Switch user
USER caribbeanwatch
WORKDIR /home/caribbeanwatch

# Setup SSH
# https://stackoverflow.com/questions/23391839/clone-private-git-repo-with-dockerfile
RUN mkdir /home/caribbeanwatch/.ssh/
RUN echo "IdentityFile /home/caribbeanwatch/.ssh/caribbean_watch_repos" >> /home/caribbeanwatch/.ssh/config
RUN echo "IdentityFile /home/caribbeanwatch/.ssh/caribbean_watch_cache_repos" >> /home/caribbeanwatch/.ssh/config
RUN echo "IdentityFile /home/caribbeanwatch/.ssh/namecheap_candylab_updater_rsa" >> /home/caribbeanwatch/.ssh/config
RUN echo "StrictHostKeyChecking no" >> /home/caribbeanwatch/.ssh/config
COPY --chown=caribbeanwatch:caribbeanwatch namecheap_ssh_config /home/caribbeanwatch/
RUN pwd
RUN ls -lh .
RUN cat namecheap_ssh_config >> /home/caribbeanwatch/.ssh/config
COPY --chown=caribbeanwatch:caribbeanwatch caribbean_watch_repos /home/caribbeanwatch/.ssh/
COPY --chown=caribbeanwatch:caribbeanwatch caribbean_watch_cache_repos /home/caribbeanwatch/.ssh/
COPY --chown=caribbeanwatch:caribbeanwatch namecheap_candylab_updater_rsa /home/caribbeanwatch/.ssh/
RUN chmod 600 /home/caribbeanwatch/.ssh/config
RUN chmod 600 /home/caribbeanwatch/.ssh/caribbean_watch_repos
RUN chmod 600 /home/caribbeanwatch/.ssh/caribbean_watch_cache_repos
RUN chmod 600 /home/caribbeanwatch/.ssh/namecheap_candylab_updater_rsa
RUN ls -lh /home/caribbeanwatch/.ssh

# Copy across scripts
COPY --chown=caribbeanwatch:caribbeanwatch activate.sh /home/caribbeanwatch/
RUN chmod 700 /home/caribbeanwatch/activate.sh

# Set up git:
RUN git config --global user.email "adam@candylab.org" 
RUN git config --global user.name "Adam Candy"
RUN git config --global push.default matching

RUN git config --global pack.windowMemory "100m"
RUN git config --global pack.packSizeLimit "100m"
RUN git config --global pack.threads "1"

# Make a copy of the project pyRVPelagia64PE414Sababank_Current
RUN mkdir /home/caribbeanwatch/src/
RUN git clone --depth 1 --branch="current" "git@bitbucket.org:adamcandy/pyrvpelagia64pe414sababank.git" /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/
COPY --chown=caribbeanwatch:caribbeanwatch twitter_secret.py /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/mercator/twitter_secret.py

# Make a copy of the project caribbeanwatch web 
RUN mkdir /home/caribbeanwatch/src/web/
#RUN git clone --depth 1 ${repoaddress}caribbeanwatch_repo /home/caribbeanwatch/src/web/caribbeanwatch/
RUN git clone --depth 1 caribbeanwatch_repo:caribbeanwatch_repo /home/caribbeanwatch/src/web/caribbeanwatch/

#  #WORKDIR /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current
#  #RUN git pull
#  
#  ENV PATH /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#  ENV JOBID $TRAVIS_JOB_NUMBER
#  
#  #RUN /home/caribbeanwatch/src/pyRVPelagia64PE414Sababank_Current/mercator/update.py --download
#  
#  #RUN make
#  
