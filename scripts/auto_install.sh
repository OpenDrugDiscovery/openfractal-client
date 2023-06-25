#!/usr/bin/env bash

set -e

ARCH=$(uname -m)
OS=$(uname)

if [[ "$OS" == "Linux" ]]; then
	PLATFORM="linux"
	if [[ "$ARCH" == "aarch64" ]]; then
		ARCH="aarch64"
	elif [[ $ARCH == "ppc64le" ]]; then
		ARCH="ppc64le"
	else
		ARCH="64"
	fi
fi

if [[ "$OS" == "Darwin" ]]; then
	PLATFORM="osx"
	if [[ "$ARCH" == "arm64" ]]; then
		ARCH="arm64"
	else
		ARCH="64"
	fi
fi

OPENFRACTAL_CLIENT_PREFIX="$HOME/.local/share/openfractal-client"

if [ -d "$OPENFRACTAL_CLIENT_PREFIX" ]; then
	echo "The directory $OPENFRACTAL_CLIENT_PREFIX already exists."
	echo "If you want to perform a new installation, first delete the existing one with 'rm -fr ${OPENFRACTAL_CLIENT_PREFIX}'."
	echo "Aborting installation."
	exit 1
fi

INSTALLER_URL="https://github.com/OpenDrugDiscovery/openfractal-client/releases/latest/download/OpenFractalClient-${PLATFORM}-${ARCH}.sh"
INSTALLER_PATH="/tmp/opfc_installer.sh"
wget ${INSTALLER_URL} -O ${INSTALLER_PATH}

# NOTE(hadim): for dev and testing locally
# INSTALLER_PATH="build/OpenFractalClient-${PLATFORM}-${ARCH}.sh"

bash ${INSTALLER_PATH} -b -p ${OPENFRACTAL_CLIENT_PREFIX}

echo ""
echo "--------------------------------------------------"
echo "Installation completed."
echo "You can now run OpenFractal Client with: ${OPENFRACTAL_CLIENT_PREFIX}/bin/qcfractal-compute-manager"
echo "Check out the documentation for the configuration and more information: https://opendrugdiscovery.github.io/openfractal-client."
echo "--------------------------------------------------"
