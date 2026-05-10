% ==========================================================
% LISTA 4 - EXERCÍCIO 1
% Objetivo: Leitura de parafuso2.jpg e exibição de 4 gráficos
% (Placeholder para processamento que o usuário irá implementar)
% ==========================================================
clear; clc; close all;

% Carregar pacote de imagem no Octave (se necessário)
if (exist('OCTAVE_VERSION', 'builtin') ~= 0)
    pkg load image;
end

% 1. LEITURA DA IMAGEM
% Caminho relativo para a imagem
try
    im_orig = imread('Imagens/parafuso2.jpg');
catch
    % Fallback caso executado de outro diretório
    im_orig = imread('Lista 4/Imagens/parafuso2.jpg');
end

% ----------------------------------------------------------
% ESPAÇO PARA O SEU PROCESSAMENTO (Implemente aqui!)
% ----------------------------------------------------------

im_proc1 = double(im_orig);

im_proc1 = fft2(im_proc1);

% 🚫 Preciso informar o −π a π?
% Não. Tu não informas isso na função.
% O que acontece é o seguinte: matematicamente, quando tu calculas a FFT, o resultado vem organizado de 0 a 2π. Ao usares o fftshift, tu estás a "rodar" a matriz de modo que o que estava no fim (2π) e o que estava no início (0) se encontrem. O resultado visual disso é o que chamamos de espectro de −π a π.
% O −π e o π são apenas os rótulos dos eixos que tu usarias num gráfico para dizer: "Olha, o centro é o zero, o lado esquerdo é o limite negativo e o direito é o positivo".

im_proc1 = fftshift(im_proc1);

% Placeholder 1 
im_proc1 = im_proc1;

% Placeholder 2
im_proc2 = im_orig;

% Placeholder 3
im_proc3 = im_orig;

% ==========================================================
% EXIBIÇÃO DOS RESULTADOS (2x2 Subplot)
% ==========================================================
figure('Name', 'Lista 4 - Processamento de Parafuso', 'NumberTitle', 'off');

subplot(2, 2, 1);
imshow(im_orig);
title('1. Imagem Original');


% Linear: Verás que o gráfico fica quase todo preto com um pontinho branco brilhante no centro. Isso acontece porque o componente de frequência zero (DC) é ordens de grandeza maior que os outros. É como tentar tirar uma foto de uma vela ao lado do Sol; o Sol ofusca tudo.

subplot(2, 2, 2);
imshow(uint8(255*mat2gray(abs(im_proc1))));
title('2. Linear');

% Logarítmica: Ao aplicar log(1+moˊdulo), tu "achatas" essa diferença. Isso permite que as frequências mais baixas e mais altas fiquem visíveis na mesma imagem.
subplot(2, 2, 3);
imshow(uint8(255*mat2gray(log(1 + abs(im_proc1)))));
title('3. Logarítmica');

% Fase (angle): Indica o "atraso" ou deslocamento dessas ondas. É aqui que está a informação de onde as bordas estão localizadas.
subplot(2, 2, 4);
imshow(angle(im_proc1));
title('4. Fase');


%1. Pré-processamento e Precisão: > A análise no domínio da frequência exige que a imagem seja tratada como um sinal matemático contínuo e não apenas como um arquivo de imagem. Por isso, seguimos a cadeia RGB → Gray → Double. Primeiro, convertemos para tons de cinza para reduzir a dimensionalidade (de 3 canais para 1). Depois, convertemos para double (ou im2double) para garantir precisão decimal nos cálculos da FFT e evitar que os valores "estourem" o limite de 255 do uint8. A normalização (trazer os valores para o intervalo [0,1]) é o que permite que funções matemáticas como o logaritmo e a exponencial funcionem sem gerar erros de escala ou ruído numérico.

%2. Anatomia do Espectro e Ortogonalidade: > No domínio da frequência, o Módulo representa a energia (quanta variação existe), enquanto a Fase representa a geometria (onde a variação ocorre). O fenômeno mais importante aqui é a ortogonalidade: uma borda ou padrão repetitivo numa direção no espaço gera uma linha de frequências na direção perpendicular (90∘ de rotação) no espectro. Assim, detalhes horizontais aparecem no eixo vertical e vice-versa. O uso da escala logarítmica é obrigatório para visualização humana, pois ela comprime a enorme amplitude do componente DC (brilho médio) e "puxa" as altas frequências das bordas para o intervalo visível, revelando a assinatura direcional da imagem.


pause;