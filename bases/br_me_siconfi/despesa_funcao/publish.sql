/*

Query para publicar a tabela.

Esse é o lugar para:
    - modificar nomes, ordem e tipos de colunas
    - dar join com outras tabelas
    - criar colunas extras (e.g. logs, proporções, etc.)

Qualquer coluna definida aqui deve também existir em `table_config.yaml`.

# Além disso, sinta-se à vontade para alterar alguns nomes obscuros
# para algo um pouco mais explícito.

TIPOS:
    - Para modificar tipos de colunas, basta substituir STRING por outro tipo válido.
    - Exemplo: `SAFE_CAST(column_name AS NUMERIC) column_name`
    - Mais detalhes: https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types

*/

CREATE VIEW basedosdados-dev.br_me_siconfi.despesa_funcao AS
SELECT 
SAFE_CAST(ano AS INT64) ano,
SAFE_CAST(sigla_uf AS STRING) sigla_uf,
SAFE_CAST(id_municipio AS STRING) id_municipio,
SAFE_CAST(portaria AS STRING) portaria,
SAFE_CAST(id_conta_normalizado AS STRING) id_conta_normalizado,
SAFE_CAST(id_conta_bd AS STRING) id_conta_bd,
SAFE_CAST(conta_original AS STRING) conta_original,
SAFE_CAST(conta_bd AS STRING) conta_bd,
SAFE_CAST(codigo AS STRING) codigo,
SAFE_CAST(formula_conta AS STRING) formula_conta,
SAFE_CAST(valor AS FLOAT64) valor
from basedosdados-dev.br_me_siconfi_staging.despesa_funcao as t