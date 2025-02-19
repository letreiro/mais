
//----------------------------------------------------------------------------//
// build: id_candidato
//----------------------------------------------------------------------------//

use "output/candidatos_1998.dta", clear
foreach ano of numlist 2000(2)2020 {
	append using "output/candidatos_`ano'.dta"
}
*

//--------------------//
// limpa entradas erradas
//--------------------//

drop if cpf == "" | cpf == "#NULO#" | cpf == "000000000-4" | cpf == "0" | cpf == "00000000000" | cpf == "NR_CPF_CANDIDATO"
drop if titulo_eleitoral == "000000000000" | titulo_eleitoral == "#NI#"

//--------------------//
// 1a rodada
// usa cpf and titulo_eleitoral
//--------------------//

keep nome cpf titulo_eleitoral
duplicates drop

egen id_candidato_bd = group(cpf titulo_eleitoral), missing
la var id_candidato_bd "ID Candidato(a) - Base dos Dados"

bys cpf: egen aux_id_number_cpf = max(id_candidato_bd)
replace id_candidato_bd = aux_id_number_cpf

bys titulo_eleitoral: egen aux_id_number_TE = max(id_candidato_bd)
replace id_candidato_bd = aux_id_number_TE

egen aux_cpf = tag(id_candidato_bd cpf)
bys id_candidato_bd: egen N_cpf = sum(aux_cpf)

egen aux_TE = tag(id_candidato_bd titulo_eleitoral)
bys id_candidato_bd: egen N_TE = sum(aux_TE)

drop aux*

duplicates tag id_cand, gen(dup)

order    id_candidato_bd N_cpf N_TE cpf titulo_eleitoral nome
sort dup id_candidato_bd N_cpf N_TE cpf titulo_eleitoral

preserve
	keep if N_cpf > 1 & N_TE > 1
	save "tmp/para_2a_rodada.dta", replace
restore

keep if N_cpf == 1 | N_TE == 1

keep id_candidato_bd cpf titulo_eleitoral nome

save "tmp/1a_rodada.dta", replace

//--------------------//
// 2a rodada
// separar por nomes
//--------------------//

use "tmp/para_2a_rodada.dta", clear

gen nome_limpo = nome
clean_string nome_limpo

gen aux_primeira = word(nome_limpo, 1)
gen aux_ultima = word(nome_limpo, -1)

// consertando strings erradas identificadas no olho
replace aux_primeira = "elves"		if aux_primeira == "elvis" & aux_ultima == "leite"
replace aux_primeira = "lourival"	if aux_primeira == "luciano" & aux_ultima == "dombroski"
replace aux_primeira = "vanderley"	if aux_primeira == "vanderlley" & aux_ultima == "passos"
replace aux_primeira = "manoel"		if aux_primeira == "manuel" & aux_ultima == "santos"
replace aux_primeira = "daizymar"	if aux_primeira == "deizymar" & aux_ultima == "messini"
replace aux_primeira = "moacir"		if aux_primeira == "moacy" & aux_ultima == "evangelista"

replace aux_ultima = "pontim"		if aux_primeira == "antonio" & aux_ultima == "pontin"
replace aux_ultima = "messine"		if aux_primeira == "daizymar" & aux_ultima == "messini"
replace aux_ultima = "ortigosa"		if aux_primeira == "ideraldo" & aux_ultima == "ortigossa"
replace aux_ultima = "rezende"		if aux_primeira == "cecilio" & aux_ultima == "resende"
replace aux_ultima = "souza"		if aux_primeira == "antonio" & aux_ultima == "sousa"
replace aux_ultima = "paula"		if aux_primeira == "nuncia" & aux_ultima == "souza"
replace aux_ultima = "silva"		if aux_primeira == "custodia" & aux_ultima == "sessim"
replace aux_ultima = "soares"		if aux_primeira == "rosangela" & aux_ultima == "dantas"

egen aux_nomes = tag(id_candidato_bd aux_primeira aux_ultima)
bys id_candidato_bd: egen N_nomes = sum(aux_nomes)

egen aux_id = group(id_candidato_bd aux_primeira aux_ultima)
replace id_candidato_bd = 100000000 + aux_id	// para diferenciar de id_candidato em linhas
format id_candidato_bd %20.0g

keep if N_nomes == 1	// excluindo candidatos nao-identificados unicamente

keep id_candidato_bd cpf titulo_eleitoral nome

save "tmp/2a_rodada.dta", replace

//--------------------//
// append
//--------------------//

use "tmp/1a_rodada.dta", clear
append using "tmp/2a_rodada.dta"

ren  id_candidato_bd aux_id
egen id_candidato_bd = group(aux_id)
la var id_candidato_bd "ID Candidato - Base dos Dados"

egen aux_cpf = tag(id_candidato_bd cpf)
bys id_candidato_bd: egen N_cpf = sum(aux_cpf)

egen aux_TE = tag(id_candidato_bd titulo_eleitoral)
bys id_candidato_bd: egen N_TE = sum(aux_TE)

drop if N_cpf > 2 | N_TE > 2	// excluindo candidatos com possibilidade de erro grande demais (>2)

sort  id_candidato_bd
order id_candidato_bd cpf titulo_eleitoral nome
keep  id_candidato_bd cpf titulo_eleitoral nome

compress

save "output/id_candidato_bd.dta", replace
