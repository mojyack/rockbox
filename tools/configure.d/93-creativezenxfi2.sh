target_id=80
modelname="creativezenxfi2"
target="CREATIVE_ZENXFI2"
memory=64
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=zxf2"
output="rockbox.creative"
bootoutput="bootloader-zenxfi2.creative"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="imx233"
t_model="creative-zenxfi2"
arm926ejscc

