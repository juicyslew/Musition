function [newtimestamp, int_sig, R] = DiscreteInt(timestampunix, signal)
%DISCRETEINT Discrete Integration Function
%   

unixdiff = ones(size(timestampunix,1)-1,size(timestampunix,2));

for i = [1:length(unixdiff)-1]
    unixdiff(i) = timestampunix(i+1) - timestampunix(i);
end


int_sig = ones(size(signal,1)-1,size(signal,2));
%size(unixdiff)
%size(signal)
R = zeros(3,3,length(int_sig));
R(:,:,1) = [1, 0, 0; 0, 1, 0; 0, 0, 1];
for i = [1:length(int_sig)]
    %int_sig(i,1)
    ox = unixdiff(i) * signal(i,1);
    %int_sig(i,2)
    oy = unixdiff(i) * signal(i,2);
    %int_sig(i,3)
    oz = unixdiff(i) * signal(i,3);
    Roll = [1 0 0 ;
              0 cos(ox) -sin(ox) ;
              0 sin(ox) cos(ox) ];

    Pitch = [ cos(oy) 0 sin(oy) ;
                     0 1 0 ;
                   -sin(oy) 0 cos(oy) ];

    Yaw = [ cos(oz) -sin(oz) 0;
                  sin(oz) cos(oz) 0 ;
                  0 0 1 ];
    R(:,:,i+1) =  Yaw * Pitch * Roll * R(:,:,i);
    
    sy = sqrt(R(1,1,i+1) * R(1,1,i+1) + R(2,1,i+1) * R(2,1,i+1));
    
    singular = sy < 1e-6;
    
    if ~singular
        int_sig(i,1) = atan2(R(3,2,i+1), R(3,3,i+1));
        int_sig(i,2) = atan2(-R(3,1,i+1), sy);
        int_sig(i,3) = atan2(R(2,1,i+1), R(1,1,i+1));
    else
        int_sig(i,1) = atan2(-R(2,3,i+1), R(2,2,i+1));
        int_sig(i,2) = atan2(-R(3,1,i+1), sy);
        int_sig(i,3) = 0;
    end
end

% idx = find(int_rot_y <= -4);
% int_rot_y = int_rot_y(1:idx(:,1));

newtimestamp = timestampunix(1:length(int_sig));

end

