clear all

im = imread("imgs_lista_8/Circulo.png");
[im_y, im_x] = size(im(:,:,1));

% se a imagem for colorida converte para cinza, se ja for P&B usa direto
if size(im, 3) == 3
  im_gray = rgb2gray(im);
else
  im_gray = im;
end
im_bin = im_gray ~= 0; % 1-bit colormap: fundo=0, circulo=1 (igual ao Linha.png)
disp(['Pixels processados: ', num2str(sum(im_bin(:)))]);

% raio fixo do circulo a detectar — ajuste conforme a imagem
r = 90;

% o centro do circulo pode estar fora da imagem (ate r pixels fora)
% por isso o acumulador e maior que a imagem e usamos offsets
a_offset = r;
b_offset = r;
a_size = im_x + 2 * r;
b_size = im_y + 2 * r;

% acumulador 2D: eixo 1 = linha do centro (b), eixo 2 = coluna do centro (a)
Acu = zeros(b_size, a_size);

for i = 1:im_y
  for j = 1:im_x
    if im_bin(i, j) == 1
      % para cada pixel de borda, o centro pode estar em qualquer direcao
      % varremos 360 graus e calculamos onde estaria o centro
      % a = x - r*cos(theta)
      % b = y - r*sin(theta)
      for k = 1:360
        theta = (k - 1) * pi / 180;
        a = round(j - r * cos(theta)) + a_offset;
        b = round(i - r * sin(theta)) + b_offset;
        if a >= 1 && a <= a_size && b >= 1 && b <= b_size
          Acu(b, a) = Acu(b, a) + 1;
        end
      end
    end
  end
end

limiar = 40;
areaAZerar = 20;
circulos = []; % cada circulo guardado como [a_real, b_real]

continua = 1;
while continua
  % encontra o pico no acumulador
  max_val = 0;
  max_a = 0;
  max_b = 0;
  for b = 1:b_size
    for a = 1:a_size
      if Acu(b, a) > max_val
        max_val = Acu(b, a);
        max_a = a;
        max_b = b;
      end
    end
  end

  if max_val >= limiar
    a_real = max_a - a_offset;
    b_real = max_b - b_offset;
    circulos = [circulos; a_real, b_real];
    disp(['Circulo encontrado: acumulador=', num2str(max_val), ' | centro=(', num2str(a_real), ', ', num2str(b_real), ')']);

    % zera regiao ao redor do pico para nao detectar o mesmo circulo de novo
    a_min = max(1, max_a - areaAZerar);
    a_max = min(a_size, max_a + areaAZerar);
    b_min = max(1, max_b - areaAZerar);
    b_max = min(b_size, max_b + areaAZerar);
    Acu(b_min:b_max, a_min:a_max) = 0;
  else
    continua = 0;
  end
end

% parametros para desenhar os circulos detectados
theta_plot = 0:0.01:2*pi;

figure('Position', [100, 100, 1400, 500]);
subplot(1, 3, 1);
imshow(im_bin);
title('Imagem Binarizada');

subplot(1, 3, 2);
imagesc(Acu);
colormap(gca, hot);
colorbar;
title('Espaco de Hough (circulos)');

subplot(1, 3, 3);
imshow(im_bin);
hold on;
for n = 1:size(circulos, 1)
  a_real = circulos(n, 1);
  b_real = circulos(n, 2);
  x_circle = a_real + r * cos(theta_plot);
  y_circle = b_real + r * sin(theta_plot);
  % filtra pontos fora da imagem
  mask = x_circle >= 1 & x_circle <= im_x & y_circle >= 1 & y_circle <= im_y;
  plot(x_circle(mask), y_circle(mask), 'r-', 'LineWidth', 2);
end
title('Circulos Detectados');
pause;
