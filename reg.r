packages <- c("MASS","e1071","caret","neuralnet","glmnet","mltools","data.table","janitor", "corrplot","dplyr","jtools","crs","earth")

install.packages(setdiff(packages, rownames(installed.packages())))  

library(MASS)
library(e1071)
library(caret)
library(neuralnet)
library(glmnet)
library(mltools)
library(data.table)
library(janitor)
library(corrplot)
library(dplyr)
library(jtools)
library(earth)

set.seed(6741)

#####READ FILES#####

ALL <- read.csv(file = "final_partitioned/all.csv")
PROF.PROF <- read.csv(file = "final_partitioned/prof.prof.csv")
PROF.ASC <- read.csv(file = "final_partitioned/prof.asc.csv")
PROF.AST <- read.csv(file = "final_partitioned/prof.ast.csv")
INS <- read.csv(file = "final_partitioned/ins.csv")
LEC <- read.csv(file = "final_partitioned/lec.csv")
FAC <- read.csv(file = "final_partitioned/fac.csv")
GT <- read.csv(file = "final_partitioned/gt.csv")

ALL.I <- read.csv(file = "final_partitioned/all_i.csv")
PROF.PROF.I <- read.csv(file = "final_partitioned/prof.prof_i.csv")
PROF.ASC.I <- read.csv(file = "final_partitioned/prof.asc_i.csv")
PROF.AST.I <- read.csv(file = "final_partitioned/prof.ast_i.csv")
INS.I <- read.csv(file = "final_partitioned/ins_i.csv")
LEC.I <- read.csv(file = "final_partitioned/lec_i.csv")
FAC.I <- read.csv(file = "final_partitioned/fac_i.csv")
GT.I <- read.csv(file = "final_partitioned/gt_i.csv")

#####ONE HOT CATEGORICAL#####
ALL$State <- as.factor(ALL$State)
ALL$Institution <- as.factor(ALL$Institution)
ALL$Race <- as.factor(ALL$Race)
ALL$Gender <- as.factor(ALL$Gender)
ALL$Role <- as.factor(ALL$Role)
ALL <- one_hot(as.data.table(ALL))
ALL <- clean_names(ALL)

ALL.I$State <- as.factor(ALL.I$State)
ALL.I$Institution <- as.factor(ALL.I$Institution)
ALL.I$intersection <- as.factor(ALL.I$intersection)
ALL.I$Role <- as.factor(ALL.I$Role)
ALL.I <- one_hot(as.data.table(ALL.I))
ALL.I <- clean_names(ALL.I)

PROF.PROF$State <- as.factor(PROF.PROF$State)
PROF.PROF$Institution <- as.factor(PROF.PROF$Institution)
PROF.PROF$Race <- as.factor(PROF.PROF$Race)
PROF.PROF$Gender <- as.factor(PROF.PROF$Gender)
PROF.PROF <- one_hot(as.data.table(PROF.PROF))
PROF.PROF <- clean_names(PROF.PROF)

PROF.PROF.I$State <- as.factor(PROF.PROF.I$State)
PROF.PROF.I$Institution <- as.factor(PROF.PROF.I$Institution)
PROF.PROF.I$intersection <- as.factor(PROF.PROF.I$intersection)
PROF.PROF.I <- one_hot(as.data.table(PROF.PROF.I))
PROF.PROF.I <- clean_names(PROF.PROF.I)

PROF.ASC$State <- as.factor(PROF.ASC$State)
PROF.ASC$Institution <- as.factor(PROF.ASC$Institution)
PROF.ASC$Race <- as.factor(PROF.ASC$Race)
PROF.ASC$Gender <- as.factor(PROF.ASC$Gender)
PROF.ASC <- one_hot(as.data.table(PROF.ASC))
PROF.ASC <- clean_names(PROF.ASC)

PROF.ASC.I$State <- as.factor(PROF.ASC.I$State)
PROF.ASC.I$Institution <- as.factor(PROF.ASC.I$Institution)
PROF.ASC.I$intersection <- as.factor(PROF.ASC.I$intersection)
PROF.ASC.I <- one_hot(as.data.table(PROF.ASC.I))
PROF.ASC.I <- clean_names(PROF.ASC.I)

PROF.AST$State <- as.factor(PROF.AST$State)
PROF.AST$Institution <- as.factor(PROF.AST$Institution)
PROF.AST$Race <- as.factor(PROF.AST$Race)
PROF.AST$Gender <- as.factor(PROF.AST$Gender)
PROF.AST <- one_hot(as.data.table(PROF.AST))
PROF.AST <- clean_names(PROF.AST)

PROF.AST.I$State <- as.factor(PROF.AST.I$State)
PROF.AST.I$Institution <- as.factor(PROF.AST.I$Institution)
PROF.AST.I$intersection <- as.factor(PROF.AST.I$intersection)
PROF.AST.I <- one_hot(as.data.table(PROF.AST.I))
PROF.AST.I <- clean_names(PROF.AST.I)

LEC$State <- as.factor(LEC$State)
LEC$Institution <- as.factor(LEC$Institution)
LEC$Race <- as.factor(LEC$Race)
LEC$Gender <- as.factor(LEC$Gender)
LEC <- one_hot(as.data.table(LEC))
LEC <- clean_names(LEC)

LEC.I$State <- as.factor(LEC.I$State)
LEC.I$Institution <- as.factor(LEC.I$Institution)
LEC.I$intersection <- as.factor(LEC.I$intersection)
LEC.I <- one_hot(as.data.table(LEC.I))
LEC.I <- clean_names(LEC.I)

FAC$State <- as.factor(FAC$State)
FAC$Institution <- as.factor(FAC$Institution)
FAC$Race <- as.factor(FAC$Race)
FAC$Gender <- as.factor(FAC$Gender)
FAC <- one_hot(as.data.table(FAC))
FAC <- clean_names(FAC)

FAC.I$State <- as.factor(FAC.I$State)
FAC.I$Institution <- as.factor(FAC.I$Institution)
FAC.I$intersection <- as.factor(FAC.I$intersection)
FAC.I <- one_hot(as.data.table(FAC.I))
FAC.I <- clean_names(FAC.I)

INS$State <- as.factor(INS$State)
INS$Institution <- as.factor(INS$Institution)
INS$Race <- as.factor(INS$Race)
INS$Gender <- as.factor(INS$Gender)
INS <- one_hot(as.data.table(INS))
INS <- clean_names(INS)

INS.I$State <- as.factor(INS.I$State)
INS.I$Institution <- as.factor(INS.I$Institution)
INS.I$intersection <- as.factor(INS.I$intersection)
INS.I <- one_hot(as.data.table(INS.I))
INS.I <- clean_names(INS.I)

GT$Title <- as.factor(GT$Title)
GT$Race <- as.factor(GT$Race)
GT$Gender <- as.factor(GT$Gender)
GT <- one_hot(as.data.table(GT))
GT <- clean_names(GT)

GT.I$Title <- as.factor(GT.I$Title)
GT.I$intersection <- as.factor(GT.I$intersection)
GT.I <- one_hot(as.data.table(GT.I))
GT.I <- clean_names(GT.I)

