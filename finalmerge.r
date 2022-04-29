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

set.seed(6741)

####READ ALL FILES####

GA.P <- read.csv(file = "analysis_data/GT+ratings/GA.csv")

CSU.L <- read.csv(file = "analysis_data/CSU+segmented/CSU_Lecturer.csv")
CSU.P <- read.csv(file = "analysis_data/CSU+segmented/CSU_Prof.csv")

IL.F <- read.csv(file = "analysis_data/IL+segmented/IL_Faculty.csv")
IL.I <- read.csv(file = "analysis_data/IL+segmented/IL_Instructor.csv")
IL.L <- read.csv(file = "analysis_data/IL+segmented/IL_Lecturer.csv")
IL.P <- read.csv(file = "analysis_data/IL+segmented/IL_Prof_Generalized.csv")

NC.F <- read.csv(file = "analysis_data/NC+segmented/NC_Faculty.csv")
NC.I <- read.csv(file = "analysis_data/NC+segmented/NC_Instructor.csv")
NC.L <- read.csv(file = "analysis_data/NC+segmented/NC_Lecturer.csv")
NC.P <- read.csv(file = "analysis_data/NC+segmented/NC_Prof_Generalized.csv")

TN.I <- read.csv(file = "analysis_data/TN+segmented/TN_Instructor.csv")
TN.P <- read.csv(file = "analysis_data/TN+segmented/TN_Prof_Generalized.csv")


#####LABEL ALL ROLES#####

GA.P$Role <- 'Professor'

CSU.L$Role <- 'Lecturer'
CSU.P$Role <- 'Professor'

IL.F$Role <- 'Faculty'
IL.I$Role <- 'Instructor'
IL.L$Role <- 'Lecturer'
IL.P$Role <- 'Professor'

NC.F$Role <- 'Faculty'
NC.I$Role <- 'Instructor'
NC.L$Role <- 'Lecturer'
NC.P$Role <- 'Professor'

TN.I$Role <- 'Instructor'
TN.P$Role <- 'Professor'

#####ALL STATES WITH GENERALIZE ROLE####

ALL <- bind_rows(subset(GA.P, select = -Rating), CSU.L, CSU.P, IL.F, IL.I, IL.L, IL.P, NC.F, NC.I, NC.L, NC.P, TN.I, TN.P)
ALL <- subset(ALL, select = -c(First.Name, Last.Name, Department, Title))

write.csv(ALL, "final_partitioned/all.csv", row.names = FALSE)

#####ALL STATS FACULTY ONLY DATA#####

FAC <- bind_rows(IL.F, NC.F)
FAC <- subset(FAC, select = -c(First.Name, Last.Name, Department, Role, Title))

write.csv(FAC, "final_partitioned/fac.csv", row.names = FALSE)

#####ALL STATS LECTURER ONLY DATA#####

LEC <- bind_rows(CSU.L, IL.L,NC.L)
LEC <- subset(LEC, select = -c(First.Name, Last.Name, Department, Role, Title))

write.csv(LEC, "final_partitioned/lec.csv", row.names = FALSE)

#####ALL STATS INSTRUCTOR ONLY DATA#####

INS <- bind_rows(IL.I,NC.I,TN.I)
INS <- subset(INS, select = -c(First.Name, Last.Name, Department, Role, Title))

write.csv(INS, "final_partitioned/ins.csv", row.names = FALSE)

#####ALL STATS PROFESSOR ONLY DATA#####

PROF <- bind_rows(subset(GA.P, select = -Rating), IL.P, NC.P, TN.P)
PROF <- subset(PROF, select = -c(First.Name, Last.Name, Department, Role))

PROF.PROF <- PROF[PROF$Title == 'Professor',]
PROF.PROF <- subset(PROF.PROF, select = -c(Title))
write.csv(PROF.PROF, "final_partitioned/prof.prof.csv", row.names = FALSE)

#####ALL STATS ASSISTANT PROFESSOR ONLY DATA#####

PROF.AST <- PROF[PROF$Title == 'Assistant Professor',]
PROF.AST <- subset(PROF.AST, select = -c(Title))
write.csv(PROF.AST, "final_partitioned/prof.ast.csv", row.names = FALSE)

#####ALL STATS ASSOCIATE PROFESSOR ONLY DATA#####

PROF.ASC <- PROF[PROF$Title == 'Associate Professor',]
PROF.ASC <- subset(PROF.ASC, select = -c(Title))
write.csv(PROF.ASC, "final_partitioned/prof.asc.csv", row.names = FALSE)

