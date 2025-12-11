# Roll back records that were accidentally updated
# check audit for modified MulMultiMediaRef_tab

library('tidyr')
library('readr')
library('stringi')


# # # # # # # # # # # # # # # # # # # # #
# I. In EMu - Audit Trails module    ####
#
#   1) Retrieve audit records for affected records that need to be recalled.
#     - e.g., to find a user's edits to Catalog Multimedia-attachments, search: 
#           - Module (AudTable) = ecatalogue, 
#           - Operation (AudOperation) = update
#           - Old Value (AudOldValue_tab) = MulMultiMediaRef_tab
#           - User (AudUser) = [user id]
# 
#   2) Report out the results. 
#     - Use the "irn and data for old-v-new" report.
#
#
# II. In a file explorer             ####
#
#   1) Add the 'Group1.csv' report file to this repo's "data" directory.
# 
#
# III.  In R / RStudio               ####
# 
#   1) Run this "record_RollbackExisting.R" script
#


# Import data ####

raw_audit <- read_csv('data/Group1.csv')

raw_aud_old <- unique(raw_audit[
  grepl("MulMultiMediaRef_tab",raw_audit$AudOldValue) > 0,
  c("irn", "AudKey", "AudDate", "AudOldValue")])

raw_aud_new <- unique(raw_audit[
  grepl("MulMultiMediaRef_tab",raw_audit$AudNewValue) > 0,
  c("irn", "AudKey", "AudDate", "AudNewValue")])

raw_aud_old$cleanOldAll <- stri_extract_all_regex(raw_aud_old$AudOldValue,
                                                  "\\d+")

raw_aud_new$cleanNewAll <- stri_extract_all_regex(raw_aud_new$AudNewValue,
                                                  "\\d+")

aud_check <- merge(raw_aud_new[,c("irn", "AudKey","AudDate","cleanNewAll")],
                   raw_aud_old[,c("irn", "AudKey","AudDate","cleanOldAll")],
                   by = c("irn", "AudKey", "AudDate"),
                   all = TRUE)

aud_fix <- unique(aud_check[,c("AudKey", "cleanNewAll", "cleanOldAll")])

aud_fix <- aud_fix %>% unnest_wider(cleanOldAll, names_sep = "MM")
aud_fix <- aud_fix %>% unnest_wider(cleanNewAll, names_sep = "newMM")

colnames(aud_fix) <- c("irn", paste0("MulMultiMediaRef_tab(", 
                                    2:NCOL(aud_fix)-1, ").irn"))

write_csv(aud_fix, "ecatalog_fix_mm.csv", na = "")
