#!/bin/bash
tmpdir=/tmp
git clone https://github.com/mojyack/libiap "$tmpdir/libiap"
rm -rf libiap
cp -r "$tmpdir/libiap/src/iap" libiap
git -C "$tmpdir/libiap" rev-parse HEAD > libiap-commit
