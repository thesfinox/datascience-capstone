#
# Performance tests.
#
# author: Riccardo Finotello
# date:   07/10/2020
#

library(quanteda)
library(data.table)
library(parallel)

setDTthreads(threads=detectCores())
quanteda_options("threads" = detectCores())
quanteda_options("verbose" = FALSE)

# load test data
print("Loading test data...")
load("./tokens.Rdata")

# create test n-grams
print("Creating test n-gram models...")
unigrams.test  <- tokens_ngrams(tokens.test, n=1, concatenator=" ")
bigrams.test   <- tokens_ngrams(tokens.test, n=2, concatenator=" ")
trigrams.test  <- tokens_ngrams(tokens.test, n=3, concatenator=" ")
fourgrams.test <- tokens_ngrams(tokens.test, n=4, concatenator=" ")

# concatenate news, blogs, Twitter data
unigrams.test  <- c(unigrams.test[[1]], unigrams.test[[2]], unigrams.test[[3]])
bigrams.test   <- c(bigrams.test[[1]], bigrams.test[[2]], bigrams.test[[3]])
trigrams.test  <- c(trigrams.test[[1]], trigrams.test[[2]], trigrams.test[[3]])
fourgrams.test <- c(fourgrams.test[[1]], fourgrams.test[[2]], fourgrams.test[[3]])

# load predictions functions
print("Loading predictions...")
source("./predictions.R")

# for each (n-1)-gram take the corresponding n-gram and compare prediction with last word
compare <- function(left, right, i) {
    last <- tokens(tolower(right[i]),
                   remove_punct      = TRUE,
                   remove_symbols    = TRUE,
                   remove_numbers    = FALSE,
                   remove_url        = TRUE,
                   remove_separators = TRUE,
                   split_hyphens     = FALSE,
                   include_docvars   = TRUE,
                   padding           = FALSE
                  )
    last <- rev(last[[1]])[1]
    pred <- getNext(left[i])
    
    # return if the last word is in the predictions
    last %in% pred
}

# perform check bigrams w/ trigrams
# e.g. compare(bigrams.test, trigrams.test, 1) ---> TRUE
# e.g. compare(bigrams.test, trigrams.test, 3) ---> FALSE
# N.B.: how to systematically check more instances?