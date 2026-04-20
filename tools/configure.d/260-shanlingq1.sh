target_id=115
modelname="shanlingq1"
target="SHANLING_Q1"
memory=64
mipsr2elcc
appextra="recorder:gui"
plugins="yes"
tool="$rootdir/tools/scramble -add=shq1 "
boottool="$rootdir/tools/mkspl-x1000 -type=nand -ppb=2 -bpp=2 "
output="rockbox.q1"
bootoutput="bootloader.q1"
sysfontbl="16-Terminus"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset="$x1000tools"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
# architecture, manufacturer and model for the target-tree build
t_cpu="mips"
t_manufacturer="ingenic_x1000"
t_model="shanlingq1"

