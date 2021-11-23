# load packages
library(bold)
library(here)
# source
source(here("src/e-fauna_bold_comparison.R"))

# search for specimen data
for (i in output$correct) {
	file <- here("data/bold_specimen_data", paste0(i, ".tsv"))
	if (!file.exists(file)) {
		message(paste0("Searching for ", i))
		tryCatch( {
			res <- bold_specimens(taxon = i,
														geo = "British Columbia")
			write.table(res, file = file, row.names = F, quote =F , sep = "\t")	
		},
		error=function(e) {
			writeLines("",file)	
		})
	}
}