#####SPLIT TRAINING AND TEST#####

smp_size.ALL <- floor(0.9 * nrow(ALL))
train_ind.ALL <- sample(seq_len(nrow(ALL)), size = smp_size.ALL)
train.ALL <- ALL[train_ind.ALL, ]
test.ALL <- ALL[-train_ind.ALL, ]
train.x.ALL <- subset(train.ALL, select = -salary)
train.y.ALL <- train.ALL$salary
test.x.ALL <- subset(test.ALL, select = -salary)
test.y.ALL <- test.ALL$salary

smp_size.ALL.I <- floor(0.9 * nrow(ALL.I))
train_ind.ALL.I <- sample(seq_len(nrow(ALL.I)), size = smp_size.ALL.I)
train.ALL.I <- ALL.I[train_ind.ALL.I, ]
test.ALL.I <- ALL.I[-train_ind.ALL.I, ]
train.x.ALL.I <- subset(train.ALL.I, select = -salary)
train.y.ALL.I <- train.ALL.I$salary
test.x.ALL.I <- subset(test.ALL.I, select = -salary)
test.y.ALL.I <- test.ALL.I$salary

smp_size.PROF.PROF <- floor(0.9 * nrow(PROF.PROF))
train_ind.PROF.PROF <- sample(seq_len(nrow(PROF.PROF)), size = smp_size.PROF.PROF)
train.PROF.PROF <- PROF.PROF[train_ind.PROF.PROF, ]
test.PROF.PROF <- PROF.PROF[-train_ind.PROF.PROF, ]
train.x.PROF.PROF <- subset(train.PROF.PROF, select = -salary)
train.y.PROF.PROF <- train.PROF.PROF$salary
test.x.PROF.PROF <- subset(test.PROF.PROF, select = -salary)
test.y.PROF.PROF <- test.PROF.PROF$salary

smp_size.PROF.PROF.I <- floor(0.9 * nrow(PROF.PROF.I))
train_ind.PROF.PROF.I <- sample(seq_len(nrow(PROF.PROF.I)), size = smp_size.PROF.PROF.I)
train.PROF.PROF.I <- PROF.PROF.I[train_ind.PROF.PROF.I, ]
test.PROF.PROF.I <- PROF.PROF.I[-train_ind.PROF.PROF.I, ]
train.x.PROF.PROF.I <- subset(train.PROF.PROF.I, select = -salary)
train.y.PROF.PROF.I <- train.PROF.PROF.I$salary
test.x.PROF.PROF.I <- subset(test.PROF.PROF.I, select = -salary)
test.y.PROF.PROF.I <- test.PROF.PROF.I$salary

smp_size.PROF.ASC <- floor(0.9 * nrow(PROF.ASC))
train_ind.PROF.ASC <- sample(seq_len(nrow(PROF.ASC)), size = smp_size.PROF.ASC)
train.PROF.ASC <- PROF.ASC[train_ind.PROF.ASC, ]
test.PROF.ASC <- PROF.ASC[-train_ind.PROF.ASC, ]
train.x.PROF.ASC <- subset(train.PROF.ASC, select = -salary)
train.y.PROF.ASC <- train.PROF.ASC$salary
test.x.PROF.ASC <- subset(test.PROF.ASC, select = -salary)
test.y.PROF.ASC <- test.PROF.ASC$salary

smp_size.PROF.ASC.I <- floor(0.9 * nrow(PROF.ASC.I))
train_ind.PROF.ASC.I <- sample(seq_len(nrow(PROF.ASC.I)), size = smp_size.PROF.ASC.I)
train.PROF.ASC.I <- PROF.ASC.I[train_ind.PROF.ASC.I, ]
test.PROF.ASC.I <- PROF.ASC.I[-train_ind.PROF.ASC.I, ]
train.x.PROF.ASC.I <- subset(train.PROF.ASC.I, select = -salary)
train.y.PROF.ASC.I <- train.PROF.ASC.I$salary
test.x.PROF.ASC.I <- subset(test.PROF.ASC.I, select = -salary)
test.y.PROF.ASC.I <- test.PROF.ASC.I$salary

smp_size.PROF.AST <- floor(0.9 * nrow(PROF.AST))
train_ind.PROF.AST <- sample(seq_len(nrow(PROF.AST)), size = smp_size.PROF.AST)
train.PROF.AST <- PROF.AST[train_ind.PROF.AST, ]
test.PROF.AST <- PROF.AST[-train_ind.PROF.AST, ]
train.x.PROF.AST <- subset(train.PROF.AST, select = -salary)
train.y.PROF.AST <- train.PROF.AST$salary
test.x.PROF.AST <- subset(test.PROF.AST, select = -salary)
test.y.PROF.AST <- test.PROF.AST$salary

smp_size.PROF.AST.I <- floor(0.9 * nrow(PROF.AST.I))
train_ind.PROF.AST.I <- sample(seq_len(nrow(PROF.AST.I)), size = smp_size.PROF.AST.I)
train.PROF.AST.I <- PROF.AST.I[train_ind.PROF.AST.I, ]
test.PROF.AST.I <- PROF.AST.I[-train_ind.PROF.AST.I, ]
train.x.PROF.AST.I <- subset(train.PROF.AST.I, select = -salary)
train.y.PROF.AST.I <- train.PROF.AST.I$salary
test.x.PROF.AST.I <- subset(test.PROF.AST.I, select = -salary)
test.y.PROF.AST.I <- test.PROF.AST.I$salary

smp_size.LEC <- floor(0.9 * nrow(LEC))
train_ind.LEC <- sample(seq_len(nrow(LEC)), size = smp_size.LEC)
train.LEC <- LEC[train_ind.LEC, ]
test.LEC <- LEC[-train_ind.LEC, ]
train.x.LEC <- subset(train.LEC, select = -salary)
train.y.LEC <- train.LEC$salary
test.x.LEC <- subset(test.LEC, select = -salary)
test.y.LEC <- test.LEC$salary

smp_size.LEC.I <- floor(0.9 * nrow(LEC.I))
train_ind.LEC.I <- sample(seq_len(nrow(LEC.I)), size = smp_size.LEC.I)
train.LEC.I <- LEC.I[train_ind.LEC.I, ]
test.LEC.I <- LEC.I[-train_ind.LEC.I, ]
train.x.LEC.I <- subset(train.LEC.I, select = -salary)
train.y.LEC.I <- train.LEC.I$salary
test.x.LEC.I <- subset(test.LEC.I, select = -salary)
test.y.LEC.I <- test.LEC.I$salary

smp_size.FAC <- floor(0.9 * nrow(FAC))
train_ind.FAC <- sample(seq_len(nrow(FAC)), size = smp_size.FAC)
train.FAC <- FAC[train_ind.FAC, ]
test.FAC <- FAC[-train_ind.FAC, ]
train.x.FAC <- subset(train.FAC, seFACt = -salary)
train.y.FAC <- train.FAC$salary
test.x.FAC <- subset(test.FAC, seFACt = -salary)
test.y.FAC <- test.FAC$salary

