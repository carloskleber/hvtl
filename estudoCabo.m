function estudoCabo
% estudo de cabo - CAL6201
peso = 0.4864;
Tcrit = 5330;
T01 = 0.2*Tcrit;
secao = 480e-6;
diam = 17.2e-3;
E = 5976e6;
alfa = 23e-6;
emiss = 1;
tamb = 20;

close all
C1 = T01./peso;
T02 = 400:5:2300;
C2 = T02./peso;
vao1 = 300;
delta1 = eqEstado(vao1, C1, C2, T01, T02, alfa, E, secao);
vao2 = 500;
delta2 = eqEstado(vao2, C1, C2, T01, T02, alfa, E, secao);
vao3 = 1000;
delta3 = eqEstado(vao3, C1, C2, T01, T02, alfa, E, secao);
figure;
plot(delta1 + tamb, T02, delta2 + tamb, T02, delta3 + tamb, T02);
axis([-100 100 600 2400]);
xlabel('Temperatura [^oC]');
ylabel('Tracao [kgf]');
legend('300 m', '500 m', '1000 m', 'Location', 'Best');
salvar('tempTracao');

flecha1 = flecha(peso, vao1, T02);
flecha2 = flecha(peso, vao2, T02);
flecha3 = flecha(peso, vao3, T02);
figure;
plot(tamb + delta1, flecha1, tamb + delta2, flecha2, tamb + delta3, flecha3); 
axis([-100 150 0 100]);
xlabel('Temperatura [^oC]');
ylabel('Flecha [m]');
legend('300 m', '500 m', '1000 m', 'Location', 'Best');
salvar('tempFlecha');

temp = tamb+3:175;
r = 2.26e-4;
v = 1;
dia = true;
amp = ampacidade(temp, tamb, emiss, diam, v, r, dia);
figure;
plot(amp, temp);
xlabel('Corrente [A]');
ylabel('Temperatura [^oC]');
salvar('corrTemp');

% interpolacao das tracoes para as temperaturas da ampacidade
TracAmp1 = interp1(tamb + delta1, T02, temp);
TracAmp2 = interp1(tamb + delta2, T02, temp);
TracAmp3 = interp1(tamb + delta3, T02, temp);
flechaAmp1 = interp1(tamb + delta1, flecha1, temp);
flechaAmp2 = interp1(tamb + delta2, flecha2, temp);
flechaAmp3 = interp1(tamb + delta3, flecha3, temp);

figure;
plot(amp, TracAmp1, amp, TracAmp2, amp, TracAmp3);
xlabel('Corrente [A]');
ylabel('Tracao [kgf]');
legend('300 m', '500 m', '1000 m', 'Location', 'Best');
salvar('corrTrac');

figure;
plot(amp, flechaAmp1, amp, flechaAmp2, amp, flechaAmp3);
xlabel('Corrente [A]');
ylabel('Flecha [m]');
legend('300 m', '500 m', '1000 m', 'Location', 'Best');
salvar('corrFlecha');

%% confeccao do gabarito
% a partir do vao de 500 m, estima-se a flecha para a condicao basica,
% usa-se a equacao de estado para flecha minima e maxima, e extrapola

tmin = -10;
tmax = 90;
hseg = 10; % altura minima de seguranca
TracMax = interp1(tamb + delta2, T02, tmin);
TracMin = interp1(tamb + delta2, T02, tmax);
fmin = flecha(peso, vao2, TracMax);
fmax = flecha(peso, vao2, TracMin);
fprintf('Limites das flechas para um vao de 500 m: %.2f m a %.2f m.\n', fmin, fmax)
v = 0:10:2000;
curvaMin = fmin .* (v ./ vao2).^2 .* 10; % ja com exagero vertical
curvaMax = fmax .* (v ./ vao2).^2 .* 10;
figure;
c1 = curvaMin + max(curvaMax) - max(curvaMin);
c2 = curvaMax;
vref = [-v(end:-1:1) v]./2;
plot(vref, [c1(end:-1:1) c1], vref, [c2(end:-1:1) c2], vref, [c2(end:-1:1) c2] - hseg.*10);
axis equal
grid on
title('Gabarito para flechas');

	function dt = eqEstado(vao, c1, c2, t01, t02, alfa, e, s)
		%% equacao de estado
		dt = 1./alfa .* ((c2 .* sinh(vao./(2 .* c2)))./(c1 .* sinh(vao./(2 .* c1))) -1 -1./(e.*s) .* (t02 - t01));
	end % function

	function f = flecha(peso, vao, tracao)
		%% flecha
		f = peso .* vao.^2 ./(8 .* tracao);
	end % function

	function i = ampacidade(t, tamb, emiss, diam, vvento, r, sol)
		%% ampacidade
		qr = 179200 .* emiss .* diam .* (((t+273)./1000).^4 - ((tamb+273)./1000).^4);
		qc = 0.09456 .* (t - tamb) .* (0.32 + 0.43 .*(45946.8 .* diam .* vvento).^0.52);
		qs = sol .* (204 .* diam);
		i = sqrt((qr + qc - qs)./r);
	end % function

	function ajustaEixos
		axis tight
		x = axis;
		axis([x(1:2) x(3:4).*1.1]);
		box off;
		grid off;
		set(gca, 'YGrid', 'on');
		set(gca, 'YTick', 0);
		set(gca, 'XGrid', 'on');
		set(gca,'XTick',0:pi/2:2*pi);
		set(gca,'XTickLabel',{'0','pi/2','pi','3pi/2','2pi'});
	end

	function salvar(nome)
		%% salvar as figuras para apostila
		set(gcf, 'PaperPosition', [0 0 7 5]);
		set(gcf, 'PaperSize', [7 5]);
		saveas(gcf, ['../' nome '.pdf'], 'pdf');
	end

end %function