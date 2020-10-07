#
# Tokenise the Swiftkey dataset.
#
# author: Riccardo Finotello
# date:   07/10/2020
#

library(quanteda)
library(readtext)
library(parallel)

# add multithreading option
quanteda_options("threads" = detectCores())
quanteda_options("verbose" = TRUE)

# read the training corpus (delete sentences shorter than 4 tokens in train set)
print("Reading text...")
train <- corpus(readtext("./train/*.txt"))
test  <- corpus(readtext("./test/*.txt"))

# read the badwords
print("Reading badwords...")
bad <- readLines("./badwords.txt", encoding="UTF-8", skipNul=TRUE)
bad <- iconv(bad, to="ASCII", sub="")

# tokenise the datasets
print("Tokenising training dataset...")
tokens.train <- tokens(train,
                       remove_punct      = TRUE,
                       remove_symbols    = TRUE,
                       remove_numbers    = FALSE,
                       remove_url        = TRUE,
                       remove_separators = TRUE,
                       split_hyphens     = FALSE,
                       include_docvars   = TRUE,
                       padding           = FALSE,
                      )

print("Tokenising test dataset...")
tokens.test  <- tokens(test,
                       remove_punct      = TRUE,
                       remove_symbols    = TRUE,
                       remove_numbers    = FALSE,
                       remove_url        = TRUE,
                       remove_separators = TRUE,
                       split_hyphens     = FALSE,
                       include_docvars   = TRUE,
                       padding           = FALSE,
                      )

# filter badwords
print("Filtering badwords...")
tokens.train <- tokens_select(tokens.train,
                              pattern          = bad,
                              selection        = "remove",
                              case_insensitive = TRUE
                             )

# save tokens to file
print("Saving tokens to file...")
tokens.train <- tokens_tolower(tokens.train)
tokens.test  <- tokens_tolower(tokens.test)
save(tokens.train, tokens.test, file="./tokens.Rdata")

# create n-grams
print("Creating n-gram models...")
unigrams  <- tokens_ngrams(tokens.train, n=1, concatenator=" ")
bigrams   <- tokens_ngrams(tokens.train, n=2, concatenator=" ")
trigrams  <- tokens_ngrams(tokens.train, n=3, concatenator=" ")
fourgrams <- tokens_ngrams(tokens.train, n=4, concatenator=" ")
save(unigrams, bigrams, trigrams, fourgrams, file="./ngrams.Rdata")

# create frequency matrices
print("Creating frequency matrices...")
dfm     <- dfm(unigrams)
bidfm   <- dfm(bigrams)
tridfm  <- dfm(trigrams)
fourdfm <- dfm(fourgrams)
save(dfm, bidfm, tridfm, fourdfm, file="./dfm.Rdata")