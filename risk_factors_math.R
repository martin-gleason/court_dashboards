# rank is Low, Mod, High
# stats: 20, 44, 60% rearrest rate for males
#stats: 16, 35, 67% female
# mod is 12-18, high is 19+ 

risk_data <- c(0:33)
#mod is 13 -18, high is 19+


return_risk <- function(score, gender = "Male", ... ){
  if(gender == "Male"){
  if(score <= 11){
    return("Low")
  } else if(score >= 12 & score <=18){
      return("Mod")
    }else{
      return("High")}
  } else {
    if(score <= 12){
      return("Low")
    } else if(score >= 13 & score <=18){
      return("Mod")
    }else{
      return("High")}
  }
}

#return_risk(score = mock_data$Score, gender = mock_data$`Client Gender`)
#sapply( mock_data$Score, gender = mock_data$`Client Gender`, return_risk)

