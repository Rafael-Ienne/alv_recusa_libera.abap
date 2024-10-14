# Projeto recusa / liberação de vendas
Este projeto, focado no módulo SD(Sales and Distributions), busca praticar a construção de relatórios ALV, uso de BAPI e interpretação de especificações funcionais. 

## Especificação funcional

Criar um programa que selecione os itens das ordens de venda e mostre o resultado em forma de relatório.
O relatório deve ter um cabeçalho contendo um botão de ação chamado RECUSAR e outro chamado LIBERAR.
O relatório deve permitir selecionar uma ou várias linhas.
Ao clicar no botão recusar, o programa vai inserir motivo de recusa ‘00’ (sem aspas) nos itens das ordens de vendas selecionados.
Ao clicar no botão liberar, o programa vai inserir motivo de recusa ‘ ’ (sem aspas) nos itens das ordens de vendas selecionados.

Tela de seleção
Este programa deve ter uma tela inicial contendo parâmetro ordem de venda (vbak-vbeln) para usar como filtro. 

Dados do relatório
O relatório deve conter os seguintes campos:
Tabela VBAP: Itens da Ordem de Vendas
vbeln ,
posnr,
matnr,
arktx,
kwmeng,
vrkme,
abgru .

Para inserir motivo de recusa deve ser usada as BAPI BAPI_SALESORDER_CHANGE.
Os parâmetros da bapi devem ser preenchidos da seguinte forma:
- SALESDOCUMENT: número da ordem VBAK-VBELN
- ORDER_HEADER_INX-UPDATEFLAG: U
- ORDER_ITEM_IN-ITM_NUMBER: VBAP-POSNR
- ORDER_ITEM_IN-REASON_REJ: “00” (sem aspas) para recusar e " " para liberar
- ORDER_ITEM_INX-ITM_NUMBER: VBAP-POSNR
- ORDER_ITEM_INX-REASON_REJ: “X” (sem aspas)


ORIENTAÇÕES TÉCNICAS:
O que voce precisa saber de ABAP:
- tabelas internas
- operações de leitura (select)
- loop, read table, select for all entries
- append
-funções 
- classes
- Status gui
- ALV com classes


## Conhecimentos aplicados
- Dicionário de dados(SE11);
- BAPI (BAPI_SALESORDER_CHANGE);
- ABAP objects(SE24);
- ALV OO (cl_gui_alv_grid).

## Tela de seleção
![Tela de seleção](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/main/img/tela_selecao.png)

## Retorno de todos os registros
![Retorno registros](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/main/img/retorno_todos_registros.png)

# Antes do bloqueio da venda do item
![Antes do bloqueio](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/main/img/antes_bloqueio.png)

# Após bloqueio da venda do item
![Após bloqueio](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/main/img/apos_recusa.png)

# Antes da liberação da venda do item
![Antes liberação](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/main/img/antes_liberacao.png)

# Após liberação da venda do item
![Após liberação](https://raw.githubusercontent.com/Rafael-Ienne/alv_recusa_libera.abap/main/img/apos_liberacao.png)
