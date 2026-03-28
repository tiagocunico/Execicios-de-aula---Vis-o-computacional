% Lista 2 - Exercicio 1
% Visão Computacional

% Limpa o workspace e a tela
clear all;
close all;
clc;

% Carregando o pacote de processamento de imagem (necessário no Octave)
pkg load image;

% Exemplo de código inicial:
img = imread('Lista2/Exercicio 1/ex2.bmp');


[linhas, colunas] = size(img);

ValorMaisEscuro = 255;
ValorMaisClaro = 0;

for i = 1:linhas
    for j = 1:colunas
        
        if img(i, j) < ValorMaisEscuro
            ValorMaisEscuro = img(i, j);
        end
        
        if img(i, j) > ValorMaisClaro
            ValorMaisClaro = img(i, j);
        end
        
    end
end



for i = 1:linhas
    for j = 1:colunas
        
        img_processada(i, j) = (img(i, j) - ValorMaisEscuro) * (255 / (ValorMaisClaro - ValorMaisEscuro));
        
    end
end



% Mostra as imagens lado a lado
figure;

% Define um grid de 1 linha por 2 colunas, e seleciona a posição 1
subplot(1, 2, 1);
imshow(img);
title('Imagem Original');

% Seleciona a posição 2 do grid
subplot(1, 2, 2);
imshow(img_processada);
title('Imagem Processada');

% Pausa a execução e aguarda você fechar a figura para finalizar o script
waitfor(gcf);
