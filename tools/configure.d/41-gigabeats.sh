target_id=26
modelname="gigabeats"
target="GIGABEAT_S"
memory=64
arm1136jfscc
tool="$rootdir/tools/scramble -add=gigs"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.gigabeat"
appextra="recorder:gui:radio"
plugins="yes"
toolset="$gigabeatbitmaptools"
boottool="$rootdir/tools/scramble -gigabeats"
bootoutput="nk.bin"
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="imx31"
t_model="gigabeat-s"

