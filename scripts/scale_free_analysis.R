library(ggplot2)
library(poweRlaw)

##########

degree <- read.csv("/Users/sophiekearney/Desktop/degrees_new.csv")
View(degree)

ggplot(degree, aes(`apoc.node.degree.p.`)) +
  geom_histogram(binwidth=3) +
  labs(x="Degree", y="Count") +
  ylim(0,300)

t <- table(degree$apoc.node.degree.p.)

#######

degree_dist <- degree$apoc.node.degree.p.
degree_dist <- degree$apoc.node.degree.p. + 1
d_pl <- displ$new(degree_dist)
est = estimate_xmin(d_pl)
d_pl$setXmin(est)

d_ln = dislnorm$new(degree_dist)
est = estimate_xmin(d_ln)
d_ln$setXmin(est)

d_pois = dispois$new(degree_dist)
est = estimate_xmin(d_pois)
d_pois$setXmin(est)

plot(d_pl)
lines(d_pl,col=2)
lines(d_ln,col=3)
lines(d_pois,col=4)

bs = bootstrap_p(d_pl)

########

degree_dist_no <- degree$apoc.node.degree.p.
degree_dist_no <- degree_dist_no[degree_dist_no > 0]

d_pl <- displ$new(degree_dist_no)
est = estimate_xmin(d_pl)
d_pl$setXmin(est)

d_ln = dislnorm$new(degree_dist)
est = estimate_xmin(d_ln)
d_ln$setXmin(est)

d_pois = dispois$new(degree_dist)
est = estimate_xmin(d_pois)
d_pois$setXmin(est)

plot(d_pl)
lines(d_pl,col=2)
lines(d_ln,col=3)
lines(d_pois,col=4)

bs = bootstrap_p(d_pl)
bs$p
View(bs)
