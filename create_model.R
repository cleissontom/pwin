library(caTools)
library(dplyr)
library(rpart)
library(rpart.plot)
library(e1071) 
library(caTools) 
library(caret) 
library(lmtest)
library(corrplot)
library(MASS)

db <- read.table("C:/Users/caval/Desktop/data_model_greyhound/data_racing_20210505.csv", head=TRUE,sep="|")
summary(db)


##############################
# function to estimative new punctual data 
###############################
new_punctual_continuum_data <- function(data) {
      
      db_distribuition_data <- data.frame(probability = seq(0.01,0.99,0.01)
                                          ,data = quantile(data,seq(0.01,0.99,0.01),na.rm = TRUE))
      data_runif <- round(runif(1),2)
      df_filter <- db_distribuition_data[(db_distribuition_data$probability >= data_runif-0.011) &
                                    (db_distribuition_data$probability <= data_runif +0.011),]
      
      return(mean(df_filter$data))
}


################################
# function to calculate new data using vector
################################
new_data_with_continuum_distribution <- function(original_data) {
      adjusted_data <- original_data
      accum_variable <- ecdf(original_data)
      
      for (i in 1:length(adjusted_data)) {
            if (is.nan(adjusted_data[i])) {
                  adjusted_data[i] <- new_punctual_continuum_data(adjusted_data)
            }
            if (is.na(adjusted_data[i])) {
                  adjusted_data[i] <- new_punctual_continuum_data(adjusted_data)
            }
            if ((accum_variable(adjusted_data[i]) >= 0.985) | (accum_variable(adjusted_data[i]) <= 0.015)) {
                  adjusted_data[i] <- new_punctual_continuum_data(adjusted_data)
            }
      }
      
      return(adjusted_data) 
}

################################
# function to estimative new punctual data JUST TO DISCRETE DATA
################################
new_punctual_discrete_data <- function(data) {
      
      table_data  = table(data)
      prop_table_data = prop.table(table_data)
      db_distribuition_data <- data.frame(prop_table_data)
      db_distribuition_data$acumulated <- cumsum(db_distribuition_data$Freq)
      colnames(db_distribuition_data) <- c("x_value","probability","accumulated")
      data_runif <- round(runif(1),2)
      df_filter <- db_distribuition_data[(db_distribuition_data$accumulated >= data_runif) ,]
      
      return(as.numeric(head(df_filter$x_value,1)))
}



################################
# function to calculate new data using vector JUST TO DISCRETE DATA
################################
new_data_with_discrete_distribution <- function(original_data) {
      
      adjusted_data <- original_data
      
      for (i in 1:length(adjusted_data)) {
            if (is.nan(adjusted_data[i])) {
                  adjusted_data[i] <- new_punctual_discrete_data(adjusted_data)
            }
            if (is.na(adjusted_data[i])) {
                  adjusted_data[i] <- new_punctual_discrete_data(adjusted_data)
            }
      }
      
      return(adjusted_data) 
}



#data manipulation
db_adj <- db




#variable: velocity
db_adj$velocity1_1 <- new_data_with_continuum_distribution(db$velocity1_1)
db_adj$velocity1_2 <- new_data_with_continuum_distribution(db$velocity1_2)
db_adj$velocity1_3 <- new_data_with_continuum_distribution(db$velocity1_3)
db_adj$velocity1_4 <- new_data_with_continuum_distribution(db$velocity1_4)
db_adj$velocity1_5 <- new_data_with_continuum_distribution(db$velocity1_5)
db_adj$velocity1_6 <- new_data_with_continuum_distribution(db$velocity1_6)

db_adj$velocity2_1 <- new_data_with_continuum_distribution(db$velocity2_1)
db_adj$velocity2_2 <- new_data_with_continuum_distribution(db$velocity2_2)
db_adj$velocity2_3 <- new_data_with_continuum_distribution(db$velocity2_3)
db_adj$velocity2_4 <- new_data_with_continuum_distribution(db$velocity2_4)
db_adj$velocity2_5 <- new_data_with_continuum_distribution(db$velocity2_5)
db_adj$velocity2_6 <- new_data_with_continuum_distribution(db$velocity2_6)

db_adj$velocity3_1 <- new_data_with_continuum_distribution(db$velocity3_1)
db_adj$velocity3_2 <- new_data_with_continuum_distribution(db$velocity3_2)
db_adj$velocity3_3 <- new_data_with_continuum_distribution(db$velocity3_3)
db_adj$velocity3_4 <- new_data_with_continuum_distribution(db$velocity3_4)
db_adj$velocity3_5 <- new_data_with_continuum_distribution(db$velocity3_5)
db_adj$velocity3_6 <- new_data_with_continuum_distribution(db$velocity3_6)


#variable: avg bend
db_adj$avg_bend1_1 <- new_data_with_continuum_distribution(db$avg_bend1_1)
db_adj$avg_bend1_2 <- new_data_with_continuum_distribution(db$avg_bend1_2)
db_adj$avg_bend1_3 <- new_data_with_continuum_distribution(db$avg_bend1_3)
db_adj$avg_bend1_4 <- new_data_with_continuum_distribution(db$avg_bend1_4)
db_adj$avg_bend1_5 <- new_data_with_continuum_distribution(db$avg_bend1_5)
db_adj$avg_bend1_6 <- new_data_with_continuum_distribution(db$avg_bend1_6)

