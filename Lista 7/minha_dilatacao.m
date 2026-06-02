function img_out = minha_dilatacao(img_in, se)
    % MINHA_DILATACAO Realiza a dilatação morfológica binária de uma imagem.
    %
    %   COMO FUNCIONA?
    %   Em vez de percorrer cada pixel da imagem com loops lentos, esta função
    %   desloca (translada) a imagem inteira em relação ao centro do elemento
    %   estruturante (SE) e acumula os resultados usando a lógica OR (|).
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
    % IMPORTANTE NA DILATAÇÃO: Preenchemos as bordas extras com FALSE (0).
    % Como a dilatação "expande" os pixels brancos (1), preencher com zeros
    % garante que a imagem não comece a dilatar "a partir de fora" dos limites.
    img_padded = false(rows + 2*pad_r, cols + 2*pad_c);
    
    % Inserimos a imagem de entrada bem no centro desta moldura
    img_padded((1 + pad_r):(rows + pad_r), (1 + pad_c):(cols + pad_c)) = img_in;
    
    % --- Passo 5: Inicialização e Loop Vetorizado ---
    % Começamos assumindo que a imagem inteira de saída é FALSE (0).
    % Conforme aplicarmos os deslocamentos com o operador OR (|),
    % os pixels brancos (1) vão "marcando" as novas posições expandidas.
    img_out = false(rows, cols);
    
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
                
                % OPERAÇÃO OR (|): Une as imagens deslocadas.
                % O pixel de saída será 1 se ele for 1 em QUALQUER um dos deslocamentos
                % gerados pela vizinhança ativa do elemento estruturante.
                img_out = img_out | sub_img;
            end
        end
    end
end
