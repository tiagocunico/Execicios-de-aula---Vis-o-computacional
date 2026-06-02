% Lista 6 - Exercício 1: Conversão de Imagem Colorida para Tons de Cinza
clc; clear; close all;
pkg load image; % Necessário no Octave para carregar funções como imread e imshow

%% 1. Leitura da Imagem Colorida
% O arquivo cbt.bmp é uma imagem RGB que representa um teste de daltonismo (Ishihara).
caminho_img = 'Lista 6/imgs_lista_6/cbt.bmp';
img_rgb = imread(caminho_img);

%% 2. Conversão para Tons de Cinza
% Existem duas formas principais de realizar essa conversão em processamento digital de imagens:
%
% Método A: Utilizando a função embutida rgb2gray
img_gray_builtin = rgb2gray(img_rgb);

% Método B: Conversão Manual utilizando a fórmula de Luminância (Padrão ITU-R BT.601)
% A fórmula clássica de ponderação é: Y = 0.299 * R + 0.587 * G + 0.114 * B
% Esse método leva em consideração a sensibilidade fisiológica do olho humano a diferentes cores.
%
% Extraímos os canais vermelho (R), verde (G) e azul (B) e convertemos para double
R = double(img_rgb(:, :, 1));
G = double(img_rgb(:, :, 2));
B = double(img_rgb(:, :, 3));

% Aplicamos a média ponderada e convertemos o resultado de volta para uint8
img_gray_manual = uint8(0.299 * R + 0.587 * G + 0.114 * B);

%% 3. Visualização e Comparação dos Resultados
figure('Name', 'Lista 6 - Exercício 1: Conversão para Tons de Cinza', 'Position', [100, 100, 1200, 500]);

% Imagem Original RGB
subplot(1, 3, 1);
imshow(img_rgb);
title('Imagem Original RGB (cbt.bmp)');

% Imagem em Tons de Cinza (Fórmula de Luminância Manual)
subplot(1, 3, 2);
imshow(img_gray_manual);
title('Tons de Cinza (Fórmula de Luminância)');

% Imagem em Tons de Cinza (Função rgb2gray)
subplot(1, 3, 3);
imshow(img_gray_builtin);
title('Tons de Cinza (rgb2gray)');

%% 4. Discussão dos Resultados e Teoria (Anotações para Estudo)
% -------------------------------------------------------------------------
% O QUE SÃO TONS DE CINZA E POR QUE NÃO USAMOS A MÉDIA SIMPLES?
% - Em uma imagem digital colorida RGB, cada pixel possui 3 canais (R, G, B).
% - Para converter em tons de cinza, precisamos reduzir esses 3 canais a 
%   apenas 1 canal de intensidade (luminância).
% - Se fizéssemos uma média aritmética simples ((R + G + B) / 3), o resultado 
%   seria visualmente artificial e insatisfatório. Isso ocorre porque o olho 
%   humano possui sensibilidades diferentes para cada cor: nós percebemos o 
%   verde muito mais brilhante que o vermelho, e o vermelho mais brilhante que o azul.
%
% A FÓRMULA DE LUMINÂNCIA (ITU-R BT.601):
% - Y = 0.299 * R + 0.587 * G + 0.114 * B
% - Note como o canal VERDE (G) tem um peso muito maior (58.7%), seguido do 
%   VERMELHO (R) (29.9%) e por fim o AZUL (B) (11.4%). Isso imita a resposta 
%   fisiológica dos nossos fotorreceptores da retina (cones).
%
% DALTONISMO E TONS DE CINZA (INTRODUÇÃO AO EXERCÍCIO 2):
% - A imagem "cbt.bmp" é um teste de daltonismo (Ishihara) onde o número 
%   está "escondido" no contraste de cores (verde vs vermelho).
% - Ao converter a imagem colorida para tons de cinza, percebemos que o número 
%   se torna PRATICAMENTE INVISÍVEL ou extremamente difícil de ler!
% - Isso acontece porque a diferença que antes era percebida pelo MATIZ (cor) 
%   desaparece quando temos apenas a INTENSIDADE (luminância), pois os tons de 
%   verde e vermelho usados no teste têm brilho (luminância Y) muito parecidos.
% - Essa é uma excelente demonstração prática de como a informação cromática é 
%   essencial para segmentação e identificação de objetos em nosso cérebro.
% -------------------------------------------------------------------------

pause;