smp_size.FAC.I <- floor(0.9 * nrow(FAC.I))
train_ind.FAC.I <- sample(seq_len(nrow(FAC.I)), size = smp_size.FAC.I)
train.FAC.I <- FAC.I[train_ind.FAC.I, ]
test.FAC.I <- FAC.I[-train_ind.FAC.I, ]
train.x.FAC.I <- subset(train.FAC.I, seFACt = -salary)
train.y.FAC.I <- train.FAC.I$salary
test.x.FAC.I <- subset(test.FAC.I, seFACt = -salary)
test.y.FAC.I <- test.FAC.I$salary

smp_size.INS <- floor(0.9 * nrow(INS))
train_ind.INS <- sample(seq_len(nrow(INS)), size = smp_size.INS)
train.INS <- INS[train_ind.INS, ]
test.INS <- INS[-train_ind.INS, ]
train.x.INS <- subset(train.INS, seINSt = -salary)
train.y.INS <- train.INS$salary
test.x.INS <- subset(test.INS, seINSt = -salary)
test.y.INS <- test.INS$salary

smp_size.INS.I <- floor(0.9 * nrow(INS.I))
train_ind.INS.I <- sample(seq_len(nrow(INS.I)), size = smp_size.INS.I)
train.INS.I <- INS.I[train_ind.INS.I, ]
test.INS.I <- INS.I[-train_ind.INS.I, ]
train.x.INS.I <- subset(train.INS.I, seINSt = -salary)
train.y.INS.I <- train.INS.I$salary
test.x.INS.I <- subset(test.INS.I, seINSt = -salary)
test.y.INS.I <- test.INS.I$salary

smp_size.GT <- floor(0.9 * nrow(GT))
train_ind.GT <- sample(seq_len(nrow(GT)), size = smp_size.GT)
train.GT <- GT[train_ind.GT, ]
test.GT <- GT[-train_ind.GT, ]
train.x.GT <- subset(train.GT, select = -salary)
train.y.GT <- train.GT$salary
test.x.GT <- subset(test.GT, select = -salary)
test.y.GT <- test.GT$salary

smp_size.GT.I <- floor(0.9 * nrow(GT.I))
train_ind.GT.I <- sample(seq_len(nrow(GT.I)), size = smp_size.GT.I)
train.GT.I <- GT.I[train_ind.GT.I, ]
test.GT.I <- GT.I[-train_ind.GT.I, ]
train.x.GT.I <- subset(train.GT.I, select = -salary)
train.y.GT.I <- train.GT.I$salary
test.x.GT.I <- subset(test.GT.I, select = -salary)
test.y.GT.I <- test.GT.I$salary

#####linear model#####

linear.ALL <- lm(salary ~ ., data = train.ALL)
summary(linear.ALL)
linear.pred.ALL <- predict(linear.ALL, newdata=test.x.ALL)
results.ALL <- data.frame(Method = 'Linear Model', 
                      R2 = R2(linear.pred.ALL, test.y.ALL) , 
                      RMSE = RMSE(linear.pred.ALL, test.y.ALL), 
                      MAE = MAE(linear.pred.ALL, test.y.ALL))

linear.ALL.I <- lm(salary ~ ., data = train.ALL.I)
summary(linear.ALL.I)
linear.pred.ALL.I <- predict(linear.ALL.I, newdata=test.x.ALL.I)
results.ALL.I <- data.frame(Method = 'Linear Model', 
                         R2 = R2(linear.pred.ALL.I, test.y.ALL.I) , 
                         RMSE = RMSE(linear.pred.ALL.I, test.y.ALL.I), 
                         MAE = MAE(linear.pred.ALL.I, test.y.ALL.I))

linear.PROF.PROF <- lm(salary ~ ., data = train.PROF.PROF)
summary(linear.PROF.PROF)
linear.pred.PROF.PROF <- predict(linear.PROF.PROF, newdata=test.x.PROF.PROF)
results.PROF.PROF <- data.frame(Method = 'Linear Model', 
                                R2 = R2(linear.pred.PROF.PROF, test.y.PROF.PROF) , 
                                RMSE = RMSE(linear.pred.PROF.PROF, test.y.PROF.PROF), 
                                MAE = MAE(linear.pred.PROF.PROF, test.y.PROF.PROF))

linear.PROF.PROF.I <- lm(salary ~ ., data = train.PROF.PROF.I)
summary(linear.PROF.PROF.I)
linear.pred.PROF.PROF.I <- predict(linear.PROF.PROF.I, newdata=test.x.PROF.PROF.I)
results.PROF.PROF.I <- data.frame(Method = 'Linear Model', 
                                  R2 = R2(linear.pred.PROF.PROF.I, test.y.PROF.PROF.I) , 
                                  RMSE = RMSE(linear.pred.PROF.PROF.I, test.y.PROF.PROF.I), 
                                  MAE = MAE(linear.pred.PROF.PROF.I, test.y.PROF.PROF.I))

linear.PROF.ASC <- lm(salary ~ ., data = train.PROF.ASC)
summary(linear.PROF.ASC)
linear.pred.PROF.ASC <- predict(linear.PROF.ASC, newdata=test.x.PROF.ASC)
results.PROF.ASC <- data.frame(Method = 'Linear Model', 
                               R2 = R2(linear.pred.PROF.ASC, test.y.PROF.ASC) , 
                               RMSE = RMSE(linear.pred.PROF.ASC, test.y.PROF.ASC), 
                               MAE = MAE(linear.pred.PROF.ASC, test.y.PROF.ASC))

linear.PROF.ASC.I <- lm(salary ~ ., data = train.PROF.ASC.I)
summary(linear.PROF.ASC.I)
linear.pred.PROF.ASC.I <- predict(linear.PROF.ASC.I, newdata=test.x.PROF.ASC.I)
results.PROF.ASC.I <- data.frame(Method = 'Linear Model', 
                                 R2 = R2(linear.pred.PROF.ASC.I, test.y.PROF.ASC.I) , 
                                 RMSE = RMSE(linear.pred.PROF.ASC.I, test.y.PROF.ASC.I), 
                                 MAE = MAE(linear.pred.PROF.ASC.I, test.y.PROF.ASC.I))

linear.PROF.AST <- lm(salary ~ ., data = train.PROF.AST)
summary(linear.PROF.AST)
linear.pred.PROF.AST <- predict(linear.PROF.AST, newdata=test.x.PROF.AST)
results.PROF.AST <- data.frame(Method = 'Linear Model', 
                               R2 = R2(linear.pred.PROF.AST, test.y.PROF.AST) , 
                               RMSE = RMSE(linear.pred.PROF.AST, test.y.PROF.AST), 
                               MAE = MAE(linear.pred.PROF.AST, test.y.PROF.AST))

linear.PROF.AST.I <- lm(salary ~ ., data = train.PROF.AST.I)
summary(linear.PROF.AST.I)
linear.pred.PROF.AST.I <- predict(linear.PROF.AST.I, newdata=test.x.PROF.AST.I)
results.PROF.AST.I <- data.frame(Method = 'Linear Model', 
                                 R2 = R2(linear.pred.PROF.AST.I, test.y.PROF.AST.I) , 
                                 RMSE = RMSE(linear.pred.PROF.AST.I, test.y.PROF.AST.I), 
                                 MAE = MAE(linear.pred.PROF.AST.I, test.y.PROF.AST.I))

