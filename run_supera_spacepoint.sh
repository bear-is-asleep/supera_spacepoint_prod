#!/bin/bash

# hit_threshold_nes=(25 50 75 100 125 150 175 200 250 300)
# pas=(0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.425 0.45 0.5 0.55 0.6 0.7)
# tws=(5 10 15 20)

#Check a few more params
hit_threshold_nes=(100 175 300)
pas=(0.425 0.7 0.85 1.0 1.3 1.5)
tws=(5 10 15 20)

#Nominal params
# hit_threshold_nes=(175)
# pas=(0.425 0.0)
# tws=(5)

fcl_file="supera_sbnd_mpvmpr_local.fcl"
run_file="run_supera_sbnd_mpvmpr_local.fcl"

for ne in "${hit_threshold_nes[@]}"; do
    for pa in "${pas[@]}"; do
        for tw in "${tws[@]}"; do
            # Calculate 'vd' and 'pa_int' before the existence check
            vd=$((tw / 5))
            pa_int=$(echo "$pa * 1000 / 1" | bc)

            output_file="larcv/larcv_ne${ne}_pa${pa_int}_tw${tw}_vd${vd}.root"
            echo "Checking if file exists: $output_file"
            
            if [ -f "$output_file" ]; then
                echo "File already exists, skipping"
                continue
            fi

            echo "Running for hit_threshold_ne $ne, pa $pa, tw $tw and vd $vd"

            # Update FCL file with current parameters
            sed -i.bak "s/\(HitThresholdNe: \).*/\1$ne/" "$fcl_file"
            sed -i.bak "s/\(PostAveragingThreshold_cm: \).*/\1$pa/" "$fcl_file"
            sed -i.bak "s/\(HitWindowTicks: \).*/\1$tw/" "$fcl_file"
            sed -i.bak "s/\(VoxelDistanceThreshold: \).*/\1$vd/" "$fcl_file"

            # Display the updated parameters
            grep "HitThresholdNe:" "$fcl_file"
            grep "PostAveragingThreshold_cm:" "$fcl_file"
            grep "HitWindowTicks:" "$fcl_file"
            grep "VoxelDistanceThreshold:" "$fcl_file"

            # Run supera
            lar -c "$run_file" -s reco1-art.root

            # Rename the output file
            mv larcv.root "$output_file"

            # Move to data folder (ensure the 'larcv/' directory exists)
            mv "$output_file" larcv/
        done
    done
done