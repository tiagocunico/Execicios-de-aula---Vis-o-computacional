
% Leitura da imagem original
im_in = imread('Lista 3/Imagens/ex2.bmp');
im_out = im_in;

[linhas, colunas] = size(im_in);
k = zeros(1, 256);

for i = 1:linhas
    for j = 1:colunas
        % Pega o valor do pixel (0 a 255)
        valor_pixel = double(im_in(i, j));
        % Como o MATLAB começa os vetores no índice 1 (não tem k(0)), 
        % temos que somar +1. Ex: Pixel 0 vai pra gaveta k(1).
        k(valor_pixel + 1) =  k(valor_pixel + 1) + 1;
    end
end
for i = 1:256
    h(i) = (1/(linhas*colunas)) * k(i);
end

% 1. Calcula o SOMATÓRIO ACUMULADO (A letra sigma gigante na fórmula)
% Para não travar seu computador fazendo um 'for' gigante para cada pixel,
% calculamos a soma cumulativa de todo o histograma antes de tudo!
soma_acumulada = zeros(1, 256);
soma_acumulada(1) = k(1);
for idx = 2:256
    soma_acumulada(idx) = soma_acumulada(idx - 1) + k(idx);
end

% 2. Aplica a fórmula g(x,y) = (255 / nl*nc) * sum(n_j)
%
% --- EXPLICAÇÃO MATEMÁTICA ---
% Ao dividir o Somatório Acumulado pelo total de pixels (nl*nc),
% calculamos a PORCENTAGEM de pixels na imagem que são mais escuros 
% (ou iguais) ao nosso pixel atual.
% Se a cor original de um pixel for maior ou igual a 80% da imagem,
% a sua cor equalizada será jogada para 80% do brilho máximo: (0.80 * 255).
% A constante abaixo prepara essa parcela "1/Total_de_Pixels * 255".
constante = 255 / (linhas * colunas);

for i = 1:linhas
    for j = 1:colunas
        valor_pixel = double(im_in(i, j));
        
        % O vetor soma_acumulada já tem a soma de todos os n_j até o f(x,y)!
        % Então é só multiplicar a constante por esse valor guardado:
        novo_brilho = constante * soma_acumulada(valor_pixel + 1);
        
        im_out(i, j) = uint8(novo_brilho);
    end
end




% 3. Calcula o histograma da nova imagem só para mostrar no gráfico
k_out = zeros(1, 256);
for i = 1:linhas
    for j = 1:colunas
        valor = double(im_out(i, j));
        k_out(valor + 1) = k_out(valor + 1) + 1;
    end
end
% Normaliza pela quantidade de pixels
h_out = k_out / (linhas * colunas);

% Criação da figura para comparação
figure('Name', 'Equalização de Histograma (Ex 5)', 'NumberTitle', 'off');

% Exibição da imagem original
subplot(2, 2, 1);
imshow(im_in);
title('Imagem Original');

% Exibição da imagem Equalizada
subplot(2, 2, 2);
imshow(im_out);
title('Imagem Equalizada');

% Histograma original
subplot(2, 2, 3);
bar(0:255, h);
xlim([0 255]);
title('Histograma - Original');

% Histograma da nova imagem (Equalizada)
subplot(2, 2, 4);
bar(0:255, h_out);
xlim([0 255]);
title('Histograma - Equalizada');

pause;
