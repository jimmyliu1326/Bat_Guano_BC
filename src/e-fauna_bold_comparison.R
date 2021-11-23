# load library
library(here)
library(data.table)
library(tidyverse)

# define data path
ento_db_path <- here("data/BC Ento Database.csv")
bold_insecta_path <- here("data/bold_insecta_orders.list")

# read data
ento_db <- fread(ento_db_path, sep = ",", header = T)
bold_insecta <- readLines(bold_insecta_path)

# clean ento db
ento_db <- ento_db %>% 
	separate(order_sci, into = c("order_sci", "order_common"), sep = " \\(") %>% 
	mutate(order_common = str_replace(order_common, "\\)", ""))

# clean bold records
bold_insecta <- str_replace(bold_insecta, " \\[.*", "")


# check if bold contains ento db orders
intersect(bold_insecta, ento_db$order_sci) %>% length()

# find ento db orders not found in bold
setdiff(ento_db$order_sci, bold_insecta)

# correct for mismatches
correction <- data.frame(order_sci = setdiff(ento_db$order_sci, bold_insecta),
												 correct = c("Collembola", "Diplura", "Notoptera", "Blattodea",
												 						"Psocodea", "Protura", "Psocodea", "Zygentoma"))
# write output taxa list
output <- ento_db %>% 
	left_join(correction, by = "order_sci") %>% 
	mutate(correct = case_when(is.na(correct) ~ order_sci,
														 T ~ correct))
writeLines(output$correct, here("data/taxa.list"))