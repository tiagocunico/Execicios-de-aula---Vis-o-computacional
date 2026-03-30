% ==========================================================
% EXERCÍCIO 3: Transformação Linear Definida por Partes
% ==========================================================
1; % <-- Comando dummy OBRIGATÓRIO no GNU Octave!
   % Isso garante que o Octave reconheça esse arquivo como um SCRIPT.
   % Se esse arquivo começasse direto com a palavra "function", ele ignoraria
   % todo o script lá embaixo.

% ==========================================================
% DEFINIÇÃO DA FUNÇÃO EXTERNA
% (No GNU Octave, a função deve SEMPRE ser definida ANTES de ser chamada!)
% ==========================================================
function im_out = transformacao_linear(im_in, ponto1, ponto2)
    % TRANSFORMACAO_LINEAR Aplica uma transformacao linear definida por partes.
    
    im_out = zeros(size(im_in), 'uint8');
    
    r1 = ponto1(1); s1 = ponto1(2);
    r2 = ponto2(1); s2 = ponto2(2);
    
    [linhas, colunas] = size(im_in);
    
    for i = 1:linhas
        for j = 1:colunas
            r = double(im_in(i, j));
            
            if r <= r1
                % Trecho 1: começa do (0,0) ate chegar em (r1,s1)
                a = s1/r1;
                s = a*r;
                
            elseif r > r1 && r <= r2
                % Trecho 2: de (r1,s1) ate chegar em (r2,s2)
                % Correção da matemática (faltou o -r1 no divisor!)
                a = (s2-s1)/(r2-r1);
                s = a*(r-r1)+s1;
                
            else
                % Trecho 3: do ponto (r2,s2) ate o finalzinho (255,255)
                % Correção da matemática (faltou o -r2 no divisor!)
                a = (255-s2)/(255-r2);
                s = a*(r-r2)+s2;
            end
            
            % Trava de segurança
            if s > 255; s = 255; end
            if s < 0;   s = 0;   end
            
            im_out(i, j) = uint8(s);
            
        end
    end
end

% ==========================================================
% EXECUÇÃO DO SCRIPT PRINCIPAL
% ==========================================================
clear; clc;

% 1. Leitura da imagem original
im_in = imread('Lista 3/Imagens/ex2.bmp');

% Se lermos uma imagem colorida (RGB, 3 canais), transformamos em cinza.
if size(im_in, 3) == 3
    im_in = rgb2gray(im_in);
end

% 2. Definição dos parâmetros da transformação
ponto1 = [60, 10];   % => Vetor com os valores de r1 e s1
ponto2 = [120, 240]; % => Vetor com os valores de r2 e s2

% 3. Chamada da função que foi definida ali em cima
im_out = transformacao_linear(im_in, ponto1, ponto2);

% ==========================================================
% PLOTAGEM DOS RESULTADOS
% ==========================================================
figure('Name', 'Exercício 3 - Transformação Linear por Partes', 'NumberTitle', 'off');

% Gráfico da Função Aplicada
subplot(1, 4, [1, 2]);
x_grafico = uint8(0:255);
% O legal aqui é que a sua própria função que processa a imagem
% consegue processar um vetor 1D do gráfico!
y_grafico = transformacao_linear(x_grafico, ponto1, ponto2);
plot(0:255, double(y_grafico), 'b-', 'LineWidth', 2);
title('Função Aplicada');
xlabel('Intensidade de Entrada (r)');
ylabel('Intensidade de Saída (s)');
xlim([0 255]); ylim([0 255]);
grid on;

% Imagem Original
subplot(1, 4, 3);
imshow(im_in);
title('Imagem Original');

% Imagem Processada
subplot(1, 4, 4);
imshow(im_out);
title('Imagem Processada (Transf. Linear)');

pause;
