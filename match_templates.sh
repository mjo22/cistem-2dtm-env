#!/usr/bin/env bash
#
# Match a set of templates to a set of micrographs

# Path to this file
sourcefn=$(readlink -e -- $BASH_SOURCE)
sourcedir=$(dirname -- $sourcefn)
errormsg="ERROR: $sourcefn"

# Set input and output directories
microdir=$sourcedir/micrographs
templdir=$sourcedir/templates
outputdir=$sourcedir/output
scriptdir=$sourcedir/scripts

# Run on all micrographs and templates
for template in $templdir/*.mrc; do
    echo "Processing template $(basename -- $template)..."
    for micrograph in $microdir/*.mrc; do
	echo -e "\t Processing micrograph $(basename -- $micrograph)..."
	cd $scriptdir
	# bash match_template.sh $micrograph $template
	sbatch match_template.slurm $micrograph $template
	cd -
    done
done
