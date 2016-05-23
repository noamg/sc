# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 16:27:39 2016

@author: noam
"""

import numpy as np
import matplotlib.pyplot as plt

#%%
def f(x,z):
    return x / (x ** 2  + z ** 2)

x = np.arange(0, 10, 0.1)

plt.figure()    
for z in range(1,8):
    plt.plot(x, f(x, z), label=str(z))
    
plt.legend(loc='best')

#%%
def H_z(x_wire, z_wire, x, z, current, mu_0=4*np.pi*1e-7):
    xx, zz = np.meshgrid(x, z)
    Tesla_to_gauss = 1e4
    return mu_0 * current / 2 / np.pi * Tesla_to_gauss * (xx - x_wire) / ((xx - x_wire) ** 2 + (zz - z_wire) ** 2)
    
#%%
    
x=np.linspace(-1.5e-3, 1.5e-3, 10)
z=np.linspace(-0.5e-3, 0.5e-3, 5)
H = H_z(1.6e-3, 0, x, z, 4)
plt.figure()
plt.plot(x, H[3, :])
