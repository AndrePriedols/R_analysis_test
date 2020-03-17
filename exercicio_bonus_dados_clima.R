# carregando packages;
library(readxl)
library(dplyr)
library(writexl)

# lendo o arquivo xlsx;
clima <- read_excel("dados_clima.xlsx")

# convertendo em data frame;
clima <- as.data.frame(clima)

# separando em objetos por Estado;
mt <- select(clima, 'UF...1','Temperatura (celsius)...2','Chuva (mm)...3','Data...4')
rj <- select(clima, 'UF...6','Temperatura (celsius)...7','Chuva (mm)...8','Data...9')
am <- select(clima, 'UF...11','Temperatura (celsius)...12','Chuva (mm)...13','Data...14')
ce <- select(clima, 'UF...16','Temperatura (celsius)...17','Chuva (mm)...18','Data...19')
rn <- select(clima, 'UF...21','Temperatura (celsius)...22','Chuva (mm)...23','Data...24')

# renomeando as colunas de maneira uniforme para junção futura;
mt <- mt %>% rename('UF' = 'UF...1', 'Temperatura (celsius)' = 'Temperatura (celsius)...2', 'Chuva (mm)' = 'Chuva (mm)...3', 'Data' = 'Data...4' )
rj <- rj %>% rename('UF' = 'UF...6', 'Temperatura (celsius)' = 'Temperatura (celsius)...7', 'Chuva (mm)' = 'Chuva (mm)...8', 'Data' = 'Data...9' )
am <- am %>% rename('UF' = 'UF...11', 'Temperatura (celsius)' = 'Temperatura (celsius)...12', 'Chuva (mm)' = 'Chuva (mm)...13', 'Data' = 'Data...14')
ce <- ce %>% rename('UF' = 'UF...16', 'Temperatura (celsius)' = 'Temperatura (celsius)...17', 'Chuva (mm)' = 'Chuva (mm)...18', 'Data' = 'Data...19')
rn <- rn %>% rename('UF' = 'UF...21', 'Temperatura (celsius)' = 'Temperatura (celsius)...22', 'Chuva (mm)' = 'Chuva (mm)...23', 'Data' = 'Data...24')

# junção num único data frame;
dadosClima <- rbind(mt, rj, am, ce, rn)

# alterando coluna "Data" para tipo Date;
dadosClima$Data <- as.Date(dadosClima$Data)

# salvando no arquivo CSV "dados_clima_versao_R.csv"
write.csv(dadosClima, 'dados_clima_versao_R.csv', row.names = FALSE)

# salvando em xlsx;
write_xlsx(dadosClima, "dados_clima_versao_R.xlsx")
