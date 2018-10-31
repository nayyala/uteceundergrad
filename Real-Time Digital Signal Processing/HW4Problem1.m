% HW4 Problem 1, part a
%w = 2.24*randn(1,100000)+1;

% HW4 Problem 1, part c

time=1;                     % length of time
Ts=1/10000;                 % time interval between samples
b = (randn(1,31) >= 0);   %%% generate 100 random bits of 1s and 0s
a = round(2 * b - 1);      %%% Map 0 to -1 and 1 to 1

freqz(a);

f = 2*pi/31;
w = -pi + f/2 : f : pi - f/2;
stem(w,abs(fftshift(fft(a))));
title('Magnitude Response');

% plotspec(a,Ts);              % call plotspec to draw spectrum

