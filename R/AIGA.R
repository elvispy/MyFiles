library(tidyverse);
library(readxl)
content <- read_excel("C:/Users/Elvis Aguero/Downloads/AIGA_Planilla Inversion y transferencia  FONACIDE (Hernandarias)_Planilla_20190831.xlsx")
extracted <- content %>% select(Fecha, Banco, Credito, Debito, Saldo)
suda <- extracted %>% filter(Banco == "SUDAMERIS")
suda_graph <- suda %>% mutate(new_saldo = Saldo/1000000000) %>% 
  ggplot(aes(Fecha, new_saldo)) + 
  geom_line(color = "#ab2a3e", size =1.7) + 
  labs(y = "Monto en miles de Millones de Guaranies", x = "",
       caption = "") + 
  ylim(c(1, 6))

# Hide panel borders and remove grid lines
suda_graph + theme(
  # Remove panel border
  panel.border = element_blank(),  
  # Remove panel grid lines
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  # Remove panel background
  panel.background = element_blank(),
  # Add axis line
  axis.line = element_line(colour = "grey"),
  plot.title = element_text(size = 12,
                            face = "italic",
                            color = "#ab2a3e", 
                            lineheight = 1.2),
  axis.title.y = element_text(size=12, 
                              face="bold",
                              hjust=0.5,
                              lineheight=1.2)
)
  
