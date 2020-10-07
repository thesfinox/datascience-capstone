#
# Create data tables.
#
# author: Riccardo Finotello
# date:   07/10/2020
#

library(data.table)
library(parallel)

setDTthreads(threads=detectCores())

# load data
print("Loading data...")
load("./dfm.Rdata")

# sum the occurrences of each n-gram
print("Summing occurrences...")
unigram  <- colSums(dfm)
bigram   <- colSums(bidfm)
trigram  <- colSums(tridfm)
fourgram <- colSums(fourdfm)

# create data table for 1-grams
print("Creating table for 1-grams...")
unigram <- data.table(u1=names(unigram), count=unigram)
setkey(unigram, u1)

# create data table for 2-grams
print("Creating table for 2-grams...")
cols   <- strsplit(names(bigram), " ", fixed=TRUE)
bigram <- data.table(b1    = sapply(cols, "[[", 1),
                     b2    = sapply(cols, "[[", 2),
                     count = bigram
                    )
setkey(bigram, b1, b2)

# create data table for 3-grams
print("Creating table for 3-grams...")
cols   <- strsplit(names(trigram), " ", fixed=TRUE)
trigram <- data.table(t1    = sapply(cols, "[[", 1),
                      t2    = sapply(cols, "[[", 2),
                      t3    = sapply(cols, "[[", 3),
                      count = trigram
                     )
setkey(trigram, t1, t2, t3)

# create data table for 4-grams
print("Creating table for 4-grams...")
cols   <- strsplit(names(fourgram), " ", fixed=TRUE)
fourgram <- data.table(f1    = sapply(cols, "[[", 1),
                       f2    = sapply(cols, "[[", 2),
                       f3    = sapply(cols, "[[", 3),
                       f4    = sapply(cols, "[[", 4),
                       count = fourgram
                      )
setkey(fourgram, f1, f2, f3, f4)

# save table to file
save(unigram, bigram, trigram, fourgram, file="./ngram_table.Rdata")
