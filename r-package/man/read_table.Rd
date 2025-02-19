% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download.R
\name{read_table}
\alias{read_table}
\title{Query a table by its name, without SQL code}
\usage{
read_table(table, billing_project_id = get_billing_id(), page_size = 1e+05)
}
\arguments{
\item{table}{defaults to \code{NULL}. If a table name is provided then it'll be concatenated with "basedosdados." and the whole table will be returned.}

\item{billing_project_id}{a string containing your billing project id. If you've run \code{set_billing_id} then feel free to leave this empty.}

\item{page_size}{\code{bigrquery} internal, how many rows per page should there be. Defaults to 10000, consider increasing if running into performance issues or big queries.}
}
\description{
\code{read_sql} takes in SQL code and runs the query for you. \code{read_table("table")} will return the entire table or an error in case it doesn't exist.
}
\examples{

\dontrun{

# instead of a SQL query use a table name directly

data <- read_sql(table = "br_ibge_pib.municipios")
data <- read_sql(table = "br_ibge_populacao.municipios")

}

}
