
% Leitura da imagem original
im_in = imread('Lista 3/Imagens/im_in.bmp');
im_out = im_in;

[linhas, colunas] = size(im_in);
k = zeros(1, 256);

for i = 1:linhas
    for j = 1:colunas
        % Pega o valor do pixel (0 a 255)
        valor_pixel = double(im_in(i, j));
        % Adiciona 1 no histograma desse valor de pixel
        k(valor_pixel + 1) =  k(valor_pixel + 1) + 1;
    end
end
for i = 1:256
    % Calcula a probabilidade de cada valor de pixel
    h(i) = (1/(linhas*colunas)) * k(i);
end

% Criação da figura para comparação
figure('Name', 'Comparação da Imagem', 'NumberTitle', 'off');

% Exibição da imagem original
subplot(1, 2, 1);
imshow(im_in);
title('Imagem Original');

% Exibição da imagem processada
subplot(1, 2, 2);
bar(0:255, h);
xlim([0 255]);
title('Histograma Calculado');

pause;
