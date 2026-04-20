target_id=70
modelname="mpiohd300"
target="MPIO_HD300"
memory=16 # always
coldfirecc
tool="$rootdir/tools/scramble -add=hd30"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 2"
output="rockbox.mpio"
bootoutput="bootloader.mpio"
appextra="recorder:gui:radio"
plugins="yes"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset="$genericbitmaptools"
# architecture, manufacturer and model for the target-tree build
t_cpu="coldfire"
t_manufacturer="mpio"
t_model="hd300"

