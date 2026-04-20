target_id=106
modelname="xduoox3"
target="XDUOO_X3"
memory=64
mipselcc
tool="$rootdir/tools/scramble -add=xdx3"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$bmp2rb_mono"
output="rockbox.x3"
appextra="recorder:gui"
plugins="yes"
toolset=$genericbitmaptools
boottool="cp"
bootoutput="bootloader-x3.bin"
# architecture, manufacturer and model for the target-tree build
t_cpu="mips"
t_manufacturer="ingenic_jz47xx"
t_model="xduoo_x3"
sysfont="08-Rockfont"

