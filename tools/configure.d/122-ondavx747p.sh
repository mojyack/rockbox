target_id=54
modelname="ondavx747p"
target="ONDA_VX747P"
memory=16
mipselcc
tool="$rootdir/tools/scramble -add=747p"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.vx747p"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$genericbitmaptools
boottool="$rootdir/tools/scramble -ccpmp"
bootoutput="ccpmp.bin"
# architecture, manufacturer and model for the target-tree build
t_cpu="mips"
t_manufacturer="ingenic_jz47xx"
t_model="onda_vx747"

