%Problem 1

%5 Coefficient Averaging Filter

b1 = [0.2 0.2 0.2 0.2 0.2];
a1 = [1];

zplane(b1,a1);

freqz(b1,a1)

%Causal discrete-time approximation to first-order differentiator

b2 = [1 -1];

zplane(b2);

freqz(b2);

%Causal discrete-time approximation to a first-order integrator

b3 = [1];
a3 = [1 -1];

zplane(b3,a3);

freqz(b3,a3);

%Causal bandpass filter with center frequency w0 

w0 = pi/2;
r = 0.95;

b4 = [1 -cos(w0)]
a4 = [1 -1.9*cos(w0) 0.9025];

zplane(b4,a4);

freqz(b4,a4);





