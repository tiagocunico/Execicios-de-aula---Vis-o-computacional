% Lista 2 - Exercicio 7
% Visão Computacional

% Limpa o workspace e a tela
clear all;
close all;
clc;

% Carregando o pacote de processamento de imagem (necessário no Octave)
pkg load image;

% Lendo as imagens
disp('Lendo as imagens im_in.bmp e im_ref.bmp...');
im_in = imread('Lista2/Exercicio 7/im_in.bmp');
im_ref = imread('Lista2/Exercicio 7/im_ref.bmp');

im_in_d = double(im_in);
im_ref_d = double(im_ref);

[linhas_in, colunas_in, canais_in] = size(im_in_d);
[linhas_ref, colunas_ref, canais_ref] = size(im_ref_d);

disp('Por favor, selecione 4 pontos na imagem de REFERENCIA (im_ref)');
disp('Dica: Selecione os cantos de algo que você consiga identificar nas duas.');
figure(1);
imshow(uint8(im_ref_d));
title('Imagem de Referencia - Selecione 4 pontos');
[X_ref, Y_ref] = ginput(4); % Seleciona 4 pontos (Colunas, Linhas)

disp('Por favor, selecione os mesmos 4 pontos na imagem de ENTRADA (im_in)');
figure(2);
imshow(uint8(im_in_d));
title('Imagem de Entrada - Selecione os mesmos 4 pontos');
[X_in, Y_in] = ginput(4); % Seleciona 4 pontos correspondentes

% Montando o sistema linear para encontrar os coeficientes da transformação bilinear
% X_in (u) = c1*x + c2*y + c3*x*y + c4
% Y_in (v) = c5*x + c6*y + c7*x*y + c8
%
% Onde (x, y) são as coordenadas da imagem de referência 
% e (u, v) na imagem de entrada.

% Matriz A baseada nos 4 pontos da referência (x, y, x*y, 1)
A = [X_ref, Y_ref, X_ref.*Y_ref, ones(4, 1)];

% Vetores U e V baseados nos pontos da imagem de entrada
U = X_in;
V = Y_in;

% Resolvendo o sistema linear para encontrar os coeficientes
C_x = A \ U; % [c1; c2; c3; c4]
C_y = A \ V; % [c5; c6; c7; c8]

c1 = C_x(1); c2 = C_x(2); c3 = C_x(3); c4 = C_x(4);
c5 = C_y(1); c6 = C_y(2); c7 = C_y(3); c8 = C_y(4);

% Inicializa a imagem final (toda preta)
img_processada = zeros(linhas_ref, colunas_ref, canais_in);

disp('Processando o registro usando transformação com aproximação bilinear...');
for y = 1:linhas_ref
    for x = 1:colunas_ref
        
        % Transforma a coordenada (x, y) de destino para a origem (u, v) => Backward Mapping
        u = c1 * x + c2 * y + c3 * x * y + c4; % Coluna real (X) 
        v = c5 * x + c6 * y + c7 * x * y + c8; % Linha real (Y)
        
        % Verifica se a coordenada cai dentro da imagem de entrada
        if u >= 1 && u <= colunas_in && v >= 1 && v <= linhas_in
            
            % --- Interpolação Bilinear ---
            u1 = floor(u);
            u2 = ceil(u);
            v1 = floor(v);
            v2 = ceil(v);
            
            % Tratamento de limites de borda (por segurança)
            if u1 < 1, u1 = 1; end
            if u2 > colunas_in, u2 = colunas_in; end
            if v1 < 1, v1 = 1; end
            if v2 > linhas_in, v2 = linhas_in; end
            
            % Distâncias fracionadas
            a = u - u1;
            b = v - v1;
            
            % Obtém os valores dos 4 vizinhos (pega todos os canais)
            p1 = im_in_d(v1, u1, :); % Superior Esquerdo
            p2 = im_in_d(v1, u2, :); % Superior Direito
            p3 = im_in_d(v2, u1, :); % Inferior Esquerdo
            p4 = im_in_d(v2, u2, :); % Inferior Direito
            
            % Realiza a média ponderada com as distâncias
            pixel_interpolado = (1-a)*(1-b)*p1 + a*(1-b)*p2 + (1-a)*b*p3 + a*b*p4;
            
            img_processada(y, x, :) = pixel_interpolado;
        end
    end
end

disp('Processamento concluído.');

% Mostra o antes e depois
figure(3);

subplot(1, 3, 1);
imshow(uint8(im_ref_d));
title('Referência (im\_ref)');

subplot(1, 3, 2);
imshow(uint8(im_in_d));
title('Entrada (im\_in)');

subplot(1, 3, 3);
imshow(uint8(img_processada));
title('Imagem Registrada');
pause;
