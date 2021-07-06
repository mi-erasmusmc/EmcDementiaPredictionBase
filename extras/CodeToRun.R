library(EmcDementiaPredictionBase)
#=======================
# USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:
outputFolder <- "./BaseResults"
options(andromedaTempFolder = "d:/temp")

# Details for connecting to the server:
dbms <- "pdw"
user <- NULL
pw <- NULL
server <- 'JRDUSAPSCTL01'
port <- 17001

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# connectionDetails <- NULL

# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- c("CDM_Optum_Panther_v1482.dbo",
                       "CDM_CPRD_v1299.dbo",
                       "CDM_IBM_MDCR_v1477.dbo",
                       "CDM_IQVIA_Germany_DA_v1376.dbo",
                       "CDM_Optum_Extended_SES_v1387.dbo")

cdmDatabaseName <- c('OPPANv1482',
                     "CPRDv1299",
                     "MDCRv1477",
                     "IQGERv1376",
                     "OPSESv1387")

cohortDatabaseSchema <- "Scratch.dbo"

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'EmcDementiaPredictionBaseCohort'

# pick the minimum count that will be displayed if creating the shiny app, the validation package, the 
# diagnosis or packaging the results to share 
minCellCount= 5

#======================
# PICK THINGS TO EXECUTE
#=======================
# want to generate a study protocol? Set below to TRUE
createProtocol <- FALSE
# want to generate the cohorts for the study? Set below to TRUE
createCohorts <- TRUE
# want to run a diagnoston on the prediction and explore results? Set below to TRUE
runDiagnostic <- FALSE
viewDiagnostic <- FALSE
# want to run the prediction study? Set below to TRUE
runAnalyses <- TRUE
sampleSize <- 1000000 # edit this to the number to sample if needed
# want to populate the protocol with the results? Set below to TRUE
createResultsDoc <- FALSE
# want to create a validation package with the developed models? Set below to TRUE
createValidationPackage <- FALSE
analysesToValidate = NULL
# want to package the results ready to share? Set below to TRUE
packageResults <- FALSE
# want to create a shiny app with the results to share online? Set below to TRUE
createShiny <- FALSE
# want to create a journal document with the settings and results populated? Set below to TRUE
createJournalDocument <- FALSE
analysisIdDocument = 1


#=======================
for (i in 1:length(cdmDatabaseName)) {
        
        EmcDementiaPredictionBase::execute(connectionDetails = connectionDetails,
                cdmDatabaseSchema = cdmDatabaseSchema[i],
                cdmDatabaseName = cdmDatabaseName[i],
                cohortDatabaseSchema = cohortDatabaseSchema,
                oracleTempSchema = oracleTempSchema,
                cohortTable = cohortTable,
                outputFolder = paste0(outputFolder,cdmDatabaseName[i]),
                createProtocol = createProtocol,
                createCohorts = createCohorts,
                runDiagnostic = runDiagnostic,
                viewDiagnostic = viewDiagnostic,
                runAnalyses = runAnalyses,
                createResultsDoc = createResultsDoc,
                createValidationPackage = createValidationPackage,
                analysesToValidate = analysesToValidate,
                packageResults = packageResults,
                minCellCount= minCellCount,
                createShiny = createShiny,
                createJournalDocument = createJournalDocument,
                analysisIdDocument = analysisIdDocument,
                sampleSize = sampleSize,
                onlyFetchData = FALSE)
}
# Uncomment and run the next line to see the shiny results:
# PatientLevelPrediction::viewMultiplePlp(outputFolder)
