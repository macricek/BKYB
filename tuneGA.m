function fit = tuneGA(pop)
global Ag
global TI
global kI
global VI
global S1b
global S2b
global Ib
global Si
global p2
global Vg
global Gb
global Sg
global Td

[a ~] = size(pop);
fit = zeros(1,a);
for i=1:a      
    Sg = pop(i,1);
    Td = pop(i,2);
    try
        dat = sim('bergman');
        %e_2 = sum(dat.e.^2);
        e_2 = sum(dat.e(5001:12000).^2);
        fit(i) = e_2;
    catch
        disp('Err');
        fit(i) = inf;
    end
end

end