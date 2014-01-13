%ttesting

%test for significance. 1. This whole bloody process revolves around
%negatives so its easy to get turned around in the naming or meaning. 2.
%I'm including all 3 t-tests because you will get confused, and looking at
%the results of all 3 options saves a lot of time remembering what method
%does what you want. 3. Depending one how strong your results are, you might want a different one anyhow 

%We want to do a one tail test. We only care if the ws is better or equal
%to rt (for now) vs ws being worse than rt. Therefore null hypothesis will
%be that wsAcc >= rtAcc (> comes from the one tail and exclusion).
%Alternative hypothesis will be wsAcc < rtAcc 
%'tail', 'left' Set the alternative hypothesis to be that the population mean of x is less than the population mean of y.
%make x = wsAcc and y = rtAcc
%Accepting the null hypothesis is success (Answer = 0. p >= 0.05)
%Rejecting the null hypothesis is failure (Meaning that wsAcc < rtAcc)


for i = 1:numCategories
    pwsMultiEnsNotGreater(i) =  isNotGreaterTTest(wsMultiEnsPred(:,i), rtEnsPred(:,i), Yaverage(:,i), Yaverage(:,i)); %low p means greater
    
    pwsMultiEnsNotLess(i) = isNotLessTTest(wsMultiEnsPred(:,i), rtEnsPred(:,i), Yaverage(:,i), Yaverage(:,i)); %low p means less than, high P means not less than (possibly equal)
    pwsMultiEnsNotEqual(i) = isNotSameTTest(wsMultiEnsPred(:,i), rtEnsPred(:,i), Yaverage(:,i), Yaverage(:,i)); %low p means unequal, high p means they're the same
end


wsMultiEnsImprovement = wsMultiEnsSuccess - rtEnsSuccess;
[wsMultiEnsImprovement;pwsMultiEns;pwsMultiEns<0.05];

%T test notes:
%Three types of t tests
%One Sample - If we already have a known (Iron Clad) value from other experiments and
%want to know if this experiment produced a differing result. - Nope
%Paired Two Sample - if you are testing the same guys but after changing
%something. Is this us? Same photos, different processing.
%Independant Two Sample - Probably us?
%a = Yes or no. uselsess
%b = probability they are the same. Lower is better. Less that 0.05 is good
%c = Confidence Interval. 
%d = tstat, the raw T value. df Degrees of Freedom. sd - standar deviation.