db_adj$avg_bend2_1 <- new_data_with_continuum_distribution(db$avg_bend2_1)
db_adj$avg_bend2_2 <- new_data_with_continuum_distribution(db$avg_bend2_2)
db_adj$avg_bend2_3 <- new_data_with_continuum_distribution(db$avg_bend2_3)
db_adj$avg_bend2_4 <- new_data_with_continuum_distribution(db$avg_bend2_4)
db_adj$avg_bend2_5 <- new_data_with_continuum_distribution(db$avg_bend2_5)
db_adj$avg_bend2_6 <- new_data_with_continuum_distribution(db$avg_bend2_6)

db_adj$avg_bend3_1 <- new_data_with_continuum_distribution(db$avg_bend3_1)
db_adj$avg_bend3_2 <- new_data_with_continuum_distribution(db$avg_bend3_2)
db_adj$avg_bend3_3 <- new_data_with_continuum_distribution(db$avg_bend3_3)
db_adj$avg_bend3_4 <- new_data_with_continuum_distribution(db$avg_bend3_4)
db_adj$avg_bend3_5 <- new_data_with_continuum_distribution(db$avg_bend3_5)
db_adj$avg_bend3_6 <- new_data_with_continuum_distribution(db$avg_bend3_6)


#variable: split
db_adj$split1_1 <- new_data_with_continuum_distribution(db$split1_1)
db_adj$split1_2 <- new_data_with_continuum_distribution(db$split1_2)
db_adj$split1_3 <- new_data_with_continuum_distribution(db$split1_3)
db_adj$split1_4 <- new_data_with_continuum_distribution(db$split1_4)
db_adj$split1_5 <- new_data_with_continuum_distribution(db$split1_5)
db_adj$split1_6 <- new_data_with_continuum_distribution(db$split1_6)


db_adj$split2_1 <- new_data_with_continuum_distribution(db$split2_1)
db_adj$split2_2 <- new_data_with_continuum_distribution(db$split2_2)
db_adj$split2_3 <- new_data_with_continuum_distribution(db$split2_3)
db_adj$split2_4 <- new_data_with_continuum_distribution(db$split2_4)
db_adj$split2_5 <- new_data_with_continuum_distribution(db$split2_5)
db_adj$split2_6 <- new_data_with_continuum_distribution(db$split2_6)


db_adj$split3_1 <- new_data_with_continuum_distribution(db$split3_1)
db_adj$split3_2 <- new_data_with_continuum_distribution(db$split3_2)
db_adj$split3_3 <- new_data_with_continuum_distribution(db$split3_3)
db_adj$split3_4 <- new_data_with_continuum_distribution(db$split3_4)
db_adj$split3_5 <- new_data_with_continuum_distribution(db$split3_5)
db_adj$split3_6 <- new_data_with_continuum_distribution(db$split3_6)


#variable: trap
db_adj$trap1_1 <- new_data_with_discrete_distribution(db$trap1_1)
db_adj$trap1_2 <- new_data_with_discrete_distribution(db$trap1_2)
db_adj$trap1_3 <- new_data_with_discrete_distribution(db$trap1_3)
db_adj$trap1_4 <- new_data_with_discrete_distribution(db$trap1_4)
db_adj$trap1_5 <- new_data_with_discrete_distribution(db$trap1_5)
db_adj$trap1_6 <- new_data_with_discrete_distribution(db$trap1_6)

db_adj$trap2_1 <- new_data_with_discrete_distribution(db$trap2_1)
db_adj$trap2_2 <- new_data_with_discrete_distribution(db$trap2_2)
db_adj$trap2_3 <- new_data_with_discrete_distribution(db$trap2_3)
db_adj$trap2_4 <- new_data_with_discrete_distribution(db$trap2_4)
db_adj$trap2_5 <- new_data_with_discrete_distribution(db$trap2_5)
db_adj$trap2_6 <- new_data_with_discrete_distribution(db$trap2_6)


db_adj$trap3_1 <- new_data_with_discrete_distribution(db$trap3_1)
db_adj$trap3_2 <- new_data_with_discrete_distribution(db$trap3_2)
db_adj$trap3_3 <- new_data_with_discrete_distribution(db$trap3_3)
db_adj$trap3_4 <- new_data_with_discrete_distribution(db$trap3_4)
db_adj$trap3_5 <- new_data_with_discrete_distribution(db$trap3_5)
db_adj$trap3_6 <- new_data_with_discrete_distribution(db$trap3_6)


#variable: position
db_adj$position1_1 <- new_data_with_discrete_distribution(db$position1_1)
db_adj$position1_2 <- new_data_with_discrete_distribution(db$position1_2)
db_adj$position1_3 <- new_data_with_discrete_distribution(db$position1_3)
db_adj$position1_4 <- new_data_with_discrete_distribution(db$position1_4)
db_adj$position1_5 <- new_data_with_discrete_distribution(db$position1_5)
db_adj$position1_6 <- new_data_with_discrete_distribution(db$position1_6)

