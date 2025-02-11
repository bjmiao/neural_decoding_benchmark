import numpy as np
from typing import Tuple, Dict, Any

class ToyAdapter:
    def __init__(self, n_samples: int = 1000, n_dim: int = 5, **kwargs):
        self.n_samples = n_samples
        self.n_dim = n_dim
        
    def load_data(self) -> Tuple[np.ndarray, np.ndarray, Dict[str, Any]]:
        # Generate two Gaussian clusters
        X1 = np.random.normal(loc=0, scale=1, size=(self.n_samples//2, self.n_dim))
        X2 = np.random.normal(loc=2, scale=1, size=(self.n_samples//2, self.n_dim))
        
        # Combine data and create labels
        X = np.vstack([X1, X2])
        y = np.array([0] * (self.n_samples//2) + [1] * (self.n_samples//2))
        
        # Metadata (optional)
        metadata = {
            "description": "Toy dataset with two Gaussian clusters",
            "dimensions": self.n_dim,
            "samples": self.n_samples
        }
        
        return X, y, metadata 