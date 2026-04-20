target_id=69
modelname="mpiohd200"
target="MPIO_HD200"
memory=16 # always
coldfirecc
tool="$rootdir/tools/scramble -add=hd20"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 7"
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
t_model="hd200"

