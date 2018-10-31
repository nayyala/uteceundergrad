
%Creating continuous-time sinusoidal signal
t = 0:0.001:1;
xt = sin(2*pi*5*t);
plot(t,xt);
title('Lab 1');
xlabel('t');
ylabel('xt');

v = xt(t(320)/0.001);
w = xt(t(640)/0.001);

%Sampling continuous-time sinusoidal signal

xn = xt(1:8:end);
xng = 0:0.008:1;

hold on
stem(xng,xn);
hold off