linear.LEC <- lm(salary ~ ., data = train.LEC)
summary(linear.LEC)
linear.pred.LEC <- predict(linear.LEC, newdata=test.x.LEC)
results.LEC <- data.frame(Method = 'Linear Model', 
                          R2 = R2(linear.pred.LEC, test.y.LEC) , 
                          RMSE = RMSE(linear.pred.LEC, test.y.LEC), 
                          MAE = MAE(linear.pred.LEC, test.y.LEC))

linear.LEC.I <- lm(salary ~ ., data = train.LEC.I)
summary(linear.LEC.I)
linear.pred.LEC.I <- predict(linear.LEC.I, newdata=test.x.LEC.I)
results.LEC.I <- data.frame(Method = 'Linear Model', 
                            R2 = R2(linear.pred.LEC.I, test.y.LEC.I) , 
                            RMSE = RMSE(linear.pred.LEC.I, test.y.LEC.I), 
                            MAE = MAE(linear.pred.LEC.I, test.y.LEC.I))

linear.FAC <- lm(salary ~ ., data = train.FAC)
summary(linear.FAC)
linear.pred.FAC <- predict(linear.FAC, newdata=test.x.FAC)
results.FAC <- data.frame(Method = 'Linear Model', 
                          R2 = R2(linear.pred.FAC, test.y.FAC) , 
                          RMSE = RMSE(linear.pred.FAC, test.y.FAC), 
                          MAE = MAE(linear.pred.FAC, test.y.FAC))

linear.FAC.I <- lm(salary ~ ., data = train.FAC.I)
summary(linear.FAC.I)
linear.pred.FAC.I <- predict(linear.FAC.I, newdata=test.x.FAC.I)
results.FAC.I <- data.frame(Method = 'Linear Model', 
                            R2 = R2(linear.pred.FAC.I, test.y.FAC.I) , 
                            RMSE = RMSE(linear.pred.FAC.I, test.y.FAC.I), 
                            MAE = MAE(linear.pred.FAC.I, test.y.FAC.I))

linear.INS <- lm(salary ~ ., data = train.INS)
summary(linear.INS)
linear.pred.INS <- predict(linear.INS, newdata=test.x.INS)
results.INS <- data.frame(Method = 'Linear Model', 
                          R2 = R2(linear.pred.INS, test.y.INS) , 
                          RMSE = RMSE(linear.pred.INS, test.y.INS), 
                          MAE = MAE(linear.pred.INS, test.y.INS))

linear.INS.I <- lm(salary ~ ., data = train.INS.I)
summary(linear.INS.I)
linear.pred.INS.I <- predict(linear.INS.I, newdata=test.x.INS.I)
results.INS.I <- data.frame(Method = 'Linear Model', 
                            R2 = R2(linear.pred.INS.I, test.y.INS.I) , 
                            RMSE = RMSE(linear.pred.INS.I, test.y.INS.I), 
                            MAE = MAE(linear.pred.INS.I, test.y.INS.I))

linear.GT <- lm(salary ~ ., data = train.GT)
summary(linear.GT)
linear.pred.GT <- predict(linear.GT, newdata=test.x.GT)
results.GT <- data.frame(Method = 'Linear Model', 
                         R2 = R2(linear.pred.GT, test.y.GT) , 
                         RMSE = RMSE(linear.pred.GT, test.y.GT), 
                         MAE = MAE(linear.pred.GT, test.y.GT))

linear.GT.I <- lm(salary ~ ., data = train.GT.I)
summary(linear.GT.I)
linear.pred.GT.I <- predict(linear.GT.I, newdata=test.x.GT.I)
results.GT.I <- data.frame(Method = 'Linear Model', 
                         R2 = R2(linear.pred.GT.I, test.y.GT.I) , 
                         RMSE = RMSE(linear.pred.GT.I, test.y.GT.I), 
                         MAE = MAE(linear.pred.GT.I, test.y.GT.I))

#####MARS#####

mars.ALL <- earth(salary ~ ., data = train.ALL)
mars.pred.ALL <- predict(mars.ALL, newdata=test.x.ALL)
results.ALL[nrow(results.ALL) + 1,] <- c("MARS",
                                 R2(mars.pred.ALL, test.y.ALL),
                                 RMSE(mars.pred.ALL, test.y.ALL),
                                 MAE(mars.pred.ALL, test.y.ALL))

mars.ALL.I <- earth(salary ~ ., data = train.ALL.I)
mars.pred.ALL.I <- predict(mars.ALL.I, newdata=test.x.ALL.I)
results.ALL.I[nrow(results.ALL.I) + 1,] <- c("MARS",
                                       R2(mars.pred.ALL.I, test.y.ALL.I),
                                       RMSE(mars.pred.ALL.I, test.y.ALL.I),
                                       MAE(mars.pred.ALL.I, test.y.ALL.I))

mars.PROF.PROF <- earth(salary ~ ., data = train.PROF.PROF)
mars.pred.PROF.PROF <- predict(mars.PROF.PROF, newdata=test.x.PROF.PROF)
results.PROF.PROF[nrow(results.PROF.PROF) + 1,] <- c("MARS",
                                                     R2(mars.pred.PROF.PROF, test.y.PROF.PROF),
                                                     RMSE(mars.pred.PROF.PROF, test.y.PROF.PROF),
                                                     MAE(mars.pred.PROF.PROF, test.y.PROF.PROF))

mars.PROF.PROF.I <- earth(salary ~ ., data = train.PROF.PROF.I)
mars.pred.PROF.PROF.I <- predict(mars.PROF.PROF.I, newdata=test.x.PROF.PROF.I)
results.PROF.PROF.I[nrow(results.PROF.PROF.I) + 1,] <- c("MARS",
                                                         R2(mars.pred.PROF.PROF.I, test.y.PROF.PROF.I),
                                                         RMSE(mars.pred.PROF.PROF.I, test.y.PROF.PROF.I),
                                                         MAE(mars.pred.PROF.PROF.I, test.y.PROF.PROF.I))

mars.PROF.ASC <- earth(salary ~ ., data = train.PROF.ASC)
mars.pred.PROF.ASC <- predict(mars.PROF.ASC, newdata=test.x.PROF.ASC)
results.PROF.ASC[nrow(results.PROF.ASC) + 1,] <- c("MARS",
                                                   R2(mars.pred.PROF.ASC, test.y.PROF.ASC),
                                                   RMSE(mars.pred.PROF.ASC, test.y.PROF.ASC),
                                                   MAE(mars.pred.PROF.ASC, test.y.PROF.ASC))

