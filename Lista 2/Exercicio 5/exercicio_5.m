% Lista 2 - Exercicio 5
% Visão Computacional

% Limpa o workspace e a tela
clear all;
close all;
clc;

% Carregando o pacote de processamento de imagem (necessário no Octave)
pkg load image;

% Lendo a imagem do diretório
disp('Lendo a imagem fg00009.bmp...');
img = imread('Lista2/Exercicio 5/fg00009.bmp');

% Se a imagem for colorida (RGB), converte para tons de cinza
if size(img, 3) == 3
    img = rgb2gray(img);
end
img = double(img);


[linhas, colunas] = size(img);

%(L0,C0) = Cordenada original do pixel
%(Lf,Cf) = Cordenada do pixel na imagem final

% Define o ângulo de rotação em graus
angulo = 30;

% Centro da imagem (ponto de pivô da rotação)
Lc = linhas / 2;
Cc = colunas / 2;

% ---------------------------------------------------------------
% Backward Mapping: para cada pixel de DESTINO, calculamos de onde
% ele veio na imagem ORIGINAL (usando a transformação INVERSA).
% Isso evita buracos (aliasing) que ocorrem no Forward Mapping.
%
% A rotação centrada equivale a:
%   1) Transladar para a origem (subtrair o centro)
%   2) Aplicar a rotação INVERSA (ângulo negativo)
%   3) Transladar de volta (somar o centro)
% ---------------------------------------------------------------

% Matriz de Rotação INVERSA (mesmo que rotação com ângulo negativo)
MatrizRotacao = [ cosd(angulo), sind(angulo), 0 ;
                 -sind(angulo), cosd(angulo), 0 ;
                             0,            0, 1];
MatrizRotacaoInversa = inv(MatrizRotacao);


% Imagem de saída começa toda preta (zeros)
img_processada = zeros(linhas, colunas);

for Lf = 1:linhas
    for Cf = 1:colunas

        % 1) Translada o pixel de destino para a origem (centro da imagem)
        CoordsTransladadas = [Lf - Lc, Cf - Cc, 1];

        % 2) Aplica a rotação inversa para descobrir de onde veio na imagem original
        % assim não fica com buracos na imagem final
        CoordsOriginais = CoordsTransladadas * MatrizRotacaoInversa;

        % 3) Translada de volta somando o centro
        L0 = round(CoordsOriginais(1) + Lc);
        C0 = round(CoordsOriginais(2) + Cc);

        % 4) Só copia o pixel se a coordenada de origem for válida
        if L0 >= 1 && L0 <= linhas && C0 >= 1 && C0 <= colunas
            img_processada(Lf, Cf) = img(L0, C0);
        end

    end
end



% Mostra as imagens na tela
figure;

subplot(1, 2, 1);
imshow(uint8(img));
title('Imagem Original');

subplot(1, 2, 2);
imshow(uint8(img_processada));
title('Imagem Processada');

% Mantém a janela aberta até que o usuário a feche
waitfor(gcf);
