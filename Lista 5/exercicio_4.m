% Lista 5 - Exercício 4: Filtro de Média Harmônica
clc; clear; close all;
pkg load image; % Necessário no Octave

%% 1. Leitura das Imagens
img_original = imread('Lista 5/imgs_lista_5/I2.bmp');
img_ruidosa = imread('Lista 5/imgs_lista_5/I2_r1.bmp');

% Garantindo que estejam em tons de cinza
if size(img_original, 3) == 3, img_original = rgb2gray(img_original); end
if size(img_ruidosa, 3) == 3, img_ruidosa = rgb2gray(img_ruidosa); end

%% 2. Aplicação do Filtro de Média Harmônica (5x5)
% A fórmula da média harmônica é: N / Soma(1 / pixel)
% Mais uma vez, para que o código rode rápido sem usar laços "for", 
% usamos um truque matemático com o imfilter!

% Passo 1: Converter para double e somar valor ínfimo para evitar dividir por zero
img_double = im2double(img_ruidosa) + 1e-6;

% Passo 2: Fazer o inverso de cada pixel (1 / valor)
img_inv = 1 ./ img_double;

% Passo 3: O fspecial('average') já calcula a (Soma / N). 
% Então, aplicá-lo na imagem invertida nos dá exatamente: Soma(1 / pixel) / N
filtro_media = fspecial('average', [5 5]);
img_inv_filt = imfilter(img_inv, filtro_media, 'replicate');

% Passo 4: Fazer o inverso do resultado novamente para obtermos a Harmônica!
% O inverso de (Soma/N) é (N/Soma), que é a fórmula exata da Média Harmônica.
img_filtrada = 1 ./ img_inv_filt;

% Passo 5: Voltar para escala de 0 a 255
img_filtrada = im2uint8(img_filtrada);

%% 3. Comparação Visual
figure('Name', 'Comparação - Filtro de Média Harmônica 5x5', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img_original);
title('Original Limpa (I2)');

subplot(1, 3, 2);
imshow(img_ruidosa);
title('Com Ruído Gaussiano (I2\_r1)');

subplot(1, 3, 3);
imshow(img_filtrada);
title('Filtrada (Média Harmônica)');

%% 4. Discussão dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% COMO FICOU O RESULTADO?
% - Assim como a Média Geométrica, a Média Harmônica também não tem um bom 
%   desempenho para remover o ruído Gaussiano (presente em I2_r1). 
% - Ela também tende a escurecer a imagem, embora as bordas possam parecer 
%   um pouco diferentes do filtro geométrico.
%
% POR QUE ESSE FILTRO FALHOU AQUI?
% - O filtro de Média Harmônica tem uma fraqueza matemática grave: se houver 
%   qualquer pixel muito escuro (perto de zero) na janela de 5x5, a conta 
%   "1 / pixel" vai dar um número gigantesco. Isso "explode" o denominador 
%   da fórmula e puxa o resultado final do pixel para muito perto de zero (preto).
% - Como o ruído Gaussiano cria pontinhos escuros aleatórios, a imagem inteira 
%   acaba sofrendo essa "puxada para o preto".
%
% QUAL A LIÇÃO DO EXERCÍCIO?
% - A Média Harmônica funciona bem apenas para "Ruído Sal" (pontinhos brancos 
%   causados por falha de sensor), pois valores altos não estragam o denominador.
% - Ele falha miseravelmente em "Ruído Pimenta" (pontinhos pretos) e em ruído 
%   Gaussiano (que possui variações tanto para o claro quanto para o escuro).
% - Conclusão: Para essa imagem específica, o filtro mais simples de todos 
%   (Média Aritmética do Exercício 2) ainda é o campeão!
% -------------------------------------------------------------------------


pause;
