# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 16:27:39 2016

@author: noam
"""

import numpy as np
import scipy as sp
from scipy import signal
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
    return mu_0 * current / 2 / np.pi * Tesla_to_gauss / (z_max - z_min) * (np.arctan((z_wire - z_max) / (x_wire - x)) - np.arctan((z_wire - z_min) / (x_wire - x))
    

def H_z_internal():
    pass

def H_coil(I_coil):
    return I

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
N_x = 100
N_z = 70
Dx = 3e-3
Dz = 1e-3
x, dx = np.linspace(-Dx, Dx, N_x, retstep=True)
z, dz = np.linspace(-Dz, Dz, N_z, retstep=True)
xx, zz = np.meshgrid(x, z)
H_green = H_z_wire(0, 0, xx, zz, 1)

x_conv = np.arange(-0.5 * Dx, 0.5 * Dx, dx)
z_conv = np.arange(-0.5 * Dz, 0.5 * Dz, dz)
xx_c, zz_c = np.meshgrid(x_conv, z_conv)
current_in = 1.5
J_const = np.ones((len(z_conv), len(x_conv))) / (len(z_conv) * len(x_conv) * dx * dz) * current_in
assert(np.allclose(J_const.sum() * dx * dz, current_in))
frac = 0.1
J_rand = np.random.binomial(n=1, p=frac, size=(len(z_conv), len(x_conv)))
J_rand = J_rand / J_rand.sum() / dx / dz * current_in
assert(np.allclose(J_rand.sum() * dx * dz, current_in))

def H_convolve(H_green, J, x, dx, z, dz, x_conv, z_conv):
    H_tot = sp.signal.convolve2d(H_green, J, mode='valid') * dx * dz
    H_avarage = np.sum(H_tot, axis=0) * dz / (z_conv[-1] - z_conv[0])
    return H_tot, H_avarage

H_tot, H_avarage = H_convolve(H_green, J_const, x, dx, z, dz, x_conv, z_conv)
if False:
    H_tot, H_avarage = H_convolve(H_green, J_rand, x, dx, z, dz, x_conv, z_conv)
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    surf = ax.plot_wireframe(xx_c, zz_c, J_rand)

#%%
if False:
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    surf = ax.plot_wireframe(xx, zz, H_green)

fig = plt.figure()
ax = fig.gca(projection='3d')
surf = ax.plot_wireframe(xx_c, zz_c, H_tot[:-1, :-1])

plt.figure()
plt.plot(x_conv, H_avarage[:-1])