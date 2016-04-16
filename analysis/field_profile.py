# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 16:27:39 2016

@author: noam
"""

import numpy as np
import matplotlib.pyplot as plt

def f(x,z):
    return x / (x ** 2  + z ** 2)

x = np.arange(0, 10, 0.1)

plt.figure()    
for z in range(1,8):
    plt.plot(x, f(x, z), label=str(z))
    
plt.legend(loc='best')