
% ==========================================================
% LISTA 4 - EXERCÍCIO 1
% Objetivo: Leitura de parafuso2.jpg e exibição de 4 gráficos
% (Placeholder para processamento que o usuário irá implementar)
% ==========================================================
clear; clc; close all;


% 📝 Resumo de Estudo: Do Espaço à Frequência (e de volta)

% Aqui tens o "guia de bolso" para revisares o que fizemos hoje:

% 1. A Viagem (FFT e Visualização)

%     Transformação: Usamos a fft2 para converter pixels em ondas senoidais (Domínio da Frequência).

%     O "Shift": Usamos fftshift para colocar a frequência zero no centro, criando um mapa de −π a π.

%     Visão Humana: Aplicamos o Módulo Logarítmico (log(1+abs)) para conseguir enxergar as frequências mais altas que, de outra forma, seriam ofuscadas pelo brilho intenso do centro.

% 2. A Anatomia da Onda (Módulo e Fase)

%     Módulo: Representa a intensidade (energia) das bordas. Revela direções (uma linha vertical no espectro significa bordas horizontais na imagem, devido à ortogonalidade de 90∘).

%     Fase: Representa a localização. Embora pareça ruído, ela contém o "mapa" de onde cada detalhe deve ser desenhado.

%     Reconstrução Polas: Usamos a função pol2cart(fase, modulo) para recombinar as peças. Provamos que, ao usar a fase de uma imagem e o módulo de outra, o resultado mantém a forma da imagem que forneceu a fase.

% 3. Filtragem e Reconstrução Inversa

%     A Volta: Para voltar a ver uma imagem, usamos ifft2. Antes disso, é obrigatório usar ifftshift para devolver o zero para os cantos, ou a imagem sairá toda fragmentada.

%     Limpeza: Terminamos sempre com real() para eliminar pequenos erros numéricos imaginários e garantir que o imshow funcione.




% Carregar pacote de imagem no Octave (se necessário)
if (exist('OCTAVE_VERSION', 'builtin') ~= 0)
    pkg load image;
end

% 1. LEITURA DA IMAGEM
% Caminho relativo para a imagem
try
    im_Parafuso = imread('Imagens/parafuso2.jpg');
    im_Parafusos= imread('Imagens/parafusos2.jpg');
catch
    % Fallback caso executado de outro diretório
    im_Parafuso = imread('Lista 4/Imagens/parafuso2.jpg');
    im_Parafusos = imread('Lista 4/Imagens/parafusos2.jpg');
end

% ----------------------------------------------------------
% ESPAÇO PARA O SEU PROCESSAMENTO (Implemente aqui!)
% ----------------------------------------------------------

im_proc1 = double(im_Parafuso);
im_proc1 = fft2(im_proc1);
im_proc1 = fftshift(im_proc1);

im_proc2 = double(im_Parafusos);
im_proc2 = fft2(im_proc2);
im_proc2 = fftshift(im_proc2);


[Real, Imag] = pol2cart(angle(im_proc1), abs(im_proc2));
im_proc3 = Real + 1i * Imag;
im_proc3 = ifftshift(im_proc3);
im_proc3 = ifft2(im_proc3);
im_proc3 = real(im_proc3);



% ==========================================================
% EXIBIÇÃO DOS RESULTADOS (2x2 Subplot)
% ==========================================================
figure('Name', 'Lista 4 - Processamento de Parafuso', 'NumberTitle', 'off');

subplot(4, 3, 1);
imshow(im_Parafuso);
title('1. Imagem Original');

subplot(4, 3, 2);
imshow(uint8(255*mat2gray(log(1 + abs(im_proc1)))));
title('2. Logarítmica');

subplot(4, 3, 3);
imshow(angle(im_proc1));
title('3. Fase');

subplot(4, 3, 4);
imshow(im_Parafusos);
title('4. Imagem Original');

subplot(4, 3, 5);
imshow(uint8(255*mat2gray(log(1 + abs(im_proc2)))));
title('5. Logarítmica');

subplot(4, 3, 6);
imshow(angle(im_proc2));
title('6. Fase');

subplot(4, 3, 8);
imshow(uint8(im_proc3));
title('8. Módulo da Imagem 1 + Fase da Imagem 2');


pause;