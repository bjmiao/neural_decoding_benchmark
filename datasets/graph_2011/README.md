# Graph 2011 Dataset Formatting

Five populations of neurons from monkey V1 were recorded and saved as separate files. We adapted the data to unify its formatting according to the needs of our project and deposited them here.

## Variables
**spike_cnt**: struct with the following fields

| Dimensions           | Data Type |
|----------------------|-----------|
| nNeu × nTrial × nOri | double    |

- Each data entry represents the spike count of $$neuron_i$$ when shown a drifting grating of $$orientation_j$$ on $$trial_k$$. The spike counts are calculated by summing the number of spikes within the 0.28 - 1.28 one-second window post grating onset
- Note that the number of neurons (nNeu) is different across populations, while number of trials / repeats (nTrial) is 50 and number of orientations (nOri) is 72 throughout all populations
- The value of orientations in the spike count data is the same as that of the **orientations** vector specified below

**orientations**: vector with the following dimensions 
| Dimensions | Data Type |
|------------|-----------|
| 1 × nOri   | double    |

- The orientations are in the range $$[0,2\pi]$$:
  - $$0$$ orientation is a vertically-striped grating moving horizontally to the left
  - $$\pi/2$$ orientation is the same grading rotated counter-clockwise by 90 degrees, such that it becomes a horizontally-striped grating that moves vertically downwards
  - $$\pi$$ orientation is the grating further rotated counter-clockwise by 90 degrees, such that it's back to a vertically-striped grating that moves horizontally to the right
- Because of the drifting property of the grating, the neurons tend to demonstrate a bimodal tuning preference (because the orientation of the grating itself is the same for any two angles that are $$\pi$$ apart, meanwhile the movement of the gratings are drifting in the opposite directions). The authors did offer the option to collapse spike counts in $$[\pi,2\pi]$$ onto those in $$[0,\pi]$$, effectively averaging data from the two ranges. However, we didn't choose to do so for our analysis.

Code used to generate the above files are in **data_formatting.m** </br>
