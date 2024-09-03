function [parametri_prosek, C] = master_SVM(tabela, dijagnoza)
    % Funkcija za predikciju bazirana na SVM metodi. Funkcija radi na
    % skupom sa 3 klase. Kao rezultat funkcije dobija se matrica konfuzije
    % C i pokazatelji uspesnosti predikcije: osetljivost, specificnost, tacnost i
    % preciznost,respektivno.
  
    %t = templateSVM('Standardize', true, 'KernelFunction', 'rbf');
    %t = templateSVM('Standardize', true, 'KernelFunction', 'linear');
    t = templateSVM('Standardize', true, 'KernelFunction', 'polynomial');
    model_SVM = fitcecoc(tabela, dijagnoza, 'Learners',t,'Prior','uniform');
 
  
%     predicted_labels = predict(model_SVM, tabela);          % nad skupom za obuku
%     C = confusionmat(dijagnoza, predicted_labels');
    
    cv_model = crossval(model_SVM, 'KFold', 10);    % kros-validacija sa 10 particija
    izlaz = kfoldPredict(cv_model);
    C = confusionmat(dijagnoza, izlaz);
     
    TP_1 = C(1,1);
    FP_1 = C(2,1) + C(3,1);
    FN_1 = C(1,2) + C(1,3);
    TN_1 = C(2,2) + C(2,3) + C(3,2) + C(3,3);

    TP_2 = C(2,2);
    FP_2 = C(1,2) + C(3,2);
    FN_2 = C(2,1) + C(2,3);
    TN_2 = C(1,1) + C(1,3) + C(3,1) + C(3,3);

    TP_3 = C(3,3);
    FP_3 = C(1,3) + C(2,3);
    FN_3 = C(3,1) + C(3,2);
    TN_3 = C(1,1) + C(1,2) + C(2,1) + C(2,2);
    
    Osetljivost_1 = TP_1 / (TP_1 + FN_1); 
    Specificnost_1 = TN_1 / (FP_1 + TN_1); 
    Tacnost_1 = (TP_1 + TN_1) / (TP_1 + FN_1 + FP_1 + TN_1) * 100;  
    Preciznost_1 = TP_1 /(TP_1 + FP_1);
    parametri_1 = [Osetljivost_1; Specificnost_1; Tacnost_1; Preciznost_1];

    Osetljivost_2 = TP_2 / (TP_2 + FN_2); 
    Specificnost_2 = TN_2 / (FP_2 + TN_2); 
    Tacnost_2 = (TP_2 + TN_2) / (TP_2 + FN_2 + FP_2 + TN_2) * 100;
    Preciznost_2 = TP_2 /(TP_2 + FP_2);
    parametri_2 = [Osetljivost_2; Specificnost_2; Tacnost_2; Preciznost_2];

    Osetljivost_3 = TP_3 / (TP_3 + FN_3); 
    Specificnost_3 = TN_3 / (FP_3 + TN_3); 
    Tacnost_3 = (TP_3 + TN_3) / (TP_3 + FN_3 + FP_3 + TN_3) * 100;
    Preciznost_3 = TP_3 /(TP_3 + FP_3);
    parametri_3 = [Osetljivost_3; Specificnost_3; Tacnost_3; Preciznost_3];


    osetljivost = (Osetljivost_1 + Osetljivost_2 + Osetljivost_3) / 3 * 100;
    specificnost = (Specificnost_1 + Specificnost_2 + Specificnost_3) / 3 * 100;
    tacnost = (Tacnost_1 + Tacnost_2 + Tacnost_3) / 3; 
    preciznost = (Preciznost_1 + Preciznost_2 + Preciznost_3) / 3 * 100;
    parametri_prosek = [osetljivost; specificnost; tacnost; preciznost];
end