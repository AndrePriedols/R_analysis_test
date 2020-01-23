# Parte 1.1:
# Exercício 1: higienizando o dataset;
# carregando as libraries;
library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)

# carregando o arquivo original no objeto "dadosInt";
dadosInt <- read.csv("processo_seletivo.csv", sep=";", stringsAsFactors = FALSE)

# nomenando colunas 1 e 2 como "UF" e "data", respectivamente;
names(dadosInt) [1] <- paste("UF")
names(dadosInt) [2] <- paste("data")

# substituindo valores na coluna "data" para formato adequado;
dadosInt$data <- str_replace_all(dadosInt$data, c("December " = "01/12/", 
                                                   "November " = "01/11/", 
                                                   "October " = "01/10/", 
                                                   "September " = "01/09/", 
                                                   "August " = "01/08/", 
                                                   "July " = "01/07/", 
                                                   "June " = "01/06/", 
                                                   "May " = "01/05/", 
                                                   "April " = "01/04/", 
                                                   "March " = "01/03/", 
                                                   "February " = "01/02/", 
                                                   "January " = "01/01/"))

# alterando coluna "data" fique no formato YYYY/MM/DD;
dadosInt$data <- as.Date(dadosInt$data, "%d/%m/%Y")

# transformando o tipo da coluna "UF" para "factor";
dadosInt$UF <- as.factor(dadosInt$UF)

# transformando o tipo das colunas "preco"e "qtidade" para "numeric";
dadosInt$preco <- str_replace(dadosInt$preco, ",", ".")
dadosInt$preco <- as.numeric(dadosInt$preco)
dadosInt$qtidade <- str_replace(dadosInt$qtidade, ",", ".")
dadosInt$qtidade <- as.numeric(dadosInt$qtidade)

# imprimindo as 6 primeiras linhas para visualizar o dataset;
head(dadosInt)

# Exercício 2: 
# a) preço médio mensal nacional;
mediaMensalNacional <- aggregate(dadosInt$preco, by=list(data=dadosInt$data), FUN=mean)

# renomeando coluna para "preço médio mensal";
names(mediaMensalNacional) [2] <- paste("preço médio mensal")

# b) vendas totais mensais nacionais;
vendaTotalMensalNacional <- aggregate(dadosInt$qtidade, by=list(data=dadosInt$data), FUN=sum)

# renomeando coluna para "volume de vendas mensal";
names(vendaTotalMensalNacional) [2] <- paste("volume de vendas mensal")

# unindo "preço médio mensal" e "volume de vendas mensal" em um data frame;
dadosMensais <- mediaMensalNacional
dadosMensais <- mutate(dadosMensais, vendaTotalMensalNacional$`volume de vendas mensal`)
names(dadosMensais)[3] <- paste("volume de vendas mensal")

# c) receita nacional mensal;
dadosMensais <- mutate(dadosMensais, "receita mensal" = dadosMensais$`preço médio mensal`*dadosMensais$`volume de vendas mensal`)

# conferindo o data frame final;
head(dadosMensais)

# checando diretório atual;
getwd()

#salvando em teste_final.csv;
# write.csv(dadosMensais,'/Users/andrepsouza/Desktop/4INTELLIGENCE/teste_final.csv', row.names = FALSE)

# Parte 1.1:
# Exercício 1: 
# a) gráfico de barras com a receita anual total nacional entre os anos de 2012 a 2018;
# criando data frame com ano/receita total e renomeando colunas;
receitaAnualTotalNacional <- select(dadosMensais, data, 'receita mensal')
names(receitaAnualTotalNacional) [1] <- paste("ano")
names(receitaAnualTotalNacional) [2] <- paste("receita anual total nacional")

# limpando coluna para conter apenas os anos;
receitaAnualTotalNacional$ano <- substr(receitaAnualTotalNacional$ano, 1,4)

# somando receita total nacional por ano;
receitaAnualTotalNacional <- aggregate(receitaAnualTotalNacional$'receita anual total nacional', by=list(ano=receitaAnualTotalNacional$ano), FUN=sum)
names(receitaAnualTotalNacional) [2] <- paste("receita anual total nacional")

# extraindo dados de 2012-2018;
receitaAnualTotalNacional$ano <- as.numeric(receitaAnualTotalNacional$ano)
ratnDozeDezoito <- filter(receitaAnualTotalNacional, ano >=2012 & ano <=2018)

# criando visualização receita anual total nacional 2012-2018;
barplot(ratnDozeDezoito$`receita anual total nacional`, names.arg = ratnDozeDezoito$ano, main ="Receita Anual Total Nacional 2012 - 2018", col=c(2,3,4,5,6,7,1))

# b) gráfico de linhas com todo o histórico mensal da receita nacional;
# criando data frame com receita mensal nacional;
rmtn <- select(dadosMensais, data, 'receita mensal')

# criando visualização;
plot(rmtn)
lines(rmtn, col=2)

# c) visualização de boxplot da quantidade vendida por mês, por estado;
# calculando os quartis;
quantile(dadosInt$qtidade)

# visualizando boxplot -  fica evidente que as quantidades vendiades têm amplitude pequena, sem outliers;
boxplot(dadosInt$qtidade)

