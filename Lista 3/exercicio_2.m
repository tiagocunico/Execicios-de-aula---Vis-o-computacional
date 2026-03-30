
% Leitura da imagem original
im_in = imread('Lista 3/Imagens/neg1.jpg');
im_out = im_in;

[linhas, colunas] = size(im_in);

for i = 1:linhas
    for j = 1:colunas
        im_out(i, j) = 255 - im_in(i, j);
    end
end

% Criação da figura para comparação
figure('Name', 'Comparação da Imagem', 'NumberTitle', 'off');

% Exibição da imagem original
subplot(1, 2, 1);
imshow(im_in);
title('Imagem Original');

% Exibição da imagem processada
subplot(1, 2, 2);
imshow(im_out);
title('Imagem Processada');

pause;
