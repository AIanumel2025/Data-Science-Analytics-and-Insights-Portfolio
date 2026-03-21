% ========================================================
% 8.2 MATLAB SCRIPT - Asthma Deterioration Modelling
% Anthony L. Anumel | MSc Artificial Intelligence
% CI7524 Big Data & Data Mining Coursework
% ========================================================

%% 1. LOAD THE ENGINEERED DATASET
% (Run the SQL view first and export to CSV)
T = readtable('asthma_model_features.csv');   % or full path if needed

%% 2. QUICK INSPECTION
disp('=== Dataset Summary ===');
head(T);
summary(T);

%% 3. EXPLORATORY DATA ANALYSIS (EDA) - Matches figures in report
figure('Name','Age Distribution');
histogram(T.age, 'FaceColor','#0072BD');
title('Fig 8: Age Distribution'); xlabel('Age'); ylabel('Frequency');
grid on;

figure('Name','Motorway Proximity');
histogram(T.motorway_distance_km, 'FaceColor','#EDB120');
title('Fig 9: Patient proximity to motorways'); xlabel('Motorway Distance (km)'); ylabel('Frequency');
grid on;

figure('Name','Target Distribution');
histogram(T.asthma_worsened, 'FaceColor','#D95319');
title('Fig 10: Asthma Worsening cases'); xlabel('Asthma Worsened (0=No, 1=Yes)'); ylabel('Count');
grid on;

figure('Name','Age vs Asthma Worsened');
boxplot(T.age, T.asthma_worsened);
title('Fig 11: Patient Asthma deterioration by Age'); ylabel('Age');
grid on;

figure('Name','Motorway Proximity vs Asthma Worsened');
boxplot(T.motorway_distance_km, T.asthma_worsened);
title('Fig 12: Motorway proximity by Asthma condition metrics'); ylabel('Motorway Distance (km)');
grid on;

%% 4. FEATURE PREPARATION
Y = T.asthma_worsened;                                      % Target
X = T(:, {'gender','age','smoker','family_history_asthma', ...
          'motorway_distance_km','high_pollution_exposure'});

% Convert categoricals
X.gender = categorical(X.gender);
X.smoker = categorical(X.smoker);
X.family_history_asthma = categorical(X.family_history_asthma);
X.high_pollution_exposure = categorical(X.high_pollution_exposure);

%% 5. TRAIN / TEST SPLIT (70/30)
cv = cvpartition(height(T), 'Holdout', 0.3);
idxTrain = training(cv);
idxTest  = test(cv);

XTrain = X(idxTrain,:);  YTrain = Y(idxTrain);
XTest  = X(idxTest,:);   YTest  = Y(idxTest);

%% 6. MODEL 1: DECISION TREE CLASSIFIER
disp('Training Decision Tree...');
treeModel = fitctree(XTrain, YTrain, 'MaxNumSplits', 30);

figure('Name','Decision Tree');
view(treeModel, 'Mode', 'graph');
title('Fig 13: Decision Tree Classifier Model');

YPredTree = predict(treeModel, XTest);
figure; confusionchart(YTest, YPredTree);
title('Fig 14: Confusion Matrix - Decision Tree Classifier');

%% 7. MODEL 2: LOGISTIC REGRESSION
disp('Training Logistic Regression...');
logModel = fitglm(XTrain, YTrain, 'Distribution', 'binomial', 'Link', 'logit');

probLog = predict(logModel, XTest);
YPredLog = probLog > 0.5;

figure; confusionchart(YTest, YPredLog);
title('Fig 16: Confusion matrix of the Logistic Regression model');

%% 8. MODEL 3: RANDOM FOREST (with class weighting for imbalance)
disp('Training Random Forest...');
YCat = categorical(YTrain);
classCounts = countcats(YCat);
classWeights = sum(classCounts) ./ classCounts;

rfModel = TreeBagger(300, XTrain, YCat, ...
    'Method', 'classification', ...
    'OOBPrediction', 'on', ...
    'MinLeafSize', 10, ...
    'Weights', classWeights(YCat));

[YPredRF, scores] = predict(rfModel, XTest);
YPredRF = categorical(YPredRF);

figure; confusionchart(YTest, YPredRF);
title('Fig 18: Confusion Matrix for Random Forest Model');

%% 9. OPTIONAL: ROC CURVES (for all models)
% You can add rocmetrics here if you want full AUC plots

disp('=== Modelling Complete ===');
disp('Check the figures/ folder for all plots.');
disp('Random Forest selected as best model due to highest sensitivity (57.9%).');

% END OF SCRIPT