db_adj$position2_1 <- new_data_with_discrete_distribution(db$position2_1)
db_adj$position2_2 <- new_data_with_discrete_distribution(db$position2_2)
db_adj$position2_3 <- new_data_with_discrete_distribution(db$position2_3)
db_adj$position2_4 <- new_data_with_discrete_distribution(db$position2_4)
db_adj$position2_5 <- new_data_with_discrete_distribution(db$position2_5)
db_adj$position2_6 <- new_data_with_discrete_distribution(db$position2_6)

db_adj$position3_1 <- new_data_with_discrete_distribution(db$position3_1)
db_adj$position3_2 <- new_data_with_discrete_distribution(db$position3_2)
db_adj$position3_3 <- new_data_with_discrete_distribution(db$position3_3)
db_adj$position3_4 <- new_data_with_discrete_distribution(db$position3_4)
db_adj$position3_5 <- new_data_with_discrete_distribution(db$position3_5)
db_adj$position3_6 <- new_data_with_discrete_distribution(db$position3_6)


#variable: weight
db_adj$weight1_1 <- new_data_with_continuum_distribution(db$weight1_1)
db_adj$weight1_2 <- new_data_with_continuum_distribution(db$weight1_2)
db_adj$weight1_3 <- new_data_with_continuum_distribution(db$weight1_3)
db_adj$weight1_4 <- new_data_with_continuum_distribution(db$weight1_4)
db_adj$weight1_5 <- new_data_with_continuum_distribution(db$weight1_5)
db_adj$weight1_6 <- new_data_with_continuum_distribution(db$weight1_6)

db_adj$weight2_1 <- new_data_with_continuum_distribution(db$weight2_1)
db_adj$weight2_2 <- new_data_with_continuum_distribution(db$weight2_2)
db_adj$weight2_3 <- new_data_with_continuum_distribution(db$weight2_3)
db_adj$weight2_4 <- new_data_with_continuum_distribution(db$weight2_4)
db_adj$weight2_5 <- new_data_with_continuum_distribution(db$weight2_5)
db_adj$weight2_6 <- new_data_with_continuum_distribution(db$weight2_6)

db_adj$weight3_1 <- new_data_with_continuum_distribution(db$weight3_1)
db_adj$weight3_2 <- new_data_with_continuum_distribution(db$weight3_2)
db_adj$weight3_3 <- new_data_with_continuum_distribution(db$weight3_3)
db_adj$weight3_4 <- new_data_with_continuum_distribution(db$weight3_4)
db_adj$weight3_5 <- new_data_with_continuum_distribution(db$weight3_5)
db_adj$weight3_6 <- new_data_with_continuum_distribution(db$weight3_6)


#variable: distance
db_adj$distance1_1 <- new_data_with_continuum_distribution(db$distance1_1)
db_adj$distance1_2 <- new_data_with_continuum_distribution(db$distance1_2)
db_adj$distance1_3 <- new_data_with_continuum_distribution(db$distance1_3)
db_adj$distance1_4 <- new_data_with_continuum_distribution(db$distance1_4)
db_adj$distance1_5 <- new_data_with_continuum_distribution(db$distance1_5)
db_adj$distance1_6 <- new_data_with_continuum_distribution(db$distance1_6)


db_adj$distance2_1 <- new_data_with_continuum_distribution(db$distance2_1)
db_adj$distance2_2 <- new_data_with_continuum_distribution(db$distance2_2)
db_adj$distance2_3 <- new_data_with_continuum_distribution(db$distance2_3)
db_adj$distance2_4 <- new_data_with_continuum_distribution(db$distance2_4)
db_adj$distance2_5 <- new_data_with_continuum_distribution(db$distance2_5)
db_adj$distance2_6 <- new_data_with_continuum_distribution(db$distance2_6)


db_adj$distance3_1 <- new_data_with_continuum_distribution(db$distance3_1)
db_adj$distance3_2 <- new_data_with_continuum_distribution(db$distance3_2)
db_adj$distance3_3 <- new_data_with_continuum_distribution(db$distance3_3)
db_adj$distance3_4 <- new_data_with_continuum_distribution(db$distance3_4)
db_adj$distance3_5 <- new_data_with_continuum_distribution(db$distance3_5)
db_adj$distance3_6 <- new_data_with_continuum_distribution(db$distance3_6)


######################
# create model
######################
db_adj$win_trap1 <- as.factor(db_adj$win_trap1)
db_adj$win_trap2 <- as.factor(db_adj$win_trap2)
db_adj$win_trap3 <- as.factor(db_adj$win_trap3)
db_adj$win_trap4 <- as.factor(db_adj$win_trap4)
db_adj$win_trap5 <- as.factor(db_adj$win_trap5)
db_adj$win_trap6 <- as.factor(db_adj$win_trap6)



######################
## balanced data win trap 1
########################
tb_win_trap1 <- table(db_adj$win_trap1)
tb_win_trap1
prop.table(tb_win_trap1)

set.seed(6969)
db_pos_y <- db_adj[db_adj$win_trap1==1,]
db_neg_y <- db_adj[db_adj$win_trap1==0,]
db_neg_y <- sample_n(db_neg_y,dim(db_pos_y)[1])


