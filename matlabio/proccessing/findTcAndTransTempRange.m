function [Tc, deltaT] = findTcAndTransTempRange(x,temperature,ressistance)

E = mean(ressistance(temperature<x(1)));
sigma = std(ressistance(temperature<x(1)));
Tc = min(temperature(((ressistance-E)>sigma*3)));
deltaT = x(2) - Tc;