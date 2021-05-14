FROM ubuntu:18.04

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' sources.list

RUN apt-get update && \
    apt-get install -y git wget unzip libglib2.0-dev libeina-dev \
    qemu-user qemu-user-static build-essential  \
    libtool-bin python automake bison vim

RUN useradd -u 1001 -m -d /home/afl afl
WORKDIR /home/afl
RUN git clone https://github.com/google/AFL.git
ADD afltimeout.sh /home/afl/AFL
RUN chown -R afl:afl /home/afl

WORKDIR /home/afl/AFL
RUN make
RUN cd qemu_mode && ./build_qemu_support.sh
RUN make install

#WORKDIR /home/afl
#RUN git clone https://github.com/pwndbg/pwndbg.git
#WORKDIR /home/afl/pwndbg
#RUN ./setup.sh

USER afl
WORKDIR /home/afl/

ENTRYPOINT ["./AFL/afltimeout.sh"]
