application="yes"
target_id=93
modelname="samsungypr1"
target="SAMSUNG_YPR1"
memory=24
uname=$(uname)
# Linux environment and CPU are the same as for R0, use the same gcc options
ypr0cc
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 9"
output="rockbox"
bootoutput="rockbox"
appextra="recorder:gui:radio"
plugins="yes"
# architecture, manufacturer and model for the target-tree build
t_cpu="hosted"
t_manufacturer="samsungypr"
t_model="ypr1"

