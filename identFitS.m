function fit = identFitS(pop)
global outS
global Ts
global tf1
global num
global den
global b0
global a0
global initVal
global stepTime
global stopTime
[a ~] = size(pop);
fit = zeros(1,a);
for i=1:a
        a1 = pop(i,1);
        b0 = pop(i,2);
        a2 = pop(i,3);
        b1 = pop(i,4);
        num = [b1, b0];
        den = [a2, a1, a0];
        tf1 = tf(num,den);
        
    try
        dat = sim('identifikaciaa');
        e_2 = sum(dat.e.^2);
        fit(i) = e_2;
    catch
        disp('Err');
        fit(i) = inf;
    end
end