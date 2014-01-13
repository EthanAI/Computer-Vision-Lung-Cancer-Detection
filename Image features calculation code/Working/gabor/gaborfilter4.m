function Iout = gaborfilter(I,lamda,theta)
%GABORFILTER Filter an image via Gabor function along a specific angle 
%    Disney, Lam, Pham
%    22 June 2006

% prepare image
if isa(I,'double') ~= 1 
    I = double(I);
end

% build filter
Sx = 4; Sy = 4;
sigma = 1.54;
%lamda = 1;
gamma = .5; %1;
G = buildgabor(Sx,Sy,sigma,gamma,lamda,theta);

% convolve filter and image
Imgabout = conv2(I,double(imag(G)),'same');
Regabout = conv2(I,double(real(G)),'same');
Iout = sqrt(Imgabout.*Imgabout + Regabout.*Regabout);

% scale output values to [0..255]
gmin = min(Iout(:));
gmax = max(Iout(:));
Iout = uint8((Iout - gmin) * (256/gmax));
