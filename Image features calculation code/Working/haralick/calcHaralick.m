function [ F ] = calcHaralick( glcm )
% HARALICK Fast Calculation of Haralick Features
%   IN:   glcm = Co-Occurrence Matrix     
%   OUT:  F = Feature Vector   
%
%   Stefan Winzeck 2012   
%   winzeck@hm.edu
% 
%   Feature Calculation according to:
%   [1] R. Haralick: 'Textural Feature for Image Classification' (1979)
%   [2] E. Miyamoto: 'Fast Calculation of Haralick Texture Features' 
% 
% MISSING:   f14  [1]

%% ALLOCATION
S=size(glcm,1);

f_2=zeros(S);
f_3=zeros(S);
f_4=zeros(S);
f_5=zeros(S);
f_6=zeros(1,2*S);
f_7=zeros(1,2*S);
f_8=zeros(1,2*S);
f_9=zeros(S);
f_11=zeros(1,S);

pxy=zeros(1,2*S);
px_y=zeros(1,S);

HX_=zeros(1,S);
HY_=zeros(1,S);
HXY_1=zeros(S);
HXY_2=zeros(S);

%% CALCULATION
% Normalization
M = glcm/sum(glcm(:));

% Energy
f_1 = M.^2;
f1 = sum(f_1(:));

%-------------------------------------------------------------------------%

u = mean2(M);
py = sum(M,1);
px = sum(M,2);


%OPTIMIZATION NEEDED: change the indicies to j = i and multiple the 
% end summations by 2.
for i=1:S
    for j=1:S
        Mij = M(i,j);
       
        f_3(i,j) = i*j*Mij;
        f_4(i,j) = (i-u)^2*Mij;
        f_5(i,j) = Mij/(1+(i-j)^2);
        %OPTIMIZATION NEEDED: Use of log tables
        f_9(i,j) = Mij*log(Mij+eps);
    
        %Equation (5) from [2]
        pxy(i+j) = pxy(i+j)+Mij;
        %Equation (6) from [2]
        px_y(abs(i-j)+1) = px_y(abs(i-j)+1)+Mij;
         
        %Different than the paper
        
        %OPTIMIZATION NEEDED: Use of log tables
        %Related to Equation (20) from [2]
        HX_(i)= px(i)*log(px(i)+eps);
        
        %Related to Equation (20) from [2]
        HY_(j)= py(j)*log(py(j)+eps);
        
        %Equation (7) from [2]
        HXY_1(i,j) = Mij*log(px(i)*py(j)+eps);
        
        %Equation (8) from [2]
        HXY_2(i,j) = px(i)*py(j)*log(px(i)*py(j)+eps);
        
    end
end

% Correlation
ux = mean(px); sx=std(px);
uy = mean(py); sy=std(py);
f3 =(sum(f_3(:))-(ux*uy))/(sx*sy);

% Sum of Variances
f4 = sum(f_4(:));

% Inverse Difference Moment
f5 = sum(f_5(:));

% Entropy
f9 = -sum(f_9(:));

% Information Measures of Correlation 1&2
HX = -sum(HX_);
HY = -sum(HY_);
HXY = f9;
HXY1 = -sum(HXY_1(:));
HXY2 = -sum(HXY_2(:));

f12 = (HXY-HXY1)/max([HX, HY]);
f13 = (1 - exp((-2)*(HXY2 - HXY)))^0.5;

%-------------------------------------------------------------------------%

for i=2:2*S
    f_6(i) = i*pxy(i);
    %OPTIMIZATION NEEDED: Use of log tables
    f_8(i) = pxy(i)*log(pxy(i)+eps);
end

% Sum Average
%f_6(1) = [];       % not necessary f_6(1) is zero anyway
f6 = sum(f_6);


% Sum Entropy
%f_8(1)=[];         % not necessary f_8(1) is zero anyway
f8 = -sum(f_8);

%-------------------------------------------------------------------------%

%Different than the paper, f7 should be calculated along side f6 and f8
for i=2:2*S
    f_7(i)=(i-f8)^2*pxy(i);
end

% Sum Variance
%f_7(1) = [];       % not necessary f_7(1) is zero anyway
f7 = sum(f_7);


% Difference Variance
f10 = var(px_y);

%-------------------------------------------------------------------------%

for k=1:S
    f_2(k) = (k-1)^2*px_y(k);
    %OPTIMIZATION NEEDED: Use of log tables
    f_11(k) = px_y(k)*log(px_y(k)+eps);
end

% Contrast
f2 = sum(f_2(:));

% Difference Entropy
f11 = -sum(f_11);
%-------------------------------------------------------------------------%


F = [f1;f2;f3;f4;f5;f6;f7;f8;f9;f10;f11;f12;f13];

end

