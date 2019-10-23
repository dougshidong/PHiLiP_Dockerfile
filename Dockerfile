FROM ubuntu:bionic

MAINTAINER doug.shidong@.com

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

RUN pwd; 
RUN echo $USER;
RUN echo $HOME; 
RUN echo $LIBRARIES; 
RUN apt search trilinos;
RUN dpkg -L trilinos-dev

RUN apt search metis;
RUN cd $LIBRARIES/dealii; ls; mkdir build; cd build; \
    cmake ../ \
    -DCMAKE_INSTALL_PREFIX=$LIBRARIES/dealii/install \
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_CXX_FLAGS="-Wno-suggest-override -pthread" \
    -DCMAKE_C_FLAGS="-pthread" \
    -DCMAKE_Fortran_COMPILER= \
    -DDEAL_II_ALLOW_BUNDLED=ON \
    -DDEAL_II_WITH_MPI=ON \
    -DDEAL_II_WITH_METIS=ON \
    -DDEAL_II_WITH_HDF5=OFF \
    -DDEAL_II_WITH_TRILINOS=ON \
    -DDEAL_II_WITH_P4EST=ON \
    -DDEAL_II_COMPONENT_EXAMPLES=OFF 
#ninja-build \
#   mpich \
#libmpich-dev \
#   mpich \

RUN cd $LIBRARIES/dealii/build; make -j3; make -j3 install;

RUN cd $LIBRARIES; git clone https://github.com/dougshidong/PHiLiP; cd PHiLiP; mkdir build_release; cd build_release; cmake ../ -DDEAL_II_DIR=$LIBRARIES/dealii/install; make -j2;
