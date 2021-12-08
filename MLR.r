library(readr)
library(tidyverse)
eurusd <- "https://raw.github.com/WKirejew/ProjektML/master/EURUSD.csv"
adata <- read_csv(eurusd)
adata <- subset(adata, Volume > 0)
adata <- mutate(adata, Date = substring(adata$Time[], 1, 10))
adata$Time[] <- substring(adata$Time[], 12, 13)
adata = select(adata, Date, Time, Close, High, Low, Volume)
print(adata[1,])