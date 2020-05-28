%% moving_avg.m - Computes moving average of a vector.

% INPUTS:
% v - 1D array of points to fit.
% n - length of moving average frame.

% OUTPUTS:
% out - moving average of v.

function out = moving_avg(v,n)

for i=n:length(v)
   out(i-n+1) = mean(v(i-n+1:i)); 
end

end