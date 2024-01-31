A bash environment for using cisTEM 2D template matching (2DTM).

To use this environment,

1) Modify configure-env to add cisTEM to path
3) Place micrographs into `micrographs/`
4) Modify configure-metadata to match the parameters of these micrographs
5) Estimate micrograph CTFs with `estimate_ctfs.sh`. Results are written to `ctfs/`
6) Place template(s) to be used for template matching into `templates/`.
7) Run 2DTM with `match_templates.sh`. Results are written to `output/`

Note: If multiple templates in `templates/` are present, each template will be run on each micrograph in `micrographs/`
