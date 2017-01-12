##this calculation is to determine the  bonus of receiving a stream of payments ahead of schedule
setwd("/Users/vtika/Documents/")
##dataset containing monthly rent, final rent, lease term and number of payments left##
misc_invoice_csv <- read.csv("/Users/vtika/Documents/misc invoice t2 total.csv", header = TRUE) 

misc_invoice_total <- data.frame(misc_invoice_csv)

##setting variables##

DRV <- misc_invoice_total$MasterLease_Device_Residual_Value_at_Closing

is.na(misc_invoice_total$MLS_Final_Rent_at_Closing) <- 0 

##Calculate the device servicer bonus##

misc_invoice_total$device.serv.bonus <- DRV * (1-(1/(1+.02/12) ^ misc_invoice_total$MLS_Standard_Rent_Billed_Months))




#calculated field determining the month the customer cancelled their lease. This will 
misc_invoice_total$Cancellation.Month <- misc_invoice_total$SubLease_Lease_Term - misc_invoice_total$MLS_Standard_Rent_Unbilled_Months

misc_invoice_total$t_Monthly <- misc_invoice_total$Cancellation.Month
misc_invoice_total$t_final <- 2


misc_invoice_total$Dt_monthly_Rent <- misc_invoice_total$MLS_Monthly_Rent_at_Closing / (1+.02/12)
misc_invoice_total$Dt_final_Rent <- misc_invoice_total$MLS_Final_Rent_at_Closing / (1+.02/12)

misc_invoice_total$rec_servicer_bonus <- ((misc_invoice_total$MLS_Monthly_Rent_at_Closing - Dt_monthly_Rent) * (misc_invoice_total$Cancellation.Month - 2)) + (misc_invoice_total$MLS_Final_Rent_at_Closing - Dt_final_Rent)
misc_invoice_total$rec_servicer_bonus[is.na(misc_invoice_total$rec_servicer_bonus)] <- 0

write.csv(misc_invoice_total[, c("SubLease_Lease_Number", 
                                 "SubLease_Handset_Model_Name",
                                 "Serial_at_Closing",
                                 "Misc.invoice.treatment.concatenated",
                                 "SubLease_Lease_Term",
                                 "MLS_Monthly_Rent_at_Closing",
                                 "MLS_Final_Rent_at_Closing",
                                 "MasterLease_Device_Residual_Value_at_Closing",
                                 "MLS_Standard_Rent_Billed_Months" ,
                                 "MLS_Standard_Rent_Unbilled_Months",
                                 "Warehouse_Grade",
                                 "DRV.at.Lease.Term",
                                 "Cancellation.Month",
                                 "Servicing.Fee",
                                 "device.serv.bonus",
                                 "rec_servicer_bonus")] ,file = "/Users/vtika/Documents/Servicer bonus.csv")
