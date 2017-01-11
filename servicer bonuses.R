##this calculation is to determine the  bonus of receiving a stream of payments ahead of schedule
setwd("/Users/vtika/Documents/")
##dataset containing monthly rent, final rent, lease term and number of payments left##
misc_invoice_csv <- read.csv("/Users/vtika/Documents/misc invoice t2 total.csv", header = TRUE) 

misc_invoice_total <- data.frame(misc_invoice_csv)

#calculated field determining the month the customer cancelled their lease. This will 
misc_invoice_total$Cancellation.Month <- misc_invoice_total$SubLease_Lease_Term - misc_invoice_total$MLS_Standard_Rent_Unbilled_Months

misc_invoice_total$t_Monthly <- misc_invoice_total$Cancellation.Month
misc_invoice_total$t_final <- 2


misc_invoice_total$Dt_monthly_Rent <- misc_invoice_total$MLS_Monthly_Rent_at_Closing / (1+.02/12)
misc_invoice_total$Dt_final_Rent <- misc_invoice_total$MLS_Final_Rent_at_Closing / (1+.02/12)

misc_invoice_total$rec_servicer_bonus <- ((misc_invoice_total$MLS_Monthly_Rent_at_Closing - Dt_monthly_Rent) * (misc_invoice_total$Cancellation.Month - 2)) + (misc_invoice_total$MLS_Final_Rent_at_Closing - Dt_final_Rent)
misc_invoice_total$rec_servicer_bonus[is.na(misc_invoice_total$rec_servicer_bonus)] <- 0

sum(misc_invoice_total$rec_servicer_bonus)

servicer_bonus_data <- misc_invoice_total[, c(misc_invoice_total$SubLease_Lease_Number)]

write.csv(misc_invoice_total[, c("SubLease_Lease_Number", 
                                 "SubLease_Lease_Term",
                                 "MasterLease_Device_Residual_Value_at_Closing",
                                 "MLS_Monthly_Rent_at_Closing",
                                 "MLS_Final_Rent_at_Closing",
                                 "SubLease_Expiration_Month",
                                 "Cancellation.Month",
                                 "rec_servicer_bonus")] ,file = "/Users/vtika/Documents/Servicer bonus.csv")