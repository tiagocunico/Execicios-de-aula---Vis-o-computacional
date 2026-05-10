% Lista 5 - Último Exercício: Filtragem Inversa com Ruído Adicional
clc; clear; close all;
pkg load image; % Necessário no Octave

%% 1. Leitura da Imagem
img_original = imread('Lista 5/imgs_lista_5/I1_r1.bmp');
if size(img_original, 3) == 3, img_original = rgb2gray(img_original); end

% ATENÇÃO: Usamos double() puro em vez de im2double() para manter a imagem
% na escala de 0 a 255. O enunciado pede para somarmos um ruído de variância
% 100 (desvio padrão = 10). Se a imagem estivesse de 0 a 1, esse ruído 
% destruiria a imagem 100%.
img_double = double(img_original);

%% 2. O Modelo Clássico de Degradação (Borramento + Ruído)
% Passo A: Borramento (Máscara de Média 5x5)
psf = fspecial('average', [5 5]);
img_borrada = imfilter(img_double, psf, 'circular');

% Passo B: Adição de Ruído Gaussiano APÓS o borramento
% A variância solicitada é 100. Como a função randn() tem variância 1,
% multiplicamos por sqrt(100), ou seja, 10 (desvio padrão).
ruido = sqrt(100) * randn(size(img_borrada));
img_degradada = img_borrada + ruido;

%% 3. Filtragem Inversa (No Domínio da Frequência)
% Passo A: Transformada de Fourier da Imagem Degradada
G = fft2(img_degradada);

% Passo B: Transformada de Fourier do filtro
H = psf2otf(psf, size(img_degradada));

% Passo C: Filtragem Inversa Pseudo-Restrita
% Usando o mesmo limiar do exercício anterior (0.05)
limiar = 0.05; 
H_inverso = zeros(size(H));
mascara_segura = abs(H) > limiar; 
H_inverso(mascara_segura) = 1 ./ H(mascara_segura);

F_estimada = G .* H_inverso;

% Passo D: Voltar para o Domínio Espacial
img_recuperada = real(ifft2(F_estimada));

%% 4. Comparação Visual
figure('Name', 'Comparação - Filtro Inverso com Ruído Extra', 'Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
imshow(uint8(img_double));
title('Original (I1\_r1)');

subplot(1, 3, 2);
imshow(uint8(img_degradada));
title('Borrada + Ruído (Var=100)');

subplot(1, 3, 3);
% Usamos [] para o MATLAB ajustar a visualização aos valores absurdos gerados
imshow(img_recuperada, []);
title('Recuperada (Filtro Inverso)');

%% 5. Discussão dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% O VERDADEIRO TERROR DO FILTRO INVERSO:
% - A equação completa da filtragem inversa com ruído é:
%   G(u,v) = H(u,v) * F(u,v)  +  N(u,v)
%
% - Quando tentamos recuperar a imagem dividindo G por H, a matemática nos dá:
%   F_estimada = F(u,v)  +  [ N(u,v) / H(u,v) ]
%
% O QUE ACONTECEU COM A IMAGEM RECUPERADA?
% - O resultado foi um desastre visual (a imagem virou praticamente apenas
%   ruído puro de alta frequência).
%
% EXPLICAÇÃO MATEMÁTICA:
% - O filtro de média (H) enfraquece as altas frequências, tendo valores muito 
%   pequenos e próximos a zero nelas.
% - O ruído branco Gaussiano (N) que acabamos de adicionar possui energia em
%   TODAS as frequências.
% - Quando a matemática calcula a parcela [ N / H ], ela divide o ruído forte 
%   por valores muito próximos a zero (do filtro H). Isso AMPLIFICA gigantescamente 
%   o ruído nas altas frequências.
%
% CONCLUSÃO FINAL:
% - Este exercício prova definitivamente por que o Filtro Inverso clássico 
%   é INÚTIL na vida real! Ele é extremamente instável e qualquer "sujeirinha" 
%   aditiva domina completamente o processo de restauração da imagem.
% -------------------------------------------------------------------------

pause;