db_balanced <- rbind(db_pos_y,db_neg_y)
dim(db_balanced)
table(db_balanced$win_trap1)

attach(db_balanced)


model_full_1 <- glm(win_trap1 ~ 
                       velocity1_1+velocity1_2+velocity1_3+velocity1_4+velocity1_5+velocity1_6
                    + velocity2_1+velocity2_2+velocity2_3+velocity2_4+velocity2_5+velocity2_6
                    + velocity3_1+velocity3_2+velocity3_3+velocity3_4+velocity3_5+velocity3_6
                    
                    + position1_1+position1_2+position1_3+position1_4+position1_5+position1_6
                    + position2_1+position2_2+position2_3+position2_4+position2_5+position2_6
                    + position3_1+position3_2+position3_3+position3_4+position3_5+position3_6
                    
                    + split1_1+split1_2+split1_3+split1_4+split1_5+split1_6
                    + split2_1+split2_2+split2_3+split2_4+split2_5+split2_6
                    + split3_1+split3_2+split3_3+split3_4+split3_5+split3_6
                    
                    + avg_bend1_1+avg_bend1_2+avg_bend1_3+avg_bend1_4+avg_bend1_5+avg_bend1_6
                    + avg_bend2_1+avg_bend2_2+avg_bend2_3+avg_bend2_4+avg_bend2_5+avg_bend2_6
                    + avg_bend3_1+avg_bend3_2+avg_bend3_3+avg_bend3_4+avg_bend3_5+avg_bend3_6
                    
                    + trap1_1 + trap1_2+trap1_3+trap1_4+trap1_5+trap1_6
                    + trap2_1 + trap2_2+trap2_3+trap2_4+trap2_5+trap2_6
                    + trap3_1 + trap3_2+trap3_3+trap3_4+trap3_5+trap3_6
                    
                    + distance1_1 + distance1_2 + distance1_3 + distance1_4 + distance1_5 + distance1_6
                    + distance2_1 + distance2_2 + distance2_3 + distance2_4 + distance2_5 + distance2_6
                    + distance3_1 + distance2_2 + distance3_3 + distance3_4 + distance3_5 + distance3_6
                           
                    + weight1_1 + weight1_2 + weight1_3 + weight1_4 + weight1_5 + weight1_6 
                    + weight2_1 + weight2_2 + weight2_3 + weight2_4 + weight2_5 + weight2_6 
                    + weight3_1 + weight3_2 + weight3_3 + weight3_4 + weight3_5 + weight3_6 
                           
                     ,data=db_balanced,family = binomial)


plot(predict(model_full_1,type = "response"),pch=16)
mod_predict_1 <- ifelse(predict(model_full_1,type = "response") > 0.5, 1, 0)
mod1_table_train <- table(db_balanced$win_trap1,mod_predict_1)
mod1_prob_table_train <- prop.table(mod1_table_train)
mod1_accuracy_train <- (mod1_table_train[1] + mod1_table_train[4])/sum(mod1_table_train)

mod1_table_train
mod1_prob_table_train
mod1_accuracy_train


#reduce data
mod_reduced_1 <- stepAIC(model_full_1)

plot(predict(mod_reduced_1,type = "response"),pch=16)
mod1_reduced_predict <- ifelse(predict(mod_reduced_1,type = "response") > 0.5, 1, 0)
mod1_reduced_table_train <- table(db_balanced$win_trap1,mod1_reduced_predict)
mod1_reduced_prob_table_train <- prop.table(mod1_reduced_table_train)
mod1_reduced_accuracy_train <- (mod1_reduced_table_train[1] + mod1_reduced_table_train[4])/sum(mod1_reduced_table_train)
mod1_reduced_table_train
mod1_reduced_prob_table_train
mod1_reduced_accuracy_train







######################
## balanced data win trap 2
########################
tb_win_trap2 <- table(db_adj$win_trap2)
tb_win_trap2
prop.table(tb_win_trap2)

set.seed(889)
db_pos_y <- db_adj[db_adj$win_trap2==1,]
db_neg_y <- db_adj[db_adj$win_trap2==0,]
db_neg_y <- sample_n(db_neg_y,dim(db_pos_y)[1])


db_balanced <- rbind(db_pos_y,db_neg_y)
dim(db_balanced)
table(db_balanced$win_trap2)

