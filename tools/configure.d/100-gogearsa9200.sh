target_id=41
modelname="gogearsa9200"
target="PHILIPS_SA9200"
memory=32 # supposedly
arm7tdmicc
tool="$rootdir/tools/scramble -mi4v3 -model=9200 -type=RBOS"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.mi4"
appextra="recorder:gui:radio"
plugins="yes"
boottool="$rootdir/tools/scramble -mi4v3 -model=9200 -type=RBBL"
bootoutput="FWImage.ebn"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset=$scramblebitmaptools
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_soc="pp"
t_manufacturer="philips"
t_model="sa9200"
