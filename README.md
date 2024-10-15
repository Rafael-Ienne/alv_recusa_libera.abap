<<<<<<< HEAD
# Monitor de status de vendas
Este projeto, focado no módulo SD(Sales and Distributions), busca praticar a construção de relatórios ALV, uso de BAPI e interpretação de especificações funcionais. 

## Especificação funcional

- Criar um programa que selecione os itens das ordens de venda e mostre o resultado em forma de relatório.
- A seleção pode acontecer também através da importação de uma planilha excel.
- O relatório deve ter um cabeçalho contendo um botão de ação chamado RECUSAR e outro chamado LIBERAR.
- O relatório deve permitir selecionar uma ou várias linhas.
- Ao clicar no botão recusar, o programa vai inserir motivo de recusa ‘00’ (sem aspas) nos itens das ordens de vendas selecionados.
- Por outro lado, ao clicar no botão liberar, o programa vai inserir motivo de recusa ‘ ’ (sem aspas) nos itens das ordens de vendas selecionados.

Tela de seleção
- Este programa deve ter uma tela inicial contendo parâmetros de seleção para usar como filtros. 

Os filtros são:
- Cliente:  kna1-kunnr
- Ordem de venda: vbak-vbeln
- Arquivo de importação: ver modelo anexo

Regras de funcionamento da tela de seleção:
- Caso o usuário preencha cliente ou ordem, o arquivo de importação não deve funcionar.
- Caso o usuário preencha arquivo de importação, cliente ou ordem não devem funcionar.
- Deve ter um radio button para selecionar qual opção vai ser usada.
- Caso seja usado o filtro arquivo de importação, o programa deve ler o arquivo e fazer as seleções de dados a seguir usando a ordem da planilha.
- Caso sejam usados os filtros cliente ou ordem, o programa deve fazer as seleções de dados a seguir usando estes filtros.

Dados do relatório

O relatório deve conter os seguintes campos:
 
- Tabela VBAK: Ordem de Vendas
(VBELN ERDAT ERNAM NETWR WAERK VKORG VTWEG SPART GBSTK KUNNR)

- Tabela VBAP: Itens da ordem de venda
(POSNR MATNR ARKTX ABGRU)
Selecionar dados onde VBAP-VBELN = VBAK-VBELN.

- Tabela KNA1: Cliente
(NAME1)
Encontrar NAME1 onde KUNNR = vbak-kunnr

Inserir motivo de recusa

Para inserir motivo de recusa deve ser usada as BAPI BAPI_SALESORDER_CHANGE.

Os parâmetros da bapi devem ser preenchidos da seguinte forma:
  
SALESDOCUMENT: número da ordem VBAK-VBELN
  
ORDER_HEADER_INX-UPDATEFLAG: U

ORDER_ITEM_IN-ITM_NUMBER: VBAP-POSNR
  
ORDER_ITEM_IN-REASON_REJ: “00” (sem aspas) para recusar e " " (sem aspas) para liberar

ORDER_ITEM_INX-ITM_NUMBER: VBAP-POSNR
  
ORDER_ITEM_INX-REASON_REJ: “X” (sem aspas)

Caso a tabela RETURN não retorne nenhum erro, executar a função BAPI_TRANSACTION_COMMIT

Caso a tabela RETURN retorne algum erro, executar a função BAPI_TRANSACTION_ROLLBACK

=======
# Projeto recusa / liberação de vendas
Este projeto, focado no módulo SD(Sales and Distributions), busca praticar a construção de relatórios ALV, module pool e uso de BAPI. Com base em um range de números de documentos de vendas passado na tela de seleção,
ocorre a seleção dos itens de venda na tabela VBAP e a exibição dos mesmos. Caso o usuário queira bloquear a venda de um determinado item, ele deve selecionar uma linha no ALV e clicar no botão "Recusar", definindo o campo ABGRU da tabela transparente VBAP para '00'. Por outro lado, se o usuário deseja liberar a venda do item, ele precisa selecionar uma linha no ALV e clicar no botão "Liberar", definindo o campo ABGRU da tabela transparente VBAP para vazio.
Tal processo ocorre mediante o uso da BAPI (módulo de função que permite realizar uma função empresarial específica) denominada 'BAPI_SALESORDER_CHANGE'.
>>>>>>> parent of 1d03875 (Merge branch 'main' of https://github.com/Rafael-Ienne/alv_recusa_libera.abap)

## Conhecimentos aplicados
- Dicionário de dados(SE11);
- BAPI (BAPI_SALESORDER_CHANGE);
- Module pool;
- ABAP objects(SE24);
- ALV OO (cl_gui_alv_grid).

## Tela de seleção
![Tela de seleção](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/refs/heads/main/img/tela_selecao.png)

## Retorno de todos os registros
![Retorno registros](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/refs/heads/main/img/TELA_COM_RESULTADOS.png)

# Antes do bloqueio da venda do item
![Antes do bloqueio](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/refs/heads/main/img/TELA_ANTES_BLOQUEIO_VENDA.png)

# Após bloqueio da venda do item
![Após bloqueio](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/refs/heads/main/img/TELA_APOS_BLOQUEIO_VENDA.png)

<<<<<<< HEAD
# Antes da liberação da venda do item
![Antes liberação](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/refs/heads/main/img/TELA_ANTES_LIBERACAO_VENDA.png)
=======
# Antes liberação da venda do item
![Antes liberação](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/main/img/antes_liberacao.png)
>>>>>>> parent of 1d03875 (Merge branch 'main' of https://github.com/Rafael-Ienne/alv_recusa_libera.abap)

# Após liberação da venda do item
![Após liberação](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/refs/heads/main/img/TELA_APOS_LIBERACAO_VENDA.png)
