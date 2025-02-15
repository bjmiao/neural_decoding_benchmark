# Coen-Cagli 2015 Dataset Formatting

A total of 10 sessions were recorded. Data from each session is preprocessed according to the needs of our project and saved into separate mat files. 

## Variables
**spike_cnt**: struct with the following fields

| Field   | Dimensions           | Data Type |
|---------|----------------------|-----------|
| phase1  | nNeu × nTrial × nOri | double    |
| phase2  | nNeu × nTrial × nOri | double    |
| phase3  | nNeu × nTrial × nOri | double    |
| phase4  | nNeu × nTrial × nOri | double    |

**orientations**: vector with the following dimensions 
| Dimensions | Data Type |
|------------|-----------|
| 1 × nOri   | double    |


For more details refer to **crcns_pvc-8_data_description.pdf** written by the original authors
