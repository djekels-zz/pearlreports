#! /bin/sh
export MOJO_PROXY=1
export QX_SRC_MODE=1
exec ./pr.pl daemon --listen 'http://*:18476'
