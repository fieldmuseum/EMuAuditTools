# 1. In EMu - Audit Trails module:

**1.1. Retrieve Audit records.**

For example, to find edits to existing Catalog records' Multimedia-attachments in 2025, search for:  
- Module (AudTable) = ecatalogue
- Operation (AudOperation) = update
- Old Value (AudOldValue_tab) = MulMultiMediaRef_tab
- Date (AudDate) = 2025
 
**1.2. Report out the Audit records.**

Use the "irn and data for old-v-new" CSV report.

# 2. In a file explorer:

**2.1.** Add the 'Group1.csv' report file to this repo's "data" directory.

See the [example output CSV here](https://github.com/fieldmuseum/EMuAuditTools/blob/main/data/Group1.csv).

# 3.  In R / RStudio:

**3.1.** Run the [recordRecover.R](recordRecover.R) script


# Other background:
- How to [install R & RStudio](https://posit.co/download/rstudio-desktop/) 
- How to [clone a repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository?tool=desktop&platform=windows) 
