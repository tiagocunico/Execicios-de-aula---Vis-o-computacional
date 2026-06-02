% Lista 6 - Exercício 2: Segmentação de Cores e Auxílio ao Daltonismo
clc; clear; close all;
pkg load image; % Necessário no Octave

%% 1. Leitura da Imagem
caminho_img = 'Lista 6/imgs_lista_6/cbt.bmp';
img_rgb = imread(caminho_img);

% Extraímos os canais Vermelho (R), Verde (G) e Azul (B) em formato double
R = double(img_rgb(:, :, 1));
G = double(img_rgb(:, :, 2));
B = double(img_rgb(:, :, 3));

%% 2. Segmentação de Objetos Vermelhos e Verdes
% Em testes de daltonismo (como o Ishihara), as cores verde e vermelho são 
% misturadas com brilhos (luminâncias) muito parecidos, tornando-as indistinguíveis 
% para quem tem protanopia ou deuteranopia. 
% No entanto, a diferença energética entre os canais de cor ainda é nítida.
%
% Definimos um limiar de diferença para isolar as cores sem pegar o fundo neutro/marrom:
limiar = 15;

% Máscara dos objetos vermelhos: Canal R é visivelmente maior que o G
mask_vermelho = (R - G) > limiar;

% Máscara dos objetos verdes: Canal G é visivelmente maior que o R
mask_verde = (G - R) > limiar;

%% 3. Isolamento dos Objetos (Fundo Preto)
% Criamos cópias da imagem original e aplicamos as máscaras em todos os 3 canais (RGB)
% definindo como preto (0) os pixels que não correspondem à cor desejada.

img_vermelhos_isolados = img_rgb;
img_vermelhos_isolados(repmat(~mask_vermelho, [1, 1, 3])) = 0;

img_verdes_isolados = img_rgb;
img_verdes_isolados(repmat(~mask_verde, [1, 1, 3])) = 0;

%% 4. Auxílio Visual Científico: Revelando a Informação (Imagem de Diferença)
% Daltônicos não distinguem verde de vermelho por conta do matiz, mas conseguem ver 
% perfeitamente variações de INTENSIDADE (brilho). 
% Se fizermos a diferença direta (R - G) e normalizarmos para o intervalo [0, 1],
% transformamos a diferença cromática em uma diferença gritante de tons de cinza.
diff_rg = R - G;
img_revelada = (diff_rg - min(diff_rg(:))) / (max(diff_rg(:)) - min(diff_rg(:)));

%% 5. Visualização dos Resultados
figure('Name', 'Lista 6 - Exercício 2: Segmentação de Cores e Daltonismo', 'Position', [100, 100, 1100, 900]);

% Subplot 1: Imagem Original (Confusa para Daltônicos)
subplot(2, 2, 1);
imshow(img_rgb);
title('1. Imagem Original RGB');

% Subplot 2: Objetos Vermelhos Isolados
subplot(2, 2, 2);
imshow(img_vermelhos_isolados);
title('2. Apenas Objetos Vermelhos');

% Subplot 3: Objetos Verdes Isolados
subplot(2, 2, 3);
imshow(img_verdes_isolados);
title('3. Apenas Objetos Verdes');

% Subplot 4: Imagem de Contraste Revelada (Legível para Qualquer Pessoa)
subplot(2, 2, 4);
imshow(img_revelada);
title('4. Contraste de Intensidade Revelado (R - G)');

%% 6. Discussão Teórica dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% POR QUE DALTÔNICOS CONFUNDEM VERDE E VERMELHO NA IMAGEM ORIGINAL?
% - A protanopia (ausência de cones L/vermelho) e a deuteranopia (ausência de 
%   cones M/verde) fazem com que a pessoa enxergue o espectro verde-vermelho 
%   como uma gradação de tons semelhantes de amarelo/marrom. 
% - Como os círculos do teste possuem brilhos semelhantes, sem a percepção 
%   do matiz (cor), os círculos vermelhos do número se misturam completamente 
%   com os círculos verdes do fundo.
%
% COMO A SEGMENTAÇÃO DE CANAIS RESOLVEU O PROBLEMA?
% - Mesmo que a percepção humana falhe, os dados numéricos da câmera/computador 
%   são claros. Ao fazermos a máscara diferencial (R - G > limiar) e (G - R > limiar),
%   separamos perfeitamente as duas populações de círculos coloridos.
% - Ao exibir as imagens separadas (Subplots 2 e 3), o daltônico consegue 
%   reconhecer a forma do número ou do fundo simplesmente por estarem isolados.
%
% O EFEITO DA IMAGEM REVELADA (R - G):
% - No Subplot 4, convertemos a diferença cromática (que o daltônico não enxerga) 
%   em contraste de luminância puro (tons de cinza de alta amplitude). Os círculos 
%   vermelhos do número ficam brancos brilhantes, e os verdes do fundo ficam pretos,
%   fazendo com que a informação oculta salte aos olhos de qualquer pessoa!
% -------------------------------------------------------------------------

pause;
