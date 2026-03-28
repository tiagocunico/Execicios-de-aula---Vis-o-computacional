% Lista 2 - Exercicio 4
% Visão Computacional

% Limpa o workspace e a tela
clear all;
close all;
clc;

% Carregando o pacote de processamento de imagem (necessário no Octave)
pkg load image;

% Lendo a imagem do diretório
disp('Lendo a imagem fg00009.bmp...');
img = imread('Lista2/Exercicio 4/fg00009.bmp');

% Se a imagem for colorida (RGB), converte para tons de cinza
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = double(img);
img_processada3x3 = double(img);
img_processada9x9 = double(img);


[linhas, colunas] = size(img_processada3x3);
for i = 1:linhas
    for j = 1:colunas
        
        Media = 0;
        Medicoes = 0;
        for i2 = 1:3
            for j2 = 1:3
                if (i+i2) <= linhas && (j+j2) <= colunas && (i+i2) >= 0 && (j+j2) >= 0
                    Media = Media + img(i+i2, j+j2);
                    Medicoes = Medicoes + 1; 
                end
            end
        end
        Media = Media / Medicoes;
        img_processada3x3(i, j) = Media;
        
    end
end


[linhas, colunas] = size(img_processada9x9);
for i = 1:linhas
    for j = 1:colunas
        
        Media = 0;
        Medicoes = 0;
        for i2 = 1:9
            for j2 = 1:9
                if (i+i2) <= linhas && (j+j2) <= colunas && (i+i2) >= 0 && (j+j2) >= 0
                    Media = Media + img(i+i2, j+j2);
                    Medicoes = Medicoes + 1; 
                end
            end
        end
        Media = Media / Medicoes;
        img_processada9x9(i, j) = Media;
        
    end
end




% Mostra as imagens na tela
figure;

subplot(1, 3, 1);
imshow(uint8(img));
title('Imagem Original');

subplot(1, 3, 2);
imshow(uint8(img_processada3x3));
title('Imagem Processada 3x3');

subplot(1, 3, 3);
imshow(uint8(img_processada9x9));
title('Imagem Processada 9x9');

% Mantém a janela aberta até que o usuário a feche
waitfor(gcf);
