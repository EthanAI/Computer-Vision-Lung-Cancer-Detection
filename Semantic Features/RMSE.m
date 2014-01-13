function [ RMSE ] = RMSE( X, Y )
%RMSE Root Mean Squared Error
%   RMSE is a standard method, wiki it. Its more 'relatable' to real values
%   than MSE so using this method to get an idea how bad our predictions
%   are off. Only makes sense for continous numerical labels, not classes.

RMSE = sqrt(mean((X - Y).^2));

end

