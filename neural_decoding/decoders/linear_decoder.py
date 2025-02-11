import numpy as np
from sklearn.linear_model import LogisticRegression
from typing import Dict, Any

class LinearDecoder:
    def __init__(self, C: float = 1.0, **kwargs):
        self.model = LogisticRegression(C=C, random_state=42)
        
    def fit(self, X: np.ndarray, y: np.ndarray) -> None:
        self.model.fit(X, y)
        
    def score(self, X: np.ndarray, y: np.ndarray) -> Dict[str, float]:
        accuracy = self.model.score(X, y)
        y_pred = self.model.predict(X)
        
        return {
            "accuracy": accuracy,
            "n_samples": len(y)
        } 