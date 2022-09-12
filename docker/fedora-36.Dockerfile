#
# dockerfile for pmemhackathon
#
# Note: After making any changes to files within this directory you have to rebuild
#       the image:
#
# $ sudo docker build -t pmemhackathon/fedora-36 -f ./fedora-36.Dockerfile .
#

FROM fedora:36

LABEL maintainer="andy.rudoff@intel.com"

# Base development packages
ARG BASE_DEPS="\
	bash-completion \
	clang \
	cmake \
	emacs \
	gcc \
	gcc-c++ \
	git-all \
	make \
	nano \
	vim-enhanced"

# pmem's Valgrind dependencies
ARG VALGRIND_DEPS="\
	autoconf \
	automake"

# memkind's dependencies
ARG MEMKIND_DEPS="\
	autoconf \
	automake \
	numactl \
	numactl-devel"

# PMDK's dependencies
ARG PMDK_DEPS="\
	autoconf \
	automake \
	daxctl-devel \
	man \
	ndctl-devel \
	pandoc \
	python3 \
	rpm-build \
	rpm-build-libs \
	rpmdevtools \
	which"

# libpmemobj-cpp's dependencies
ARG LIBPMEMOBJ_CPP_DEPS="\
	doxygen \
	libatomic \
	tbb-devel"

# Dependencies for compiling pmemkv and pmemkv bindings
ARG PMEMKV_DEPS="\
	java-1.8.0-openjdk-devel \
	nodejs \
	npm \
	python3-devel \
	rapidjson-devel \
	ruby-devel \
	tbb-devel \
	xmvn"

# librpma's dependencies
ENV RPMA_DEPS "\
	iproute \
	iputils \
	librdmacm-utils \
	net-tools \
	rdma-core-devel"

RUN dnf update -y \
 && dnf install -y \
	${BASE_DEPS} \
	${VALGRIND_DEPS} \
	${MEMKIND_DEPS} \
	${PMDK_DEPS} \
	${LIBPMEMOBJ_CPP_DEPS} \
	${PMEMKV_DEPS} \
	${RPMA_DEPS}\
	bc \
	bind-utils \
	binutils \
	file \
	findutils \
	fuse \
	fuse-devel \
	gdb \
	glib2-devel \
	golang \
	lbzip2 \
	libtool \
	libunwind-devel \
	ncurses-devel \
	openssh-server \
	passwd \
	perl-Text-Diff \
	pkgconf \
	rsync \
	strace \
	sudo \
	tar \
	unzip \
	wget \
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

RUN rm /pmdk.sh /valgrind.sh /pmemobj-cpp.sh /pmemkv.sh /setup-maven-settings.sh \
	/pmemkv-java.sh /pmemkv-python.sh /pmemkv-nodejs.sh /pmemkv-ruby.sh /memkind.sh /librpma.sh
