% Lista 5 - Exercício 2: Filtro de Média Aritmética
clc; clear; close all;
pkg load image; % Necessário no Octave

%% 1. Leitura das Imagens
% Carregando a imagem original (sem ruído) e a imagem com ruído (I2_r1)
img_original = imread('Lista 5/imgs_lista_5/I2.bmp');
img_ruidosa = imread('Lista 5/imgs_lista_5/I2_r1.bmp');

% Garantindo que estejam em tons de cinza
if size(img_original, 3) == 3, img_original = rgb2gray(img_original); end
if size(img_ruidosa, 3) == 3, img_ruidosa = rgb2gray(img_ruidosa); end

%% 2. Aplicação do Filtro de Média Aritmética (5x5)
% -------------------------------------------------------------------------
% COMO FUNCIONA O FSPECIAL AQUI?
% O 'fspecial' é uma função nativa que constrói a "máscara" (matriz) do filtro.
% Quando pedimos um filtro 'average' de tamanho [5 5], ele cria uma matriz 
% de 5 linhas e 5 colunas. Para que o brilho da imagem não mude, a soma de 
% todos os elementos dessa matriz tem que ser 1. 
% Como são 25 elementos, o 'fspecial' simplesmente divide 1 por 25 (0.04)
% e cria uma matriz onde todos os elementos valem 0.04.
% O 'imfilter' depois vai deslizar essa matriz pela imagem, multiplicando 
% os vizinhos por 0.04 e somando, o que matematicamente é exatamente a mesma 
% coisa que "somar os 25 vizinhos e dividir por 25".
% -------------------------------------------------------------------------
tamanho_filtro = [5 5];
filtro_media = fspecial('average', tamanho_filtro);

% Aplica o filtro na imagem com ruído
% Usamos 'replicate' para tratar as bordas da imagem repetindo os pixels extremos
img_filtrada = imfilter(img_ruidosa, filtro_media, 'replicate');

%% 3. Comparação Visual
figure('Name', 'Comparação - Filtro de Média 5x5', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img_original);
title('Original Limpa (I2)');

subplot(1, 3, 2);
imshow(img_ruidosa);
title('Com Ruído (I2\_r1)');

subplot(1, 3, 3);
imshow(img_filtrada);
title('Filtrada (Média 5x5)');

%% 4. Discussão dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% O QUE O FILTRO DE MÉDIA FEZ?
% - O filtro de média aritmética substitui o valor de cada pixel pela 
%   média dos 25 pixels (5x5) ao seu redor.
%
% PONTO POSITIVO (Remoção do Ruído):
% - Como o ruído gaussiano (presente na I2_r1) causa variações aleatórias 
%   para mais e para menos, tirar a média da vizinhança ajuda a "cancelar" 
%   esses erros. Visualmente, a imagem filtrada fica muito menos "granulada".
%
% PONTO NEGATIVO (Borramento / Perda de Nitidez):
% - O filtro de média atua como um filtro passa-baixas (remove altas frequências).
% - Bordas e detalhes finos representam transições bruscas de cor (altas frequências).
% - Ao fazer a média de uma borda, ela é suavizada. O resultado final é uma 
%   imagem notavelmente mais borrada (desfocada) em comparação com a original (I2).
% -------------------------------------------------------------------------

pause;
