~~Zajęcia numer 1 <- 10.13
##topepo.github.io/caret/index.html ->pakiet funkcji machine learning
library(caret,ggplot2)
data <- iris
##klasyfikacja - zmienna factorowa (factor)
##regresja - zmienna ciągła (liczbowa - numeric) - pełny zakres? -> przekształcenia żeby zakres miał -inf,+inf

##Przygotowanie danych do analizy:
#apply, base - wbudowane
#dplyr, tidyr, ggplot2 - do instalacji

preproc <- caret::preProcess(data, method=c("center","scale"))
mydata <- predict(preproc, data)
#Rozkład skośny -> rozkład normalny -> standaryzacja boxa-coxa:
preproc <- caret::preProcess(data, method=c("BoxCox"))
mydata <- predict(preproc, data)

##niezbalansowanie danych:
#downSample()
#upSample()

##redukcja wymiarowości:
#Recursive Feature Elimination, RFE 
library(mlbench)
set.seed(1)
results <- rfe(input, output, sizes=c(1:100), rfeControl=rfeControl(functions=rfFuncs, method="cv", number=10))
print(results)
plot(results, type=c("g","o"))
#rfeControl=rfeControl(functions=rfFuncs, method="cv", number=10) - kroswalidacja, o "number" iteracji
#Learning Vector Quantization, LVQ
#minimum-Redundancy Maximum-Relevance, mRMR

~~Zajęcia numer 2 <-10.20
# funkcja wbudowana apply
# lapply/tapply
test <- lapply(iris[,1:4], range, mean,  function(x){x^2-3}) 
# wywołanie funkcji na zbiorze iris [,1:4]] - 5 kolumna ma wartości w innym formacie, więc wykorzystujemy tylko 1:4 kolumny i [, - wszystkie wiersze tych kolumn
test <- data.frame(test) # forma tabelaryczna

#dplyr

# - select
# - filter
# - mutate
# - arrange
# - group_by
# - summarize
# - 

#Principal Component Analysis, PCA
- maksymalizujemy wariancję w "m" wymiarowej przestrzeni,
- każdy nowy wymiar jest ortogonalny do poprzedniego, spełniając warunek największej wariancji
fit_pca <- prcomp(data, center = TRUE, scale. = TRUE) 
#pakiet podstawowy, z wykorzystaniem centrowania i skalowania danych tworzy matrycę obrotów fit_pca$rotation i dane fit_pca$x

~~Zajęcia numer 3 <-10.27
##Grupowanie danych
#Partitioning based - podział na podstawie konkretnych cech łączących punkty należące do danej grupy
 - K-means: klaster o określonym środku
kmeans()
kmeansruns() - oblicza liczbę grup - k, wymaga pakietu fpc
 - K-medoids: klaster jest jednym elementem, pakiety fpc i cluster
pam()
pamk()
 - Ocena jakości grupowania - pakiet NbClust
NbClust()
#Hierarchical clustering - tworzy hierarchię grup (dendrogram)
Dist <- dist(iris[,-5], method="euclidean")
fit_tree <- hclust(Dist, method="ward.D")
plot(fit_tree)

~~Zajęcia numer 4 <-11.3
##Model liniowy
tworzenie modelu - lm()
podsumowanie modelu - summary()
wyświetlanie modelu - plot() lub abline()
predykcja - predict()
library(UsingR)
data(diamond); head(diamond,3)
fit <- lm(price~carat, data=diamond)
summary(fit)newres <- data.frame(carat=c(1,2,3))
predict(fit, newdata=newres, interval = ("confidence"))
plot(diamond$cara, diamond$price); abline(fit)
#transformacja danych:
 - funkcja log() #tworzy logarytm,
 - funkcja I() #bardziej skomlikowane funkcje matematyczne np. I(Temp^2)
 - funkcja factor() #zmienia typ danych
fit2 <- lm(Wind ~ I(Temp^2) + log(Solar.R) + factory(Month)) #operator ~ znaczy wszystko, + uwzględnia dodatkowe parametry, - usuwa dany element
#interakcje - operator * - wszystkie interakcje lub : - jedna interakcja:
lm(y ~ a * b, data) - podwójna interakcja (a, b, ab)
lm(y ~ a * b * c, data) - potrójna interakcja (a, b, c, ab, ac, bc, abc)
lm(y ~ a + b + b:c) - interakcje: a, b i bc
#uaktualnianie modeli - funkcje: update() i step()

##Modele drzew decyzyjnych:
#Recursive partioning - minimalizuje funkcję sumy kwadratów błędów
library(rpart)
fit <- rpart(Out ~.,data = training, method = "class")
summary(fit)
r-bloggers.com/recursive-partioning-and-regression-trees-exercises/
#C4.5 - maxymalizuje różnice entropii, wymaga zainstalowanej Javy:
library(RWeka)
fit <- J48(Out ~., data = training, method ="class")
summary(fit)
#PART - algorytm przycinający zbiór danych:
library(RWeka)
fit <- PART(Out ~., data = raining, method = "class")
summary(fit)
#FFT - szybkie i oszczędne drzewa, każda gałąź tworzy przynajmniej 1 ostateczną ścieżkę:
library("FFTrees")
fit <- fft(formula = diagnosis ~., data = breastcancer)
plot(fit, main = "Breastcancer FFT", decision.names = c("Healthy", "Cancer"))

#Lasy losowe: bagging (Bootstrap Aggregation) - iteracyjne wykorzystanie tego samego algorytmu:
 - utworzyć nowe dane za pomocą pewnego algorytmu,
 library(ipred)
 fit <- bagging(Out ~., data=training, method="class")
 summary(fit)
 - trenować na nich wiele drzew decyzyjnych,
 - pozwolić drzewom na generowanie dowolnych parametrów,
 library(randomForest)
 fit <- randomForest(Output ~., data=training, ntree=150) #ntree - parametr określający liczbę drzew
 plot(fit)
 fit$importance #uzysaknie informacji o ważności kolumn na podstawie Gini index
 - ostatecznie wybrać ostateczne predykcje (np. poprzez głosowanie)

~~Zajęcia numer 6 <-11.24 
## Modele zespołowe (łączenie modeli)
- Cohens Kappa -> dokładność metody - dokładność strzału losowego, jeśli >0 to model ma jakikolwiek sens i można go dalej łączyć

#Ensemble models - łączenie słabych modeli
#Pakiet h2o:
library(h2o)
h2o_local <- h2o.init(ip ="localhost", port = 54321 nthreads = -1, mex_mem_size = "5g")
h2o_data <- h2o.importFile(path = "...", header = TRUE, sep = ",")
.. podział danych na treining_frame, test_frame, validation_frame
h2o_model <- h2o.stackedEnsemble (x, y, training_frame, model_id = NULL, validation_frame = NULL, base_models = list(), selection_strategy = c("choose_all"))

##Walidacja:
- Cohens Kappa, Accuracy itp.
- Confusion Matrix and Statistics - zbiór pomiarów dokładności itp.