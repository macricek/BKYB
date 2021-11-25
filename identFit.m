function fit = identFit(pop)
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

[a ~] = size(pop);
fit = zeros(1,a);
for i=1:a
        a0 = pop(i,1);
        a1 = pop(i,2);
        b0 = pop(i,3);
        d = 0;
        a2 = pop(i,4);
        b1 = pop(i,5);
        %transfer = tf([b1, b0],[a2,a1,a0]);
        [A,B,C,D] = tf2ss([b1, b0],[a2,a1,a0]);
        xInit = [0, init/C(2)];
    
    try
        dat = sim('identifikacia');
        e_2 = sum(dat.e.^2);
        fit(i) = e_2;
    catch
        disp('Err');
        fit(i) = inf;
    end
end
end