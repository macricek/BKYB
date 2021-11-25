
global init
global out
global a0
global a1
global a2
global b1
global b0
global d
global Ts
global xInit
global A
global B
global C
global D
load('tep.mat');
out.time = tout;
out.signals.values = tepN';
out.signals.dimensions = 1;
Ts = 0.01;
init = tepN(1);

load('paramsFull2');
a0 = Best(1);
a1 = Best(2);
b0 = Best(3);
a2 = Best(4);
b1 = Best(5);

[A,B,C,D] = tf2ss([b1, b0],[a2,a1,a0]);
xInit = [0, init/C(2)];
dat = sim('identifikacia');
figure
hold on
plot(tout,tepN);
plot(dat.y);