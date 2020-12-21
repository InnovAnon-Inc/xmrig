#FROM nvidia/cuda:11.1-devel-ubuntu16.04 as base
FROM nvidia/cuda:9.1-devel-ubuntu16.04 as base

MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>
LABEL version="1.0"                                                     \
      maintainer="Innovations Anonymous <InnovAnon-Inc@protonmail.com>" \
      about="Dockerized Crypto Miner"                                   \
      org.label-schema.build-date=$BUILD_DATE                           \
      org.label-schema.license="PDL (Public Domain License)"            \
      org.label-schema.name="Dockerized Crypto Miner"                   \
      org.label-schema.url="InnovAnon-Inc.github.io/docker"             \
      org.label-schema.vcs-ref=$VCS_REF                                 \
      org.label-schema.vcs-type="Git"                                   \
      org.label-schema.vcs-url="https://github.com/InnovAnon-Inc/docker"

ARG  DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND ${DEBIAN_FRONTEND}

ARG  TZ=UTC
ENV  TZ ${TZ}
ARG  LANG=C.UTF-8
ENV  LANG ${LANG}
ARG  LC_ALL=C.UTF-8
ENV  LC_ALL ${LC_ALL}

RUN apt update \
 && apt full-upgrade -y

FROM base as builder

COPY ./scripts/dpkg-dev-xmrig.list /dpkg-dev.list
RUN test -f                        /dpkg-dev.list  \
 && apt install      -y `tail -n+2 /dpkg-dev.list` \
 && rm -v                          /dpkg-dev.list

COPY ./scripts/configure-xmrig.sh /configure.sh

FROM builder as scripts
USER root

# TODO -march -mtune -U
RUN mkdir -v                /app \
 && chown -v nobody:nogroup /app
COPY            --chown=root ./scripts/healthcheck-xmrig.sh /app/healthcheck.sh
COPY            --chown=root ./scripts/entrypoint-xmrig.sh  /app/entrypoint.sh
WORKDIR                     /app
USER nobody

ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN shc -Drv -f healthcheck.sh   \
 && shc -Drv -f entrypoint.sh    \
 && test -x     healthcheck.sh.x \
 && test -x     entrypoint.sh.x

FROM builder as libuv
USER root

RUN git clone --depth=1 --recursive  \
    git://github.com/libuv/libuv.git \
                            /app     \
 && mkdir -v                /app/build                                  \
 && chown -v nobody:nogroup /app/build
WORKDIR                     /app
USER nobody

ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN cd       build                                                      \
 && /configure.sh                                                       \
 && cd       ..                                                         \
 && cmake --build build                                                 \
 && cd       build                                                      \
 && make DESTDIR=dest install                                           \
 && cd           dest                                                   \
 && tar vpacf ../dest.txz --owner root --group root .

FROM builder as lib
USER root

COPY --chown=root --from=libuv /app/build/dest.txz /dest.txz
RUN tar vxf /dest.txz -C /                \
 && rm -v   /dest.txz                     \
 && git clone --depth=1 --recursive       \
    git://github.com/xmrig/xmrig-cuda.git \
                            /app          \
 && mkdir -v                /app/build    \
 && chown -v nobody:nogroup /app/build
WORKDIR                     /app
USER nobody

ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN cd       build                                                      \
 && /configure.sh                                                       \
      -DWITH_ARGON2=OFF -DWITH_ASTROBWT=OFF -DWITH_CN_LITE=OFF          \
      -DWITH_CN_HEAVY=OFF -DWITH_CN_PICO=OFF                            \
      -DWITH_CN_R=OFF -DWITH_KAWPOW=OFF                                 \
      -DCUDA_LIB=/usr/local/cuda-9.1/targets/x86_64-linux/lib/stubs/libcuda.so \
 && cd ..                                                               \
 && cmake --build build                                                 \
 && cd            build                                                 \
 && strip --strip-unneeded libxmrig-cuda.so                             \
 && strip --strip-all      libxmrig-cu.a

FROM builder as app
USER root

