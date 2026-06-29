% Lista 7 - Exercício 4: Teste das Funções Morfológicas Customizadas
clc; clear; close all;

% Adiciona a pasta deste script (Lista 7) ao caminho de busca do Octave
caminho_script = fileparts(mfilename('fullpath'));
addpath(caminho_script);


%% 1. Leitura da Imagem de Teste
% Esta imagem contém caracteres com pequenas fendas (gaps) de 1 e 2 pixels de largura.
caminho_img = 'Lista 7/imgs_lista_7/Fig0907(a)(text_gaps_1_and_2_pixels).png';
img_original = imread(caminho_img);

%% 2. Definição do Elemento Estruturante (SE)
% Usaremos um elemento estruturante quadrado de 3x3.
% Ele tem raio de 1 pixel em todas as direções, o que é perfeito para realizar 
% a dilatação necessária para unir fendas de até 2 pixels de largura.
se = true(3, 3);

%% 3. Processamento Morfológico
disp('Processando Erosão...');
img_erosao = minha_erosao(img_original, se);

disp('Processando Dilatação...');
img_dilatacao = minha_dilatacao(img_original, se);

disp('Processando Abertura...');
img_abertura = minha_abertura(img_original, se);

disp('Processando Fechamento...');
img_fechamento = meu_fechamento(img_original, se);

%% 4. Visualização Geral dos Resultados
figure('Name', 'Lista 7: Processamento Morfológico Geral', 'Position', [100, 100, 1200, 800]);

subplot(2, 3, 1);
imshow(img_original);
title('1. Imagem Original (Com Gaps)');

subplot(2, 3, 2);
imshow(img_erosao);
title('2. Erosão (Caracteres Finos / Gaps Ampliados)');

subplot(2, 3, 3);
imshow(img_dilatacao);
title('3. Dilatação (Caracteres Negritos / Gaps Fechados)');

subplot(2, 3, 4);
imshow(img_abertura);
title('4. Abertura (Contornos Suavizados / Gaps Abertos)');

subplot(2, 3, 5);
imshow(img_fechamento);
title('5. Fechamento (Caracteres Corrigidos / Gaps Fechados)');

% Subplot 6: Zoom Comparativo (Original vs Fechamento)
% Vamos recortar uma região homogênea com texto para destacar a correção das fendas.
regiao_crop = [150, 280, 180, 330]; % [linha_ini, linha_fim, col_ini, col_fim]
crop_original = img_original(regiao_crop(1):regiao_crop(2), regiao_crop(3):regiao_crop(4));
crop_fechamento = img_fechamento(regiao_crop(1):regiao_crop(2), regiao_crop(3):regiao_crop(4));

% Criando uma imagem composta lado a lado para o zoom comparativo
img_zoom_comparativo = [crop_original, true(size(crop_original, 1), 4), crop_fechamento];

subplot(2, 3, 6);
imshow(img_zoom_comparativo);
title('6. Zoom: Original (Esquerda) vs Fechamento (Direita)');

%% 5. Discussão Teórica dos Resultados (Anotações para Estudo)
% -------------------------------------------------------------------------
% ANÁLISE DOS EFEITOS DE CADA OPERAÇÃO MORFOLÓGICA:
%
% 1. EROSÃO:
%    - A erosão "encolhe" os objetos em primeiro plano. 
%    - Como o elemento estruturante 3x3 precisa caber inteiramente dentro do texto, 
%      os caracteres tornam-se extremamente finos, e as fendas originais de 1 e 2 pixels 
%      são amplificadas, fazendo partes dos caracteres sumirem por completo.
%
% 2. DILATAÇÃO:
%    - A dilatação "expande" os objetos em primeiro plano. 
%    - Ela preenche com sucesso todas as fendas (gaps) dos caracteres. 
%    - Contudo, o efeito colateral é que o texto fica extremamente grosso (em negrito),
%      fazendo com que letras vizinhas se fundam e fiquem ilegíveis.
%
% 3. ABERTURA (Erosão seguida de Dilatação):
%    - A abertura é ótima para remover ruídos isolados (pequenos pontos brancos) e 
%      suavizar contornos externos.
%    - Entretanto, ela NÃO consegue fechar as fendas do texto. Como a erosão roda 
%      primeiro, ela aumenta a distância das fendas eliminando pontes estreitas. A 
%      dilatação subsequente apenas restaura a espessura original das letras restantes, 
%      mas as fendas continuam lá (ou ficam ainda maiores).
%
% 4. FECHAMENTO (Dilatação seguida de Erosão):
%    - O fechamento é a ferramenta ideal para resolver o problema desta imagem!
%    - A dilatação roda primeiro, preenchendo as fendas e criando conexões ("pontes") 
%      sólidas entre os segmentos quebrados das letras.
%    - A erosão subsequente encolhe o contorno de volta ao seu tamanho e espessura 
%      originais. Como as pontes criadas pela dilatação são largas o suficiente, a 
%      erosão não consegue desfazê-las.
%    - O resultado é um texto perfeitamente legível, com espessura original preservada 
%      e todas as fendas restauradas!
% -------------------------------------------------------------------------

pause;
