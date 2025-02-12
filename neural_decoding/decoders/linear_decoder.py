import numpy as np
from sklearn.linear_model import LogisticRegression, LinearRegression
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
    

class LinearRegressionDecoder:
    def __init__(self, **kwargs):
        self.model = LinearRegression(**kwargs)
        
    def fit(self, X: np.ndarray, y: np.ndarray) -> None:
        self.model.fit(X, y)
        
    def score(self, X: np.ndarray, y: np.ndarray) -> Dict[str, float]:
        r2_score = self.model.score(X, y)
        y_pred = self.model.predict(X)
        mse = np.mean((y - y_pred) ** 2)
        
        return {
            "r2_score": r2_score,
            "mse": mse,
            "n_samples": len(y)
        }