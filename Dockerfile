FROM alpine as build
RUN apk update    \
&&  apk upgrade   \
&&  apk add       \
    wget          \
    cmake         \
    alpine-sdk    \
    automake      \
    autoconf      \
    libtool       \
    linux-headers \
    bash

COPY   ./xmrig/ /xmrig
WORKDIR /xmrig/scripts

COPY ./pgo/xmrig.prof /var/teamhack/pgo/xmrig.prof

ARG NPROC

ARG  CFLAGS
ENV  CFLAGS=" $CFLAGS -fprofile-use=/var/teamhack/pgo/xmrig.prof -fprofile-abs-path"

ARG LDFLAGS
ENV LDFLAGS="$LDFLAGS -fprofile-use=/var/teamhack/pgo/xmrig.prof -fprofile-abs-path"

ARG DONATE_HOST
ARG DONATE_STRATEGY
ARG WALLET

RUN bash -eu build_deps.sh

WORKDIR /xmrig
RUN sed -i 's/--kMinimumDonateLevel = 1;/kMinimumDonateLevel = 0;/'                                                       \
  src/donate.h                                                                                                            \
&&  sed -i "s/--donate.v2.xmrig.com:3333/$DONATE_HOST/"                                                                   \
  src/core/config/Config_default.h                                                                                        \
&&  sed -i "s/--xmrig.moneroocean.stream/$DONATE_STRATEGY/"                                                               \
  src/net/strategies/DonateStrategy.cpp                                                                                   \
&&  sed -i "s/--89TxfrUmqJJcb1V124WsUzA78Xa3UYHt7Bg8RGMhXVeZYPN8cE5CZEk58Y1m23ZMLHN7wYeJ9da5n5MXharEjrm41hSnWHL/$WALLET/" \
  src/net/strategies/DonateStrategy.cpp
COPY ./Config_default.h \
  src/core/config/Config_default.h

RUN cmake -S . -B build            \
    -DXMRIG_DEPS=scripts/deps      \
    -DBUILD_STATIC=ON              \
    -DCMAKE_BUILD_TYPE=Release     \
    -DWITH_HTTP=OFF                \
    -DWITH_ENV_VARS=OFF            \
    -DWITH_OPENCL=OFF              \
    -DWITH_ADL=OFF                 \
    -DWITH_CUDA=OFF                \
    -DWITH_NVML=OFF                \
    -DWITH_MO_BENCHMARK=ON         \
    -DWITH_TLS=ON                  \
    -DWITH_EMBEDDED_CONFIG=ON      \
&&  VERBOSE=defined                \
    cmake --build build            \
&&  ldd build/xmrig

FROM scratch
COPY --from=build /xmrig/build/xmrig /xmrig
WORKDIR  /var/teamhack
ENTRYPOINT ["/xmrig"]

