% LT com retorno pelo solo, aproximacao por cabo
x = [-10 0 10 0];
y = [20 20 20 2];
raio = [0.02 0.02 0.02 1];
m = zeros(4,4);
for i1 = 1:4,
	for i2 = i1:4,
		if i1 == i2,
			m(i1,i2) = log((2 .* abs(y(i1)))./raio(i1));
		else
			d = hypot(x(i1) - x(i2), y(i1) - y(i2));
			D = hypot(x(i1) - x(i2), y(i1) + y(i2));
			m(i1,i2) = log(D/d);
			m(i2,i1) = m(i1,i2);
		end
	end
end
mu = 4e-7.*pi;
eps = 8.85e-12;
l = mu ./ (2 .* pi) .* m;
c = 2 .* pi .* eps .* inv(m);
