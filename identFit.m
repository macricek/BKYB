function fit = identFit(pop)
global outS
global Ts
global tf1
global num
global den
global initVal
global stepTime
global stopTime
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
        num = [b2, b1, b0];
        den = [a3, a2, a1, a0];
        tf1 = tf(num,den);
        
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