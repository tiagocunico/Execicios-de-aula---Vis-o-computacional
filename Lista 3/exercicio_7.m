% ==========================================================
% SCRIPT PRINCIPAL - EXERCÍCIO 7
% ==========================================================
1; % Comando dummy para Octave

function im_out = convolucao(im_in, mascara)
    [linhas_img, colunas_img] = size(im_in);
    im_out = zeros(linhas_img, colunas_img, 'uint8');
    
    [linhas_mask, colunas_mask] = size(mascara);
    raio_y = floor(linhas_mask / 2);
    raio_x = floor(colunas_mask / 2);
    
    for i = 1:linhas_img
        for j = 1:colunas_img
            soma = 0;
            for m = 1:linhas_mask
                for n = 1:colunas_mask
                    linha_atual = i + (m - 1) - raio_y;
                    coluna_atual = j + (n - 1) - raio_x;
                    
                    if linha_atual >= 1 && linha_atual <= linhas_img && ...
                       coluna_atual >= 1 && coluna_atual <= colunas_img
                        pixel_imagem = double(im_in(linha_atual, coluna_atual));
                        peso_filtro = double(mascara(m, n));
                        soma = soma + (pixel_imagem * peso_filtro);
                    end
                end
            end
            
            % O GRANDE SEGREDO DAS BORDAS BRILHANTES!
            % O comando 'abs' (valor absoluto) faz com que os números negativos
            % (que indicam bordas escuras) se tornem positivos.
            % Isso faz com que a borda fique branca, não importa se o filtro
            % detectou a transição de escura para clara ou de clara para escura!
            soma = abs(soma);

            if soma > 255; soma = 255; end
            %if soma < 0; soma = 0; end

            im_out(i, j) = uint8(soma);
        end
    end
end

% ==========================================================
clear; clc;

im_in = imread('Lista 3/Imagens/parafuso.JPG');
if size(im_in, 3) == 3
    im_in = rgb2gray(im_in);
end

% ----------------------------------------------------------
% DEFINIÇÃO DOS FILTROS (Super Amplificados para o Parafuso)
% ----------------------------------------------------------

% 1. Filtro Sobel (Detecta Bordas VERTICAIS)
% Dobrei o tamanho dos pesos (-2 e -4) para "salientar a rosca" 
% de uma forma muito mais esbranquiçada e forte!
filtro_vertical = [ -1  0  1;
                    -2  0  2;
                    -1  0  1 ];

% 2. Filtro Sobel (Detecta Bordas HORIZONTAIS)
filtro_horizontal = [ -1 -2 -1;
                       0  0  0;
                       1  2  1 ];

% 3. Filtro Laplaciano (TODAS as Direções)
filtro_laplaciano = [ -1 -1 -1;
                      -1  8 -1;
                      -1 -1 -1 ];

% ==========================================================
% EXECUÇÃO OTIMIZADA (Processamento das Imagens)
% ==========================================================

% Como agora usamos o módulo nas bordas abs(), nós temos que juntar
% as IMAGENS geradas, e não as máscaras (que anulariam umas às outras!)
% A imagem Vertical agora é focada violentamente na Rosca do Parafuso.
im_vert  = uint8(abs(conv2(double(im_in), filtro_vertical, 'same')));
im_horz  = uint8(abs(conv2(double(im_in), filtro_horizontal, 'same')));
im_todas = uint8(abs(conv2(double(im_in), filtro_laplaciano, 'same')));

% A Mega Composição final que o enunciado pede (destacando tudo)
im_combo = im_vert + im_horz + im_todas;

% EXTRA: Aplicando um filtro Passa-Baixa (Suavização) no final!
% A sua excelente ideia de borrar levemente as bordas encontradas 
% para deixá-las mais "gordas", contínuas e parecidas com o gabarito.
filtro_media_3x3 = ones(3, 3) / 9;
im_combo_suave = uint8(conv2(double(im_combo), filtro_media_3x3, 'same'));

% ==========================================================
% PLOTAGEM DOS RESULTADOS ESPERADOS
% ==========================================================
figure('Name', 'Exercício 7 - Salientando a Rosca', 'NumberTitle', 'off');

subplot(2, 3, 1);
imshow(im_vert);
title('1. A Rosca (Fil. Vertical)');

subplot(2, 3, 2);
imshow(im_in);
title('FOTO ORIGINAL');

subplot(2, 3, 3);
imshow(im_horz);
title('2. O Corpo (Fil. Horizontal)');

subplot(2, 3, 4);
imshow(im_todas);
title('3. Laplaciano (Todas)');

subplot(2, 3, 5);
imshow(im_combo);
title('4. Todos Juntos (Cru)');

subplot(2, 3, 6);
imshow(im_combo_suave);
title('5. Todos Juntos + Média');

disp('Imagens brilhantes geradas com sucesso!');
pause;
