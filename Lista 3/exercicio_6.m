% ==========================================================
% EXERCÍCIO 6: Filtragem (Convolução Genérica)
% ==========================================================
1; % <-- Comando dummy OBRIGATÓRIO no GNU Octave!

function im_out = convolucao(im_in, mascara)
    % CONVOLUCAO Aplica uma máscara de filtro de qualquer tamanho (M x N)
    
    [linhas_img, colunas_img] = size(im_in);
    im_out = zeros(linhas_img, colunas_img, 'uint8');
    
    % Descobre o tamanho da máscara
    [linhas_mask, colunas_mask] = size(mascara);
    
    % Calcula o "raio" da máscara (pra saber o quanto ela avança do centro)
    raio_y = floor(linhas_mask / 2);
    raio_x = floor(colunas_mask / 2);
    
    for i = 1:linhas_img
        for j = 1:colunas_img
            
            soma = 0;
            
            % Passeia pelos índices da máscara
            for m = 1:linhas_mask
                for n = 1:colunas_mask
                    
                    % Descobre qual é o pixel real da imagem que a máscara
                    % está cobrindo naquele exato momento.
                    linha_atual = i + (m - 1) - raio_y;
                    coluna_atual = j + (n - 1) - raio_x;
                    
                    % Condição de Contorno: Dirichlet (Zeros fora da imagem)
                    if linha_atual >= 1 && linha_atual <= linhas_img && ...
                       coluna_atual >= 1 && coluna_atual <= colunas_img
                        
                        pixel_imagem = double(im_in(linha_atual, coluna_atual));
                        peso_filtro = double(mascara(m, n));
                        
                        soma = soma + (pixel_imagem * peso_filtro);
                    end
                end
            end
            
            if soma > 255; soma = 255; end
            if soma < 0;   soma = 0;   end
            
            im_out(i, j) = uint8(soma);
        end
    end
end

% ==========================================================
% SCRIPT PRINCIPAL
% ==========================================================
clear; clc;

im_in = imread('Lista 3/Imagens/ex2.bmp');
if size(im_in, 3) == 3
    im_in = rgb2gray(im_in);
end

% Exemplo de Uso 1: Máscara da Média 5x5
mascara_media_5x5 = ones(5, 5) / 25;

% Exemplo de Uso 2: Máscara de Borda (Laplaciano)
mascara_bordas = [ 1 2 1;
                   2 4 2;
                   1 2 1 ]/16;

% Chamamos a super função Genérica!
im_processada_1 = convolucao(im_in, mascara_media_5x5);
im_processada_2 = convolucao(im_in, mascara_bordas);

% PLOTAGEM
figure('Name', 'Exercício 6 - Filtro Genérico', 'NumberTitle', 'off');

subplot(1, 3, 1);
imshow(im_in);
title('Imagem Original');

subplot(1, 3, 2);
imshow(im_processada_1);
title('Filtro Média 5x5');

subplot(1, 3, 3);
imshow(im_processada_2);
title('Detector Bordas (Nitidez)');

pause;
