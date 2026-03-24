% Lista 2 - Exercicio 3 (Diferença Colorida)
% Visão Computacional

% Limpa o workspace e a tela
clear all;
close all;
clc;

% Carregando o pacote de processamento de imagem (necessário no Octave)
pkg load image;

% Lendo as duas imagens do diretório
img1_original = imread('Lista2/Exercicio 3/img1.jpg');
img1 = double(img1_original);

img2_original = imread('Lista2/Exercicio 3/img2.jpeg');

% Redimensionamos a imagem 2 para ter exatamente o mesmo tamanho da imagem 1
[h, w, canais] = size(img1);
img2 = imresize(img2_original, [h, w]);
img2 = double(img2);

% Lógica de processamento
% Diferença absoluta para evitar valores negativos que escurecem demais a imagem
img_processada = abs(img2 - img1);

% Para normalizar imagem colorida com 3 canais, fazemos a normalização em cada canal
if canais == 3
    for c = 1:3
        % Encontra max e min daquele canal
        valorMax = max(max(img_processada(:,:,c)));
        valorMin = min(min(img_processada(:,:,c)));
        
        if (valorMax - valorMin) > 0
            img_processada(:,:,c) = (img_processada(:,:,c) - valorMin) * (255 / (valorMax - valorMin));
        end
    end
else
    % Imagem em tons de cinza
    valorMax = max(max(img_processada));
    valorMin = min(min(img_processada));
    if (valorMax - valorMin) > 0
        img_processada = (img_processada - valorMin) * (255 / (valorMax - valorMin));
    end
end

% Mostra as imagens lado a lado em um grid de 1 linha por 3 colunas
figure;
subplot(1, 3, 1);
imshow(uint8(img1_original));
title('Imagem 1 (Original)');

subplot(1, 3, 2);
imshow(uint8(img2_original));
title('Imagem 2 (Original)');

subplot(1, 3, 3);
imshow(uint8(img_processada));
title('Imagem Processada (Colorida)');

waitfor(gcf);
