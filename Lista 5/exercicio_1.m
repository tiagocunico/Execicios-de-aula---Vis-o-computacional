% Lista 5 - Estimação da distribuição de ruído aditivo
clc; clear; close all;
pkg load image; % Necessário no Octave para carregar funções como imread, imshow e imcrop

%% 1. Leitura das Imagens
% As imagens I1_r1 e I2_r1 estão contaminadas por ruído gaussiano.
% As imagens I1_r2 e I2_r2 estão contaminadas por ruído uniforme.

img_I1_r1 = imread('Lista 5/imgs_lista_5/I1_r1.bmp');
img_I1_r2 = imread('Lista 5/imgs_lista_5/I1_r2.bmp');
img_I2_r1 = imread('Lista 5/imgs_lista_5/I2_r1.bmp');
img_I2_r2 = imread('Lista 5/imgs_lista_5/I2_r2.bmp');

% Converte para tons de cinza caso alguma imagem seja RGB (garantia)
if size(img_I1_r1, 3) == 3, img_I1_r1 = rgb2gray(img_I1_r1); end
if size(img_I1_r2, 3) == 3, img_I1_r2 = rgb2gray(img_I1_r2); end
if size(img_I2_r1, 3) == 3, img_I2_r1 = rgb2gray(img_I2_r1); end
if size(img_I2_r2, 3) == 3, img_I2_r2 = rgb2gray(img_I2_r2); end

%% 2. Visualização das Imagens
figure('Name', 'Imagens com Ruído', 'Position', [100, 100, 900, 700]);

subplot(2, 2, 1);
imshow(img_I1_r1);
title('I1\_r1 (Ruído Gaussiano)');

subplot(2, 2, 2);
imshow(img_I1_r2);
title('I1\_r2 (Ruído Uniforme)');

subplot(2, 2, 3);
imshow(img_I2_r1);
title('I2\_r1 (Ruído Gaussiano)');

subplot(2, 2, 4);
imshow(img_I2_r2);
title('I2\_r2 (Ruído Uniforme)');

%% 3. Estimação da Distribuição do Ruído
% DICA: A forma mais comum de estimar a distribuição do ruído aditivo em uma 
% imagem é extrair o histograma de uma região "plana" (homogênea) da imagem, 
% onde a variância se deve quase que exclusivamente ao ruído.

disp('Passo 1: Selecione uma região homogênea na imagem I1_r1 (fundo, sem textura).');
figure('Name', 'Selecione a ROI em I1');
imshow(img_I1_r1);
title('Arraste um retângulo em uma área "plana" e dê um duplo clique.');
[roi_I1_r1, rect_I1] = imcrop();
close;

% Reutiliza as mesmas coordenadas para a versão com ruído uniforme da I1
roi_I1_r2 = imcrop(img_I1_r2, rect_I1);

disp('Passo 2: Selecione uma região homogênea na imagem I2_r1 (fundo, sem textura).');
figure('Name', 'Selecione a ROI em I2');
imshow(img_I2_r1);
title('Arraste um retângulo em uma área "plana" e dê um duplo clique.');
[roi_I2_r1, rect_I2] = imcrop();
close;

% Reutiliza as mesmas coordenadas para a versão com ruído uniforme da I2
roi_I2_r2 = imcrop(img_I2_r2, rect_I2);

%% 4. Plotagem dos Histogramas do Ruído
% Vamos visualizar os histogramas dessas regiões planas. 
% Como a imagem em si é constante nessa área, a variação é apenas o ruído!

figure('Name', 'Histogramas do Ruído Estimado', 'Position', [150, 150, 900, 700]);

subplot(2, 2, 1);
imhist(roi_I1_r1);
title('Histograma da ROI de I1\_r1 (Gaussiano)');

subplot(2, 2, 2);
imhist(roi_I1_r2);
title('Histograma da ROI de I1\_r2 (Uniforme)');

subplot(2, 2, 3);
imhist(roi_I2_r1);
title('Histograma da ROI de I2\_r1 (Gaussiano)');

subplot(2, 2, 4);
imhist(roi_I2_r2);
title('Histograma da ROI de I2\_r2 (Uniforme)');
%% 4. Discussão dos Resultados e Conceitos (Anotações para Estudo)
% -------------------------------------------------------------------------
% POR QUE USAMOS UMA REGIÃO PLANA PARA ESTIMAR O RUÍDO?
% Em um mundo ideal (sem ruído), uma área de fundo "plana" teria todos os seus 
% pixels com exatamente o mesmo valor de intensidade. Ao adicionar ruído a essa 
% imagem, esse valor único é bagunçado, criando variações. Como a imagem 
% "verdadeira" ali não tem textura, 100% da variação nessa área é o ruído.
%
% COMO O HISTOGRAMA É FEITO NESSA REGIÃO (imhist)?
% O imhist() NÃO calcula o histograma da imagem toda, apenas do seu recorte.
% Ele conta a frequência de cada tom de cinza (de 0 a 255) contando pixel por pixel 
% dentro do quadrado que você selecionou, e plota um gráfico.
%
% INTERPRETAÇÃO DOS RESULTADOS OBTIDOS:
% Ao observar os histogramas gerados, enxergamos a "assinatura" do ruído:
%
% 1. Ruído Gaussiano (I1_r1 e I2_r1): 
%    A maioria dos pixels sofre pouca alteração e se concentra no meio, diminuindo 
%    suavemente para as laterais. O histograma forma um clássico "Sino" (Curva Normal).
%
% 2. Ruído Uniforme (I1_r2 e I2_r2): 
%    O ruído tem igual probabilidade de somar/subtrair qualquer valor dentro de um 
%    intervalo. O histograma forma um "bloco" retangular mais achatado.
% -------------------------------------------------------------------------
pause;
