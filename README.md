# Data Science Specialisation Capstone

## Next Word Prediction

--
Riccardo Finotello
--

### Description

This project is the final capstone of the *Data Science Specialisation* offered by the John Hopkins University through [Coursera.org](https://www.coursera.org/specializations/jhu-data-science).
The idea is to build a web app capable of predicting the next word given an incomplete sentence as input, mimicking the behaviour of the next word prediction present in an Android/iOS keyboard.
We use the dataset provided by [SwiftKey](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) for training and testing the web app built in RStudio.

### Predictions

The project consists of two main tasks, a pitch presentation and a web app realisation.
An exploratory data analysis was performed and can be found on RPubs.
It shows the main data analysis with plots showing the most occurrences of words and n-grams.
The full analysis has been performed in separated *R* files:

1. the [get.R](./get.R) file contains the main functions to retrieve the datasets,
2. the [tokens.R](./tokens.R) is built to tokenise the documents and save different n-grams,
3. in [table.R](./table.R) we translate the tokens into the `data.table` format before applying transformations and performing any computation,
4. [kneserney.R](./kneserney.R) contains an implementation of the Kneser-Ney algorithm for computing the probability of a word appearing after several others,
5. in [predictions.R](./predictions.R) we write the main functions to predict the next word given a sentence as input,
6. [tests.R](./tests.R) contain some unit tests performed on the test dataset.

The code for the app can be found in the [webapp](./webapp) directory.
Finally a pitch presentation will be available on [RPubs](https://rpubs.com/thesfinox/672458).

### Notes

For the development of the app we use the English corpus provided by SwiftKey.
From the blogs, news and Twitter data we collect 15% of the entries for training and 5% for testing purposes.
The implementation of the [Kneser-Ney](https://en.wikipedia.org/wiki/Kneser%E2%80%93Ney_smoothing) algorithm follows the description found in the [Wikipedia page](https://en.wikipedia.org/wiki/Kneser%E2%80%93Ney_smoothing).

