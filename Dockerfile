FROM ubuntu:bionic

MAINTAINER doug.shidong@gmail.com

RUN apt-get update && apt-get -yq install \
    bzip2 \
    cmake \
    g++ \
    gcc \
    gfortran \
    git \
    gsl-bin \
    libblas-dev \
    libbz2-dev \
    libgsl-dev \
    liblapack-dev \
    libnetcdf-c++4-dev \
    libnetcdf-cxx-legacy-dev \
    libnetcdf-dev \
    numdiff \
    unzip \
    wget \
    zlib1g-dev \
    libopenmpi-dev \
    metis \
    libmetis-dev \
    libgmsh-dev \
    trilinos-all-dev \
    petsc-dev \
    slepc-dev \
    python


USER root
RUN useradd -m ddong
ENV USER ddong
ENV HOME /home/$USER
WORKDIR $HOME

RUN echo $USER
RUN ls; pwd;

RUN cd $HOME; mkdir Libraries; cd Libraries;
ENV LIBRARIES $HOME/Libraries
#
# Select the default compiler
ENV CC mpicc
ENV CXX mpicxx
ENV FC mpif90
ENV FF mpif77


# p4est installation
# See https://www.dealii.org/current/external-libs/p4est.html
ENV P4EST_DIR $LIBRARIES/p4est_install
RUN wget https://www.dealii.org/current/external-libs/p4est-setup.sh
RUN wget http://p4est.github.io/release/p4est-2.0.tar.gz
RUN chmod u+x p4est-setup.sh; ./p4est-setup.sh p4est-2.0.tar.gz $LIBRARIES/p4est_install

RUN cd $LIBRARIES; git clone https://github.com/dougshidong/dealii; 

