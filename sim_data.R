#simstudy to create management dash
library("simstudy")

column_names<- c("Client ID", "PO ID", "Name", "Age", "Type", "Time Left",
                 "Risk Level", "Risk Trend", "Reassess Date", "Adult Type", "Violation Status", 
                 "Custodial Status", "Next Court Date", "Placement", "JAW", "Contact by Officer")

sim_data <- defData(varname = "Client Gender", dist = "binary", formula = .5)
sim_data <- defData(sim_data, varname = "PO ID", dist = "nonrandom", formula = "350", variance = 10)
sim_data <- defData(sim_data, varname = "Age", dist = "normal", formula = 15, variance = 5)
sim_data <- defData(sim_data, varname = "Type", dist = "categorical", formula = ".2;.3;.5",
                    variance = 5, link = "identity")

sim_risk_data <- genData(1000, sim_data)


