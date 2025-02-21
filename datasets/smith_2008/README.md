# Smith & Cohn 2008 Dataset Formatting

Data from V1 of 3 anesthetized monkeys were recorded. According to the authors, any neuron with SNR < 1.5 and an average firing rate < 1 spike/second are removed and excluded from downstream analysis. After neuron removal, data from each monkey is preprocessed according to the needs of our project and saved into separate mat files. 

## Variables
**spike_cnt**: struct with the following fields

| Dimensions           | Data Type |
|----------------------|-----------|
| nNeu × nTrial × nOri | double    |

- Each data entry represents the spike count of $$neuron_i$$ when shown a drifting grating of $$orientation_j$$ on $$trial_k$$. The spike counts are calculated by summing the number of spikes within the 0.28 - 1.28 one-second window post grating onset
- Note that the number of neurons (nNeu) is different across monkeys, while number of trials / repeats (nTrial) is 200 and number of orientations (nOri) is 12 throughout all monkeys' recording sessions
- The value of orientations in the spike couunt data is the same as that of the **orientations** vector specified below

**orientations**: vector with the following dimensions 
| Dimensions | Data Type |
|------------|-----------|
| 1 × nOri   | double    |

- The orientations are in the range $$[0,2\pi]$$:
  - $$0$$ orientation is a vertically-striped grating moving horizontally to the left
  - $$\pi/2$$ orientation is the same grading rotated counter-clockwise by 90 degrees, such that it becomes a horizontally-striped grading that moves vertically downwards
  - $$\pi$$ orientation is the gradient further rotated counter-clockwise by 90 degrees, such that it's back to a vertically-striped grating that moves horizontally to the right
- Because of the drifting property of the grating, the neurons tend to demonstrate a bimodal tuning preference (because the orientation of the grating itself is the same for any two angles that are $$pi$$ apart, meanwhile the direction of drift is in the opposite direction)

Code used to generate the above files are in **data_formatting.m** </br>
For more details, refer to **crcns_pvc-11_data_description.pdf** written by the original authors
