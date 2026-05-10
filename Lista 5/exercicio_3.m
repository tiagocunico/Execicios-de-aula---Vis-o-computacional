% Lista 5 - Exercício 3: Filtro de Média Geométrica
clc; clear; close all;
pkg load image; % Necessário no Octave

%% 1. Leitura das Imagens
img_original = imread('Lista 5/imgs_lista_5/I2.bmp');
img_ruidosa = imread('Lista 5/imgs_lista_5/I2_r1.bmp');

% Garantindo que estejam em tons de cinza
if size(img_original, 3) == 3, img_original = rgb2gray(img_original); end
if size(img_ruidosa, 3) == 3, img_ruidosa = rgb2gray(img_ruidosa); end

%% 2. Aplicação do Filtro de Média Geométrica (5x5)
% A média geométrica consiste em multiplicar os 25 pixels e tirar a raiz 25.
% Computacionalmente, fazer 255 elevado a 25 estoura o limite do computador.
% O grande "truque" da visão computacional para fazer isso sem erro é usar 
% Logaritmo: A Média Geométrica = Exponencial( Média Aritmética dos Logaritmos ).

% Passo 1: Converter a imagem para "double" (0 a 1) para podermos fazer contas matemáticas
% Somamos um valor minúsculo (1e-6) para evitar o erro matemático de "log(0)"
img_double = im2double(img_ruidosa) + 1e-6;

% Passo 2: Tirar o logaritmo de cada pixel da imagem
img_log = log(img_double);

% Passo 3: Aplicar a Média Aritmética normal (que já sabemos fazer) em cima dessa imagem-log
filtro_media = fspecial('average', [5 5]);
img_log_filtrada = imfilter(img_log, filtro_media, 'replicate');

% Passo 4: Aplicar a função exponencial (inversa do log) para desfazer a alteração
img_filtrada = exp(img_log_filtrada);

% Passo 5: Converter de volta para o formato de imagem (0 a 255)
img_filtrada = im2uint8(img_filtrada);

%% 3. Comparação Visual
figure('Name', 'Comparação - Filtro de Média Geométrica 5x5', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img_original);
title('Original Limpa (I2)');

subplot(1, 3, 2);
imshow(img_ruidosa);
title('Com Ruído Gaussiano (I2\_r1)');

subplot(1, 3, 3);
imshow(img_filtrada);
title('Filtrada (Média Geométrica)');

%% 4. Discussão dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% O QUE OCORREU COM A IMAGEM?
% - O filtro de média geométrica tende a preservar levemente melhor as bordas 
%   do que a média aritmética, PORÉM ele escurece MUITO a imagem e não
%   remove a granulação tão bem nesse caso.
%
% POR QUE FICOU TÃO RUIM E ESCURA?
% - A média geométrica baseia-se na multiplicação. Se o ruído Gaussiano criar 
%   um único pixel muito escuro (valor perto de 0) em um fundo claro, ao 
%   multiplicar esse pixel pelos seus vizinhos da janela 5x5, ele "puxa" a
%   média geométrica de todo aquele pedaço lá para o fundo (perto de 0).
% - O resultado é um escurecimento geral, perda de contraste e uma remoção 
%   de ruído ineficiente.
%
% QUAL A LIÇÃO DO EXERCÍCIO?
% - O filtro de Média Geométrica é bom apenas para remover ruídos do tipo 
%   "Sal" (pontos brancos), pois os pontos claros não puxam a multiplicação para 
%   baixo. Mas ele é PÉSSIMO para ruído Gaussiano e ruído "Pimenta" (pontos pretos).
% - Para a imagem I2_r1, a velha Média Aritmética (Exercício 2) foi muito superior! mais ou menos, eu achei bem parecido
% -------------------------------------------------------------------------

pause;
