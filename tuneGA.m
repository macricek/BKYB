function fit = tuneGA(pop)
global S1b
global S2b
global Ib
global TI
global kI
global VI

[a ~] = size(pop);
fit = zeros(1,a);
for i=1:a      
    TI = pop(i,1);
    kI = pop(i,2);
    VI = pop(i,3);
    gamma = 5e-4;
    try
        dat = sim('cv4modelGA');
        e_2 = sum(dat.fitness.^2);
        e_v = (100-VI)^2;
        fit(i) = e_2 + gamma*e_v;
    catch
        disp('Err');
        fit(i) = inf;
    end
end

end