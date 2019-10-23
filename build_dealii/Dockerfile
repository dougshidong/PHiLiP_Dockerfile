FROM dougshidong/dealii:latest
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

RUN cd $LIBRARIES; git clone https://github.com/dougshidong/PHiLiP; cd PHiLiP; mkdir build_release; cd build_release; cmake ../ -DDEAL_II_DIR=$LIBRARIES/dealii/install; make;
