% Lista 5 - Exercício 6: Filtragem Inversa
clc; clear; close all;
pkg load image; % Necessário no Octave

%% 1. Leitura da Imagem
% Carregamos a imagem (note que ela JÁ tem ruído originalmente)
img_original = imread('Lista 5/imgs_lista_5/I1_r1.bmp');
if size(img_original, 3) == 3, img_original = rgb2gray(img_original); end

img_double = im2double(img_original);

%% 2. Degradação (Borramento com Média 5x5 de ganho unitário)
% Criamos a máscara do filtro de média 5x5 (que já tem ganho unitário de fábrica)
psf = fspecial('average', [5 5]);

% Aplicamos o filtro na imagem para obter a imagem degradada (borrada)
% Usamos a borda 'circular' para evitar problemas com a FFT (Transformada de Fourier)
img_borrada = imfilter(img_double, psf, 'circular');

%% 3. Filtragem Inversa (No Domínio da Frequência)
% Para reverter o filtro, não adianta tentar "des-multiplicar" os pixels.
% Precisamos ir para o Domínio das Frequências (Fourier).

% Passo A: Transformada de Fourier da imagem borrada (G)
G = fft2(img_borrada);

% Passo B: Transformada de Fourier do próprio filtro (H)
% A função psf2otf converte a matriz 5x5 para o mesmo tamanho da imagem e tira a FFT.
H = psf2otf(psf, size(img_borrada));

% Passo C: Filtragem Inversa (Matematicamente F = G / H)
% ATENÇÃO AO PROBLEMA: O filtro de média zera (bloqueia) muitas frequências altas.
% Isso significa que a matriz H tem muitos valores próximos a 0. 
% Dividir qualquer ruído minúsculo da imagem (G) por 0 resulta em Infinito, o que 
% destruiria a imagem completamente. 
% Para corrigir, criamos um Filtro Inverso "Pseudo-Restrito" que não divide por zero.

limiar = 0.05; % Frequências com módulo menor que 0.05 serão ignoradas
H_inverso = zeros(size(H));
mascara_segura = abs(H) > limiar; 
H_inverso(mascara_segura) = 1 ./ H(mascara_segura);

% Multiplicar pelo inverso é matematicamente igual a dividir
F_estimada = G .* H_inverso;

% Passo D: Voltar para o Domínio Espacial (imagem normal)
img_recuperada = real(ifft2(F_estimada));

%% 4. Comparação Visual
figure('Name', 'Comparação - Filtragem Inversa', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(img_double);
title('Original I1\_r1 (Já com ruído)');

subplot(1, 3, 2);
imshow(img_borrada);
title('Degradada (Média 5x5)');

subplot(1, 3, 3);
imshow(img_recuperada, []);
title('Recuperada (Filtro Inverso)');

%% 5. Discussão dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% O QUE ACONTECEU AQUI?
% - A teoria da filtragem inversa é linda no papel: F = G / H.
% - PORÉM, na vida real isso raramente funciona com perfeição. O nosso filtro 
%   de média (H) jogou fora as altas frequências. A matemática não consegue 
%   "criar" detalhes que foram destruídos sem acabar amplificando o ruído junto.
%
% A MAIOR FRAQUEZA DA FILTRAGEM INVERSA DIRETA:
% - Como a imagem "I1_r1" JÁ TINHA ruído Gaussiano antes de aplicarmos a média, 
%   quando fazemos a divisão por H (que tem valores pequenos), a matemática 
%   amplifica esse ruído de maneira brutal nas altas frequências.
% - O resultado final (Recuperada) costuma voltar a ficar "borrado" misturado
%   com artefatos de padrão repetitivo, e a nitidez não é restaurada perfeitamente.
%
% CONCLUSÃO:
% - A Filtragem Inversa só funciona perfeitamente em um ambiente de laboratório 
%   onde o ruído é ABSOLUTAMENTE ZERO. Na presença de qualquer ruído minúsculo 
%   (como no caso da imagem I1_r1), ela falha, e precisamos apelar para filtros 
%   avançados como o Filtro de Wiener para tentar "salvar" a imagem.
% -------------------------------------------------------------------------
pause;
