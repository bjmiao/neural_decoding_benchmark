import numpy as np
import os
import time


def zscore_transform(matrix):
    ''' we do zscore to matrix on the acis of neuron.
        each neuron's response overall the session will be zscore'ed
    '''
    origin_shape = matrix.shape
    matrix = matrix.reshape(matrix.shape[0], -1)
    matrix = (matrix - matrix.mean(1).reshape(-1, 1)) / matrix.std(axis = 1).reshape(-1, 1)
    matrix = matrix.astype('float16')
    matrix = matrix.reshape(origin_shape)
    np.nan_to_num(matrix, copy = False)
    return matrix

if __name__ == "__main__":
    a = np.random.randn(100, 300)
    start = time.time()
    a = zscore_transform(a)
    stop = time.time()
    print("complete. Used time:", stop - start)
