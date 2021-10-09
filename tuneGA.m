function fit = tuneGA(pop)
global time;
global glucose;
global insuline;
global xq;
global glucose_int;
global insuline_int;
global Ib;
global Gb;
global p2;
global Si;
global Sg;
global G_0;

[a ~] = size(pop);
fit = zeros(1,a);
for i=1:a      
    p2 = pop(i,1);%3.2736e-2;
    Si = pop(i,2);%1.0278e-13;
    Sg = pop(i,3);%3.0031e-2;
    G_0 = pop(i,4);%14.9;
    try
        dat = sim('bergman_GA');
        e = dat.error;
        fit(i) = sum(abs(e));
    catch
        disp('Err');
        fit(i) = 10000;
    end
end

end