target_id=61
modelname="ondavx777"
target="ONDA_VX777"
memory=16
mipselcc
tool="$rootdir/tools/scramble -add=x777"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.vx777"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$genericbitmaptools
boottool="$rootdir/tools/scramble -ccpmp"
bootoutput="ccpmp.bin"
# architecture, manufacturer and model for the target-tree build
t_cpu="mips"
t_manufacturer="ingenic_jz47xx"
t_model="onda_vx747"

