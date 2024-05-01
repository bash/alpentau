#!/usr/bin/env bash

set -euo pipefail

extension_path=browser/themes/addons/alpenglow

if ! [[ -d gecko-dev ]]
then
    (git clone -n --depth=1 --filter=tree:0 https://github.com/mozilla/gecko-dev && \
        cd gecko-dev && \
        git sparse-checkout set --no-cone "$extension_path" && \
        git checkout)
else
    (cd gecko-dev && \
        git fetch --depth=1 --no-tags && \
        git reset --hard FETCH_HEAD)
fi

patch "gecko-dev/$extension_path/manifest.json" manifest.json.patch
npx web-ext build --source-dir "gecko-dev/$extension_path"
