function [ classValues ] = num2RadClass( predict )
%num2RadClass Takes values 1-5 and converts them into a discrete rating
%   To make the area around 1 and 5 equal to the area around 2, 3 and 4,
%   the rounding buckets are as follows: 1.0 - 1.8 - 2.6 - 3.4 - 4.2 - 5.0
%   Everyone (all 5 ratings) get 0.8 points of space

ones = ((predict < 1.8) & (predict >= 1.0));
twos = ((predict < 2.6) & (predict >= 1.8));
twos = twos * 2;
threes = ((predict < 3.4) & (predict >= 2.6));
threes = threes * 3;
fours = ((predict < 4.2) & (predict >= 3.4));
fours = fours * 4;
fives = ((predict <= 5.0) & (predict >= 4.2));
fives = fives * 5;

classValues = ones + twos + threes + fours + fives;

end

