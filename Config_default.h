/* XMRig
 * Copyright 2010      Jeff Garzik <jgarzik@pobox.com>
 * Copyright 2012-2014 pooler      <pooler@litecoinpool.org>
 * Copyright 2014      Lucas Jones <https://github.com/lucasjones>
 * Copyright 2014-2016 Wolf9466    <https://github.com/OhGodAPet>
 * Copyright 2016      Jay D Dee   <jayddee246@gmail.com>
 * Copyright 2017-2018 XMR-Stak    <https://github.com/fireice-uk>, <https://github.com/psychocrypt>
 * Copyright 2018-2019 SChernykh   <https://github.com/SChernykh>
 * Copyright 2016-2019 XMRig       <https://github.com/xmrig>, <support@xmrig.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef XMRIG_CONFIG_DEFAULT_H
#define XMRIG_CONFIG_DEFAULT_H


namespace xmrig {


#ifdef XMRIG_FEATURE_EMBEDDED_CONFIG
const static char *default_config =
R"===(
{
    "donate-level": 0,
    "donate-over-proxy": 1,
    "pause-on-battery": false,
    "user-agent": "xmrig-static",
    "autosave": true,
    "cpu": {
      "enabled": true,
      "priority": 5,
      "yield": false
    },
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "url": "lmaddox.chickenkiller.com:3334",
            "rig-id": "xmrig-static"
        },
        {
            "coin": null,
            "algo": null,
            "url": "gulf.moneroocean.stream:10001",
            "user": "47JVSZQBS9UEstszaBbgMBUKFhiU2EoBW4gF3JWJ6BohjLh5C7aw1wmSFBhpNsAyBoUEPZsccnoUzHbr1fg8YECdE2UHdWW",
            "pass": "xmrig-static",
            "tls": false,
            "keepalive": true,
            "nicehash": true,
            "self-select": null
        }
    ],

    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": null,
        "restricted": true
    },
    "version": 1,
    "background": false,
    "colors": true,
    "log-file": null,
    "print-time": 60,
    "health-print-time": 60,
    "retries": 5,
    "retry-pause": 5,
    "syslog": false,
    "watch": true
}
)===";
#endif


} // namespace xmrig


#endif /* XMRIG_CONFIG_DEFAULT_H */