#####GEORGIA TECH DATA WITH RATING#####

GA.P <- subset(GA.P, select = -c(State, First.Name, Last.Name, Institution, Department, Role) )

write.csv(GA.P, "final_partitioned/gt.csv", row.names = FALSE)

#####INTERSECTIONAL DATA#####
ALL$Gender[ALL$Gender == 'mostly_male'] <- 'male'
ALL$Gender[ALL$Gender == 'mostly_female'] <- 'female'
ALL$Gender[ALL$Gender == 'andy'] <- 'unknown'

PROF.PROF$Gender[PROF.PROF$Gender == 'mostly_male'] <- 'male'
PROF.PROF$Gender[PROF.PROF$Gender == 'mostly_female'] <- 'female'
PROF.PROF$Gender[PROF.PROF$Gender == 'andy'] <- 'unknown'

PROF.ASC$Gender[PROF.ASC$Gender == 'mostly_male'] <- 'male'
PROF.ASC$Gender[PROF.ASC$Gender == 'mostly_female'] <- 'female'
PROF.ASC$Gender[PROF.ASC$Gender == 'andy'] <- 'unknown'

PROF.AST$Gender[PROF.AST$Gender == 'mostly_male'] <- 'male'
PROF.AST$Gender[PROF.AST$Gender == 'mostly_female'] <- 'female'
PROF.AST$Gender[PROF.AST$Gender == 'andy'] <- 'unknown'

INS$Gender[INS$Gender == 'mostly_male'] <- 'male'
INS$Gender[INS$Gender == 'mostly_female'] <- 'female'
INS$Gender[INS$Gender == 'andy'] <- 'unknown'

LEC$Gender[LEC$Gender == 'mostly_male'] <- 'male'
LEC$Gender[LEC$Gender == 'mostly_female'] <- 'female'
LEC$Gender[LEC$Gender == 'andy'] <- 'unknown'

FAC$Gender[FAC$Gender == 'mostly_male'] <- 'male'
FAC$Gender[FAC$Gender == 'mostly_female'] <- 'female'
FAC$Gender[FAC$Gender == 'andy'] <- 'unknown'

GA.P$Gender[GA.P$Gender == 'mostly_male'] <- 'male'
GA.P$Gender[GA.P$Gender == 'mostly_female'] <- 'female'
GA.P$Gender[GA.P$Gender == 'andy'] <- 'unknown'

ALL$intersection <- paste(ALL$Gender, ALL$Race, sep="_")
PROF.PROF$intersection <- paste(PROF.PROF$Gender, PROF.PROF$Race, sep="_")
PROF.ASC$intersection <- paste(PROF.ASC$Gender, PROF.ASC$Race, sep="_")
PROF.AST$intersection <- paste(PROF.AST$Gender, PROF.AST$Race, sep="_")
LEC$intersection <- paste(LEC$Gender, LEC$Race, sep="_")
FAC$intersection <- paste(FAC$Gender, FAC$Race, sep="_")
INS$intersection <- paste(INS$Gender, INS$Race, sep="_")
GA.P$intersection <- paste(GA.P$Gender, GA.P$Race, sep="_")


ALL <- subset(ALL, select = -c(Race, Gender) )
PROF.PROF <- subset(PROF.PROF, select = -c(Race, Gender) )
PROF.ASC <- subset(PROF.ASC, select = -c(Race, Gender) )
PROF.AST <- subset(PROF.AST, select = -c(Race, Gender) )
INS <- subset(INS, select = -c(Race, Gender) )
FAC <- subset(FAC, select = -c(Race, Gender) )
LEC <- subset(LEC, select = -c(Race, Gender) )
GA.P <- subset(GA.P, select = -c(Race, Gender) )

write.csv(ALL, "final_partitioned/all_i.csv", row.names = FALSE)
write.csv(PROF.PROF, "final_partitioned/prof.prof_i.csv", row.names = FALSE)
write.csv(PROF.ASC, "final_partitioned/prof.asc_i.csv", row.names = FALSE)
write.csv(PROF.AST, "final_partitioned/prof.ast_i.csv", row.names = FALSE)
write.csv(LEC, "final_partitioned/lec_i.csv", row.names = FALSE)
write.csv(FAC, "final_partitioned/fac_i.csv", row.names = FALSE)
write.csv(INS, "final_partitioned/ins_i.csv", row.names = FALSE)
write.csv(GA.P, "final_partitioned/gt_i.csv", row.names = FALSE)