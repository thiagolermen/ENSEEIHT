# TP1 - Modele beta-bonomial : avalanche a Montroe

# Initialisation
# Question 1
library(rootSolve)

# Question 2
model = function(x, pa, qa, pb, qb){
    c(F1=pa-pbeta(qa, x[1], x[2]), F2=pb-pbeta(qb, x[1], x[2]))
}
sol = multiroot(model, start=c(1,10), pa=0.05, qa=0.01, pb=0.9, qb=0.05)
p=sol$root[1]
q=sol$root[2]
sprintf("Value of p = %f", p)
sprintf("Value of q = %f", q)

# Question 3
x = 6 # Years with snowstorm
n = 150 # Total of years

# theta | x ~ Be(p + x, n + q - x)
x_val = seq(0, 0.1, 0.001)
plot(x_val, dbeta(x_val, p + x, n + q - x), type="l")
lines(x_val, dbeta(x_val, p, q), col="red")

# Question 4
polya = function(x_star, h, p, q, n, x){choose(h, x_star)*beta(x_star+x+p, h-x_star+n-x+q)/beta(x+p, n-x+q)}
x_star = seq(0, 10, 1)
par(mfrow=c(2,2))
for (h in  c(5, 10, 20, 30)){
    plot(x_star, polya(x_star, h, p, q, n, x), type="h")
}

# Question 5
par(mfrow=c(1,1))
h = seq(1,30,0.1)
p_h = 1 - polya(0, h, p, q, n, x)
plot(h, (1-p_h)/p_h, type="l")
abline(6, 0)

# Question 6
p = 1/2
q = 1/2
par(mfrow=c(1,1))
h = seq(1,30,0.1)
p_h = 1 - polya(0, h, p, q, n, x)
plot(h, (1-p_h)/p_h, type="l")
abline(6, 0)