model_full_2 <- glm(win_trap2 ~ 
                       velocity1_1+velocity1_2+velocity1_3+velocity1_4+velocity1_5+velocity1_6
                    + velocity2_1+velocity2_2+velocity2_3+velocity2_4+velocity2_5+velocity2_6
                    + velocity3_1+velocity3_2+velocity3_3+velocity3_4+velocity3_5+velocity3_6
                    
                    + position1_1+position1_2+position1_3+position1_4+position1_5+position1_6
                    + position2_1+position2_2+position2_3+position2_4+position2_5+position2_6
                    + position3_1+position3_2+position3_3+position3_4+position3_5+position3_6
                    
                    + split1_1+split1_2+split1_3+split1_4+split1_5+split1_6
                    + split2_1+split2_2+split2_3+split2_4+split2_5+split2_6
                    + split3_1+split3_2+split3_3+split3_4+split3_5+split3_6
                    
                    + avg_bend1_1+avg_bend1_2+avg_bend1_3+avg_bend1_4+avg_bend1_5+avg_bend1_6
                    + avg_bend2_1+avg_bend2_2+avg_bend2_3+avg_bend2_4+avg_bend2_5+avg_bend2_6
                    + avg_bend3_1+avg_bend3_2+avg_bend3_3+avg_bend3_4+avg_bend3_5+avg_bend3_6
                    
                    + trap1_1 + trap1_2+trap1_3+trap1_4+trap1_5+trap1_6
                    + trap2_1 + trap2_2+trap2_3+trap2_4+trap2_5+trap2_6
                    + trap3_1 + trap3_2+trap3_3+trap3_4+trap3_5+trap3_6
                    
                    + distance1_1 + distance1_2 + distance1_3 + distance1_4 + distance1_5 + distance1_6
                    + distance2_1 + distance2_2 + distance2_3 + distance2_4 + distance2_5 + distance2_6
                    + distance3_1 + distance2_2 + distance3_3 + distance3_4 + distance3_5 + distance3_6
                    
                    + weight1_1 + weight1_2 + weight1_3 + weight1_4 + weight1_5 + weight1_6 
                    + weight2_1 + weight2_2 + weight2_3 + weight2_4 + weight2_5 + weight2_6 
                    + weight3_1 + weight3_2 + weight3_3 + weight3_4 + weight3_5 + weight3_6 
                    
                    ,data=db_balanced,family = binomial)


plot(predict(model_full_2,type = "response"),pch=16)
mod_predict_2 <- ifelse(predict(model_full_2,type = "response") > 0.5, 1, 0)
mod2_table_train <- table(db_balanced$win_trap2,mod_predict_2)
mod2_prob_table_train <- prop.table(mod2_table_train)
mod2_accuracy_train <- (mod2_table_train[1] + mod2_table_train[4])/sum(mod2_table_train)
mod2_table_train
mod2_prob_table_train
mod2_accuracy_train

#reduce data
mod_reduced_2 <- stepAIC(model_full_2)

plot(predict(mod_reduced_2,type = "response"),pch=16)
mod2_reduced_predict <- ifelse(predict(mod_reduced_2,type = "response") > 0.5, 1, 0)
mod2_reduced_table_train <- table(db_balanced$win_trap2,mod2_reduced_predict)
mod2_reduced_prob_table_train <- prop.table(mod2_reduced_table_train)
mod2_reduced_accuracy_train <- (mod2_reduced_table_train[1] + mod2_reduced_table_train[4])/sum(mod2_reduced_table_train)
mod2_reduced_table_train
mod2_reduced_prob_table_train
mod2_reduced_accuracy_train













######################
## balanced data win trap 3
########################
tb_win_trap3 <- table(db_adj$win_trap3)
tb_win_trap3
prop.table(tb_win_trap3)

set.seed(889)
db_pos_y <- db_adj[db_adj$win_trap3==1,]
db_neg_y <- db_adj[db_adj$win_trap3==0,]
db_neg_y <- sample_n(db_neg_y,dim(db_pos_y)[1])


db_balanced <- rbind(db_pos_y,db_neg_y)
dim(db_balanced)

model_full_3 <- glm(win_trap3 ~
                       velocity1_1+velocity1_2+velocity1_3+velocity1_4+velocity1_5+velocity1_6
                    + velocity2_1+velocity2_2+velocity2_3+velocity2_4+velocity2_5+velocity2_6
                    + velocity3_1+velocity3_2+velocity3_3+velocity3_4+velocity3_5+velocity3_6
                    
                    + position1_1+position1_2+position1_3+position1_4+position1_5+position1_6
                    + position2_1+position2_2+position2_3+position2_4+position2_5+position2_6
                    + position3_1+position3_2+position3_3+position3_4+position3_5+position3_6
                    
                    + split1_1+split1_2+split1_3+split1_4+split1_5+split1_6
                    + split2_1+split2_2+split2_3+split2_4+split2_5+split2_6
                    + split3_1+split3_2+split3_3+split3_4+split3_5+split3_6
                    
                    + avg_bend1_1+avg_bend1_2+avg_bend1_3+avg_bend1_4+avg_bend1_5+avg_bend1_6
                    + avg_bend2_1+avg_bend2_2+avg_bend2_3+avg_bend2_4+avg_bend2_5+avg_bend2_6
                    + avg_bend3_1+avg_bend3_2+avg_bend3_3+avg_bend3_4+avg_bend3_5+avg_bend3_6
                    
                    + trap1_1 + trap1_2+trap1_3+trap1_4+trap1_5+trap1_6
                    + trap2_1 + trap2_2+trap2_3+trap2_4+trap2_5+trap2_6
                    + trap3_1 + trap3_2+trap3_3+trap3_4+trap3_5+trap3_6
                    
                    + distance1_1 + distance1_2 + distance1_3 + distance1_4 + distance1_5 + distance1_6
                    + distance2_1 + distance2_2 + distance2_3 + distance2_4 + distance2_5 + distance2_6
                    + distance3_1 + distance2_2 + distance3_3 + distance3_4 + distance3_5 + distance3_6
                    
                    + weight1_1 + weight1_2 + weight1_3 + weight1_4 + weight1_5 + weight1_6 
                    + weight2_1 + weight2_2 + weight2_3 + weight2_4 + weight2_5 + weight2_6 
                    + weight3_1 + weight3_2 + weight3_3 + weight3_4 + weight3_5 + weight3_6 
                    
                    ,data=db_balanced,family = binomial)