mars.PROF.ASC.I <- earth(salary ~ ., data = train.PROF.ASC.I)
mars.pred.PROF.ASC.I <- predict(mars.PROF.ASC.I, newdata=test.x.PROF.ASC.I)
results.PROF.ASC.I[nrow(results.PROF.ASC.I) + 1,] <- c("MARS",
                                                       R2(mars.pred.PROF.ASC.I, test.y.PROF.ASC.I),
                                                       RMSE(mars.pred.PROF.ASC.I, test.y.PROF.ASC.I),
                                                       MAE(mars.pred.PROF.ASC.I, test.y.PROF.ASC.I))

mars.PROF.AST <- earth(salary ~ ., data = train.PROF.AST)
mars.pred.PROF.AST <- predict(mars.PROF.AST, newdata=test.x.PROF.AST)
results.PROF.AST[nrow(results.PROF.AST) + 1,] <- c("MARS",
                                                   R2(mars.pred.PROF.AST, test.y.PROF.AST),
                                                   RMSE(mars.pred.PROF.AST, test.y.PROF.AST),
                                                   MAE(mars.pred.PROF.AST, test.y.PROF.AST))

mars.PROF.AST.I <- earth(salary ~ ., data = train.PROF.AST.I)
mars.pred.PROF.AST.I <- predict(mars.PROF.AST.I, newdata=test.x.PROF.AST.I)
results.PROF.AST.I[nrow(results.PROF.AST.I) + 1,] <- c("MARS",
                                                       R2(mars.pred.PROF.AST.I, test.y.PROF.AST.I),
                                                       RMSE(mars.pred.PROF.AST.I, test.y.PROF.AST.I),
                                                       MAE(mars.pred.PROF.AST.I, test.y.PROF.AST.I))

mars.LEC <- earth(salary ~ ., data = train.LEC)
mars.pred.LEC <- predict(mars.LEC, newdata=test.x.LEC)
results.LEC[nrow(results.LEC) + 1,] <- c("MARS",
                                         R2(mars.pred.LEC, test.y.LEC),
                                         RMSE(mars.pred.LEC, test.y.LEC),
                                         MAE(mars.pred.LEC, test.y.LEC))

mars.LEC.I <- earth(salary ~ ., data = train.LEC.I)
mars.pred.LEC.I <- predict(mars.LEC.I, newdata=test.x.LEC.I)
results.LEC.I[nrow(results.LEC.I) + 1,] <- c("MARS",
                                             R2(mars.pred.LEC.I, test.y.LEC.I),
                                             RMSE(mars.pred.LEC.I, test.y.LEC.I),
                                             MAE(mars.pred.LEC.I, test.y.LEC.I))

mars.FAC <- earth(salary ~ ., data = train.FAC)
mars.pred.FAC <- predict(mars.FAC, newdata=test.x.FAC)
results.FAC[nrow(results.FAC) + 1,] <- c("MARS",
                                         R2(mars.pred.FAC, test.y.FAC),
                                         RMSE(mars.pred.FAC, test.y.FAC),
                                         MAE(mars.pred.FAC, test.y.FAC))

mars.FAC.I <- earth(salary ~ ., data = train.FAC.I)
mars.pred.FAC.I <- predict(mars.FAC.I, newdata=test.x.FAC.I)
results.FAC.I[nrow(results.FAC.I) + 1,] <- c("MARS",
                                             R2(mars.pred.FAC.I, test.y.FAC.I),
                                             RMSE(mars.pred.FAC.I, test.y.FAC.I),
                                             MAE(mars.pred.FAC.I, test.y.FAC.I))

mars.INS <- earth(salary ~ ., data = train.INS)
mars.pred.INS <- predict(mars.INS, newdata=test.x.INS)
results.INS[nrow(results.INS) + 1,] <- c("MARS",
                                         R2(mars.pred.INS, test.y.INS),
                                         RMSE(mars.pred.INS, test.y.INS),
                                         MAE(mars.pred.INS, test.y.INS))

mars.INS.I <- earth(salary ~ ., data = train.INS.I)
mars.pred.INS.I <- predict(mars.INS.I, newdata=test.x.INS.I)
results.INS.I[nrow(results.INS.I) + 1,] <- c("MARS",
                                             R2(mars.pred.INS.I, test.y.INS.I),
                                             RMSE(mars.pred.INS.I, test.y.INS.I),
                                             MAE(mars.pred.INS.I, test.y.INS.I))

mars.GT <- earth(salary ~ ., data = train.GT)
mars.pred.GT <- predict(mars.GT, newdata=test.x.GT)
results.GT[nrow(results.GT) + 1,] <- c("MARS",
                                       R2(mars.pred.GT, test.y.GT),
                                       RMSE(mars.pred.GT, test.y.GT),
                                       MAE(mars.pred.GT, test.y.GT))

mars.GT.I <- earth(salary ~ ., data = train.GT.I)
mars.pred.GT.I <- predict(mars.GT.I, newdata=test.x.GT.I)
results.GT.I[nrow(results.GT.I) + 1,] <- c("MARS",
                                       R2(mars.pred.GT.I, test.y.GT.I),
                                       RMSE(mars.pred.GT.I, test.y.GT.I),
                                       MAE(mars.pred.GT.I, test.y.GT.I))
#####SVM#####

# svm.ALL <- svm(salary ~ ., data=train.ALL)
# summary(svm.ALL)
# svm.pred.ALL <- predict(svm.ALL, test.x.ALL)
# results.ALL[nrow(results.ALL) + 1,] <- c("Support Vector Regression",
#                                  R2(svm.pred.ALL, test.y.ALL),
#                                  RMSE(svm.pred.ALL, test.y.ALL),
#                                  MAE(svm.pred.ALL, test.y.ALL))
# 
# svm.ALL.I <- svm(salary ~ ., data=train.ALL.I)
# summary(svm.ALL.I)
# svm.pred.ALL.I <- predict(svm.ALL.I, test.x.ALL.I)
# results.ALL.I[nrow(results.ALL.I) + 1,] <- c("Support Vector Regression",
#                                  R2(svm.pred.ALL.I, test.y.ALL.I),
#                                  RMSE(svm.pred.ALL.I, test.y.ALL.I),
#                                  MAE(svm.pred.ALL.I, test.y.ALL.I))
# 
svm.PROF.PROF <- svm(salary ~ ., data=train.PROF.PROF)
summary(svm.PROF.PROF)
svm.pred.PROF.PROF <- predict(svm.PROF.PROF, test.x.PROF.PROF)
results.PROF.PROF[nrow(results.PROF.PROF) + 1,] <- c("Support Vector Regression",
                                                     R2(svm.pred.PROF.PROF, test.y.PROF.PROF),
                                                     RMSE(svm.pred.PROF.PROF, test.y.PROF.PROF),
                                                     MAE(svm.pred.PROF.PROF, test.y.PROF.PROF))

svm.PROF.PROF.I <- svm(salary ~ ., data=train.PROF.PROF.I)
summary(svm.PROF.PROF.I)
svm.pred.PROF.PROF.I <- predict(svm.PROF.PROF.I, test.x.PROF.PROF.I)
results.PROF.PROF.I[nrow(results.PROF.PROF.I) + 1,] <- c("Support Vector Regression",
                                                         R2(svm.pred.PROF.PROF.I, test.y.PROF.PROF.I),
                                                         RMSE(svm.pred.PROF.PROF.I, test.y.PROF.PROF.I),
                                                         MAE(svm.pred.PROF.PROF.I, test.y.PROF.PROF.I))

