FROM hombit/mesa-src:12778-python3.7-stretch

RUN apt-get update &&\
    apt-get install -y python3-pip python3-setuptools &&\
    apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/* &&\
    truncate -s 0 /var/log/*log

RUN pip3 install numpy cython

RUN sed -i'' -e 's/FCstatic =/FCstatic = -fPIC/' /mesa/utils/makefile_header
RUN echo "SPECIAL_C_FLAGS = -fPIC" >> /mesa/utils/makefile_header

env MESASDK_ROOT=/mesasdk
env MESA_DIR=/mesa

COPY call_mesa_script.sh setup.py /mesa2py/
WORKDIR /mesa2py
RUN python3 setup.py buildmesa

COPY . /mesa2py
RUN python3 setup.py install
RUN python3 test.py
