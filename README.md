# 1. In EMu - Audit Trails module:

**1.1. Retrieve eaudit records for affected records that need to be recalled.**

For example, to find a user's edits to Catalog Multimedia-attachments, search for:  
- Module (AudTable) = ecatalogue
- Operation (AudOperation) = update
- Old Value (AudOldValue_tab) = MulMultiMediaRef_tab
- User (AudUser) = [user id]
 
**1.2. Report out the results. **

Use the "irn and data for old-v-new" report.

# 2. In a file explorer:

**2.1.** Add the 'Group1.csv' report file to this repo's "data" directory.

# 3.  In R / RStudio:

**3.1.** Run the [recordRecover.R](recordRecover.R) script


# Other background:
- How to [install R & RStudio](https://posit.co/download/rstudio-desktop/) 
- How to [clone a repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository?tool=desktop&platform=windows) 
