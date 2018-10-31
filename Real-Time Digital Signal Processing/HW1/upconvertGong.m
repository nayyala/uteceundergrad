%%% upconvertGong.m
%%%
%%% Demonstrates upconversion and downconversion
%%%
%%% by Prof. Brian L. Evans, bevans@ece.utexas.edu
%%% The University of Texas at Austin
%%%
%%% Original version: August 28, 2015
%%% Current version:  February 5, 2016
%%%
%%% This Matlab script will play three sounds:
%%% (1) low-frequency signal (baseband signal)
%%% (2) upconverted signal centered at a higher frequency,
%%% (3) the downconverted signal,
%%% The downconverted signal consists of the baseband
%%% signal plus some higher frequency artifacts.
%%%
%%% Note: The gong.wav file must be on your path.
%%%
%%% addpath('/Users/brianevans/Courses/SRD-MatlabFiles');

%%% Read gong signal
%%% Dominant frequencies are 520 (C5), 630 and 660 Hz (E5) from
%%% ploting the spectrum: plotspec(basebandInput, 1/fs)
%%% Maximum frequency of interest, f1, is 660 Hz.
[basebandInput, fs] = audioread('gong.wav');
basebandInput = basebandInput';
f1 = 660;

Ts = 1/fs;                           %%% Sampling time
numSamples = length(basebandInput);
n = 1 : numSamples;
t = n * Ts;
tmax = Ts * numSamples;

%%% Upconvert using sinusoidal amplitude modulation
%%% to be centered at frequency fc
fc = 4*f1;
carrier = cos(2*pi*fc*t);
modulated = (1 + basebandInput) .* carrier;

%%% Downconvert by sinusoidal amplitude demodulation
%%% 1. Modulate using the same carrier signal
%%%    (causes gain to be reduced by 1/2).
%%%    Assume knowledge of carrier frequency fc 
%%%    used in modulation/upconversion.
%%% 2. Apply lowpass filter to extract baseband
%%%    (and multiply by 2 of compensate for step 1).
%%%    Use averaging lowpass filter of length N
%%%    which has null bandwidth B = 2 pi / N.
%%%    In sinusoidal amplitude demodulation, baseband
%%%    bandwith in Hz is f1.  We can the solve for
%%%    N in B = 2 pi / N = 2 pi f1 / fs, which gives
%%%    N = fs / f1 (converted to integer).
carrier = cos(2*pi*fc*t);
modulateAgain = modulated .* carrier;

FIRlength = floor(fs/f1);
if 2*floor(FIRlength/2) == FIRlength
  FIRlength = FIRlength - 1;
end
lowpassCoeffs = ones(1, FIRlength) / FIRlength;
basebandOutput = 2*filter(lowpassCoeffs, 1, modulateAgain);
basebandOutput = basebandOutput - mean(basebandOutput);
err = immse(basebandOutput,basebandInput);

%%% Playback signals
sound(basebandInput, fs);
pause(tmax+1);
sound(modulated, fs);
pause(tmax+1);
sound(basebandOutput, fs);

