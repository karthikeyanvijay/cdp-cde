FROM container.repository.cloudera.com/cloudera/dex/dex-spark-runtime-2.4.5:1.5.0-b111
USER root
RUN dnf install -y git gcc gcc-c++ make && dnf clean all && rm -rf /var/cache/dnf
RUN pip3 install --upgrade cython setuptools
RUN pip3 install pandas wheel scoring
RUN mkdir repos && \
  cd repos && \
  git clone https://github.com/apache/arrow.git && \
  pip3 install -r arrow/python/requirements-build.txt && \
  export ARROW_HOME=$(pwd)/dist && \
  export LD_LIBRARY_PATH=$(pwd)/dist/lib:$LD_LIBRARY_PATH && \
  mkdir arrow/cpp/build && \
  pushd arrow/cpp/build && \
  cmake -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DARROW_WITH_BZ2=ON \
      -DARROW_WITH_ZLIB=ON \
      -DARROW_WITH_ZSTD=ON \
      -DARROW_WITH_LZ4=ON \
      -DARROW_WITH_SNAPPY=ON \
      -DARROW_WITH_BROTLI=ON \
      -DARROW_PARQUET=ON \
      -DARROW_PYTHON=ON \
      -DARROW_BUILD_TESTS=ON \
      -DPYTHON_EXECUTABLE=/usr/bin/python3 \
      .. && \
  make -j4 && \
  make install
RUN cd /opt/spark/work-dir/repos/arrow/python && \
  export ARROW_HOME=/opt/spark/work-dir/repos/dist && \
  export LD_LIBRARY_PATH=/opt/spark/work-dir/repos/dist && \
  export PYARROW_WITH_PARQUET=1 && \
  export PYARROW_CMAKE_OPTIONS="-DCMAKE_MODULE_PATH=${ARROW_HOME} -DCMAKE_FIND_DEBUG_MODE=ON -DPYTHON_EXECUTABLE=/usr/bin/python3" && \
  python3 setup.py build_ext --build-type=release --bundle-arrow-cpp bdist_wheel
RUN pip3 install /opt/spark/work-dir/repos/arrow/python/dist/pyarrow-4.0.0*.whl && rm -rf /opt/spark/work-dir/repos
# CMake 1.13 or higher required by xgboost
RUN dnf remove cmake --noautoremove -y
RUN dnf install -y openssl-devel && dnf clean all && rm -rf /var/cache/dnf
RUN wget https://github.com/Kitware/CMake/releases/download/v3.19.6/cmake-3.19.6.tar.gz && \
  tar zxvf cmake-3.* && \
  cd cmake-3.19.6 && \
  ./bootstrap --prefix=/usr/local && \
  make -j$(nproc) && \
  make install
RUN rm -rf /opt/spark/work-dir/cmake-3.*
RUN pip3 install scikit-learn matplotlib picklable-itertools statsmodels discretize memory_profiler
# Install xgboost
ARG XGBOOST_VERSION=0.82
RUN python3 -m pip install --no-cache -I xgboost==${XGBOOST_VERSION}
USER 1345
