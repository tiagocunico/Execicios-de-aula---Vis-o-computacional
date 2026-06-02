function img_out = meu_fechamento(img_in, se)
    % MEU_FECHAMENTO Realiza a operação morfológica de fechamento binário.
    %   O fechamento consiste em uma DILATAÇÃO seguida de uma EROSÃO.
    %   É usado para preencher pequenos buracos e gaps (fendas) em objetos.
    
    img_out = minha_erosao(minha_dilatacao(img_in, se), se);
end
