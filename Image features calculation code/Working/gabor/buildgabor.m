function G = buildgabor(Sx, Sy, sigma, gamma, lambda, theta)
%BUILDGABOR Builds a Gabor filter kernel for use in image processing
%    Disney, Lam, Pham
%    22 June 2006

G = zeros(2*Sx+1,2*Sy+1);

for x = -fix(Sx):fix(Sx)
    for y = -fix(Sy):fix(Sy)
        x_theta = x*cos(theta) + y*sin(theta);
        y_theta = -x*sin(theta) + y*cos(theta);
        G(fix(Sx)+x+1,fix(Sy)+y+1) = exp( ...
            -.5*( (x_theta^2 + gamma^2*y_theta^2) /sigma^2) + ...
            2*pi*x_theta*i/lambda ...
        );
    end
end