plot(predict(model_full_3,type = "response"),pch=16)
mod_predict_3 <- ifelse(predict(model_full_3,type = "response") > 0.5, 1, 0)
mod3_table_train <- table(db_balanced$win_trap3,mod_predict_3)
mod3_prob_table_train <- prop.table(mod3_table_train)
mod3_accuracy_train <- (mod3_table_train[1] + mod3_table_train[4])/sum(mod3_table_train)
mod3_table_train
mod3_prob_table_train
mod3_accuracy_train

#reduce data
mod_reduced_3 <- stepAIC(model_full_3)

plot(predict(mod_reduced_3,type = "response"),pch=16)
mod3_reduced_predict <- ifelse(predict(mod_reduced_3,type = "response") > 0.5, 1, 0)
mod3_reduced_table_train <- table(db_balanced$win_trap3,mod3_reduced_predict)
mod3_reduced_prob_table_train <- prop.table(mod3_reduced_table_train)
mod3_reduced_accuracy_train <- (mod3_reduced_table_train[1] + mod3_reduced_table_train[4])/sum(mod3_reduced_table_train)
mod3_reduced_table_train
mod3_reduced_prob_table_train
mod3_reduced_accuracy_train







######################
## balanced data win trap 4
########################
tb_win_trap4 <- table(db_adj$win_trap4)
tb_win_trap4
prop.table(tb_win_trap4)

set.seed(889)
db_pos_y <- db_adj[db_adj$win_trap4==1,]
db_neg_y <- db_adj[db_adj$win_trap4==0,]
db_neg_y <- sample_n(db_neg_y,dim(db_pos_y)[1])


db_balanced <- rbind(db_pos_y,db_neg_y)
dim(db_balanced)

model_full_4 <- glm(win_trap4 ~ 
                       velocity1_1+velocity1_2+velocity1_3+velocity1_4+velocity1_5+velocity1_6
                    + velocity2_1+velocity2_2+velocity2_3+velocity2_4+velocity2_5+velocity2_6
                    + velocity3_1+velocity3_2+velocity3_3+velocity3_4+velocity3_5+velocity3_6
                    
                    + position1_1+position1_2+position1_3+position1_4+position1_5+position1_6
                    + position2_1+position2_2+position2_3+position2_4+position2_5+position2_6
                    + position3_1+position3_2+position3_3+position3_4+position3_5+position3_6
                    
                    + split1_1+split1_2+split1_3+split1_4+split1_5+split1_6
                    + split2_1+split2_2+split2_3+split2_4+split2_5+split2_6
                    + split3_1+split3_2+split3_3+split3_4+split3_5+split3_6
                    
                    + avg_bend1_1+avg_bend1_2+avg_bend1_3+avg_bend1_4+avg_bend1_5+avg_bend1_6
                    + avg_bend2_1+avg_bend2_2+avg_bend2_3+avg_bend2_4+avg_bend2_5+avg_bend2_6
                    + avg_bend3_1+avg_bend3_2+avg_bend3_3+avg_bend3_4+avg_bend3_5+avg_bend3_6
                    
                    + trap1_1 + trap1_2+trap1_3+trap1_4+trap1_5+trap1_6
                    + trap2_1 + trap2_2+trap2_3+trap2_4+trap2_5+trap2_6
                    + trap3_1 + trap3_2+trap3_3+trap3_4+trap3_5+trap3_6
                    
                    + distance1_1 + distance1_2 + distance1_3 + distance1_4 + distance1_5 + distance1_6
                    + distance2_1 + distance2_2 + distance2_3 + distance2_4 + distance2_5 + distance2_6
                    + distance3_1 + distance2_2 + distance3_3 + distance3_4 + distance3_5 + distance3_6
                    
                    + weight1_1 + weight1_2 + weight1_3 + weight1_4 + weight1_5 + weight1_6 
                    + weight2_1 + weight2_2 + weight2_3 + weight2_4 + weight2_5 + weight2_6 
                    + weight3_1 + weight3_2 + weight3_3 + weight3_4 + weight3_5 + weight3_6 
                    
                    ,data=db_balanced,family = binomial)


plot(predict(model_full_4,type = "response"),pch=16)
mod_predict_4 <- ifelse(predict(model_full_4,type = "response") > 0.5, 1, 0)
mod4_table_train <- table(db_balanced$win_trap4,mod_predict_4)
mod4_prob_table_train <- prop.table(mod4_table_train)
mod4_accuracy_train <- (mod4_table_train[1] + mod4_table_train[4])/sum(mod4_table_train)
mod4_table_train
mod4_prob_table_train
mod4_accuracy_train

#reduce data
mod_reduced_4 <- stepAIC(model_full_4)

