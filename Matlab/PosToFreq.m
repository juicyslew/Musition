        %disp(i*convertval)
        %tn = i/play_Fs;
        %currsig = in(floor(i*convertval)+1);
        %phase = mod(tn, 1/currsig) * lastsig/currsig ;
        %signal(i) = sin(2*pi*(lastsig*i/play_Fs+phase));
        %lastsig = currsig;

function [signal] = PosToFreq(pitch, vol, Fs)
%POSTOFREQ converts position or orientation signal to auditory signal
%   Takes the value of the input and converts those values to frequencies.
    %convertval = Fs/play_Fs;
    signal = zeros(length(pitch),1);
    %disp(size(signal))
    %disp(convertval)
    %disp(size(in))
    
    h_1 = pitch(1); %frequency of first wave
    hs = zeros(length(pitch), 1); %frequency ratios of first to other waves
    
    for j = 1:length(pitch)
        hs(j) = h_1/pitch(j);
    end
    
    t_1 = 0;
    for i = 1:length(signal)-1 %-1 because was going out of bounds
        t_1 = t_1 + (1/Fs) / hs(i);
        t = t_1 * hs(i);
        signal(i) = vol(i)*sin(2*pi*pitch(i)*(t)); %sin(2*pi*freq*time);
    end
end

