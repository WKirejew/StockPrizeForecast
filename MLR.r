library(readr)
library(tidyverse)
library(TTR)

## 1. Pobranie danych i wstępna obróbka
eurusd1h <- "https://raw.github.com/WKirejew/ProjektML/master/EURUSD.csv"
adata <- read_csv(eurusd1h)
adata <- subset(adata, Volume > 0)
adata <- mutate(adata, Date = substring(adata$Time[], 1, 10))
adata$Time[] <- substring(adata$Time[], 12, 13)
adata = select(adata, Date, Time, Close, High, Low, Volume)

## 2. Obliczenie i dodanie wskaźników analizy technicznej
#Lista parametrów:
rsin <- 14

#RSI
adata <- mutate(adata, RSI = RSI(adata$Close, n = rsin))
bdata <- adata[-c(1:rsin),]


print(bdata[1,])