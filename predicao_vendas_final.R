# Parte 1.3;
# modelo previsão de vendas baseado no preço;
# carregando as libraries;
library(dplyr)
library(ggplot2)
library(lubridate)
library(stringr)

# carregando o arquivo "teste_final.csv";
dadosInt <- read.csv("processo_seletivo.csv", sep=";", stringsAsFactors = FALSE)

# extraindo colunas de interesse - "preço médio mensal" e "volume de vendas mensal";
preco_qtde <- select(dadosInt, preco, qtidade)

# alterando ambas colunas para tipo numérico;
preco_qtde$preco <- str_replace(preco_qtde$preco, ",", ".")
preco_qtde$qtidade <- str_replace(preco_qtde$qtidade, ",", ".")
preco_qtde$preco <- as.numeric(preco_qtde$preco)
preco_qtde$qtidade <- as.numeric(preco_qtde$qtidade)

# ordenando preco_qtde por preços em ordem crescente;
preco_qtde <- preco_qtde[order(preco_qtde$preco),]
head(preco_qtde)

# plotando preço X quantidade para visualizar a possível correlação entre ambos;
plot(preco_qtde)
# nota-se uma evidente correlação negativa entre ambos, o que é esperado;

# carregando pacote ISwR;
library(ISwR)

# calculando a correlação entre ambos;
cor(preco_qtde$preco, preco_qtde$qtidade)
# correlação de -0.949 - confirma impressão inicial;

# traçando uma linha que demonstre a correlação;
scatter.smooth(x=preco_qtde$preco, y=preco_qtde$qtidade, main="Correlação entre Preço e Quantidade")

# realizando uma regressão linear que preveja a quantidade em função do preço;
regressao <- lm(qtidade ~ preco, data=preco_qtde)

# imprimindo os valores encontrados;
regressao

# logo, o modelo preditivo seria: qtidade = 18.423 - 0.203*preco

# por se tratar de uma relação linear, a sensibilidade da demanda em relção ao preço é o próprio coeficiente angular, - 0,203;
# isso significa que a demanda é bastante inelástica em relação ao preço (osciações de preço têm reflexo relativamente pequeno na demanda);

