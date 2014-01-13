function [ nsv , beta , bias ] = svr (X,Y,ker ,C, loss ,e)
%Note: As of 7/17/2013 this code is broken and has not be used once - ES

% SVR Support Vector Regression
%
% Usage : [ nsv beta bias ] = svr (X,Y,ker ,C ,loss ,e)
%
% Parameters : X - Training inputs
% Y - Training targets
% ker - kernel function
% C - upper bound ( non - separable case )
% loss - loss function
% e - insensitivity
% nsv - number of support vectors
% beta - Difference of Lagrange Multipliers
% bias - bias term
%
% Author : Steve Gunn ( srg@ecs . soton .ac .uk )
if ( nargin < 3 | nargin > 6) % check correct number of arguments
    help svr
else
    fprintf ('Support Vector Regressing ....\ n')
    fprintf (' ______________________________ \n')
    n = size (X ,1);
    if ( nargin <6) e =0.0; , end
    if ( nargin <5) loss =' eInsensitive ';, end
    if ( nargin <4) C= Inf ;, end
    if ( nargin <3) ker ='linear ';, end
    
    % Construct the Kernel matrix
    
    fprintf (' Constructing ...\ n');
    H = zeros (n,n);
    for i =1: n
        for j =1: n
            H(i,j ) = svkernel (ker ,X(i ,:) ,X(j ,:));
        end
    end
    
    % Set up the parameters for the Optimisation problem
    switch lower ( loss )
        case ' einsensitive ',
            Hb = [ H -H; -H H];
            c = [( e* ones (n ,1) - Y ); ( e* ones (n ,1) + Y )];
            vlb = zeros (2*n ,1); % Set the bounds : alphas >= 0
            vub = C* ones (2*n ,1); % alphas <= C
            x0 = zeros (2*n ,1); % The starting point is [0 0 0 0]
            neqcstr = nobias ( ker ); % Set the number of equality constraints (1 or 0)
            if neqcstr
                A = [ ones (1,n) - ones (1,n)]; , b = 0; % Set the constraint Ax = b
            else
                A = []; , b = [];
            end
        case 'quadratic ',
            Hb = H + eye (n )/(2* C);
            c = -Y;
            vlb = -1 e30 * ones (n ,1);

            vub = 1 e30 * ones (n ,1);
            x0 = zeros (n ,1); % The starting point is [0 0 0 0]
            neqcstr = nobias ( ker ); % Set the number of equality constraints (1 or 0)
            if neqcstr
                A = ones (1,n); , b = 0; % Set the constraint Ax = b
            else
                A = []; , b = [];
            end
        otherwise , disp ('Error : Unknown Loss Function \n');
end

% Add small amount of zero order regularisation to
% avoid problems when Hessian is badly conditioned .
% Rank is always less than or equal to n.
% Note that adding to much reg will peturb solution

Hb = Hb + 1e -10 * eye ( size (Hb ));

% Solve the Optimisation Problem
fprintf ('Optimising ...\ n');
st = cputime ;

[ alpha lambda how ] = qp(Hb , c , A , b , vlb , vub , x0 , neqcstr );

fprintf ('Execution time : %4.1 f seconds \n',cputime - st );
fprintf ('Status : % s\n',how );

switch lower ( loss )
    case ' einsensitive ',
        beta = alpha (1: n) - alpha (n +1:2* n);
    case 'quadratic ',
        beta = alpha ;
end
fprintf ('|w0 |^2 : % f\n',beta '*H* beta );
fprintf ('Sum beta : % f\n',sum ( beta ));

% Compute the number of Support Vectors
epsilon = svtol ( abs ( beta ));
svi = find ( abs ( beta ) > epsilon );
nsv = length ( svi );
fprintf ('Support Vectors : % d (%3.1 f %%)\ n',nsv ,100* nsv /n);

% Implicit bias , b0
bias = 0;

% Explicit bias , b0
if nobias ( ker ) ~= 0
    switch lower ( loss )
        case ' einsensitive ',
            % find bias from average of support vectors with interpolation error e
            % SVs with interpolation error e have alphas : 0 < alpha < C
            svii = find ( abs ( beta ) > epsilon & abs ( beta ) < (C - epsilon ));
            if length ( svii ) > 0
                bias = (1/ length ( svii ))* sum (Y( svii ) - e* sign ( beta ( svii )) - H(svii , svi )* beta ( svi ));
            else
                fprintf ('No support vectors with interpolation error e - cannot compute bias .\n');
                bias = ( max (Y)+ min (Y ))/2;
            end
        case 'quadratic ',
            bias = mean (Y - H* beta );
        end
    end
end