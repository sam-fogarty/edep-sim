# Macro that use G4 particle gun to create a single particle

COUNT="10"
source ${DETSIMROOT}/cmt/setup.sh

MACRO=`mktemp -t detsim.XXXXXXXXXX` || exit 1
cat >> $MACRO <<EOF
/dsim/control baseline 1.0
/dsim/update

# Create the first particle source.  This source will be used to
# specify the position of the vertex.  The any of the GPS direction
# and energy commands can be used.
/gps/particle e-
/gps/energy 600 MeV

# This generates the position of the first particle gun.  It will be
# used for the other particle guns.  The /gps/position command must
# come first.
/gps/position 0.0 100.0 -60.0 cm
/gps/pos/type Volume
/gps/pos/shape Para
/gps/pos/halfx 10 cm
/gps/pos/halfy 10 cm
/gps/pos/halfz 10 cm

# This generates the direction of the first particle gun. 
/gps/ang/type beam1d
/gps/ang/sigma_r 15 deg
/gps/ang/rot2 0 0 -1

/run/beamOn ${COUNT}

EOF

OUTPUT=detsim-single-electron

if [ -f $OUTPUT ]; then
    rm $OUTPUT
fi

DETSIM.exe -o $OUTPUT $MACRO 

rm $MACRO