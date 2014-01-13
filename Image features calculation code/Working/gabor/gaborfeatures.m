function features = gaborfeatures( I , mask )

% variable parameters
nthetas = 4;
nlambdas = 3;
min_theta = 0;
max_theta = 3*pi/4;
min_lambda = .5;
max_lambda = 1.5;

features = zeros(nthetas,nlambdas,2);

% calculate feature vector of means and standard deviations
for t = 1:nthetas
    for l = 1:nlambdas
        theta = (t-1) * (max_theta-min_theta)/(nthetas-1) + min_theta;
        lambda = (l+2)/10;%(l-1) * (max_lambda-min_lambda)/(nlambdas-1) + min_lambda;
        I2 = gaborfilter4(I,lambda,theta);
        I2D = double(I2);
        
        %PFS 7/15/2013 
        %guard image only on this nodule segmentation.
        pv = guardImage(I2D, mask,1);
        features(t,l,1) = mean(pv);
        features(t,l,2) = std(pv);
    end
end
