# Supera Spacepoint Params

This repo contains instructions for generating larcv samples, with differing parameters to label spacepoints as ghost / non-ghost. For more info on the parameters, see the [SBND Supera Spacepoint Params talk](assets/SPINE_SP_2025Feb26.pdf)

For SBND, we used [sbndcode v10_04_01](https://github.com/SBNSoftware/sbndcode/tree/v10_04_01) to generate the samples. It's important to only use intime (particles whose initial time in the detector is within the beam gate) particles, as opposed to out-of-time particles (mainly cosmics that start outside the beam gate).

## Setup

First run the generation up to the point Supera is run. For SBND this is reco1. The fcl files to do this are below.

```
run_mpvmpr_sbnd_intime.fcl
g4_sce_lite.fcl
detsim_sce_lite.fcl
reco1_mpvmpr_doublets.fcl # For doublet spacepoints
reco1_mpvmpr.fcl # For triplet spacepoints
```

The reco1_mpvmpr_doublets.fcl and reco1_mpvmpr_triplet.fcl files are the same as reco1_mpvmpr.fcl, but use doublet and triplet hits to generate spacepoints, respectively. 

Ensure that the cluster3D outputs are stored in the final output file. I do this using `lar -c eventdump.fcl -s <reco1_output>.root -n 1 > eventdump_reco1.log`.

## Generate samples

To make the `larcv` files, use `run_supera_spacepoint.sh`. This will run Supera, which will make the `larcv` files. It will also rename the output file to include the params used in the filename. i.e. `larcv_ne100_pa300_tw5_vd1.root`.

Tweak the `hit_threshold_nes`, `pas`, and `tws` variables in the `run_supera_spacepoint.sh` file to generate the samples with the desired parameters.

## Evaluation

Once the files are made, use the [supera_spacepoint](https://github.com/bear-is-asleep/supera_spacepoint_prod) repo to evaluate the performance of the different parameters.