plot(predict(mod_reduced_4,type = "response"),pch=16)
mod4_reduced_predict <- ifelse(predict(mod_reduced_4,type = "response") > 0.5, 1, 0)
mod4_reduced_table_train <- table(db_balanced$win_trap4,mod4_reduced_predict)
mod4_reduced_prob_table_train <- prop.table(mod4_reduced_table_train)
mod4_reduced_accuracy_train <- (mod4_reduced_table_train[1] + mod4_reduced_table_train[4])/sum(mod4_reduced_table_train)
mod4_reduced_table_train
mod4_reduced_prob_table_train
mod4_reduced_accuracy_train




######################
## balanced data win trap 5
########################
tb_win_trap5 <- table(db_adj$win_trap5)
tb_win_trap5
prop.table(tb_win_trap5)

set.seed(889)
db_pos_y <- db_adj[db_adj$win_trap5==1,]
db_neg_y <- db_adj[db_adj$win_trap5==0,]
db_neg_y <- sample_n(db_neg_y,dim(db_pos_y)[1])


db_balanced <- rbind(db_pos_y,db_neg_y)
dim(db_balanced)

model_full_5 <- glm(win_trap5 ~ 
                       velocity1_1+velocity1_2+velocity1_3+velocity1_4+velocity1_5+velocity1_6
                    + velocity2_1+velocity2_2+velocity2_3+velocity2_4+velocity2_5+velocity2_6
                    + velocity3_1+velocity3_2+velocity3_3+velocity3_4+velocity3_5+velocity3_6
                    
                    + position1_1+position1_2+position1_3+position1_4+position1_5+position1_6
                    + position2_1+position2_2+position2_3+position2_4+position2_5+position2_6
                    + position3_1+position3_2+position3_3+position3_4+position3_5+position3_6
                    
                    + split1_1+split1_2+split1_3+split1_4+split1_5+split1_6
                    + split2_1+split2_2+split2_3+split2_4+split2_5+split2_6
                    + split3_1+split3_2+split3_3+split3_4+split3_5+split3_6
                    
                    + avg_bend1_1+avg_bend1_2+avg_bend1_3+avg_bend1_4+avg_bend1_5+avg_bend1_6
                    + avg_bend2_1+avg_bend2_2+avg_bend2_3+avg_bend2_4+avg_bend2_5+avg_bend2_6
                    + avg_bend3_1+avg_bend3_2+avg_bend3_3+avg_bend3_4+avg_bend3_5+avg_bend3_6
                    
                    + trap1_1 + trap1_2+trap1_3+trap1_4+trap1_5+trap1_6
                    + trap2_1 + trap2_2+trap2_3+trap2_4+trap2_5+trap2_6
                    + trap3_1 + trap3_2+trap3_3+trap3_4+trap3_5+trap3_6
                    
                    + distance1_1 + distance1_2 + distance1_3 + distance1_4 + distance1_5 + distance1_6
                    + distance2_1 + distance2_2 + distance2_3 + distance2_4 + distance2_5 + distance2_6
                    + distance3_1 + distance2_2 + distance3_3 + distance3_4 + distance3_5 + distance3_6
                    
                    + weight1_1 + weight1_2 + weight1_3 + weight1_4 + weight1_5 + weight1_6 
                    + weight2_1 + weight2_2 + weight2_3 + weight2_4 + weight2_5 + weight2_6 
                    + weight3_1 + weight3_2 + weight3_3 + weight3_4 + weight3_5 + weight3_6 
                    
                    ,data=db_balanced,family = binomial)


plot(predict(model_full_5,type = "response"),pch=16)
mod_predict_5 <- ifelse(predict(model_full_5,type = "response") > 0.5, 1, 0)
mod5_table_train <- table(db_balanced$win_trap5,mod_predict_5)
mod5_prob_table_train <- prop.table(mod5_table_train)
mod5_accuracy_train <- (mod5_table_train[1] + mod5_table_train[4])/sum(mod5_table_train)
mod5_table_train
mod5_prob_table_train
mod5_accuracy_train

#reduce data
mod_reduced_5 <- stepAIC(model_full_5)

plot(predict(mod_reduced_5,type = "response"),pch=16)
mod5_reduced_predict <- ifelse(predict(mod_reduced_5,type = "response") > 0.5, 1, 0)
mod5_reduced_table_train <- table(db_balanced$win_trap5,mod5_reduced_predict)
mod5_reduced_prob_table_train <- prop.table(mod5_reduced_table_train)
mod5_reduced_accuracy_train <- (mod5_reduced_table_train[1] + mod5_reduced_table_train[4])/sum(mod5_reduced_table_train)
mod5_reduced_table_train
mod5_reduced_prob_table_train
mod5_reduced_accuracy_train






######################
## balanced data win trap 6
########################
tb_win_trap6 <- table(db_adj$win_trap6)
tb_win_trap6
prop.table(tb_win_trap6)

set.seed(889)
db_pos_y <- db_adj[db_adj$win_trap6==1,]
db_neg_y <- db_adj[db_adj$win_trap6==0,]
db_neg_y <- sample_n(db_neg_y,dim(db_pos_y)[1])


db_balanced <- rbind(db_pos_y,db_neg_y)
dim(db_balanced)

