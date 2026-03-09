% Lista 2 - Exercicio 2 - Letra A
% Visão Computacional

% Limpa o workspace e a tela
clear all;
close all;
clc;

% Carregando o pacote de processamento de imagem (necessário no Octave)
pkg load image;

% Lendo as duas imagens do diretório
img1 = imread('Lista2/Exercicio 2/bg00010.bmp');
img2 = imread('Lista2/Exercicio 2/fg00009.bmp');

% Lógica de processamento
% (Adicione seu código para processar as imagens aqui)

img_processada = (img2 - img1);

% Mostra as imagens lado a lado em um grid de 1 linha por 3 colunas
figure;
subplot(1, 3, 1);
imshow(img1);
title('Imagem 1 (bg)');

subplot(1, 3, 2);
imshow(img2);
title('Imagem 2 (fg)');

subplot(1, 3, 3);
imshow(img_processada);
title('Imagem Processada');

waitfor(gcf);
