#if [ `uname` == Darwin ]; then
#	# the vtk config files use some system specific libs which we have to remove
#    python $RECIPE_DIR/remove-system-libs.py $PREFIX/lib/cmake/vtk-6.3/VTKTargets.cmake
#fi


mkdir build
cd build

# Configure step
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=$PREFIX \
 -DCMAKE_BUILD_TYPE=Release \
 -DOCE_TESTING=OFF \
 -DOCE_USE_PCH=OFF \
 -DOCE_COPY_HEADERS_BUILD=ON \
 -DCMAKE_PREFIX_PATH=$PREFIX \
 -DCMAKE_SYSTEM_PREFIX_PATH=$PREFIX \
 -DOCE_INSTALL_LIB_DIR=lib \
 -DOCE_INSTALL_BIN_DIR=bin \
 -DOCE_WITH_FREEIMAGE=ON \
 -DFREEIMAGE_INCLUDE_DIR=$PREFIX/include/ \
 -DOCE_WITH_GL2PS=ON \
 -DGL2PS_INCLUDE_DIR=$PREFIX/include/ \
 -DOCE_WITH_VTK=OFF \
 -DOCE_MULTITHREAD_LIBRARY=TBB \
 -DOCE_INSTALL_PREFIX=$PREFIX -DOCE_ENABLE_DEB_FLAG=OFF ..

# Build step
ninja | grep Linking
#if [ `uname` == Darwin ]; then
  #make -j 5 | grep Built  # set to 5 on travis
#else
  #make -j $CPU_COUNT | grep Built
#fi
# Install step
ninja install > installed_files.txt
#make install > installed_files.log  # to reduce the number of lines to the console

if [ `uname` != Darwin ]; then
    python $RECIPE_DIR/remove-system-libs.py $PREFIX/lib/oce-0.18/OCE-libraries-release.cmake
else
    python $RECIPE_DIR/remove-system-libs.py $PREFIX/OCE.framework/Versions/0.18/Resources/OCE-libraries-release.cmake
fi
