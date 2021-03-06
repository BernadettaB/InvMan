library(tidyverse)

# ABC analysis
ord.share <- c(0.32,	0.22,	0.16,	0.11,	0.07,	0.03,	0.02,	0.02,	0.015,	0.01,	0.009,	0.007,	0.005,	0.003,	0.001)
cum.ord.share <-cumsum(ord.share)
share.mat.num <- 0:length(ord.share)/length(ord.share)

png(file = "abc_plot.png", bg = "transparent", width=1200, height = 600)
par(family="serif")
plot(share.mat.num, c(0,cum.ord.share), type="b" , xlab = "share of material number", ylab="cumulative ordered value share", pch = 16, cex.lab = 2, cex.axis = 1.5)
abline(h = c(.8,.95), lty="dashed")
text(x= share.mat.num[-1], y = cum.ord.share-.03, labels=1:15, cex=1.75)
text(x= c(.05,.05,0.05), y = c(.6,.875,.990), labels=c("A","B","C"), cex=3)
dev.off()


# Plot of accuracy ratio

x.vals <- seq(.001,.25, length.out = 100)
log.q <- sapply(x.vals, function(x) mean(log(abs(rnorm(300000, 1, sd =x)))^2))

png(file = "q_plot.png", bg = "transparent", width=1200, height = 600)
par(family="serif", mar =c(4,9,4,.1))
plot(x.vals, log.q, type="l", ylab=expression(E*bgroup("(",log*bgroup("(",over(hat(d),d),")")^2 ,")")  ), xlab=expression(paste("standard deviation ", sigma)), main=expression(over(hat(d),d) %~%N(1,sigma)) , cex.lab = 1.75, cex.axis = 1.5, cex.main = 2)
dev.off()

# RSU/XYZ

q.vals <- c(0.012	,0.026,	0.042,	0.015	,0.051,	0.008,	0.005,	0.062	,0.032,	0.015,	0.012,	0.021,	0.004,	0.042,	0.037)

png(file = "abc_xyz_plot.png", bg = "transparent", width=1200, height = 600)
par(family="serif")
plot(q.vals, cum.ord.share , type="p" , xlab = "expected logarithmized accuracy", ylab="cumulative ordered value share", pch = 16, cex.lab = 2, cex.axis = 1.5, ylim=c(.25,1))
abline(h = c(.8,.95), lty="dashed")
abline(v = c(.02,.04), lty="dashed")
text(x= q.vals, y = cum.ord.share-.03, labels=1:15, cex=1.75)
par(xpd=T)
text(x= c(.065,.065,0.065), y = c(.6,.875,.990), labels=c("A","B","C"), cex=2)
text(x= c(.01,.03,0.0525), y = c(1.05,1.05,1.05), labels=c("X","Y","Z"), cex=2)
dev.off()


# IQR analysis #################################
# expected weekly demand in euros
w.vals <- ord.share * 150000
# stcok value
s.vals <- c(119.0	, 75.0, 	18.2,	58.6	,59.4,	32.2,	19.7,	28.6,	9.6	,13.2,	8.8,	5.3,	10.7,	7.1,	12.4)
# o vals
o.vals <- c(rep(2,3), rep(4,4), rep(6,8))
# a values
a.vals <- o.vals*w.vals/1000
# e1 values
e.1.vals <- sapply(s.vals - a.vals, function(x) max(0,x))
e.1.vals
# IQR vals
iqr.vals <- sapply(round(a.vals/s.vals,2), function(x) min(x,1))


png(file = "abc_iqr_plot.png", bg = "transparent", width=1200, height = 600)
par(family="serif")
plot(iqr.vals, cum.ord.share , type="p" , xlab = "IQR value", ylab="cumulative ordered value share", pch = 16, cex=1.5, cex.lab = 2, cex.axis = 1.5, ylim=c(.25,1), xlim = c(0,1))
abline(h = c(.8,.95), lty="dashed")
abline(v = c(.33,.66), lty="dashed")
text(x= iqr.vals, y = cum.ord.share-.03, labels=1:15, cex=1.75)
par(xpd=T)
text(x= c(1.065,1.065,1.065), y = c(.6,.875,.990), labels=c("A","B","C"), cex=2)
text(x= c(.17,.5,0.85), y = c(1.05,1.05,1.05), labels=c("no mover","slow mover","fast mover"), cex=2)
dev.off()


# deterministic MRP

## direct production coefficients
A <- rbind(
c(0,0,0,0,0,0,0,0),
c(0,0,0,0,0,0,0,0),
c(1,0,0,0,0,0,0,0),
c(2,1,2,0,3,0,0,0),
c(0,1,0,0,0,0,0,0),
c(0,0,0,3,0,0,0,0),
c(0,0,0,4,2,0,0,0),
c(0,0,5,0,3,0,0,0))

## gross demand matrix
G <- round(solve(diag(nrow(A)) - A))
## primary demand vector
x <- c(50,80,10,0,5,0,0,0)
# stock levels
s <- c(10,20,30,240,25,90,10,150)
## net demand
G %*% (x-s)
