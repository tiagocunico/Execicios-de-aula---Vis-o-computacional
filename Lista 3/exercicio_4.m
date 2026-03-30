
% Leitura da imagem original
im_in = imread('Lista 3/Imagens/im_in.bmp');
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

% Criação da figura para comparação
figure('Name', 'Comparação da Imagem', 'NumberTitle', 'off');

% Exibição da imagem original
subplot(1, 2, 1);
imshow(im_in);
title('Imagem Original');

% Exibição da imagem processada
subplot(1, 2, 2);
% Como você construiu o seu o array 'h' com os valores finais na mão
% e não está querendo plotar uma "imagem", a função certa para mostrar
% o seu vetor do histograma como gráfico de barras é a bar():
bar(0:255, h);
xlim([0 255]);
title('Histograma Calculado');

pause;
