# code to create the json prediction:
webApi <- "https://awsagunva1011.jnj.com:8443/WebAPI"

populationSettings <- list(PatientLevelPrediction::createStudyPopulationSettings(binary = T, 
                                                                                 includeAllOutcomes = T, 
                                                                                 firstExposureOnly = T, 
                                                                                 washoutPeriod = 365, 
                                                                                 removeSubjectsWithPriorOutcome = T, 
                                                                                 priorOutcomeLookback = 99999, 
                                                                                 requireTimeAtRisk = T, 
                                                                                 minTimeAtRisk = 1824, 
                                                                                 riskWindowStart = 1, 
                                                                                 startAnchor = 'cohort start', 
                                                                                 endAnchor = 'cohort start', 
                                                                                 riskWindowEnd = 1825, 
                                                                                 verbosity = 'INFO',
                                                                                 addExposureDaysToEnd = F,
                                                                                 addExposureDaysToStart = F))
modelList <- list(list("LassoLogisticRegressionSettings" = list("variance" = 0.01))
)
covariateSettings <- list(list(
  list(
    fnct = 'createCovariateSettings',
    settings = FeatureExtraction::createCovariateSettings(
      useDemographicsAgeGroup = T)
  )
))

# resrictOutcomePops <- data.frame(outcomeId = c(16428,16435),
#                                  populationSettingId = c(1,2))
# resrictModelCovs = data.frame(modelSettingId = c(1,1,2),
#                               covariateSettingId = c(1,2,1))

executionSettings <- list(washoutPeriod = 365,
                          minCovariateFraction = 0.00,
                          normalizeData = T,
                          testSplit = "stratified",
                          testFraction = 0.20,
                          splitSeed = 1000,
                          nfold = 3)

json <- createDevelopmentStudyJson(packageName = 'EmcDementiaPredictionBase',
                                   packageDescription = 'A package to create the full dementia prediction models.',
                                   createdBy = 'Henrik John',
                                   organizationName = 'Erasmus MC',
                                   targets = data.frame(targetId = c(22337),
                                                        cohortId = c(22337),
                                                        targetName = c('Target')),
                                   outcomes = data.frame(outcomeId = c(7414),
                                                         cohortId = c(7414),
                                                         outcomeName = c('Outcome')),
                                   populationSettings = populationSettings,
                                   modelList = modelList,
                                   covariateSettings = covariateSettings,
                                   resrictOutcomePops = NULL,
                                   resrictModelCovs = NULL,
                                   executionSettings = executionSettings,
                                   webApi = webApi,
                                   outputLocation = 'D:/hjohn/DementiaBase',
                                   jsonName = 'predictionAnalysisList.json')

specifications <- Hydra::loadSpecifications(file.path('D:/hjohn/DementiaBase', 'predictionAnalysisList.json'))
Hydra::hydrate(specifications = specifications, outputFolder = 'D:/hjohn/DementiaBase/EmcDementiaPredictionBase')
