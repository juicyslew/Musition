%%
clear;
clf;
load Square_Test.mat;

hold on;
signal = [rotation_rate_yradianss, rotation_rate_xradianss, rotation_rate_zradianss];
Fs = 50;
play_Fs = 44100;

% n = [-22:21];
% %n0 = zeros(size(n));
% %n0(n==0) = 1;
% wc = pi/8;
% h = wc/pi * sinc(wc/pi*n);
% sigfilt(:,1) = conv(signal(:,1), h, 'same');
% sigfilt(:,2) = conv(signal(:,2), h, 'same');
% sigfilt(:,3) = conv(signal(:,3), h, 'same');

timestamp0 = timestampunix - timestampunix(1);
%plot(timestamp0, sigfilt, 'r-');

[timestamp1, int_sig, R] = DiscreteInt(timestamp0, signal);
plot(timestamp1, int_sig(:,3), 'r-');

rollsig = attitude_rollradians(1:length(timestamp1));
pitchsig = attitude_pitchradians(1:length(timestamp1));
yawsig = attitude_yawradians(1:length(timestamp1));

plot(timestamp1, yawsig, 'k-')
%%
R = zeros(3,3,length(int_sig));
R(:,:,1) = [1, 0, 0; 0, 1, 0; 0, 0, 1];
for i = [1:length(int_sig)]
    %int_sig(i,1)
    ox = rollsig(i,1);
    %int_sig(i,2)
    oy = pitchsig(i,1);
    %int_sig(i,3)
    oz = yawsig(i,1);
    Roll = [1 0 0 ;
              0 cos(ox) -sin(ox) ;
              0 sin(ox) cos(ox) ];

    Pitch = [ cos(oy) 0 sin(oy) ;
                     0 1 0 ;
                   -sin(oy) 0 cos(oy) ];

    Yaw = [ cos(oz) -sin(oz) 0;
                  sin(oz) cos(oz) 0 ;
                  0 0 1 ];
    R(:,:,i+1) =  -Yaw * -Pitch * -Roll;
end

pos = zeros(length(R), 3);

for i = 1:length(R)-1 %-1 is jank, but whatever
    pos(i,:) = R(:,:,i) * ones(3,1);
end
comet3(pos(:,1), pos(:,2), pos(:,3));
title('Position of Phone')
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
%%

pitchintsig = InterpSig(pitchsig, Fs, play_Fs);
rollintsig = InterpSig(rollsig, Fs, play_Fs);

% Pitch Calc
pitchintsig = 440 .* (2.^(pitchintsig));
plot(pitchintsig, 'k-');

%Roll Calc
rollintsig = 1 .* (2.^(rollintsig/2));
plot(rollintsig, 'r-');
music = PosToFreq(pitchintsig, rollintsig, play_Fs);

clf;
plot(music, 'k-')

%sound(music, play_Fs)

%[timestamp2, int2_sig] = DiscreteInt(timestamp1, int_sig);
%plot(timestamp2, int2_sig, 'k-');




