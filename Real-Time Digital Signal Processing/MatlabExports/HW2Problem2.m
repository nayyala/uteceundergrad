%HW2, Problem 2, part a

[x,fs] = audioread('twosignals.wav');
%plotspec(x,1/fs);
%sound(x,fs);

% nsize = 10240;
% nover = 3/4*nsize;
% nfft = [];
% spectrogram(x, nsize, nover, [], fs, 'yaxis'); 
% h = colorbar;
% ylabel(h, 'Magnitude, dB'); ylabel('Frequency, kHz');
% xlabel('Time, s');title('Spectrogram of the signal'); 
% figure;

% %part b
fnyq = fs/2;
fpass1 = 0;
fpass2 = 1300;
fstop = 1800;
ctfreq = [fpass1 fpass2 fstop fnyq];
idealamp = [1 1 0 0];
pmfreq = ctfreq/fnyq;
filterOrder = 50;
filterCoeffs = firpm(filterOrder,pmfreq,idealamp);
y = filter(filterCoeffs,1,x);

%part d
%y = y(1:2:length(y));
 %sound(y,fs);
% plotspec(y,1/fs);

%part e
vec = cumsum(ones(1,length(y)));
upsampledLength = 2*length(vec);
vecUpsampledBy2 = zeros(1,upsampledLength);
vecUpsampledBy2(1:2:upsampledLength) = y;

sound(vecUpsampledBy2,2*fs);
plotspec(y,0.5/fs);




%part c
% fnyq = fs/2;
% fpass = 2500;
% fstop = 3000;
% ctfreq = [0 fpass fstop fnyq];
% idealamp = [0 0 1 1];
% pmfreq = ctfreq/fnyq;
% filterOrder = 50;
% filterCoeffs = firpm(filterOrder,pmfreq,idealamp);
% y = filter(filterCoeffs,1,x);
% sound(y,fs);
% plotspec(y,1/fs);


