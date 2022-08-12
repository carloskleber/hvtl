z = 1i*0.34;
y = 1i*4.8e-6;
zc = sqrt(z / y);
gama = sqrt(z * y);
a = cosh(gama * l);
b = zc * sinh(gama * l);
c = 1/zc * sinh(gama * l);
q = [a b; c a];
v = zeros(11,1);
v(end) = 750e3 / sqrt(3);
i2 = 2e9/750e3/sqrt(3);
tmp = [v(end); i2];
for i1 = 10:-1:1,
	tmp = q * tmp;
	v(i1) = tmp(1);
end
plot(abs(v).*1e-3.*sqrt(3));
ylabel('Tensao [kV]');