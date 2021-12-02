function fit = identFit(pop)
global init
global outS
global a0
global a1
global a2
global b1
global b0
global Ts
global xInit
global A
global B
global C
global D
global initVal

[a ~] = size(pop);
fit = zeros(1,a);
for i=1:a
        a0 = pop(i,1);
        a1 = pop(i,2);
        b0 = pop(i,3);
        a2 = pop(i,4);
        b1 = pop(i,5);
        a3 = pop(i,6);
        b2 = pop(i,7);
        %transfer = tf([b1, b0],[a2,a1,a0]);
        [A,B,C,D] = tf2ss([b2, b1, b0],[a3, a2,a1,a0]);
        xInit = [0, init/C(2), 0];
    
    try
        dat = sim('identifikaciaS');
        e_2 = sum(dat.e.^2);
        fit(i) = e_2;
    catch
      disp('Err');
      fit(i) = inf;
    end
end
end