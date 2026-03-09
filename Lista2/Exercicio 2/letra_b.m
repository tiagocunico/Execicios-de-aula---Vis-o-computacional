% Lista 2 - Exercicio 2 - Letra B
% Visão Computacional

% Limpa o workspace e a tela
clear all;
close all;
clc;

% Carregando o pacote de processamento de imagem (necessário no Octave)
pkg load image;

% Lendo as duas imagens do diretório
img1 = imread('Lista2/Exercicio 2/bg00010.bmp');
img1 = double(img1);

img2 = imread('Lista2/Exercicio 2/fg00009.bmp');
img2 = double(img2);

% Lógica de processamento
% (Adicione seu código para processar as imagens aqui)

img_processada = (img2 - img1);



[linhas, colunas] = size(img_processada);

ValorMaisEscuro = 255;
ValorMaisClaro = 0;

for i = 1:linhas
    for j = 1:colunas
        
        if img_processada(i, j) < ValorMaisEscuro
            ValorMaisEscuro = img_processada(i, j);
        end
        
        if img_processada(i, j) > ValorMaisClaro
            ValorMaisClaro = img_processada(i, j);
        end
        
    end
end

for i = 1:linhas
    for j = 1:colunas
        img_processada(i, j) = (img_processada(i, j) - ValorMaisEscuro) * (255 / (ValorMaisClaro - ValorMaisEscuro));
    end
end




% Mostra as imagens lado a lado em um grid de 1 linha por 3 colunas
figure;
subplot(1, 3, 1);
imshow(uint8(img1));
title('Imagem 1 (bg)');

subplot(1, 3, 2);
imshow(uint8(img2));
title('Imagem 2 (fg)');

subplot(1, 3, 3);
imshow(uint8(img_processada));
title('Imagem Processada');

waitfor(gcf);
