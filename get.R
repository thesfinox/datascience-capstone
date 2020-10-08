#
# Download and partition the Swiftkey dataset.
#
# author: Riccardo Finotello
# date:   07/10/2020
#

# download the dataset
print("Downloading dataset...")
file.url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
file.out <- "./swiftkey.zip"
if(!file.exists(file.out)) {download.file(file.url, file.out, method="curl")}
if(!dir.exists("./final")) {unzip(file.out)}

# download list of bad words
print("Downloading bad words list...")
file.url <- "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/badwordslist/badwords.txt"
file.out <- "./badwords.txt"
if(!file.exists(file.out)) {download.file(file.url, file.out, method="curl")}

# read the files
print("Reading blogs data...")
blogs   <- readLines("./final/en_US/en_US.blogs.txt", encoding="UTF-8", skipNul=TRUE)
print("Reading news data...")
news    <- readLines("./final/en_US/en_US.news.txt", encoding="UTF-8", skipNul=TRUE)
print("Reading Twitter data...")
twitter <- readLines("./final/en_US/en_US.twitter.txt", encoding="UTF-8", skipNul=TRUE)

# clean from non ASCII characters
print("Removing non ASCII characters...")
blogs   <- iconv(blogs, to="ASCII", sub="")
news    <- iconv(news, to="ASCII", sub="")
twitter <- iconv(twitter, to="ASCII", sub="")

# sample training data (flip a biased coin and decide what to keep)
set.seed(42)

#---- blogs data
print("Partitioning blogs data...")
index <- as.logical(rbinom(n=length(blogs), size=1, prob=0.05))
blogs.train <- blogs[index]
blogs.out   <- blogs[-index]
index <- as.logical(rbinom(n=length(blogs.out), size=1, prob=0.01))
blogs.test  <- blogs.out[index]

#---- news data
print("Partitioning news data...")
index <- as.logical(rbinom(n=length(news), size=1, prob=0.03))
news.train <- news[index]
news.out   <- news[-index]
index <- as.logical(rbinom(n=length(news.out), size=1, prob=0.01))
news.test  <- news.out[index]

#---- twitter data
print("Partitioning Twitter data...")
index <- as.logical(rbinom(n=length(twitter), size=1, prob=0.02))
twitter.train <- twitter[index]
twitter.out   <- twitter[-index]
index <- as.logical(rbinom(n=length(twitter.out), size=1, prob=0.005))
twitter.test  <- twitter.out[index]

# save partitions to separate files
print("Saving partitions to separate files...")

#---- create directories
if(!dir.exists("./train")) {dir.create("./train")}
if(!dir.exists("./test")) {dir.create("./test")}

#---- save files
writeLines(blogs.train, "./train/blogs.txt")
writeLines(blogs.test, "./test/blogs.txt")
writeLines(news.train, "./train/news.txt")
writeLines(news.test, "./test/news.txt")
writeLines(twitter.train, "./train/twitter.txt")
writeLines(twitter.test, "./test/twitter.txt")