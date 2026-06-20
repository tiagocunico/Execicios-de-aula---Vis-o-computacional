clear all

im = imread("imgs_lista_8/4Retas.png");
[im_y, im_x] = size(im);

% na forma polar, rho = x*cos(theta) + y*sin(theta)
% rho representa a distancia da reta ate a origem
% rho pode ser negativo, entao usamos um offset para indexar o acumulador
% a diagonal e o maior rho possivel (canto mais distante da imagem)
diag = round(sqrt(im_x^2 + im_y^2));
rho_offset = diag;
rho_size = 2 * diag + 1;

% acumulador: eixo 1 = angulo theta (0 a 179 graus), eixo 2 = rho deslocado
Acu = zeros(180, rho_size);

for i = 1:im_y
  for j = 1:im_x
    if im(i, j) == 1
      % para cada pixel, varremos os 180 angulos e calculamos rho
      % diferente do slope-intercept, cos e sin nunca explodem
      % entao retas verticais (theta=0) e horizontais (theta=90) funcionam normalmente
      for k = 1:180
        theta = (k - 1) * pi / 180; % theta vai de 0 a 179 graus
        rho = round(j * cos(theta) + i * sin(theta)) + rho_offset;
        if rho >= 1 && rho <= rho_size
          Acu(k, rho) = Acu(k, rho) + 1;
        end
      end
    end
  end
end

limiar = 63;
areaAZerar = 10;
linhas = []; % cada linha guardada como [k, rho_real]

continua = 1;
while continua
  max_val = 0;
  max_k = 0;
  max_rho = 0;
  for k = 1:180
    for rho = 1:rho_size
      if Acu(k, rho) > max_val
        max_val = Acu(k, rho);
        max_k = k;
        max_rho = rho;
      end
    end
  end

  if max_val >= limiar
    max_rho_real = max_rho - rho_offset;
    linhas = [linhas; max_k, max_rho_real];
    disp(['Reta encontrada: acumulador=', num2str(max_val), ' | angulo=', num2str(max_k - 1), ' graus | rho=', num2str(max_rho_real)]);

    % zera janela ao redor do pico para nao detectar a mesma reta de novo
    k_min = max(1, max_k - areaAZerar);
    k_max = min(180, max_k + areaAZerar);
    r_min = max(1, max_rho - areaAZerar);
    r_max = min(rho_size, max_rho + areaAZerar);
    Acu(k_min:k_max, r_min:r_max) = 0;

    % remove os votos dos pixels da reta detectada do acumulador
    % operacao inversa da construcao: subtrai 1 em vez de somar
    theta_reta = (max_k - 1) * pi / 180;
    for col = 1:im_x
      % equacao da reta em forma polar: rho = x*cos(theta) + y*sin(theta)
      % isolando y: y = (rho - x*cos(theta)) / sin(theta)
      % para theta=0 (reta vertical): x = rho/cos(0) = rho
      if abs(sin(theta_reta)) < 1e-6
        row = round(max_rho_real / cos(theta_reta));
        if col ~= row
          continue;
        end
        row = im_y / 2; % linha qualquer para percorrer coluna vertical
      else
        row = round((max_rho_real - col * cos(theta_reta)) / sin(theta_reta));
      end
      if row >= 1 && row <= im_y
        for k = 1:180
          theta = (k - 1) * pi / 180;
          rho_voto = round(col * cos(theta) + row * sin(theta)) + rho_offset;
          if rho_voto >= 1 && rho_voto <= rho_size
            Acu(k, rho_voto) = max(0, Acu(k, rho_voto) - 1);
          end
        end
      end
    end
  else
    continua = 0;
  end
end

figure('Position', [100, 100, 1400, 500]);
subplot(1, 3, 1);
imshow(im);
title('Imagem Original');

subplot(1, 3, 2);
imagesc(Acu);
colormap(gca, hot);
colorbar;
title('Espaco de Hough (polar)');

subplot(1, 3, 3);
imshow(im);
hold on;
for n = 1:size(linhas, 1)
  theta_n = (linhas(n, 1) - 1) * pi / 180;
  rho_n = linhas(n, 2);
  x_vals = 1:im_x;
  % isola y da equacao polar: y = (rho - x*cos(theta)) / sin(theta)
  % para retas verticais (sin~0), plota uma linha vertical em x=rho/cos(theta)
  if abs(sin(theta_n)) < 1e-6
    x_vert = round(rho_n / cos(theta_n));
    plot([x_vert, x_vert], [1, im_y], 'r-', 'LineWidth', 2);
  else
    y_vals = round((rho_n - x_vals * cos(theta_n)) / sin(theta_n));
    % filtra pontos fora da imagem para nao expandir o plot
    mask = y_vals >= 1 & y_vals <= im_y;
    plot(x_vals(mask), y_vals(mask), 'r-', 'LineWidth', 2);
  end
end
title('Retas Detectadas');
pause;
