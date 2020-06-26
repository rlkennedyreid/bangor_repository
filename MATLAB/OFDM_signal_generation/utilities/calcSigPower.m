function power = calcSigPower(sig)
%CALCSIGPOWER Summary of this function goes here
%   Detailed explanation goes here
power = sum(abs(sig(:)).^2)/numel(sig);
end

