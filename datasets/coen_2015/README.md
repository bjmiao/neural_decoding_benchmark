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

- Each data entry represents the spike count of $$neuron_i$$ when shown a grating of $$orientation_j$$ on $$trial_k$$ 
- Note that the number of neurons (nNeu) is different across sessions, while number of trials / repeats (nTrial) is 20 and number of orientations (nOri) is 16 throughout all sessions
- Do not average data across the phases, run models on each phase separately
- The value of orientations in the spike couunt data is the same as that of the **orientations** vector specified below

**orientations**: vector with the following dimensions 
| Dimensions | Data Type |
|------------|-----------|
| 1 × nOri   | double    |

- The orientations were originally in the range $$[-\pi/2,\ \pi/2]$$ but to unify across datasets we've rotated the span counter-clockwise by one quadrant to be $$[0, \pi]$$

Code used to generate the above files are in **data_formatting.m** </br>
For more details, refer to **crcns_pvc-8_data_description.pdf** written by the original authors
