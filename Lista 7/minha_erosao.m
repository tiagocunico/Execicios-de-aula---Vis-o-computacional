function img_out = minha_erosao(img_in, se)
    % MINHA_EROSAO Realiza a erosão morfológica binária de uma imagem.
    %
    %   COMO FUNCIONA?
    %   Em vez de percorrer cada pixel da imagem com loops lentos, esta função
    %   desloca (translada) a imagem inteira em relação ao centro do elemento
    %   estruturante (SE) e acumula os resultados usando a lógica AND (&).
    %   Isso é chamado de "Vetorização" e roda em frações de milissegundo!
    %
    %   Entradas:
    %     img_in : Imagem original (será convertida para lógica/binária)
    %     se     : Elemento estruturante binário (dimensões ímpares)
    
    % --- Passo 1: Garantia de tipos lógicos ---
    % Se a imagem de entrada ou o SE não forem lógicos (0 e 1 binários),
    % nós os convertemos comparando com > 0.
    if ~islogical(img_in)
        img_in = img_in > 0;
    end
    if ~islogical(se)
        se = se > 0;
    end

    % --- Passo 2: Validar dimensões do Elemento Estruturante ---
    % Elementos estruturantes morfológicos precisam ter dimensões ímpares
    % (ex: 3x3, 5x5, 7x7) para possuírem um pixel central perfeito.
    [M, N] = size(se);
    if mod(M, 2) == 0 || mod(N, 2) == 0
        error('O elemento estruturante deve ter dimensões ímpares.');
    end

    % --- Passo 3: Encontrar o Pixel Central e as Margens ---
    % Por exemplo, se SE for 3x3 (M=3, N=3):
    % - O centro cr e cc será: floor((3+1)/2) = 2 (ou seja, a posição central [2, 2])
    cr = floor((M + 1) / 2);
    cc = floor((N + 1) / 2);
    
    % Margens de deslocamento necessárias (raio do elemento)
    % Se SE é 3x3, precisamos de pad_r = floor(3/2) = 1 pixel de margem
    pad_r = floor(M / 2);
    pad_c = floor(N / 2);
    
    [rows, cols] = size(img_in);
    
    % --- Passo 4: Moldura de Preenchimento (Padding) ---
    % Criamos uma imagem ampliada (uma "moldura") para podermos fazer os
    % deslocamentos sem estourar os limites das coordenadas da matriz original.
    % 
    % IMPORTANTE NA EROSÃO: Preenchemos as bordas extras com TRUE (1).
    % Fizemos isso porque a erosão "consome" as bordas que tocam pixels pretos (0).
    % Se preenchessemos com 0, a imagem original inteira sofreria erosão a partir
    % dos limites externos do arquivo. Preenchendo com 1, protegemos as bordas.
    img_padded = true(rows + 2*pad_r, cols + 2*pad_c);
    
    % Inserimos a imagem de entrada bem no centro desta moldura
    img_padded((1 + pad_r):(rows + pad_r), (1 + pad_c):(cols + pad_c)) = img_in;
    
    % --- Passo 5: Inicialização e Loop Vetorizado ---
    % Começamos assumindo que a imagem inteira de saída é TRUE (1).
    % Conforme aplicarmos os deslocamentos com o operador AND (&),
    % os pixels pretos (0) vão "comendo" e desativando as posições.
    img_out = true(rows, cols);
    
    % Varremos as linhas (r) e colunas (c) do ELEMENTO ESTRUTURANTE
    for r = 1:M
        for c = 1:N
            % Apenas realizamos o deslocamento se a posição de SE for 1 (ativa)
            if se(r, c)
                % Calcula a distância (offset) em relação ao centro (cr, cc)
                % Ex: Se estamos na primeira linha (r=1) e o centro é cr=2,
                % o deslocamento vertical é dr = 1 - 2 = -1 (deslocar 1 pixel para CIMA)
                dr = r - cr;
                dc = c - cc;
                
                % Extraímos da moldura a submatriz deslocada de mesmo tamanho que a imagem original.
                % Ao mudar as coordenadas indexadas com dr e dc, pegamos a imagem "deslocada".
                sub_img = img_padded((1 + pad_r + dr):(rows + pad_r + dr), ...
                                     (1 + pad_c + dc):(cols + pad_c + dc));
                
                % OPERAÇÃO AND (&): Une as imagens deslocadas.
                % O pixel de saída só será 1 se ele for 1 na imagem original E em 
                % todas as direções indicadas pelo elemento estruturante.
                img_out = img_out & sub_img;
            end
        end
    end
end
