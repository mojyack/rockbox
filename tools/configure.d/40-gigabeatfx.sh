target_id=20
modelname="gigabeatfx"
target="GIGABEAT_F"
memory=32 # always
arm9tdmicc
tool="$rootdir/tools/scramble -add=giga"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.gigabeat"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$gigabeatbitmaptools
boottool="$rootdir/tools/scramble -gigabeat"
bootoutput="FWIMG01.DAT"
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="s3c2440"
t_model="gigabeat-fx"

