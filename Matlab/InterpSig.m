function [intsig] = InterpSig(origsig, Fs, play_Fs)
%INTERPSIG Summary of this function goes here
%   Detailed explanation goes here
    xq = linspace(1, length(origsig), length(origsig) * play_Fs/Fs);
    intsig= interp1(origsig, xq);
end