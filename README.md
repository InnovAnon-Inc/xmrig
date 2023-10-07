# xmrig [![xmrig](https://github.com/InnovAnon-Inc/xmrig/actions/workflows/pkgrel.yml/badge.svg)](https://github.com/InnovAnon-Inc/xmrig/actions/workflows/pkgrel.yml)
Dockerized Builder for Statically-Linked XMRig with Embedded Config using XMRig-Proxy
==========
[![License Summary](https://img.shields.io/github/license/InnovAnon-Inc/xmrig?color=%23FF1100&label=Free%20Code%20for%20a%20Free%20World%21&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://tldrlegal.com/license/unlicense#summary)
[![Latest Release](https://img.shields.io/github/commits-since/InnovAnon-Inc/xmrig/latest?color=%23FF1100&include_prereleases&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://github.com/InnovAnon-Inc/xmrig/releases/latest)
[![Lines of Code](https://tokei.rs/b1/github/InnovAnon-Inc/xmrig?category=code&color=FF1100&logo=InnovAnon-Inc&logoColor=FF1133&style=plastic)](https://github.com/InnovAnon-Inc/xmrig)
[![Repo Size](https://img.shields.io/github/repo-size/InnovAnon-Inc/xmrig?color=%23FF1100&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://github.com/InnovAnon-Inc/xmrig)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/InnovAnon-Inc/xmrig?color=FF1100&logo=InnovAnon-Inc&logoColor=FF1133&style=plastic)](https://www.codefactor.io/repository/github/InnovAnon-Inc/xmrig)

![Dependent repos (via libraries.io)](https://img.shields.io/librariesio/dependent-repos/pypi/xmrig?color=FF1100&style=plastic)
![Libraries.io dependency status for latest release](https://img.shields.io/librariesio/release/pypi/xmrig?color=FF1100&style=plastic)
![Libraries.io SourceRank](https://img.shields.io/librariesio/sourcerank/pypi/xmrig?style=plastic)
![Libraries.io dependency status for GitHub repo](https://img.shields.io/librariesio/github/InnovAnon-Inc/xmrig?color=FF1100&logoColor=FF1133&style=plastic)

[![Tip Me via PayPal](https://img.shields.io/badge/paypal-donate-FF1100.svg?logo=paypal&logoColor=FF1133&style=plastic)](https://www.paypal.me/InnovAnon)

-----

- Select the crypto miner implementation:
    ```
    MINER={cpuminer-multi | cpuminer-opt | cpuminer-rkz | cpuminer-opt-sugarchain | cpuminer-opt-cpupower | cpuminer-opt-neoscrypt }
    ```
- Set the architecture of the host:
    ```
    ARCH="`gcc -march=native -Q --help=target | awk '$1 == "-march=" {print $2}'`"
    ```
- (Optional) select another configuration; otherwise leave this variable blank or unset:
    ```
    CNF=btc
    ```
- (Optional) customize the configuration; otherwise, leave this variable blank or unset:
    ```
    #VOL='-v ./secrets/:/conf.d/:ro'
    VOL="--mount type=bind,source=$(pwd)/secrets,target=/conf.d,readonly"
    ```
- Decide whether to run always or run once:
    ```
    DCMD='docker service create' || # run always
    DCMD='docker run'               # run once
    ```
- Run the crypto miner that has been compiled for your host architecture:
    ```
    $DCMD -d --name "$MINER" --read-only --restart always --rm $VOL "innovanon/$MINER:$ARCH" $CNF
    ```

# Innovations Anonymous
Free Code for a Free World!
==========
![Corporate Logo](https://innovanon-inc.github.io/assets/images/logo.gif)

