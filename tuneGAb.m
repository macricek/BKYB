function fit = tuneGAb(pop)
global S1b
global S2b
global Ib
global TI
global kI
global VI
global Sg
global Vg
global Gb
global Si
global p2

[a ~] = size(pop);
fit = zeros(1,a);
for i=1:a      
    Si = pop(i,1) / 10;
    p2 = pop(i,2) / 10;
    try
        dat = sim('bergmanGA');
        e_2 = sum(dat.fitness.^2);
        fit(i) = e_2;
    catch
        disp('Err');
        fit(i) = inf;
    end
end

end