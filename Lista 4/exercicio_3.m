% ==========================================================
% LISTA 4 - EXERCÍCIO 3
% Objetivo: Comparar filtragem espacial (convolução) vs frequência (FFT)
% ==========================================================
clear; clc; close all;


%Questão 3: O Duelo de Domínios (Espacial vs. Frequência)

%Nesta questão, o objetivo é provar o Teorema da Convolução: filtrar uma imagem com uma máscara de média no espaço é o mesmo que multiplicá-las na frequência.

    %No Domínio Espacial: Utilizamos a convolução clássica. O computador desliza a máscara de 5×5 sobre cada pixel. É simples, mas "caro" computacionalmente se a máscara for muito grande.

    %No Domínio da Frequência:

        %O Segredo do Zero Padding: Para o resultado ser idêntico, precisamos aumentar a imagem e a máscara (preencher com zeros) até o tamanho (M+k−1). Isso evita a convolução circular, impedindo que as bordas da imagem "vazem" umas para as outras.

        %A Operação: Calculamos a fft2 de ambos e multiplicamos ponto a ponto (.*).

    %Veredito de Tempo (tic/toc): Para máscaras pequenas (5×5), o domínio espacial costuma ser rápido. Mas, à medida que a máscara cresce, o domínio da frequência torna-se imbatível, pois a complexidade da multiplicação não muda com o tamanho do filtro.




% Carregar pacote de imagem no Octave
if (exist('OCTAVE_VERSION', 'builtin') ~= 0)
    pkg load image;
end

% 1. LEITURA E PRE-PROCESSAMENTO
try
    im_orig = imread('Imagens/parafuso2.jpg');
catch
    im_orig = imread('Lista 4/Imagens/parafuso2.jpg');
end

% Garantir que é escala de cinza e double
if size(im_orig, 3) == 3
    im_in = double(rgb2gray(im_orig));
else
    im_in = double(im_orig);
end

% Definição da máscara de média 5x5
mascara = ones(5, 5) / 25;

% ==========================================================
% ABORDAGEM 1: DOMÍNIO ESPACIAL (Convolução Manual para mostrar lentidão)
% ==========================================================
disp('Iniciando filtragem no domínio espacial...');
tic;

[linhas_img, colunas_img] = size(im_in);
im_espacial = zeros(linhas_img, colunas_img);
[linhas_mask, colunas_mask] = size(mascara);
raio_y = floor(linhas_mask / 2);
raio_x = floor(colunas_mask / 2);

% Implementação via laços (loops) para evidenciar a complexidade O(N^2 * M^2)
for i = 1:linhas_img
    for j = 1:colunas_img
        soma = 0;
        for m = 1:linhas_mask
            for n = 1:colunas_mask
                li = i + (m - 1) - raio_y;
                co = j + (n - 1) - raio_x;
                
                % Condição de fronteira nula (Zero Padding implícito)
                if li >= 1 && li <= linhas_img && co >= 1 && co <= colunas_img
                    soma = soma + (im_in(li, co) * mascara(m, n));
                end
            end
        end
        im_espacial(i, j) = soma;
    end
end

t_espacial = toc;
fprintf('Via convolução:\nElapsed time is %f seconds.\n', t_espacial);

% ==========================================================
% ABORDAGEM 2: DOMÍNIO DA FREQUÊNCIA (FFT)
% ==========================================================
disp('Iniciando filtragem no domínio da frequência...');
tic;

[H, W] = size(im_in);
[h, w] = size(mascara);

% Para convolução linear via FFT, precisamos de padding (H+h-1, W+w-1)
P = H + h - 1;
Q = W + w - 1;

% FFT da imagem e da máscara com padding
I_fft = fft2(im_in, P, Q);
H_fft = fft2(mascara, P, Q);

% Multiplicação ponto a ponto (convolução no espaço = multiplicação na frequência)
R_fft = I_fft .* H_fft;

% Inversa e extração da parte real
im_freq = real(ifft2(R_fft));

% Crop para retornar ao tamanho original ('same')
% O deslocamento para centralizar depende do raio da máscara
im_freq = im_freq(1+raio_y:H+raio_y, 1+raio_x:W+raio_x);

t_freq = toc;
fprintf('Via fft:\nElapsed time is %f seconds.\n', t_freq);

% ==========================================================
% EXIBIÇÃO E COMPARAÇÃO
% ==========================================================
figure('Name', 'Exercício 3 - Espacial vs Frequência', 'NumberTitle', 'off');

subplot(1, 3, 1);
imshow(uint8(im_in));
title('Original');

subplot(1, 3, 2);
imshow(uint8(im_espacial));
title(['Espacial (', num2str(t_espacial, '%.2f'), 's)']);

subplot(1, 3, 3);
imshow(uint8(im_freq));
title(['Frequência (', num2str(t_freq, '%.4f'), 's)']);

% Verificação de erro entre as duas
erro = max(max(abs(im_espacial - im_freq)));
fprintf('Diferença máxima entre os métodos: %e\n', erro);

pause;