function img_out = minha_abertura(img_in, se)
    % MINHA_ABERTURA Realiza a operação morfológica de abertura binária.
    %   A abertura consiste em uma EROSÃO seguida de uma DILATAÇÃO.
    %   É usada para remover ruídos pequenos (pontos claros) e suavizar contornos.
    
    img_out = minha_dilatacao(minha_erosao(img_in, se), se);
end
