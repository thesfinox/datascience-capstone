#
# Compute probabilities using Kneser-Ney smoothing.
#
# author: Riccardo Finotello
# date:   07/10/2020
#

library(data.table)
library(parallel)

setDTthreads(threads=detectCores())

# load data
print("Loading data...")
load("./ngram_table.Rdata")

# set discount
d <- 0.7

print("Computing Kneser-Ney...")

# (1): no. of different bigrams
n_bigrams <- nrow(bigram[, .N, by = .(b1,b2)])

# (2): no. of bigrams completed by each word
n_closed <- bigram[, .(tot = (.N)), by = b2]
names(n_closed) <- c("word", "tot")
setkey(n_closed, word)

# (3): probability for each unigram: (1) / (2)
unigram[, prob:= (n_closed[u1,tot] / n_bigrams)]

# (4): no. of bigrams started by each word
n_open <- bigram[, .(tot = (.N)), by = b1]
names(n_open) <- c("word", "tot")
setkey(n_open, word)

# (5): no. of unigrams inside the bigrams
bigram[, n_unigrams:= unigram[b1,count]]

# (6): compute probability of bigrams
bigram[, prob:= ((count - d) / n_unigrams + d * n_open[b1,tot] * unigram[b2,prob] / n_unigrams)]

# (7): no. of trigrams started by each word
n_open <- trigram[, .(tot = (.N)), by = .(t1,t2)]
names(n_open) <- c("word1", "word2", "tot")
setkey(n_open, word1, word2)

# (8): no. of bigrams inside trigrams
trigram[, n_bigrams:= bigram[.(t1,t2),count]]

# (9): compute probability of trigrams
trigram[, prob:= ((count - d) / n_bigrams + d * n_open[.(t1,t2),tot] * bigram[.(t1,t2),prob] / n_bigrams)]

# (10): no. of fourgrams started by each word
n_open <- fourgram[, .(tot = (.N)), by = .(f1,f2,f3)]
names(n_open) <- c("word1", "word2", "word3", "tot")
setkey(n_open, word1, word2, word3)

# (11): no. of trigrams inside fourgrams
fourgram[, n_trigrams:= trigram[.(f1,f2,f3),count]]

# (12): compute probability of fourgrams
fourgram[, prob:= ((count - d) / n_trigrams + d * n_open[.(f1,f2,f3),tot] * trigram[.(f1,f2,f3),prob] / n_trigrams)]

# save the data
save(unigram, bigram, trigram, fourgram, file="./ngram_prob.Rdata")
