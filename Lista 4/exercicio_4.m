% ==========================================================
% LISTA 4 - EXERCÍCIO 4 (COMPLETO)
% Objetivo: Comparação de Filtros no Domínio da Frequência
% 1. Passa-Alta (Centro 30x30 zerado)
% 2. Passa-Baixa (Apenas centro 30x30 mantido)
% 3. Remoção de Bordas (Bordas externas 30px zeradas)
% ==========================================================
clear; clc; close all;


%Questão 4: O Filtro Passa-Altas Manual

%Aqui, manipulamos o espectro diretamente para "extrair" apenas o que muda rápido na imagem.

    %O "Alvo" (Baixas Frequências): Ao usarmos o fftshift, o centro da matriz passa a representar as áreas lisas e de brilho constante (baixas frequências).

    %A Ação (Zerar o Centro): Ao colocarmos um quadrado de zeros (ex: 30×30) no centro, estamos a apagar a "iluminação de fundo" e as partes sem detalhes.

    %O Resultado Visual: Após o ifftshift e a ifft2, a imagem resultante mostra apenas as bordas e texturas finas. É um processo de realce: eliminamos o que é lento (fundo) e mantemos o que é rápido (contornos do parafuso).

    %Ponto de Atenção: A imagem final deve ser tratada com real() para remover resíduos complexos e normalizada para visualização, já que as bordas sozinhas podem parecer muito escuras inicialmente.







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

if size(im_orig, 3) == 3
    im_in = double(rgb2gray(im_orig));
else
    im_in = double(im_orig);
end

% 2. TRANSFORMADA DE FOURIER E DESLOCAMENTO (SHIFT)
I_fft = fft2(im_in);
I_shift_orig = fftshift(I_fft);
[H, W] = size(I_shift_orig);

% Centro do espectro
cy = floor(H/2) + 1;
cx = floor(W/2) + 1;
r_min_y = cy - 15; r_max_y = cy + 14;
r_min_x = cx - 15; r_max_x = cx + 14;

% ==========================================================
% VARIANTE 1: FILTRO PASSA-ALTA (Centro 30x30 zerado)
% ==========================================================
I_shift_hp = I_shift_orig;
I_shift_hp(r_min_y:r_max_y, r_min_x:r_max_x) = 0;
im_hp = real(ifft2(ifftshift(I_shift_hp)));

% ==========================================================
% VARIANTE 2: FILTRO PASSA-BAIXA (Apenas centro 30x30 mantido)
% ==========================================================
I_shift_lp = zeros(H, W);
I_shift_lp(r_min_y:r_max_y, r_min_x:r_max_x) = I_shift_orig(r_min_y:r_max_y, r_min_x:r_max_x);
im_lp = real(ifft2(ifftshift(I_shift_lp)));

% ==========================================================
% VARIANTE 3: REMOÇÃO DE BORDAS (Bordas externas 30px zeradas)
% ==========================================================
I_shift_border = I_shift_orig;
b = 30; % Tamanho da borda
I_shift_border(1:b, :) = 0;           % Topo
I_shift_border(H-b+1:H, :) = 0;       % Base
I_shift_border(:, 1:b) = 0;           % Esquerda
I_shift_border(:, W-b+1:W) = 0;       % Direita
im_border = real(ifft2(ifftshift(I_shift_border)));

% ==========================================================
% EXIBIÇÃO DOS RESULTADOS (2 linhas x 4 colunas)
% ==========================================================
figure('Name', 'Exercício 4 - Variantes de Filtro de Frequência', 'NumberTitle', 'off');

% --- LINHA 1: RESULTADOS NO ESPAÇO ---
subplot(2, 4, 1); imshow(uint8(im_in)); title('Original');
subplot(2, 4, 2); imshow(mat2gray(im_hp)); title('Passa-Alta (Centro 0)');
subplot(2, 4, 3); imshow(mat2gray(im_lp)); title('Passa-Baixa (Só Centro)');
subplot(2, 4, 4); imshow(mat2gray(im_border)); title('Bordas 30px Zeradas');

% --- LINHA 2: ESPECTROS (LOG) ---
subplot(2, 4, 5); imshow(mat2gray(log(1 + abs(I_shift_orig)))); title('Espectro Orig.');
subplot(2, 4, 6); imshow(mat2gray(log(1 + abs(I_shift_hp)))); title('Esp. Passa-Alta');
subplot(2, 4, 7); imshow(mat2gray(log(1 + abs(I_shift_lp)))); title('Esp. Passa-Baixa');
subplot(2, 4, 8); imshow(mat2gray(log(1 + abs(I_shift_border)))); title('Esp. Bordas Off');

disp('Exercício 4 concluído com todas as variantes!');
pause;