COPY --chown=root --from=libuv /app/build/dest.txz /dest.txz
COPY --chown=root --from=lib   /app/build/libxmrig-cuda.so \
                               /app/build/libxmrig-cu.a    \
                               /usr/local/lib/
RUN tar vxf /dest.txz -C /           \
 && rm -v /dest.txz                  \
 && git clone --depth=1 --recursive  \
    git://github.com/xmrig/xmrig.git \
    /app                             \
 && sed -i 's/constexpr const int kMinimumDonateLevel = 1;/constexpr const int kMinimumDonateLevel = 0;/' /app/src/donate.h \
 && mkdir -v                /app/build \
 && chown -v nobody:nogroup /app/build
WORKDIR                     /app
USER nobody

ARG CFLAGS="-g0 -Ofast -ffast-math -fassociative-math -freciprocal-math -fmerge-all-constants -fipa-pta -floop-nest-optimize -fgraphite-identity -floop-parallelize-all"
ARG CXXFLAGS
ENV CFLAGS ${CFLAGS}
ENV CXXFLAGS ${CXXFLAGS}

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}

RUN cd       build                                                      \
 && /configure.sh                                                       \
      -DWITH_HWLOC=ON -DWITH_LIBCPUID=OFF                               \
      -DWITH_HTTP=OFF -DWITH_TLS=ON                                     \
      -DWITH_ASM=ON -DWITH_OPENCL=OFF -DWITH_CUDA=ON -DWITH_NVML=OFF    \
      -DWITH_DEBUG_LOG=OFF -DHWLOC_DEBUG=OFF -DCMAKE_BUILD_TYPE=Release \
      -DWITH_BENCHMARK=OFF                                              \
      -DWITH_ARGON2=OFF -DWITH_ASTROBWT=OFF -DWITH_CN_LITE=OFF          \
      -DWITH_CN_HEAVY=OFF -DWITH_CN_PICO=OFF                            \
      -DWITH_KAWPOW=OFF -DWITH_BENCHMARK=OFF                            \
 && cd ..                                                               \
 && cmake --build build                                                 \
 && cd            build                                                 \
 && strip --strip-all xmrig
#RUN upx --all-filters --ultra-brute cpuminer

#FROM nvidia/cuda:9.1-runtime-ubuntu16.04
FROM base
USER root

COPY --chown=root --from=libuv /app/build/dest.txz /dest.txz
COPY ./scripts/dpkg-xmrig.list     /dpkg.list
RUN test -f                        /dpkg.list  \
 && apt install      -y `tail -n+2 /dpkg.list` \
 && rm -v                          /dpkg.list  \
 && apt autoremove   -y         \
 && apt clean        -y         \
 && rm -rf /var/lib/apt/lists/* \
           /usr/share/info/*    \
           /usr/share/man/*     \
           /usr/share/doc/*     \
 && tar vxf /dest.txz -C /      \
 && rm -v /dest.txz
COPY --from=app --chown=root /app/build/xmrig               /usr/local/bin/
COPY --from=lib --chown=root /app/build/libxmrig-cuda.so    /usr/local/lib/

ARG COIN=xmr-cuda
ENV COIN ${COIN}
COPY "./mineconf/${COIN}.d/"   /conf.d/
VOLUME                         /conf.d
#COPY            --chown=root ./scripts/entrypoint-xmrig.sh  /usr/local/bin/entrypoint
COPY --from=scripts --chown=root /app/entrypoint.sh.x        /usr/local/bin/entrypoint

#COPY            --chown=root ./scripts/healthcheck-xmrig.sh /usr/local/bin/healthcheck
COPY --from=scripts --chown=root /app/healthcheck.sh.x        /usr/local/bin/healthcheck
HEALTHCHECK --start-period=30s --interval=1m --timeout=3s --retries=3 \
CMD ["/usr/local/bin/healthcheck"]

ARG DOCKER_TAG=generic
ENV DOCKER_TAG ${DOCKER_TAG}
COPY           --chown=root ./scripts/test.sh              /test
RUN                                                        /test test \
 && rm -v                                                  /test

#EXPOSE 4048
WORKDIR /
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD        ["default"]

