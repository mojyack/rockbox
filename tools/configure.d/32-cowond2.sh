target_id=34
modelname="cowond2"
target="COWON_D2"
memory=32
arm926ejscc
tool="$rootdir/tools/scramble -add=d2"
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.d2"
bootoutput="bootloader-cowond2.bin"
appextra="recorder:gui:radio"
plugins="yes"
toolset="$tccbitmaptools"
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="tcc780x"
t_model="cowond2"

