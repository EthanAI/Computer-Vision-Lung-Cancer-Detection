function m = csvread_mod(filename, r, c, rng)
%CSVREAD Read a comma separated value file.
%   M = CSVREAD('FILENAME') reads a comma separated value formatted file
%   FILENAME.  The result is returned in M.  The file can only contain
%   numeric values.
%
%   M = CSVREAD('FILENAME',R,C) reads data from the comma separated value
%   formatted file starting at row R and column C.  R and C are zero-
%   based so that R=0 and C=0 specifies the first value in the file.
%
%   M = CSVREAD('FILENAME',R,C,RNG) reads only the range specified
%   by RNG = [R1 C1 R2 C2] where (R1,C1) is the upper-left corner of
%   the data to be read and (R2,C2) is the lower-right corner.  RNG
%   can also be specified using spreadsheet notation as in RNG = 'A1..B7'.
%
%   CSVREAD fills empty delimited fields with zero.  Data files where
%   the lines end with a comma will produce a result with an extra last 
%   column filled with zeros.
%
%   See also CSVWRITE, DLMREAD, DLMWRITE, LOAD, FILEFORMATS, TEXTSCAN.

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 5.17.4.2 $  $Date: 2006/11/11 22:44:06 $

% Validate input args
if nargin==0
    error(nargchk(1,1,nargin,'struct')); 
end

% Get Filename
if ~ischar(filename)
    error('MATLAB:csvread:FileNameMustBeString', ...
        'Filename must be a string.'); 
end

% Make sure file exists
if exist(filename,'file') ~= 2 
    error('MATLAB:csvread:FileNotFound',...
    'File not found.');
end

%
% Call dlmread with a comma as the delimiter
%
if nargin < 2
    r = 0;
end
if nargin < 3
    c = 0;
end
if nargin < 4
    m=dlmread_mod(filename, ',', r, c); %%%% _mod version calls dlmread_mod instead of dlmread
else
    m=dlmread_mod(filename, ',', r, c, rng); %%%% _mod version calls dlmread_mod instead of dlmread
end
