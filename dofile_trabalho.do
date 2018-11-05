***************************************************
**CODIGO PARA TRABALHO DE ECONOMETRIA I************
**COM O PROFESSOR JESUS ALEXEI LUIZAR OBREGON******
**ESSE PROGRAMA TEM FINS DE REPLICAÇÃO*************
**AUTOR: PEDERO CAVALCANTE OLIVEIRA ***************
**DEPARTAMENTO DE ECONOMIA, UFF, NITERÓI, RJ*******
***************************************************

***********ABRA A PNAD2015 E DEPOIS**************** 
***********RODE O CODIGO***************************

*instalar dpplot
ssc inst dpplot

****RESTRINGINDO AMOSTRA À ALAGOAS
destring uf, replace

gen AL = 0
replace AL = 1 if uf == 27

*VARIAVEIS DESCRITIVAS SIMPLES
gen branco = 0
replace branco = 1 if v0404 == 2

gen idade = v8005
gen idade_quad = v8005^2

***excluindo crianças para não termos resultados contaminados pelo trabalho infantil****
drop if idade < 15 

gen casado = 0
replace casado = 1 if v4011 == 1

gen nasceu_AL = 0
replace nasceu_AL = 1 if v5030 == 27

gen migrante_sul = 0
replace migrante_sul = 1 if nasceu_AL == 0 & v5030 > 30

gen analfabeto = 0
replace analfabeto = 1 if v0601 == 3

gen anos_estudo = 0
replace anos_estudo = v4803 if v4803 < 17
replace anos_estudo = 16 if v4803 == 17
gen anos_estudo_quad = anos_estudo^2

*SETOR DE ATUAÇÃO

gen funcionario_publico = 0
replace funcionario_publico = 1 if v4706 == 3

gen militar = 0
replace militar = 1 if v4706 == 2

gen formal = 0
replace formal = 1 if v4706 == 1

gen informal = 0
replace informal = 1 if v4706 == 4

gen domestica_formal = 0
replace domestica_formal = 1 if v4706 == 6 

gen domestica_informal = 1
replace domestica_formal = 1 if v4706 == 7

gen outros = 0
replace outros = 1 if militar == 0 | formal == 0 | funcionario_publico == 0 | informal == 0| domestica_formal == 0 | domestica_informal == 0

*RENDIMENTOS, IMPORTANTE LIMPAR OS COM 999999999999 PORQUE ESSE É O CODIGO PARA AUSENCIA DE RESPOSTA
gen salario = 0
replace salario = v4718 if v4718 < 999999999

gen lnsalario = ln(salario)
*RELAÇÕES DE TRABALHO

gen satisfeito_trabalho = 0
replace satisfeito_trabalho = 1 if v3703 > 4

gen recebe_salario_acordado = 0
replace recebe_salario_acordado = 1 if v3706 == 1 | v3706 == 3

gen sindicalizado = 0 
replace sindicalizado = 1 if v9087 == 1

gen meses_trab = v9612 / 12
gen tempo_trab = v9611 + meses_trab

gen carga_horaria = v9058 

gen empregador_tem_cnpj = 0
replace empregador_tem_cnpj = 1 if v90531 == 1

*distribuição probabilistica dos salarios
dpplot salario, dist(exp)
dpplot salario, dist(normal)

dpplot carga_horaria, dist(normal)
dpplot tempo_trab, dist(normal)
dpplot tempo_trab, dist(exp)


sum salario, detail
sum carga_horaria, detail
sum tempo_trab, detail

table migrante
table analfabeto
table branco


*MODELO COM TODAS OS REGRESSORES

*Y em nível
reg salario branco idade idade_quad migrante_sul casado analfabeto anos_estudo anos_estudo_quad funcionario_publico militar formal informal domestica_formal domestica_informal outros satisfeito_trabalho recebe_salario_acordado sindicalizado tempo_trab carga_horaria empregador_tem_cnpj

*Y em log neperiano
reg lnsalario branco idade idade_quad migrante_sul casado analfabeto anos_estudo anos_estudo_quad funcionario_publico militar formal informal domestica_formal domestica_informal outros satisfeito_trabalho recebe_salario_acordado sindicalizado tempo_trab carga_horaria empregador_tem_cnpj

*Y em nivel depois de excluir regressores irrelevantes
reg salario branco idade idade_quad migrante_sul analfabeto anos_estudo anos_estudo_quad funcionario_publico militar formal informal domestica_formal  satisfeito_trabalho recebe_salario_acordado sindicalizado tempo_trab carga_horaria empregador_tem_cnpj

*Y em log neperiano depois de excluir regressores irrelevantes
reg lnsalario branco idade idade_quad migrante_sul analfabeto anos_estudo anos_estudo_quad funcionario_publico militar formal informal domestica_formal  satisfeito_trabalho recebe_salario_acordado sindicalizado tempo_trab carga_horaria empregador_tem_cnpj
