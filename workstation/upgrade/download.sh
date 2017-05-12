#!/bin/sh

ftp -ia ftp://ftp.spline.de/pub/OpenBSD/snapshots/`machine -a`/{index.txt,*.tgz,bsd*,INS*,SHA*}
