library(ggplot2)
data <- read.csv("/Users/sophiekearney/human_variants.csv")
View(data)

p_vals <- na.omit(data$p_val)
p_vals <-as.numeric(p_vals)

ggplot(data, aes(x=p_vals)) + 
  geom_histogram(color="black", fill="white") +
  ggtitle("Human Variant P-Values") +
  theme(plot.title = element_text(hjust = 0.5)) + 
  scale_x_continuous("P-Values") + 
  scale_y_continuous("Count")

gwas <- data[data$source=="GWASCatalog",]
gwas_chrom <- gwas[!is.na(as.numeric(gwas$chromosome)),]
gwas_chrom$chromosome <- as.numeric(gwas_chrom$chromosome)

ggplot(data=gwas_chrom, aes(x=chromosome)) + 
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_x_continuous("Chromosome", labels = as.character(gwas_chrom$chromosome), breaks = gwas_chrom$chromosome)+
  scale_y_continuous("Count") + 
  ggtitle("Human Variant Chromosome") +
  theme(plot.title = element_text(hjust = 0.5))

###############

mouse <- read.csv("/Users/sophiekearney/h_t_m.csv")
View(mouse)

ggplot(data=mouse, aes(x=to_tissue)) + 
  geom_bar(aes(y = (..count..)/sum(..count..)))





