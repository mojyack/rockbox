target_id=64
modelname="ondavx767"
target="ONDA_VX767"
memory=16 #FIXME
mipselcc
tool="cp"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.vx767"
appextra="recorder:gui:radio"
plugins="" #FIXME
toolset=$genericbitmaptools
boottool="$rootdir/tools/scramble -ccpmp"
bootoutput="ccpmp.bin"
# architecture, manufacturer and model for the target-tree build
t_cpu="mips"
t_manufacturer="ingenic_jz47xx"
t_model="onda_vx767"

