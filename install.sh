#!/usr/bin/env bash

install_zcu216() (
    set -euo pipefail

    repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
    board_dir="$repo_dir/boards/ZCU216/rfsoc_mts"
    python3 -c 'from importlib.metadata import version; raise SystemExit(0 if version("pynq") == "4.0.0" else "ZCU216 requires PYNQ 4.0.0")'
    if [[ ! -d "${PYNQ_JUPYTER_NOTEBOOKS:-}" || ! -f "$board_dir/bitstream/mts.xsa" ]]; then
        echo "The ZCU216 installer needs the PYNQ notebook directory and bitstream/mts.xsa." >&2
        exit 1
    fi

    work_dir="$(mktemp -d)"
    trap 'rm -rf -- "$work_dir"' EXIT
    git clone --depth 1 --branch v4.0.0 https://github.com/Xilinx/PYNQ.git "$work_dir/PYNQ"

    patch="$repo_dir/boards/patches/xrfdc_mts_v2024.patch"
    git -C "$work_dir/PYNQ" apply --check "$patch"
    git -C "$work_dir/PYNQ" apply "$patch"
    rfdc_package="$work_dir/PYNQ/sdbuild/packages/xrfdc/package"
    make -C "$rfdc_package" embeddedsw
    metal_dir="$rfdc_package/embeddedsw/ThirdParty/sw_services/libmetal/src/libmetal"
    cmake -S "$metal_dir" -B "$metal_dir/build-libmetal" \
        -DCMAKE_TOOLCHAIN_FILE="$rfdc_package/toolchain.cmake"
    make -C "$rfdc_package"
    cp "$rfdc_package/libxrfdc.so" "$rfdc_package/xrfdc/"

    clock_package="$work_dir/PYNQ/sdbuild/packages/xrfclk/package"
    cp "$board_dir"/xrfclk/*.txt "$clock_package/xrfclk/"
    python3 -m pip install --no-build-isolation --force-reinstall --no-deps "$rfdc_package" "$clock_package"
    python3 -c 'import xrfdc; assert all(hasattr(xrfdc.RFdc, name) for name in ("adc_mts_init", "dac_mts_init", "adc_mts_sync", "dac_mts_sync", "mts_sysref_enable"))'

    cd "$repo_dir"
    python3 -m pip install --no-build-isolation .
)

export BOARD="$(tr -d '\0' < /proc/device-tree/chosen/pynq_board)"
if [[ "$BOARD" == ZCU216 ]]; then
    install_zcu216
    exit $?
fi

# Clone the PYNQ 3.1.1 image
git clone --branch image_v3.1.1 --recursive https://github.com/Xilinx/PYNQ.git
cd PYNQ

# Apply changes to xrfdc and reinstall the package
echo "Applying xrfdc MTS patch & reinstalling the package"
git apply ../boards/patches/xrfdc_mts_v2024.patch

pushd sdbuild/packages/xrfdc
. pre.sh || { echo "xrfdc pre.sh failed"; exit 1; }
. qemu.sh || { echo "xrfdc qemu.sh failed"; exit 1; }
popd

export BOARD="$(tr -d '\0' < /proc/device-tree/chosen/pynq_board)" # Source the board again

# Move required LMK/LMX driver files into xrfclk and reinstall the package
echo "Copying LMK/LMX files into xrfclk and reinstalling the package"
sudo cp -r ../boards/$BOARD/rfsoc_mts/xrfclk/. ./sdbuild/packages/xrfclk/package/xrfclk/

pushd sdbuild/packages/xrfclk
. pre.sh || { echo "xrfclk pre.sh failed"; exit 1; }
. qemu.sh || { echo "xrfclk qemu.sh failed"; exit 1; }
popd

export BOARD="$(tr -d '\0' < /proc/device-tree/chosen/pynq_board)" # Source the board again

# Install rfsoc_mts package and notebook
set +x
echo "Installing rfsoc_mts package"
cd ..
python3 -m pip install . --no-build-isolation

echo "The MTS demonstration is now installed!"

# Remove installation folder
rm -rf /rfsoc_mts/