svm.PROF.ASC <- svm(salary ~ ., data=train.PROF.ASC)
summary(svm.PROF.ASC)
svm.pred.PROF.ASC <- predict(svm.PROF.ASC, test.x.PROF.ASC)
results.PROF.ASC[nrow(results.PROF.ASC) + 1,] <- c("Support Vector Regression",
                                                   R2(svm.pred.PROF.ASC, test.y.PROF.ASC),
                                                   RMSE(svm.pred.PROF.ASC, test.y.PROF.ASC),
                                                   MAE(svm.pred.PROF.ASC, test.y.PROF.ASC))

svm.PROF.ASC.I <- svm(salary ~ ., data=train.PROF.ASC.I)
summary(svm.PROF.ASC.I)
svm.pred.PROF.ASC.I <- predict(svm.PROF.ASC.I, test.x.PROF.ASC.I)
results.PROF.ASC.I[nrow(results.PROF.ASC.I) + 1,] <- c("Support Vector Regression",
                                                       R2(svm.pred.PROF.ASC.I, test.y.PROF.ASC.I),
                                                       RMSE(svm.pred.PROF.ASC.I, test.y.PROF.ASC.I),
                                                       MAE(svm.pred.PROF.ASC.I, test.y.PROF.ASC.I))

svm.PROF.AST <- svm(salary ~ ., data=train.PROF.AST)
summary(svm.PROF.AST)
svm.pred.PROF.AST <- predict(svm.PROF.AST, test.x.PROF.AST)
results.PROF.AST[nrow(results.PROF.AST) + 1,] <- c("Support Vector Regression",
                                                   R2(svm.pred.PROF.AST, test.y.PROF.AST),
                                                   RMSE(svm.pred.PROF.AST, test.y.PROF.AST),
                                                   MAE(svm.pred.PROF.AST, test.y.PROF.AST))

svm.PROF.AST.I <- svm(salary ~ ., data=train.PROF.AST.I)
summary(svm.PROF.AST.I)
svm.pred.PROF.AST.I <- predict(svm.PROF.AST.I, test.x.PROF.AST.I)
results.PROF.AST.I[nrow(results.PROF.AST.I) + 1,] <- c("Support Vector Regression",
                                                       R2(svm.pred.PROF.AST.I, test.y.PROF.AST.I),
                                                       RMSE(svm.pred.PROF.AST.I, test.y.PROF.AST.I),
                                                       MAE(svm.pred.PROF.AST.I, test.y.PROF.AST.I))

# svm.LEC <- svm(salary ~ ., data=train.LEC)
# summary(svm.LEC)
# svm.pred.LEC <- predict(svm.LEC, test.x.LEC)
# results.LEC[nrow(results.LEC) + 1,] <- c("Support Vector Regression",
#                                          R2(svm.pred.LEC, test.y.LEC),
#                                          RMSE(svm.pred.LEC, test.y.LEC),
#                                          MAE(svm.pred.LEC, test.y.LEC))
# 
# svm.LEC.I <- svm(salary ~ ., data=train.LEC.I)
# summary(svm.LEC.I)
# svm.pred.LEC.I <- predict(svm.LEC.I, test.x.LEC.I)
# results.LEC.I[nrow(results.LEC.I) + 1,] <- c("Support Vector Regression",
#                                              R2(svm.pred.LEC.I, test.y.LEC.I),
#                                              RMSE(svm.pred.LEC.I, test.y.LEC.I),
#                                              MAE(svm.pred.LEC.I, test.y.LEC.I))

svm.FAC <- svm(salary ~ ., data=train.FAC)
summary(svm.FAC)
svm.pred.FAC <- predict(svm.FAC, test.x.FAC)
results.FAC[nrow(results.FAC) + 1,] <- c("Support Vector Regression",
                                         R2(svm.pred.FAC, test.y.FAC),
                                         RMSE(svm.pred.FAC, test.y.FAC),
                                         MAE(svm.pred.FAC, test.y.FAC))

svm.FAC.I <- svm(salary ~ ., data=train.FAC.I)
summary(svm.FAC.I)
svm.pred.FAC.I <- predict(svm.FAC.I, test.x.FAC.I)
results.FAC.I[nrow(results.FAC.I) + 1,] <- c("Support Vector Regression",
                                             R2(svm.pred.FAC.I, test.y.FAC.I),
                                             RMSE(svm.pred.FAC.I, test.y.FAC.I),
                                             MAE(svm.pred.FAC.I, test.y.FAC.I))

svm.INS <- svm(salary ~ ., data=train.INS)
summary(svm.INS)
svm.pred.INS <- predict(svm.INS, test.x.INS)
results.INS[nrow(results.INS) + 1,] <- c("Support Vector Regression",
                                         R2(svm.pred.INS, test.y.INS),
                                         RMSE(svm.pred.INS, test.y.INS),
                                         MAE(svm.pred.INS, test.y.INS))

svm.INS.I <- svm(salary ~ ., data=train.INS.I)
summary(svm.INS.I)
svm.pred.INS.I <- predict(svm.INS.I, test.x.INS.I)
results.INS.I[nrow(results.INS.I) + 1,] <- c("Support Vector Regression",
                                             R2(svm.pred.INS.I, test.y.INS.I),
                                             RMSE(svm.pred.INS.I, test.y.INS.I),
                                             MAE(svm.pred.INS.I, test.y.INS.I))

svm.GT <- svm(salary ~ ., data=train.GT)
summary(svm.GT)
svm.pred.GT <- predict(svm.GT, test.x.GT)
results.GT[nrow(results.GT) + 1,] <- c("Support Vector Regression",
                                    R2(svm.pred.GT, test.y.GT),
                                    RMSE(svm.pred.GT, test.y.GT),
                                    MAE(svm.pred.GT, test.y.GT))

svm.GT.I <- svm(salary ~ ., data=train.GT.I)
summary(svm.GT.I)
svm.pred.GT.I <- predict(svm.GT.I, test.x.GT.I)
results.GT.I[nrow(results.GT.I) + 1,] <- c("Support Vector Regression",
                                    R2(svm.pred.GT.I, test.y.GT.I),
                                    RMSE(svm.pred.GT.I, test.y.GT.I),
                                    MAE(svm.pred.GT.I, test.y.GT.I))

#####logistic#####

