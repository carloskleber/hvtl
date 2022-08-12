clear all
ia = 1;
ib = -0.9i;
ic = 1.2i;
zp = 0.18i;
zm = 0.06i;
zabc = [zp zm zm; zm zp zm; zm zm zp]
iabc = [ia; ib; ic]
vabc = zabc * iabc;
disp('Vabc')
abs(vabc)
angle(vabc)*180/pi
a = 1*exp(i*120*pi/180);
A = [1 1 1; 1 a*a a; 1 a a*a];
z012 = A\zabc*A
i012 = A\iabc
disp('I012')
abs(i012)
angle(i012)*180/pi
v012 = z012 * i012;
disp('V012')
abs(v012)
angle(v012)*180/pi
vabcr = A * v012;
disp('Prova de Vabc')
abs(vabcr)
angle(vabcr)*180/pi


















