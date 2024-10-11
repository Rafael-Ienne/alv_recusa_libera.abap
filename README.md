# Projeto recusa / liberação de vendas
Este projeto, focado no módulo SD(Sales and Distributions), busca praticar a construção de relatórios ALV e uso de BAPI. Com base em um range de números de documentos de vendas passado na tela de seleção,
ocorre a seleção dos itens de venda na tabela VBAP e a exibição dos mesmos em um ALV. Caso o usuário queira bloquear a venda de um determinado item, ele deve selecionar uma linha no ALV e clicar no botão "Recusar", definindo o campo ABGRU da tabela transparente VBAP para '00'. Por outro lado, se o usuário deseja liberar a venda do item, ele precisa selecionar uma linha no ALV e clicar no botão "Liberar", definindo o campo ABGRU da tabela transparente VBAP para vazio.
Tal processo ocorre mediante o uso da BAPI (módulo de função que permite realizar uma função empresarial específica) denominada 'BAPI_SALESORDER_CHANGE'.

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
