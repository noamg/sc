# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 16:27:39 2016

@author: noam
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

#%%
def f(x,z):
    return x / (x ** 2  + z ** 2)

x = np.arange(0, 10, 0.1)

plt.figure()    
for z in range(1,8):
    plt.plot(x, f(x, z), label=str(z))
    
plt.legend(loc='best')

#%%
Tesla_to_gauss = 1e4
def H_z_wire(x_wire, z_wire, xx, zz, current, mu_0=4*np.pi*1e-7):    
    return mu_0 * current / 2 / np.pi * Tesla_to_gauss * (x_wire - xx) / ((xx - x_wire) ** 2 + (zz - z_wire) ** 2)

def H_z_wire_avaraged(x_wire, z_wire, x, z_min, z_max, current, mu_0=4*np.pi*1e-7):
    return mu_0 * current / 2 / np.pi * Tesla_to_gauss / (z_max - z_min) * (np.arctan(z_max / x) - np.arctan(z_min / x))
    
    
#%%

N_x = 60
N_z = 20
x, dx = np.linspace(-1.5e-3, 1.5e-3, N_x, retstep=True)
z, dz = np.linspace(-0.5e-3, 0.5e-3, N_z, retstep=True)
xx, zz = np.meshgrid(x, z)
#z = 0.1e-3
H = 5 * H_z_wire(1.6e-3, 0, xx, zz, 4) + 6 * H_z_wire(-1.6e-3, 0, xx, zz, 4)
H_a = 5 * H_z_wire_avaraged(1.6e-3, 0, x, z[0], z[-1], 4) + 6 * H_z_wire_avaraged(-1.6e-3, 0, x, z[0], z[-1], 4)
H_a_numeric = np.sum(H, axis=0) * dz / (z[-1] - z[0])
#plt.figure()
#plt.plot(x, H[3, :])
#plt.plot(x, H[0,:])

fig = plt.figure()
ax = fig.gca(projection='3d')
surf = ax.plot_wireframe(xx, zz, H)

plt.figure()
plt.plot(x, H_a)
plt.plot(x, H_a_numeric)

#%%