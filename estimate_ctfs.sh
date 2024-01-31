#!/usr/bin/env bash
#
# Compute CTFs over all micrographs

# Path to this file
sourcefn=$(readlink -e -- $BASH_SOURCE)
sourcedir=$(dirname -- $sourcefn)
errormsg="ERROR: $sourcefn"

# Set input and output directories
microdir=$sourcedir/micrographs
outputdir=$sourcedir/output
scriptdir=$sourcedir/scripts

# Run on all micrographs
for micrograph in $microdir/*.mrc; do
    echo "Processing micrograph $(basename -- $micrograph)..."
    cd $scriptdir
    bash estimate_ctf.sh $micrograph
    # sbatch estimate_ctf.slurm $micrograph
    cd -
done
