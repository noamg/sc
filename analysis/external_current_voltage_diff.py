# -*- coding: utf-8 -*-
"""
Created on Thu May 26 14:57:59 2016

@author: noam
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib import mlab

I_coil_expected = 7
Tpt100_expected = 22.6
Tpt100_tolerance = 0.2


folder = "/home/noam/studies/physics/lab_c/sc.git/data/150516/"
file_1 = "/home/noam/studies/physics/lab_c/sc.git/data/150516/THI_manThermalAutoMeas_9_65.csv"
names = ['t', 'Tpt100', 'V', 'I_ext', 'I_coil', 'I_int', 'I_ext_order', 'I_int_sign, I_ext_sign']
table = mlab.csv2rec(file_1, names=names, skiprows=1)
assert np.allclose(table['I_coil'], I_coil_expected)
assert np.allclose(table['Tpt100'], Tpt100_expected, atol=Tpt100_tolerance)
assert np.allclose(table['Tpt100'], table['Tpt100'][0])
assert np.allclose(table['I_int'], table['I_int'][0])
#%%
I_ext = table['I_ext']
is_each_I_ext_on = table['I_ext_order'] != 0
is_each_I_ext_off = np.bitwise_not(is_each_I_ext_on)

V = table['V']

V_mean_on = np.mean(V[is_each_I_ext_on])
V_std_on = np.std(V[is_each_I_ext_on])
V_mean_off = np.mean(V[is_each_I_ext_off])
V_std_off = np.std(V[is_each_I_ext_off])

#%%
def plot_v_mean_std(I_ext, V, V_mean_on, V_std_on, V_mean_off, V_std_off):
    plt.figure()
    plt.plot(I_ext, V, '.')
    plt.hlines([V_mean_on - V_std_on, V_mean_on, V_mean_on + V_std_on], I_ext.min(), I_ext.max(), label='on')
    plt.hlines([V_mean_off - V_std_off, V_mean_off, V_mean_off + V_std_off], I_ext.min(), I_ext.max(), label='off', colors='r')
    
    plt.xlabel('external current')
    plt.ylabel('voltage on sample')
    plt.legend(loc='best')
    
    
plot_v_mean_std(I_ext, V, V_mean_on, V_std_on, V_mean_off, V_std_off)
plt.figure()
plt.plot(V, '.')

#%%
wrap_d = np.diff(np.where(is_each_I_ext_on)[0])[0]
slice_no_edges = slice(np.floor(0.5 * wrap_d - 0.5), -np.ceil(0.5 * wrap_d - 0.5))
wrap = V[is_each_I_ext_off][slice_no_edges].reshape((-1, wrap_d - 1))
means = np.mean(wrap, axis=1)
plt.figure()
plt.plot(means)
wrap_detrand = wrap - means[:, np.newaxis]
on_detrand = V[is_each_I_ext_on] - means
wrap_on_off = np.hstack([wrap_detrand[:,:5], on_detrand.reshape(-1,1), wrap_detrand[:,5:]])
off_detrand = wrap_detrand.flatten()
all_detrand = wrap_on_off.flatten()

plt.figure()
plt.plot(all_detrand, '.')


V_mean_on_det = np.mean(on_detrand)
V_std_on_det = np.std(on_detrand)
V_mean_off_det = np.mean(off_detrand)
V_std_off_det = np.std(off_detrand)

plot_v_mean_std(I_ext[slice_no_edges], all_detrand, V_mean_on_det, V_std_on_det, V_mean_off_det, V_std_off_det)




"""
table['s]
table['sampvoltv']
table['exrcurra']
table['coilcurra']
table['intcurra']
table
table['intcurr_sign']

SampVolt(V),extCurr(A),CoilCurr(A),intCurr(A),SampCurr_order(A),intCurr_sign,extCurr_sign
"""
#%%