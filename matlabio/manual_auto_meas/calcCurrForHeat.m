function HeatCurr = calcCurrForHeat(desiredTempRes)

tempRes_currSq_slope = 746; % ohm per amp^2; (used to be 910)
tempRes_0 = pt100_convert(77,true);

HeatCurr = sqrt((desiredTempRes - tempRes_0)/tempRes_currSq_slope);