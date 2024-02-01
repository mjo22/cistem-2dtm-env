## A bash environment for using cisTEM 2D template matching (2DTM).

To use this environment,

1) Modify `configure-env` to add cisTEM to path
3) Place micrographs into `micrographs/`
4) Modify `configure-metadata` to match the parameters of these micrographs
5) Estimate micrograph CTFs with the command `bash estimate_ctfs.sh`. Results are written to `ctfs/`
6) Place template(s) to be used for template matching into `templates/`. If multiple templates in `templates/` are present, each template will be run on each micrograph in `micrographs/`
7) Run 2DTM with the command `bash match_templates.sh`. Results are written to `output/`

Note: the `estimate_ctfs.sh` / `match_templates.sh` scripts either call the `scripts/estimate_ctf.sh` or `scripts/estimate_ctf.slurm` / `scripts/match_template.sh` or `scripts/match_template.slurm`. Edit these files to choose whether or not to run the scripts in bash or to queue with sbatch. If using sbatch, modify the default slurm parameters in each `.slurm` script.
