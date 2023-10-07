FROM alpine as build
RUN apk update
RUN apk upgrade
RUN apk add wget cmake alpine-sdk automake autoconf libtool linux-headers bash

COPY   ./xmrig/ /xmrig
WORKDIR /xmrig/scripts

ARG NPROC

ARG  CFLAGS
ENV  CFLAGS=" $CFLAGS -fprofile-generate=/var/teamhack/pgo/aircrack-ng.prof -fprofile-abs-path -fuse-linker-plugin -flto -momit-leaf-frame-pointer -Ofast -g0 -fmerge-all-constants -fomit-frame-pointer -ftree-parallelize-loops=$NPROC"

ARG LDFLAGS
ENV LDFLAGS="$LDFLAGS -fprofile-generate=/var/teamhack/pgo/aircrack-ng.prof -fprofile-abs-path -fuse-linker-plugin -flto -fmerge-all-constants -fomit-frame-pointer -ftree-parallelize-loops=$NPROC -lgcov"

RUN bash -eu build_deps.sh

ARG DONATE_HOST
ARG DONATE_STRATEGY
ARG WALLET

WORKDIR /xmrig
RUN sed -i 's/--kMinimumDonateLevel = 1;/kMinimumDonateLevel = 0;/' \
  src/donate.h
RUN sed -i "s/--donate.v2.xmrig.com:3333/$DONATE_HOST/"             \
  src/core/config/Config_default.h
RUN sed -i "s/--xmrig.moneroocean.stream/$DONATE_STRATEGY/"         \
  src/net/strategies/DonateStrategy.cpp
RUN sed -i "s/--89TxfrUmqJJcb1V124WsUzA78Xa3UYHt7Bg8RGMhXVeZYPN8cE5CZEk58Y1m23ZMLHN7wYeJ9da5n5MXharEjrm41hSnWHL/$WALLET/" \
  src/net/strategies/DonateStrategy.cpp
COPY ./Config_default.h \
  src/core/config/Config_default.h

RUN cmake -S . -B build            \
  -DXMRIG_DEPS=scripts/deps        \
  -DBUILD_STATIC=ON                \
  -DCMAKE_BUILD_TYPE=Release       \
  -DWITH_HTTP=OFF                  \
  -DWITH_ENV_VARS=OFF              \
  -DWITH_OPENCL=OFF                \
  -DWITH_ADL=OFF                   \
  -DWITH_CUDA=OFF                  \
  -DWITH_NVML=OFF                  \
  -DWITH_MO_BENCHMARK=ON           \
  -DWITH_TLS=ON                    \
  -DWITH_EMBEDDED_CONFIG=ON
RUN VERBOSE=defined cmake --build build

FROM scratch
COPY --from=build /xmrig/build/xmrig /
WORKDIR  /var/teamhack
VOLUME ["/var/teamhack/pgo"]
ENTRYPOINT ["/xmrig"]

