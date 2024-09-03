% Neophodno izvrsiti selekciju obelezja a to se moze postici metodom stabla oduke.
% Takodje, omoguceno je i graficko predstavljanje rezultata, sto lekarima 
% omogucava da razumeju proces odabira parametara.


clear
load tabela
load tabelaT
load dijagnoza
load dijagnozaT

%%
% sve_greske = [];                                            
% for i = 1 : 30
%     model = fitctree(tabelaT, tug, 'CrossVal', 'On', 'KFold', 10, 'MaxNumSplits', i, 'Prior','uniform');                        
%     greska = kfoldLoss(model);         
%     sve_greske = [sve_greske; greska];   
% end
% min_greska = min(sve_greske);
% [~, opt_br_stab] = ismember(min_greska, sve_greske);
opt_br_stab = 25;
model_DT = fitctree(tabelaT, tug, 'MaxNumSplits', opt_br_stab, 'Prior', 'uniform');  
view(model_DT)  
view(model_DT,'mode','graph')

md1 = fitctree(tabela, K_level);
importance = predictorImportance(md1);

%     predicted_labels = predict(model_RF, tabela);          % nad skupom za obuku
%     C = confusionmat(dijagnoza, predicted_labels');
    
%cv_model = crossval(model_DT, 'KFold', 15);    % kros-validacija sa 15 particija
%izlaz = kfoldPredict(cv_model);
%C = confusionmat(dijagnoza, izlaz);
