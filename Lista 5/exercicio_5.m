% Lista 5 - Exercício 5: Filtro de Mediana
clc; clear; close all;
pkg load image; % Necessário no Octave

%% 1. Leitura das Imagens
img_original = imread('Lista 5/imgs_lista_5/I2.bmp');
img_ruidosa = imread('Lista 5/imgs_lista_5/I2_r1.bmp');

% Garantindo que estejam em tons de cinza
if size(img_original, 3) == 3, img_original = rgb2gray(img_original); end
if size(img_ruidosa, 3) == 3, img_ruidosa = rgb2gray(img_ruidosa); end

%% 2. Aplicação do Filtro de Mediana (5x5)
% O filtro de mediana é um filtro espacial não-linear. 
% Em vez de calcular uma média matemática (que "mistura" valores), ele 
% ordena os 25 pixels da janela do menor para o maior e simplesmente 
% escolhe o valor que caiu bem no meio (a mediana estatística).
% No Octave/MATLAB, usamos a função medfilt2:

tamanho_filtro = [5 5];
img_filtrada = medfilt2(img_ruidosa, tamanho_filtro);

%% 3. Comparação Visual
figure('Name', 'Comparação - Filtro de Mediana 5x5', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img_original);
title('Original Limpa (I2)');

subplot(1, 3, 2);
imshow(img_ruidosa);
title('Com Ruído Gaussiano (I2\_r1)');

subplot(1, 3, 3);
imshow(img_filtrada);
title('Filtrada (Mediana 5x5)');

%% 4. Discussão dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% O QUE OCORREU COM A IMAGEM?
% - O filtro de Mediana conseguiu suavizar o ruído Gaussiano muito bem.
% - A grande vantagem observada aqui em relação à Média Aritmética (Ex. 2) 
%   é que a Mediana NÃO BORROU tanto as bordas! As formas das porcas e 
%   parafusos continuam com contornos muito mais nítidos.
%
% POR QUE A MEDIANA É MELHOR PARA PRESERVAR BORDAS?
% - A Média Aritmética soma pixels claros de um lado da borda com os pixels 
%   escuros do outro lado, criando um tom de cinza intermediário e esfumaçado.
% - A Mediana NÃO inventa números novos, ela apenas escolhe um valor que JÁ 
%   EXISTE ali. Ao cruzar uma borda, a mediana estatística "pula" diretamente 
%   para a cor do outro objeto, preservando a nitidez (degrau) da borda.
%
% CONCLUSÃO GERAL DOS FILTROS (RESUMO):
% - Média Aritmética: Boa para ruído Gaussiano, mas sacrifica a nitidez (borra).
% - Média Geométrica/Harmônica: Ruins para Gaussiano/Pimenta, escurecem a imagem.
% - Mediana: A campeã de todos. Ela é imbatível contra ruído "Sal e Pimenta" 
%   (impulsivo), e neste caso do ruído Gaussiano ela demonstrou remover o ruído 
%   conseguindo proteger o contorno dos objetos da foto.
% -------------------------------------------------------------------------

pause;
