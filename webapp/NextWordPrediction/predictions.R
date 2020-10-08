#
# Predict next word.
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

# load data
print("Loading data...")
load("./ngram_prob.Rdata")

# function to get the last 3 words
getWords <- function(str) {
    words <- tokens(tolower(str),
                    remove_punct      = TRUE,
                    remove_symbols    = TRUE,
                    remove_numbers    = FALSE,
                    remove_url        = TRUE,
                    remove_separators = TRUE,
                    split_hyphens     = FALSE,
                    include_docvars   = TRUE,
                    padding           = FALSE,
                   )
    rev(rev(words[[1]])[1:3])
}

# function to get next word
getNext <- function(str, n=5) {
    # tokenise the words
    words     <- getWords(str)
    
    # select next words from fourgrams
    nextWords <- fourgram[.(words[1], words[2], words[3])][order(-prob)]
    if(any(is.na(nextWords))) {
        # if there are no fourgrams then go to trigrams
        nextWords <- trigram[.(words[2], words[3])][order(-prob)]
        if(any(is.na(nextWords))) {
            # if there are no trigrams go to bigrams
            nextWords <- bigram[.(words[3])][order(-prob)]
            if(any(is.na(nextWords))) {
                # if there are no bigrams choose randomly the most common 100 words
                nextWords <- sample(unigram[order(-prob)][1:100][,u1], size=n)
            }
            # return second word of the bigrams
            if(length(nextWords) >= n) {return(nextWords[1:n,b2])}
            return(nextWords[,b2])
        }
        # return third word of the trigram
        if(nrow(nextWords) >= n) {return(nextWords[1:n,t3])}
        return(nextWords[,t3])
    }
    # return fourth word of the fourgram
    if(nrow(nextWords) >= n) {return(nextWords[1:n,f4])}
    return(nextWords[,f4])
}