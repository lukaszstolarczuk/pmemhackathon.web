#
# dockerfile for pmemhackathon, fc30 based
#
# Note: After making any changes to files within this directory you have to rebuild
#       the image:
#
# $ sudo docker build -t pmemhackathon/pmemfc30:09 -f ./docker/Dockerfile ./docker/
#

FROM fedora:30

LABEL maintainer="andy.rudoff@intel.com"

ENV RPMA_DEPS "\
	iproute \
	iputils \
	librdmacm-utils \
	net-tools \
	rdma-core-devel"

RUN dnf update -y \
 && dnf install -y \
	${RPMA_DEPS} \
	autoconf\
	automake\
	bash-completion\
	bc\
	bind-utils\
	binutils\
	clang\
	cmake\
	daxctl-devel\
	doxygen\
	emacs\
	file\
	findutils\
	fuse\
	fuse-devel\
	gcc\
	gcc-c++\
	gdb\
	git-all\
	glib2-devel\
	golang\
	lbzip2\
	libatomic\
	libtool\
	libudev-devel\
	libunwind-devel\
	make\
	man\
	nano\
	ncurses-devel\
	ndctl-devel\
	numactl-devel\
	java-1.8.0-openjdk\
	openssh-server\
	pandoc\
	passwd\
	perl-Text-Diff\
	pkgconfig\
	python3-devel\
	rapidjson-devel\
	rpm-build\
	rpm-build-libs\
	rpmdevtools\
	rsync\
	ruby-devel\
	strace\
	tar\
	tbb-devel\
	unzip\
	vim-enhanced\
	wget\
	which\
	xmvn\
 && curl -sL https://rpm.nodesource.com/setup_10.x | bash - \
 && dnf install -y nodejs \
 && dnf debuginfo-install -y glibc \
 && dnf clean all

COPY pmdk.sh /
RUN /pmdk.sh

COPY valgrind.sh /
RUN /valgrind.sh

COPY memkind.sh /
RUN /memkind.sh

COPY pmemobj-cpp.sh /
RUN /pmemobj-cpp.sh

COPY pmemkv.sh /
RUN /pmemkv.sh

# Prepare extra maven params
# It's executed and its result is exported within 'pmemkv-java.sh'
COPY setup-maven-settings.sh /setup-maven-settings.sh

COPY pmemkv-java.sh /
RUN /pmemkv-java.sh

COPY pmemkv-python.sh /
RUN /pmemkv-python.sh

COPY pmemkv-nodejs.sh /
RUN /pmemkv-nodejs.sh

COPY pmemkv-ruby.sh /
RUN /pmemkv-ruby.sh

COPY librpma.sh /
RUN /librpma.sh

COPY tz.sh /
RUN /tz.sh

RUN rm /pmdk.sh /valgrind.sh /pmemobj-cpp.sh /pmemkv.sh /setup-maven-settings.sh /pmemkv-java.sh /pmemkv-python.sh /pmemkv-nodejs.sh /pmemkv-ruby.sh /memkind.sh /librpma.sh /tz.sh
