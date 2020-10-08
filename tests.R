#
# Performance tests.
#
# author: Riccardo Finotello
# date:   07/10/2020
#

library(quanteda)
library(readtext)
library(data.table)
library(parallel)

setDTthreads(threads=detectCores())
quanteda_options("threads" = detectCores())
quanteda_options("verbose" = FALSE)

# load test data
print("Loading test data...")
test  <- corpus(readtext("./test/*.txt"))
test  <- tokens(test,
                what="sentence",
                remove_punct      = TRUE,
                remove_symbols    = TRUE,
                remove_numbers    = FALSE,
                remove_url        = TRUE,
                remove_separators = TRUE,
                split_hyphens     = FALSE,
                include_docvars   = TRUE,
                padding           = FALSE,
               )
test <- c(test[[1]], test[[2]], test[[3]])

# remove last word from each sentence
test.remove <- lapply(test, (function(x) {word(x, start=1, end=-2)}))
# save last word and remove punctuation
test.last   <- lapply(test, (function(x) {word(x, start=-1)}))
test.last   <- sapply(test.last, (function(x) {gsub("[[:punct:]]+", "", x)}))

# load data for predictions
source("./predictions.R")

# compute predictions
predictions <- sapply(test.remove, (function(x) {getNext(x, n=1)}))

# do predictions match the last words?
accuracy <- sum(as.integer(test.last == predictions)) / length(predictions)
print(paste("Accuracy: ", accuracy))