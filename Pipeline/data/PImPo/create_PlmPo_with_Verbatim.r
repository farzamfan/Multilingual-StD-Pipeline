# Install required packages (only necessary if not already installed)
install.packages("magrittr")
install.packages("dplyr")
install.packages("manifestoR")
install.packages("haven")

# Load packages
library(magrittr)
library(dplyr)
library(manifestoR)
library(haven)

# Set working directory
setwd("Desktop/Plm Manifest/") # Substitute .... with the file path of the directory in which you are working, 
# e.g. setwd("C:/Users/data_set/PImPo")

# Sign up on the Manifesto Project website (https://manifesto-project.wzb.eu/)
# and download your personal API key.
# Save it into the working directory set above.
mp_setapikey(key.file = "manifesto_apikey.txt")
mp_use_corpus_version(versionid = 20150708174629)

# Download the csv file with the quasi-sentence level data set and
# the csv with the verbatim missing in the Corpus
# Save both into the set working directory.

# Add the data set to your R session.
PImPo <- read.csv("PImPo_qsl_wo_verbatim.csv", sep = ",", dec = ".", stringsAsFactors = F, fileEncoding = "UTF-8", encoding = "UTF-8")

# Access verbatim from corpus
documents <- PImPo %>% group_by(party, date) %>% slice(1) %>% ungroup()
corpus <- mp_metadata(documents) %>%
  subset(annotations) %>%
  mp_corpus() %>%
  as.data.frame(with.meta = TRUE) %>%
  filter(text != ".") %>% 
  mutate(country = substr(as.character(party), 1, 2)) %>% 
  mutate(country = as.integer(country)) %>% 
  select(content = text, party, date, country, cmp_code, pos_corpus = pos) %>%
  filter(!is.na(cmp_code)) %>%
  mutate(party = as.integer(party), date = as.integer(date))

# Add verbatim to the immigration dataset
PImPo_preproc_verbatim <- left_join(PImPo, corpus %>% select(date, party, pos_corpus, cmp_code, content), 
                                    by = c("date", "party", "pos_corpus"))

# The 2007 manifesto of the Finish National Coalition   
# and the 2013 manifesto of the German Greens in the corpus 
# does not contain all verbatim that was coded by the crowd. 
# Execute the next line, to see how many quasi-sentence are affected by this.
PImPo_preproc_verbatim %>% filter(is.na(content)) %$% table(party, date)

# The reason why this text is not included in the Manifesto Corpus is 
# that the Manifesto Project classified the respective text as text in margin.
# This decision was made in retrospect and by the time the Manifesto Project 
# removed the text from the Corpus, the crowd coding had already been conducted 
# and thus the respective text has been coded by the crowd. 
# We have left it in the PImPo so that the user can decide freely 
# whether to ignore this text, or whether to work with it. 

# For excluding the specific quasi-sentences run this line.
PImPo_verbatim <- PImPo_preproc_verbatim %>% filter(!is.na(pos_corpus))

# If you want to exclude the marginal text from the PImPo, continue the script in line 74.
# For adding the text execute the following lines, too.
mis_verbatim <- read.csv("mis_verbatim.csv", sep = ",", dec = ".", stringsAsFactors = F, fileEncoding = "UTF-8", encoding = "UTF-8")
PImPo_mis_verbatim <- PImPo_preproc_verbatim %>% filter(is.na(pos_corpus))
cleaned_PImPo_mis_verbatim <- left_join(PImPo_mis_verbatim %>% select(-c(content, cmp_code)), 
                                        mis_verbatim, 
                                        by = c("rn"))
PImPo_verbatim <- rbind(PImPo_verbatim, cleaned_PImPo_mis_verbatim)
PImPo_verbatim <- PImPo_verbatim %>% arrange(rn)

# Save dataset with verbatim to your working directory
# If you want to easily open the csv later in xlsx, 
# it is useful to set the correct column seperator now. 
# Which one you need depends on the language installations on your computer,
# in most cases the "," will be correct, if that is not 
# the case it will be the semicolon (see second line).
# If you want all special characters displayed correctly in Excel, make sure 
# to specify the encoding as UTF-8 when reading the csv into Excel.
write.table(PImPo_verbatim, "PImPo_verbatim.csv", fileEncoding = "UTF-8", row.names = FALSE, sep = ",")
# write.table(PImPo_verbatim, "PImPo_verbatim.csv", fileEncoding = "UTF-8", row.names = FALSE, sep = ";")

# If you want to use the data in Stata you can execute this line
# for exporting a dta file. Be aware the version is set to Stata14.
# Theoretically you can also set it to other Stata versions, by exchanging the 14
# for another version number between 10 and 14. 
# Be aware that if you use the Stata version below 14, Stata will automatically cut long strings.
# Meaning that your dataset will not always contain the full content of a quasi-sentence.
write_dta(PImPo_verbatim, path = "PImPo_verbatim.dta", version = 14)