train.ALL$salary <- (train.ALL$salary- min(train.ALL$salary))/(max(train.ALL$salary) - min(train.ALL$salary))
train.ALL.I$salary <- (train.ALL.I$salary- min(train.ALL.I$salary))/(max(train.ALL.I$salary) - min(train.ALL.I$salary))
train.PROF.PROF$salary <- (train.PROF.PROF$salary- min(train.PROF.PROF$salary))/(max(train.PROF.PROF$salary) - min(train.PROF.PROF$salary))
train.PROF.PROF.I$salary <- (train.PROF.PROF.I$salary- min(train.PROF.PROF.I$salary))/(max(train.PROF.PROF.I$salary) - min(train.PROF.PROF.I$salary))
train.PROF.ASC$salary <- (train.PROF.ASC$salary- min(train.PROF.ASC$salary))/(max(train.PROF.ASC$salary) - min(train.PROF.ASC$salary))
train.PROF.ASC.I$salary <- (train.PROF.ASC.I$salary- min(train.PROF.ASC.I$salary))/(max(train.PROF.ASC.I$salary) - min(train.PROF.ASC.I$salary))
train.PROF.AST$salary <- (train.PROF.AST$salary- min(train.PROF.AST$salary))/(max(train.PROF.AST$salary) - min(train.PROF.AST$salary))
train.PROF.AST.I$salary <- (train.PROF.AST.I$salary- min(train.PROF.AST.I$salary))/(max(train.PROF.AST.I$salary) - min(train.PROF.AST.I$salary))
train.LEC$salary <- (train.LEC$salary- min(train.LEC$salary))/(max(train.LEC$salary) - min(train.LEC$salary))
train.LEC.I$salary <- (train.LEC.I$salary- min(train.LEC.I$salary))/(max(train.LEC.I$salary) - min(train.LEC.I$salary))
train.FAC$salary <- (train.FAC$salary- min(train.FAC$salary))/(max(train.FAC$salary) - min(train.FAC$salary))
train.FAC.I$salary <- (train.FAC.I$salary- min(train.FAC.I$salary))/(max(train.FAC.I$salary) - min(train.FAC.I$salary))
train.INS$salary <- (train.INS$salary- min(train.INS$salary))/(max(train.INS$salary) - min(train.INS$salary))
train.INS.I$salary <- (train.INS.I$salary- min(train.INS.I$salary))/(max(train.INS.I$salary) - min(train.INS.I$salary))
train.GT$salary <- (train.GT$salary- min(train.GT$salary))/(max(train.GT$salary) - min(train.GT$salary))
train.GT.I$salary <- (train.GT.I$salary- min(train.GT.I$salary))/(max(train.GT.I$salary) - min(train.GT.I$salary))

test.y.ALL <- (test.y.ALL- min(test.y.ALL))/(max(test.y.ALL) - min(test.y.ALL))
test.y.ALL.I <- (test.y.ALL.I- min(test.y.ALL.I))/(max(test.y.ALL.I) - min(test.y.ALL.I))
test.y.PROF.PROF <- (test.y.PROF.PROF- min(test.y.PROF.PROF))/(max(test.y.PROF.PROF) - min(test.y.PROF.PROF))
test.y.PROF.PROF.I <- (test.y.PROF.PROF.I- min(test.y.PROF.PROF.I))/(max(test.y.PROF.PROF.I) - min(test.y.PROF.PROF.I))
test.y.PROF.ASC <- (test.y.PROF.ASC- min(test.y.PROF.ASC))/(max(test.y.PROF.ASC) - min(test.y.PROF.ASC))
test.y.PROF.ASC.I <- (test.y.PROF.ASC.I- min(test.y.PROF.ASC.I))/(max(test.y.PROF.ASC.I) - min(test.y.PROF.ASC.I))
test.y.PROF.AST <- (test.y.PROF.AST- min(test.y.PROF.AST))/(max(test.y.PROF.AST) - min(test.y.PROF.AST))
test.y.PROF.AST.I <- (test.y.PROF.AST.I- min(test.y.PROF.AST.I))/(max(test.y.PROF.AST.I) - min(test.y.PROF.AST.I))
test.y.LEC <- (test.y.LEC- min(test.y.LEC))/(max(test.y.LEC) - min(test.y.LEC))
test.y.LEC.I <- (test.y.LEC.I- min(test.y.LEC.I))/(max(test.y.LEC.I) - min(test.y.LEC.I))
test.y.FAC <- (test.y.FAC- min(test.y.FAC))/(max(test.y.FAC) - min(test.y.FAC))
test.y.FAC.I <- (test.y.FAC.I- min(test.y.FAC.I))/(max(test.y.FAC.I) - min(test.y.FAC.I))
test.y.INS <- (test.y.INS- min(test.y.INS))/(max(test.y.INS) - min(test.y.INS))
test.y.INS.I <- (test.y.INS.I- min(test.y.INS.I))/(max(test.y.INS.I) - min(test.y.INS.I))
test.y.GT <- (test.y.GT- min(test.y.GT))/(max(test.y.GT) - min(test.y.GT))
test.y.GT.I <- (test.y.GT.I- min(test.y.GT.I))/(max(test.y.GT.I) - min(test.y.GT.I))

log.ALL <- glm(salary~., data = train.ALL, family='binomial')
summary(log.ALL)
log.pred.ALL <- predict(log.ALL, test.x.ALL)
results.ALL[nrow(results.ALL) + 1,] <- c("Logistic Regression",
                                 R2(log.pred.ALL, test.y.ALL),
                                 RMSE(log.pred.ALL, test.y.ALL),
                                 MAE(log.pred.ALL, test.y.ALL))

log.ALL.I <- glm(salary~., data = train.ALL.I, family='binomial')
summary(log.ALL.I)
log.pred.ALL.I <- predict(log.ALL.I, test.x.ALL.I)
results.ALL.I[nrow(results.ALL.I) + 1,] <- c("Logistic Regression",
                                       R2(log.pred.ALL.I, test.y.ALL.I),
                                       RMSE(log.pred.ALL.I, test.y.ALL.I),
                                       MAE(log.pred.ALL.I, test.y.ALL.I))

log.PROF.PROF <- glm(salary~., data = train.PROF.PROF, family='binomial')
summary(log.PROF.PROF)
log.pred.PROF.PROF <- predict(log.PROF.PROF, test.x.PROF.PROF)
results.PROF.PROF[nrow(results.PROF.PROF) + 1,] <- c("Logistic Regression",
                                                     R2(log.pred.PROF.PROF, test.y.PROF.PROF),
                                                     RMSE(log.pred.PROF.PROF, test.y.PROF.PROF),
                                                     MAE(log.pred.PROF.PROF, test.y.PROF.PROF))

log.PROF.PROF.I <- glm(salary~., data = train.PROF.PROF.I, family='binomial')
summary(log.PROF.PROF.I)
log.pred.PROF.PROF.I <- predict(log.PROF.PROF.I, test.x.PROF.PROF.I)
results.PROF.PROF.I[nrow(results.PROF.PROF.I) + 1,] <- c("Logistic Regression",
                                                         R2(log.pred.PROF.PROF.I, test.y.PROF.PROF.I),
                                                         RMSE(log.pred.PROF.PROF.I, test.y.PROF.PROF.I),
                                                         MAE(log.pred.PROF.PROF.I, test.y.PROF.PROF.I))

log.PROF.ASC <- glm(salary~., data = train.PROF.ASC, family='binomial')
summary(log.PROF.ASC)
log.pred.PROF.ASC <- predict(log.PROF.ASC, test.x.PROF.ASC)
results.PROF.ASC[nrow(results.PROF.ASC) + 1,] <- c("Logistic Regression",
                                                   R2(log.pred.PROF.ASC, test.y.PROF.ASC),
                                                   RMSE(log.pred.PROF.ASC, test.y.PROF.ASC),
                                                   MAE(log.pred.PROF.ASC, test.y.PROF.ASC))

