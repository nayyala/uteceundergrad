%Chirp Signal Generation
time = 10;
f0 = 20;
fstep = 420;
fs = 44100;
Ts = 1/fs;
t = 0:Ts:time;
c = cos(2*pi*f0*t + pi*fstep*t.^2);

%plotspec(c,Ts);

sound(c,fs);

%spectrogram(c);