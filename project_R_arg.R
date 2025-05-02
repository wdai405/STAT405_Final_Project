##loadpackage
require("glmnet")

rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  template_file = args[1]
} else {
  cat('usage: Rscript project_R_args.R <template file> \n', file=stderr())
  stop()
}


## Label classified as 1-BENIGN and 0-Other

chunk_00 <- read.csv(paste0("./partioned/",i,".csv")
chunk_00$Label_original <- chunk_00$Label
chunk_00$Label <- as.character(chunk_00$Label)
chunk_00$Label[chunk_00$Label=="BENIGN"] <- 1
chunk_00$Label[chunk_00$Label != 1] <- 0
chunk_00$Label <- as.numeric(chunk_00$Label)

table(chunk_00$Label)

##remove DST_IP, SRC_IP, flow_ID, time stamp grouped into 3 - 10pm-6am - night, 6am-2pm -day , 2pm-10pm -eve

chunk_00 <- chunk_00[, !names(chunk_00) %in% c("id","Dst.IP", "Src.IP","Flow.ID","Label_original")]

chunk_00$Timestamp <- sapply(chunk_00$Timestamp, function(ts) {
  hr <- as.numeric(format(strptime(substr(ts, 1, 19), format = "%Y-%m-%d %H:%M:%S"), "%H"))
  if (hr >= 6 & hr < 14) return("Day")
  else if (hr >= 14 & hr < 22) return("Evening")
  else return("Night")
})
                                      
##scale variables except Timestamp
##single_level_factors <- sapply(chunk_00, function(col) is.factor(col) && length(unique(col)) < 2)
##chunk_00 <- chunk_00[ , !single_level_factors]
##donot_scale <- c("Label", "Timestamp")
##var_to_scale <- setdiff(names(chunk_00), donot_scale)
##chunk_00[var_to_scale] <- scale(chunk_00[var_to_scale])

## Lasso regression
x=model.matrix(Label~.,chunk_00)[,-1]
y=chunk_00$Label

lm.lasso=glmnet(x,y,alpha=1)
cv.out=cv.glmnet(x,y,alpha=1,nfolds=10)
lambda.best=cv.out$lambda.min
lambda.best

##select coefficients for the best fit
lasso_coefs <- coef(lm.lasso, s = lambda.best)

##lasso_coefs
selected_variables <- rownames(lasso_coefs)[lasso_coefs[, 1] != 0]
selected_variables <- selected_variables[!selected_variables %in% "(Intercept)"]

##Variable with category label
selected_variables[!selected_variables %in% colnames(chunk_00)]
selected_variables[selected_variables==selected_variables[!selected_variables %in% colnames(chunk_00)]]<-"Timestamp"
call <- paste("Label ~", paste(selected_variables, collapse = " + "))

logReg_model <- glm(as.formula(call),data=chunk_00, family=binomial("logit"))

## output summary of model 
capture.output(summary(logReg_model)$coefficients, file = paste0(i,"_output.csv")

