import numpy as np
from sklearn.model_selection import train_test_split
from typing import Tuple, Dict, Any

class SimpleSplitFormatter:
    def __init__(self, test_size: float = 0.2, random_state: int = 42, **kwargs):
        self.test_size = test_size
        self.random_state = random_state
        
    def format_data(self, X: np.ndarray, y: np.ndarray, metadata: Dict[str, Any]) -> Tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, 
            test_size=self.test_size, 
            random_state=self.random_state
        )
        return X_train, X_test, y_train, y_test