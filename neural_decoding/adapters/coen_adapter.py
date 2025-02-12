import numpy as np
import scipy.io as sio
from typing import Tuple, Dict, Any

class CoenOriAdapter:
    '''
    Adapter for Coen dataset with orientation tuning data
    '''
    def __init__(self, filepath, **kwargs):
        self.filepath = filepath
        print(self.filepath)
        
    def load_data(self) -> Tuple[np.ndarray, np.ndarray, Dict[str, Any]]:

        # Load the dataset
        data = sio.loadmat(self.filepath)

        # Parse responses to different image sets
        latency = 50
        resp_train = data['resp_train']
        tmp = np.copy(resp_train)
        tmp[:, :, :, :resp_train.shape[3]-latency] = resp_train[:, :, :, latency:]
        tmp[:, :, :, -latency:] = data['resp_train_blk'][:, :, :, :latency]
        resp_train = tmp

        # Compute spike count per stimulus presentation
        resp = np.nansum(resp_train, axis=3)  # [#neurons #stimuli #repeats]
        reps = 20  # number of repeats

        tmp = np.squeeze(resp[:, (2*9*30+128):(2*9*30+128+64), :])  # gratings for orientation tuning
        resp_ori = np.reshape(tmp, (tmp.shape[0], 4, 16, reps))  # [#neurons #phases #orientations #repeats]

        # Metadata (optional)
        metadata = {
            "description": "Toy dataset with two Gaussian clusters",
        }

        X = np.nanmean(resp_ori, axis = 1) # take the mean across phases
        X = X.reshape(X.shape[0], -1).T # #sample * #neurons
        ori = np.arange(90, -90, -11.25) # orientation, 16
        y = np.repeat(ori, reps) # #sample
        metadata = {
            "description": "Coen dataset with orientation tuning data",
        }
        return X, y, metadata
    
# for debug
if __name__ == "__main__":
    filepath = r'C:\Users\bjmiao\Documents\Workspace\neural_decoding_dataset\Coen\data\10.mat'
    adapter = CoenOriAdapter(filepath)
    X, y, metadata = adapter.load_data()
    print(X.shape, y.shape, metadata)
    print(y)
