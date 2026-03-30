% Leitura da imagem original
im_in = imread('Lista 3/Imagens/im_in.bmp');

% Aqui eu guardei o seu código de limiarização antiga caso você precise depois
% Limiar = 95;
% im_limiarizada = im_in > Limiar;

[linhas, colunas] = size(im_in);

% Inicializando as matrizes de saída com zeros para cada condição de contorno
im_dirichlet = zeros(linhas, colunas, 'uint8');
im_neumann = zeros(linhas, colunas, 'uint8');
im_circular = zeros(linhas, colunas, 'uint8');
im_replicacao = zeros(linhas, colunas, 'uint8');

% Dica: Para ver bem o efeito da borda, tente aplicar um Filtro de Média (borramento) 
% apenas nas bordas ou na imagem inteira com uma máscara 3x3, por exemplo.
% Você precisará acessar pixels como im_in(i-1, j-1) ... im_in(i+1, j+1).

for i = 1:linhas
    for j = 1:colunas
        
        % Sua missão: Quando você estiver nas bordas (ex: i=1 ou j=1), o MATLAB
        % não deixa você pedir o pixel im_in(i-1, j) pois o índice 0 não existe!
        % Crie os lógicos (if/else) para contornar isso nas 4 situações abaixo:
        
        % -------------------------------------------------------------
        % 1. Condição de Dirichlet (Zero Padding)
        % Se o pixel pedido sair da imagem, você deve considerar o valor dele como 0.
        % --- SEU CÓDIGO DA LÓGICA DE DIRICHLET VAI AQUI ---
        %im_dirichlet(i, j) = im_in(i, j); % Substitua aplicando real seu filtro
        media = 0;
        for k = i-1:i+1
            for l = j-1:j+1
                if k < 1 || k > linhas || l < 1 || l > colunas
                    media = media + 0;
                else
                    media = media + double(im_in(k, l));
                end
            end
        end
        im_dirichlet(i, j) = media / 9;
        
        % -------------------------------------------------------------
        % 2. Condição de Neumann (Espelhamento)
        % Se pedir pixel fora (ex: índice 0 ou linha+1), pegue o valor do pixel rebatido 
        % dentro da imagem correspondente.
        % --- SEU CÓDIGO DA LÓGICA DE NEUMANN VAI AQUI ---
        %im_neumann(i, j) = im_in(i, j); % Substitua aplicando real seu filtro
        media = 0;
        for k = i-1:i+1
            for l = j-1:j+1
                if k < 1 || k > linhas || l < 1 || l > colunas
                    if k < 1 && l < 1
                        media = media + double(im_in(k+1, l+1));
                    end
                    if k < 1 && l > 0 && l < colunas
                        media = media + double(im_in(k+1, l));
                    end
                    if k > 0 && l < 1 && k < linhas
                        media = media + double(im_in(k, l+1));
                    end
                    if k > 0 && l > colunas && k < linhas
                        media = media + double(im_in(k, l-1));
                    end
                    if k > linhas && l > 0 && l < colunas
                        media = media + double(im_in(k-1, l));
                    end
                    if k > linhas && l > colunas && k < linhas
                        media = media + double(im_in(k-1, l-1));
                    end
                else
                    media = media + double(im_in(k, l));
                end
            end
        end
        im_neumann(i, j) = media / 9;
        
        
        % -------------------------------------------------------------
        % 3. Periodicidade Circular (Wrap-around)
        media_circ = 0;
        for k = i-1:i+1
            for l = j-1:j+1
                k_circ = k;
                l_circ = l;
                
                % Lógica Circular (Wrap-around)
                if k < 1
                    k_circ = linhas;
                elseif k > linhas
                    k_circ = 1;
                end
                
                if l < 1
                    l_circ = colunas;
                elseif l > colunas
                    l_circ = 1;
                end
                
                media_circ = media_circ + double(im_in(k_circ, l_circ));
            end
        end
        im_circular(i, j) = media_circ / 9;
        
        
        % -------------------------------------------------------------
        % 4. Replicação do último pixel
        media_rep = 0;
        for k = i-1:i+1
            for l = j-1:j+1
                k_rep = k;
                l_rep = l;
                
                % Lógica de Replicação: Trava no limite da borda
                if k < 1
                    k_rep = 1;
                elseif k > linhas
                    k_rep = linhas;
                end
                
                if l < 1
                    l_rep = 1;
                elseif l > colunas
                    l_rep = colunas;
                end
                
                media_rep = media_rep + double(im_in(k_rep, l_rep));
            end
        end
        im_replicacao(i, j) = media_rep / 9;
        
    end
end


% Limiarização
Limiar = 95;

% Criação da figura para visualizar Original, Filtros e Limiarização
figure('Name', 'Comparação - Condições de Contorno e Limiares', 'NumberTitle', 'off');

% Linha 1: Imagem Original e Limiarizada
subplot(3, 4, 2); 
imshow(im_in);
title('Imagem Original');

subplot(3, 4, 3);
imshow(im_in > Limiar);
title('Original Limiarizada');

% Linha 2: Imagens Filtradas
subplot(3, 4, 5); imshow(im_dirichlet); title('1. Filtro: Dirichlet');
subplot(3, 4, 6); imshow(im_neumann); title('2. Filtro: Neumann');
subplot(3, 4, 7); imshow(im_circular); title('3. Filtro: Circular');
subplot(3, 4, 8); imshow(im_replicacao); title('4. Filtro: Replicação');

% Linha 3: Imagens Limiarizadas
subplot(3, 4, 9); imshow(im_dirichlet > Limiar); title('1. Limiar: Dirichlet');
subplot(3, 4, 10); imshow(im_neumann > Limiar); title('2. Limiar: Neumann');
subplot(3, 4, 11); imshow(im_circular > Limiar); title('3. Limiar: Circular');
subplot(3, 4, 12); imshow(im_replicacao > Limiar); title('4. Limiar: Replicação');

pause;
