#!/bin/sh
doas env PKG_PATH=https://packages.rhaalovely.net/pub/OpenBSD/6.1/packages/$(arch -s) pkg_add -u firefox

