FROM ubuntu:13.04
MAINTAINER Suguru Kato

# install fuse https://gist.github.com/henrik-muehe/6155333
RUN apt-get install -y libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

RUN apt-get install -y wget
RUN cd /tmp; wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1304/x86_64/cuda-repo-ubuntu1304_6.0-37_amd64.deb
RUN cd /tmp; dpkg -i cuda-repo-ubuntu1304_6.0-37_amd64.deb
RUN apt-get update
RUN apt-get install -y cuda

ENV PATH /usr/local/cuda/bin:$PATH
CMD cd /src; nvcc sample.cu; ./a.out