log.PROF.ASC.I <- glm(salary~., data = train.PROF.ASC.I, family='binomial')
summary(log.PROF.ASC.I)
log.pred.PROF.ASC.I <- predict(log.PROF.ASC.I, test.x.PROF.ASC.I)
results.PROF.ASC.I[nrow(results.PROF.ASC.I) + 1,] <- c("Logistic Regression",
                                                       R2(log.pred.PROF.ASC.I, test.y.PROF.ASC.I),
                                                       RMSE(log.pred.PROF.ASC.I, test.y.PROF.ASC.I),
                                                       MAE(log.pred.PROF.ASC.I, test.y.PROF.ASC.I))

log.PROF.AST <- glm(salary~., data = train.PROF.AST, family='binomial')
summary(log.PROF.AST)
log.pred.PROF.AST <- predict(log.PROF.AST, test.x.PROF.AST)
results.PROF.AST[nrow(results.PROF.AST) + 1,] <- c("Logistic Regression",
                                                   R2(log.pred.PROF.AST, test.y.PROF.AST),
                                                   RMSE(log.pred.PROF.AST, test.y.PROF.AST),
                                                   MAE(log.pred.PROF.AST, test.y.PROF.AST))

log.PROF.AST.I <- glm(salary~., data = train.PROF.AST.I, family='binomial')
summary(log.PROF.AST.I)
log.pred.PROF.AST.I <- predict(log.PROF.AST.I, test.x.PROF.AST.I)
results.PROF.AST.I[nrow(results.PROF.AST.I) + 1,] <- c("Logistic Regression",
                                                       R2(log.pred.PROF.AST.I, test.y.PROF.AST.I),
                                                       RMSE(log.pred.PROF.AST.I, test.y.PROF.AST.I),
                                                       MAE(log.pred.PROF.AST.I, test.y.PROF.AST.I))

log.LEC <- glm(salary~., data = train.LEC, family='binomial')
summary(log.LEC)
log.pred.LEC <- predict(log.LEC, test.x.LEC)
results.LEC[nrow(results.LEC) + 1,] <- c("Logistic Regression",
                                         R2(log.pred.LEC, test.y.LEC),
                                         RMSE(log.pred.LEC, test.y.LEC),
                                         MAE(log.pred.LEC, test.y.LEC))

log.LEC.I <- glm(salary~., data = train.LEC.I, family='binomial')
summary(log.LEC.I)
log.pred.LEC.I <- predict(log.LEC.I, test.x.LEC.I)
results.LEC.I[nrow(results.LEC.I) + 1,] <- c("Logistic Regression",
                                             R2(log.pred.LEC.I, test.y.LEC.I),
                                             RMSE(log.pred.LEC.I, test.y.LEC.I),
                                             MAE(log.pred.LEC.I, test.y.LEC.I))

log.FAC <- glm(salary~., data = train.FAC, family='binomial')
summary(log.FAC)
log.pred.FAC <- predict(log.FAC, test.x.FAC)
results.FAC[nrow(results.FAC) + 1,] <- c("Logistic Regression",
                                         R2(log.pred.FAC, test.y.FAC),
                                         RMSE(log.pred.FAC, test.y.FAC),
                                         MAE(log.pred.FAC, test.y.FAC))

log.FAC.I <- glm(salary~., data = train.FAC.I, family='binomial')
summary(log.FAC.I)
log.pred.FAC.I <- predict(log.FAC.I, test.x.FAC.I)
results.FAC.I[nrow(results.FAC.I) + 1,] <- c("Logistic Regression",
                                             R2(log.pred.FAC.I, test.y.FAC.I),
                                             RMSE(log.pred.FAC.I, test.y.FAC.I),
                                             MAE(log.pred.FAC.I, test.y.FAC.I))

log.INS <- glm(salary~., data = train.INS, family='binomial')
summary(log.INS)
log.pred.INS <- predict(log.INS, test.x.INS)
results.INS[nrow(results.INS) + 1,] <- c("Logistic Regression",
                                         R2(log.pred.INS, test.y.INS),
                                         RMSE(log.pred.INS, test.y.INS),
                                         MAE(log.pred.INS, test.y.INS))

log.INS.I <- glm(salary~., data = train.INS.I, family='binomial')
summary(log.INS.I)
log.pred.INS.I <- predict(log.INS.I, test.x.INS.I)
results.INS.I[nrow(results.INS.I) + 1,] <- c("Logistic Regression",
                                             R2(log.pred.INS.I, test.y.INS.I),
                                             RMSE(log.pred.INS.I, test.y.INS.I),
                                             MAE(log.pred.INS.I, test.y.INS.I))

log.GT <- glm(salary~., data = train.GT, family='binomial')
summary(log.GT)
log.pred.GT <- predict(log.GT, test.x.GT)
results.GT[nrow(results.GT) + 1,] <- c("Logistic Regression",
                                       R2(log.pred.GT, test.y.GT),
                                       RMSE(log.pred.GT, test.y.GT),
                                       MAE(log.pred.GT, test.y.GT))

log.GT.I <- glm(salary~., data = train.GT.I, family='binomial')
summary(log.GT.I)
log.pred.GT.I <- predict(log.GT.I, test.x.GT.I)
results.GT.I[nrow(results.GT.I) + 1,] <- c("Logistic Regression",
                                       R2(log.pred.GT.I, test.y.GT.I),
                                       RMSE(log.pred.GT.I, test.y.GT.I),
                                       MAE(log.pred.GT.I, test.y.GT.I))


write.csv(results.ALL, "model_results/all.csv", row.names = FALSE)
write.csv(results.PROF.PROF, "model_results/prof.prof.csv", row.names = FALSE)
write.csv(results.PROF.ASC, "model_results/prof.asc.csv", row.names = FALSE)
write.csv(results.PROF.AST, "model_results/prof.ast.csv", row.names = FALSE)
write.csv(results.LEC, "model_results/lec.csv", row.names = FALSE)
write.csv(results.FAC, "model_results/fac.csv", row.names = FALSE)
write.csv(results.INS, "model_results/ins.csv", row.names = FALSE)
write.csv(results.GT, "model_results/gt.csv", row.names = FALSE)

write.csv(results.ALL.I, "model_results/all_i.csv", row.names = FALSE)
write.csv(results.PROF.PROF.I, "model_results/prof.prof_i.csv", row.names = FALSE)
write.csv(results.PROF.ASC.I, "model_results/prof.asc_i.csv", row.names = FALSE)
write.csv(results.PROF.AST.I, "model_results/prof.ast_i.csv", row.names = FALSE)
write.csv(results.LEC.I, "model_results/lec_i.csv", row.names = FALSE)
write.csv(results.FAC.I, "model_results/fac_i.csv", row.names = FALSE)
write.csv(results.INS.I, "model_results/ins_i.csv", row.names = FALSE)
write.csv(results.GT.I, "model_results/gt_i.csv", row.names = FALSE)