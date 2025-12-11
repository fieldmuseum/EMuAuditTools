# Recover records that were accidentally deleted.

library('tidyr')
library('readr')
library('stringi')
library('stringr')


# # # # # # # # # # # # # # # # # # # # #
# I. In EMu - Audit Trails module    ####
#
#   1) Retrieve audit records for affected records that need to be recalled.
#     - e.g., to find a user's edits to Catalog Multimedia-attachments, search: 
#           - Module (AudTable) = ecatalogue 
#           - Operation (AudOperation) = delete
#           - User (AudUser) = [user id]
#           - Date (AudDate) = [date of accidental delete]
# 
#   2) Report out the results. 
#     - Use the "Admin - Recover deleted Cat records" report.
#
#
# II. In a file explorer             ####
#
#   1) Add the 'Group1.csv' report file to this repo's "data" directory.
# 
#
# III.  In R / RStudio               ####
# 
#   1) Run this "record_RecoverDeleted.R" script
#


# Import data ####

raw_audit <- read_csv('real_data/Group1.csv')

raw_aud <- unique(raw_audit[
  tolower(raw_audit$AudOperation) == 'delete',
  c("AudKey", "AudColumnName", "AudOldValue")])

# cleanup raw values
for (i in 1:NROW(raw_aud)) {
  
  raw_aud$AudOldValue[i] <- stri_replace_all_regex(raw_aud$AudOldValue[i],
                                                   paste0(raw_aud$AudColumnName[i], ':\\s*'),
                                                   '')
  raw_aud$AudOldValue[i] <- stri_replace_all_regex(raw_aud$AudOldValue[i],
                                                   '\\s*(</*(atom|table)>)+\\s*',
                                                   '')
  raw_aud$AudOldValue[i] <- stri_replace_all_regex(raw_aud$AudOldValue[i],
                                                   '\\s*(</*tuple>)+\\s*',
                                                   '|')
  raw_aud$AudOldValue[i] <- stri_replace_all_regex(raw_aud$AudOldValue[i],
                                                   '^\\||\\|$',
                                                   '')
  
}

# raw_parsed <- separate_wider_delim(raw_aud, AudOldValue, delim = "|", 
#                                    names_sep = "_", 
#                                    too_few = 'align_start',
#                                    too_many = 'drop')

raw_spread <- pivot_wider(raw_aud, id_cols = AudKey, names_from = AudColumnName, values_from = AudOldValue)


cols_to_keep <- c("AdmGUIDValue_tab", 
                  "AdmGUIDType_tab", "AdmGUIDIsPreferred_tab", 
                  "AdmPublishWebNoPassword", "AdmPublishWebPassword",
                  "CatMuseum", "CatDepartment",
                  "CatCatalog", "CatCatalogSubset",
                  "CatCatalogueNo", "CatProjectIz_tab", "CatRecordType", 
                  "ColCollectionEventRef", 
                  "ConConditionPeriodType", "DeaTransferOfTitle",
                  "DesKDescription0", "DesKPreferred_tab", "DesKType_tab", 
                  "GeoHazardous", "GeoProcessed", "GeoValuation",
                  "IdeTaxonRef_tab", "IdeFiledAs_tab", "IdeHasTypeStatus",
                  "LocFisCurrentLocation_tab",
                  "LotDescription_tab", "LotOwnerRef_tab",
                  "LotCountDry", "LotCountWet", "LotDry", "LotTypeStatus",
                  "PhePrepPartID_tab", "PreCount_tab", 
                  # "PreMammalsPrepType_tab", "PreOPrepType_tab",
                  "PriAccessionNumberRef",
                  "PriSiteRef",
                  "PriSiteCENumberRef",
                  "PriTissue", "PriXray", 
                  "PrvCurrentStorage_tab", "PrvEventSequence_tab", 
                  "PrvPreservation_tab", "PrvSeries_tab",
                  "RelIsParent", "SecDepartment_tab", "SecRecordStatus", 
                  "SpeHReceivedAs", 
                  "ValValuationPeriodType"
                  )

raw_spread2 <- raw_spread[,c('irn', sort(cols_to_keep))]

for (j in 1:NCOL(raw_spread2)) {

  if (NROW(unique(raw_spread2[[j]])) == 1) {
    
    if (is.na(unique(raw_spread2[[j]]))) {
    
      raw_spread2 <- raw_spread2[,-j]
    
    }
  }
}


table_cols <- colnames(raw_spread2)[grepl("_tab|0", colnames(raw_spread2)) > 0]


raw_spread2 <- raw_spread2 %>%
  separate_wider_delim(all_of(table_cols),
                       names_sep = "_",  '|',
                       too_few = 'align_start')

# Prep colnames for import
colnames(raw_spread2) <- stri_replace_all_regex(colnames(raw_spread2),
                                                '_(\\d+)$',
                                                '($1)')

colnames(raw_spread2)[grepl('Ref', colnames(raw_spread2)) > 0] <- 
  paste0(colnames(raw_spread2)[grepl('Ref', colnames(raw_spread2)) > 0],
         '.irn')

# Output raw-parsed and import-prepped recovered records
write_csv(raw_spread2, 
          paste0("ecatalog_fix_PreppedImport",
                 "_", Sys.Date(),
                 ".csv"),
          na = "")

write_csv(raw_spread, 
          paste0("ecatalog_RAW",
                 "_", Sys.Date(),
                 ".csv"),
          na = "")
