# -*- coding: utf-8 -*-
"""
Created on Sat Mar 26 19:45:12 2016

@author: noam
"""

import numpy as np

import scipy as sp
from scipy import io
from scipy import optimize
from scipy import stats


def f_1(i, r, c):
    return r * i ** 2 / (i + c)
    
def f_2(i, r, c):
    return r / (i + c)
    
def f_3(x, slope, c):
    return slope * x - c
    
file = "/home/noam/studies/physics/lab_c/super_conductors/THI_6_7_forPythonFit.mat"
m = sp.io.loadmat(file)
i_v = m['THI7']
i = i_v[:,0]
v = i_v[:,1]
popt_1, pcov_1 = sp.optimize.curve_fit(f_1, i, v, bounds=([0, 0], [np.inf, np.inf]))
popt_2, pcov_2 = sp.optimize.curve_fit(f_2, i, v / i **2 , bounds=([0, 0], [np.inf, np.inf]))
popt_3, pcov_3 = sp.optimize.curve_fit(f_3, i ** 2 / v, i, bounds=([0, 0], [np.inf, np.inf]))


print( popt_1)
print(np.sqrt(np.diag(pcov_1)))
print()
print( popt_2)
print(np.sqrt(np.diag(pcov_2)))
print()
print( popt_3)
print(np.sqrt(np.diag(pcov_3)))
print()


"""
print (popt_2)
print (popt_3)

print(pcov_2)
print(pcov_3)
#print( pcov_1, pcov_2, pcov_3)
"""