model_full_6 <- glm(win_trap6 ~ 
                       velocity1_1+velocity1_2+velocity1_3+velocity1_4+velocity1_5+velocity1_6
                    + velocity2_1+velocity2_2+velocity2_3+velocity2_4+velocity2_5+velocity2_6
                    + velocity3_1+velocity3_2+velocity3_3+velocity3_4+velocity3_5+velocity3_6
                    
                    + position1_1+position1_2+position1_3+position1_4+position1_5+position1_6
                    + position2_1+position2_2+position2_3+position2_4+position2_5+position2_6
                    + position3_1+position3_2+position3_3+position3_4+position3_5+position3_6
                    
                    + split1_1+split1_2+split1_3+split1_4+split1_5+split1_6
                    + split2_1+split2_2+split2_3+split2_4+split2_5+split2_6
                    + split3_1+split3_2+split3_3+split3_4+split3_5+split3_6
                    
                    + avg_bend1_1+avg_bend1_2+avg_bend1_3+avg_bend1_4+avg_bend1_5+avg_bend1_6
                    + avg_bend2_1+avg_bend2_2+avg_bend2_3+avg_bend2_4+avg_bend2_5+avg_bend2_6
                    + avg_bend3_1+avg_bend3_2+avg_bend3_3+avg_bend3_4+avg_bend3_5+avg_bend3_6
                    
                    + trap1_1 + trap1_2+trap1_3+trap1_4+trap1_5+trap1_6
                    + trap2_1 + trap2_2+trap2_3+trap2_4+trap2_5+trap2_6
                    + trap3_1 + trap3_2+trap3_3+trap3_4+trap3_5+trap3_6
                    
                    + distance1_1 + distance1_2 + distance1_3 + distance1_4 + distance1_5 + distance1_6
                    + distance2_1 + distance2_2 + distance2_3 + distance2_4 + distance2_5 + distance2_6
                    + distance3_1 + distance2_2 + distance3_3 + distance3_4 + distance3_5 + distance3_6
                    
                    + weight1_1 + weight1_2 + weight1_3 + weight1_4 + weight1_5 + weight1_6 
                    + weight2_1 + weight2_2 + weight2_3 + weight2_4 + weight2_5 + weight2_6 
                    + weight3_1 + weight3_2 + weight3_3 + weight3_4 + weight3_5 + weight3_6 
                    
                    ,data=db_balanced,family = binomial)


plot(predict(model_full_6,type = "response"),pch=16)
mod_predict_6 <- ifelse(predict(model_full_6,type = "response") > 0.5, 1, 0)
mod6_table_train <- table(db_balanced$win_trap6,mod_predict_6)
mod6_prob_table_train <- prop.table(mod6_table_train)
mod6_accuracy_train <- (mod6_table_train[1] + mod6_table_train[4])/sum(mod6_table_train)
mod6_table_train
mod6_prob_table_train
mod6_accuracy_train

#reduce data
mod_reduced_6 <- stepAIC(model_full_6)

plot(predict(mod_reduced_6,type = "response"),pch=16)
mod6_reduced_predict <- ifelse(predict(mod_reduced_6,type = "response") > 0.5, 1, 0)
mod6_reduced_table_train <- table(db_balanced$win_trap6,mod6_reduced_predict)
mod6_reduced_prob_table_train <- prop.table(mod6_reduced_table_train)
mod6_reduced_accuracy_train <- (mod6_reduced_table_train[1] + mod6_reduced_table_train[4])/sum(mod6_reduced_table_train)
mod6_reduced_table_train
mod6_reduced_prob_table_train
mod6_reduced_accuracy_train


#final models
mod_reduced_1
mod_reduced_2
mod_reduced_3
mod_reduced_4
mod_reduced_5
mod_reduced_6


#final prints table
mod1_accuracy_train
mod1_reduced_accuracy_train

mod2_accuracy_train
mod2_reduced_accuracy_train

mod3_accuracy_train
mod3_reduced_accuracy_train

mod4_accuracy_train
mod4_reduced_accuracy_train

mod5_accuracy_train
mod5_reduced_accuracy_train

mod6_accuracy_train
mod6_reduced_accuracy_train


db_adj$predict_mod1 <- predict(mod_reduced_1, newdata = db_adj,type = "response")
db_adj$predict_mod2 <- predict(mod_reduced_2, newdata = db_adj,type = "response")
db_adj$predict_mod3 <- predict(mod_reduced_3, newdata = db_adj,type = "response")
db_adj$predict_mod4 <- predict(mod_reduced_4, newdata = db_adj,type = "response")
db_adj$predict_mod5 <- predict(mod_reduced_5, newdata = db_adj,type = "response")
db_adj$predict_mod6 <- predict(mod_reduced_6, newdata = db_adj,type = "response")


db_export <- db_adj[,c("url_racing","win_trap1","win_trap2","win_trap3","win_trap4","win_trap5","win_trap6"
                      ,"start_odd_1","start_odd_2","start_odd_3","start_odd_4","start_odd_5","start_odd_6"
                       ,"predict_mod1","predict_mod2","predict_mod3","predict_mod4","predict_mod5","predict_mod6")]
summary(db_export)


write.table(db_export,"model_greyhound_applied_20210505.csv",row.names=FALSE,sep=";")
