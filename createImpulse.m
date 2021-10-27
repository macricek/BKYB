function final = createImpulse(in, sizeOf)
v = size(in,1);
tmp = [];
for i = 1:v
    tmp = [tmp; 
        [in(i, 1), in(i, 2)];
        [in(i, 1) + sizeOf, 0]];
end
final = tmp;
end