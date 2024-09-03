tabela_podataka = xlsread('podaci.xlsx');

%%

%%KORELACIJA

korelacija = corr(tabela_podataka);
%%

%%CRTANJE GRAFIKA KORELACIJE

imagesc(korelacija);
colormap(jet);
colorbar;

labelNames = {'Starost','TM','TV','Pusenje','WBC','NEU','LYM','MONO','EOS','BASO','RBC','HGB','HCT','MCV','MCH','MCHC','RDW','RETC','IRF','NRBC','PLT','MPV','%rP','aPTT','PT','TT','Aptt','PT','TT','FBG','D-dimer','AT','vWF','AGR ADP','AGR TRAP','AGR ASPI','AGR COL','sec.','sec.','mA/min','%','mA','%'};
set(gca,'XTickLabel',labelNames);   
set(gca,'YTickLabel',labelNames); 
plottools('on');
%%

%%IZDVAJANJE OBILJEZJA I LABELA (TARGETA) IZ BAZE PODATAKA

obiljezja = tabela_podataka(:, [1, 2, 3, 4, 6, 32, 33, 34, 35]);
target1 = tabela_podataka(:, 43);
target2 = tabela_podataka(:, 45);

broj_targeta1 = numel(tabela_podataka(:,43));                               %broj podataka (pacijenata) u targetu1
target1_po_velicini = sort(tabela_podataka(:,43),'ascend');                 %sortiranje targeta1 od min do max vrednosti
target1_klasa1 = sum(tabela_podataka(:,43) <= 95);                          %odredjivanje granicnih vrednosti za podelu u 3 klase (k1=45, k2=43, k3=45)
target1_klasa2 = sum(tabela_podataka(:,43) > 95 & tabela_podataka(:,43) < 111);
target1_klasa3 = sum(tabela_podataka(:,43) >= 111);


broj_targeta2 = numel(tabela_podataka(:,45));                               %broj podataka (pacijenata) u targetu2
target2_po_velicini = sort(tabela_podataka(:,45),'ascend');                 %sortiranje targeta2 od min do max vrednosti
target2_klasa1 = sum(tabela_podataka(:,45) <= 99);                          %odredjivanje granicnih vrednosti za podelu u 3 klase (k1=43, k2=43, k3=47)
target2_klasa2 = sum(tabela_podataka(:,45) > 99 & tabela_podataka(:,45) <= 109);
target2_klasa3 = sum(tabela_podataka(:,45) > 109);


broj_pacijenata = size(tabela_podataka, 1);

target1_ = [];
for i = 1 : broj_pacijenata
    if target1(i) <= 95
        target1_(i) = 1;
    end
    if target1(i) > 95 & target1(i) < 111
        target1_(i) = 2;
    end
    if target1(i) >= 111
        target1_(i) = 3;
    end
end

target2_ = [];
for i = 1 : broj_pacijenata
    if target2(i) <= 99
        target2_(i) = 1;
    end
    if target2(i) > 99 & target2(i) <= 109
        target2_(i) = 2;
    end
    if target2(i) > 109
        target2_(i) = 3;
    end
end


target1_ = target1_';
target2_ = target2_';
%%

%%STABLO ODLUKE ZA TARGET1

sve_greske = [];                                            
for i = 1 : 300
    model_stablo_odluke1 = fitctree(obiljezja, target1_, 'CrossVal', 'On', 'KFold', 10, 'MaxNumSplits', i, 'Prior','uniform');                        
    greska = kfoldLoss(model_stablo_odluke1);         
    sve_greske = [sve_greske; greska];   
end
min_greska = min(sve_greske);
[~, opt_br_stab] = ismember(min_greska, sve_greske);
model_DT = fitctree(obiljezja, target1_, 'MaxNumSplits', opt_br_stab, 'Prior', 'uniform');  
view(model_DT)  
view(model_DT,'mode','graph')
%%
%%STABLO ODLUKE ZA TARGET2

sve_greske = [];                                            
for i = 1 : 30
    model_stablo_odluke2 = fitctree(obiljezja, target2_, 'CrossVal', 'On', 'KFold', 10, 'MaxNumSplits', i, 'Prior','uniform');                        
    greska = kfoldLoss(model_stablo_odluke2);         
    sve_greske = [sve_greske; greska];   
end
min_greska = min(sve_greske);
[~, opt_br_stab] = ismember(min_greska, sve_greske);
model_DT = fitctree(obiljezja, target2_, 'MaxNumSplits', opt_br_stab, 'Prior', 'uniform');  
view(model_DT)  
view(model_DT,'mode','graph')


%%
%==============================================================================================================================
%*********************************************************TARGET1**************************************************************
%==============================================================================================================================

%%OBUCAVANJE MODELA ZA TARGET1

vrsta_kernela = {'linear', 'gaussian', 'polynomial'};   % koriste se 3 vrste kernel funkcije

for k = 1 : numel(vrsta_kernela)
    t1{k} = templateSVM('Standardize', true,'KernelFunction', vrsta_kernela{k});    % for petlja za izvrsavanje svm sa razlicitim kernelima 
    svm_model_1{k} = fitcecoc(obiljezja, target1_, 'Learners',t1{k},'Prior','uniform');
%   svm_model_1{k} = fitcecoc(obiljezja, target1_, 'Learners',t1{k},'Prior','uniform','OptimizeHyperparameters', 'auto', 'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus'));
%     svm_model_1{k} = fitcecoc(obiljezja, target1_, 'Learners',t1{k},'Prior','uniform','OptimizeHyperparameters', 'auto', 'HyperparameterOptimizationOptions',struct('Optimizer',...
%     'randomsearch'));
    cv_model_1{k} = crossval(svm_model_1{k}, 'KFold', 15);
    izlaz_1{k} = kfoldPredict(cv_model_1{k}); 
    C1{k} = confusionmat(target1_, izlaz_1{k});
    save('izlazz_1','izlaz_1');
    save('targett1_', 'target1_')
end 


%%

%%CRTANJE MATRICE KONFUZIJE ZA TARGET1 
   
matrica_konfuzije_11 = confusionchart(target1_, izlaz_1{1,1});
savefig('matrica_konfuzije_11')
%%

matrica_konfuzije_12 = confusionchart(target1_, izlaz_1{1,2});
savefig('matrica_konfuzije_12_randomsearch')
%%

matrica_konfuzije_13 = confusionchart(target1_, izlaz_1{1,3});
savefig('matrica_konfuzije_13_randomsearch')
%%

for i = 1 : numel(vrsta_kernela)
    true_positive1_1{i} = C1{i}(1,1);
    false_positive1_1{i} = C1{i}(2,1) + C1{i}(3,1);
    false_negative1_1{i} = C1{i}(1,2) + C1{i}(1,3);
    true_negative1_1{i} = C1{i}(2,2) + C1{i}(2,3) + C1{i}(3,2) + C1{i}(3,3);
    
    true_positive1_2{i} = C1{i}(2,2);
    false_positive1_2{i} = C1{i}(1,2) + C1{i}(3,2);
    false_negative1_2{i} = C1{i}(2,1) + C1{i}(2,3);
    true_negative1_2{i} = C1{i}(1,1) + C1{i}(3,1) + C1{i}(1,3) + C1{i}(3,3);
    
    true_positive1_3{i} = C1{i}(3,3);
    false_positive1_3{i} = C1{i}(1,3) + C1{i}(2,3);
    false_negative1_3{i} = C1{i}(3,1) + C1{i}(3,2);
    true_negative1_3{i} = C1{i}(1,1) + C1{i}(2,1) + C1{i}(1,2) + C1{i}(2,2); 

   
    preciznost1_1{i} = true_positive1_1{i} / (true_positive1_1{i} + false_positive1_1{i});
    osjetljivost1_1{i} = true_positive1_1{i} / (true_positive1_1{i} + false_negative1_1{i});
    specificnost1_1{i} = true_negative1_1{i} / (true_negative1_1{i} + false_positive1_1{i});
    tacnost1_1{i} = (true_positive1_1{i} + true_negative1_1{i}) / (true_positive1_1{i} + true_negative1_1{i} + false_positive1_1{i} + false_negative1_1{i});
   
    preciznost1_2{i} = true_positive1_2{i} / (true_positive1_2{i} + false_positive1_2{i});
    osjetljivost1_2{i} = true_positive1_2{i} / (true_positive1_2{i} + false_negative1_2{i});
    specificnost1_2{i} = true_negative1_2{i} / (true_negative1_2{i} + false_positive1_2{i});
    tacnost1_2{i} = (true_positive1_2{i} + true_negative1_2{i}) / (true_positive1_2{i} + true_negative1_2{i} + false_positive1_2{i} + false_negative1_2{i});

    preciznost1_3{i} = true_positive1_3{i} / (true_positive1_3{i} + false_positive1_3{i});
    osjetljivost1_3{i} = true_positive1_3{i} / (true_positive1_3{i} + false_negative1_3{i});
    specificnost1_3{i} = true_negative1_3{i} / (true_negative1_3{i} + false_positive1_3{i});
    tacnost1_3{i} = (true_positive1_3{i} + true_negative1_3{i}) / (true_positive1_3{i} + true_negative1_3{i} + false_positive1_3{i} + false_negative1_3{i});

    preciznost1{i} = (preciznost1_1{i} + preciznost1_2{i} + preciznost1_3{i}) / 3 * 100;
    osjetljivost1{i} = (osjetljivost1_1{i} + osjetljivost1_2{i} + osjetljivost1_3{i}) / 3 * 100;
    specificnost1{i} = (specificnost1_1{i} + specificnost1_2{i} + specificnost1_3{i}) / 3 * 100;
    tacnost1{i} = (tacnost1_1{i} + tacnost1_2{i} + tacnost1_3{i}) / 3 * 100;
    parametri1{i} = [preciznost1{i}' osjetljivost1{i}' specificnost1{i}' tacnost1{i}'];
%     disp('preciznost osjetljivost specificnost tacnost')
%     disp(parametri1{i})
end

vrsta1 = [preciznost1{1,1} preciznost1{1,2} preciznost1{1,3}]';
vrsta2 = [osjetljivost1{1,1} osjetljivost1{1,2} osjetljivost1{1,3}]';
vrsta3 = [specificnost1{1,1} specificnost1{1,2} specificnost1{1,3}]';
vrsta4 = [tacnost1{1,1} tacnost1{1,2} tacnost1{1,3}]';
tabela_randomsearch = table(['L';'G';'P'],vrsta1, vrsta2, vrsta3, vrsta4);
tabela_randomsearch.Properties.VariableNames = {'kernel\karakteristike' 'preciznost' 'osjetljivost' 'specificnost' 'tacnost'};
writetable(tabela_randomsearch, 'Rezultati za prvi target_randomsearch.dat');
%%

%%RACUNJANJE MERA ZA EVALUACIJU MODELA
% true_positive1_1 = C1(1,1);
% false_positive1_1 = C1(2,1) + C1(3,1);
% false_negative1_1 = C1(1,2) + C1(1,3);
% true_negative1_1 = C1(2,2) + C1(2,3) + C1(3,2) + C1(3,3);
% 
% true_positive1_2 = C1(2,2);
% false_positive1_2 = C1(1,2) + C1(3,2);
% false_negative1_2 = C1(2,1) + C1(2,3);
% true_negative1_2 = C1(1,1) + C1(3,1) + C1(1,3) + C1(3,3);
% 
% true_positive1_3 = C1(3,3);
% false_positive1_3 = C1(1,3) + C1(2,3);
% false_negative1_3 = C1(3,1) + C1(3,2);
% true_negative1_3 = C1(1,1) + C1(2,1) + C1(1,2) + C1(2,2); 
% 
% preciznost1_1 = true_positive1_1 / (true_positive1_1 + false_positive1_1);
% osjetljivost1_1 = true_positive1_1 / (true_positive1_1 + false_negative1_1);
% specificnost1_1 = true_negative1_1 / (true_negative1_1 + false_positive1_1);
% tacnost1_1 = (true_positive1_1 + true_negative1_1) / (true_positive1_1 + true_negative1_1 + false_positive1_1 + false_negative1_1);
% 
% preciznost1_2 = true_positive1_2 / (true_positive1_2 + false_positive1_2);
% osjetljivost1_2 = true_positive1_2 / (true_positive1_2 + false_negative1_2);
% specificnost1_2 = true_negative1_2 / (true_negative1_2 + false_positive1_2);
% tacnost1_2 = (true_positive1_2 + true_negative1_2) / (true_positive1_2 + true_negative1_2 + false_positive1_2 + false_negative1_2);
% 
% preciznost1_3 = true_positive1_3 / (true_positive1_3 + false_positive1_3);
% osjetljivost1_3 = true_positive1_3 / (true_positive1_3 + false_negative1_3);
% specificnost1_3 = true_negative1_3 / (true_negative1_3 + false_positive1_3);
% tacnost1_3 = (true_positive1_3 + true_negative1_3) / (true_positive1_3 + true_negative1_3 + false_positive1_3 + false_negative1_3);
% 
% preciznost1 = (preciznost1_1 + preciznost1_2 + preciznost1_3) / 3 * 100;
% osjetljivost1 = (osjetljivost1_1 + osjetljivost1_2 + osjetljivost1_3) / 3 * 100;
% specificnost1 = (specificnost1_1 + specificnost1_2 + specificnost1_3) / 3 * 100;
% tacnost1 = (tacnost1_1 + tacnost1_2 + tacnost1_3) / 3 * 100;
% parametri1 = [preciznost1 osjetljivost1 specificnost1 tacnost1];
% disp('preciznost osjetljivost specificnost tacnost')
% disp(parametri1)



%%
%==============================================================================================================================
%*********************************************************TARGET2**************************************************************
%==============================================================================================================================


%%OBUCAVANJE MODELA ZA TARGET2

vrsta_kernela = {'linear', 'gaussian', 'polynomial'};   % koriste se 3 vrste kernel funkcije

for k = 1 : numel(vrsta_kernela)
    t2{k} = templateSVM('Standardize', true,'KernelFunction', vrsta_kernela{k}); 
    svm_model_2{k} = fitcecoc(obiljezja, target2_, 'Learners',t2{k},'Prior','uniform','OptimizeHyperparameters', 'auto', 'HyperparameterOptimizationOptions',struct('Optimizer',...
    'randomsearch'));
    cv_model_2{k} = crossval(svm_model_2{k}, 'KFold', 15); 
    izlaz_2{k} = kfoldPredict(cv_model_2{k});
    C2{k} = confusionmat(target2_, izlaz_2{k});
end

%%

%%CRTANJE MATRICE KONFUZIJE ZA TARGET2

matrica_konfuzije_21 = confusionchart(target2_, izlaz_2{1,1});
savefig('matrica_konfuzije_21_randomsearch_target2')
%%

matrica_konfuzije_22 = confusionchart(target2_, izlaz_2{1,2});
savefig('matrica_konfuzije_22_randomsearch_target2')
%%

matrica_konfuzije_23 = confusionchart(target2_, izlaz_2{1,3});
savefig('matrica_konfuzije_23_randomsearch_target2')
%%

for i = 1 : numel(vrsta_kernela)
    true_positive2_1{i} = C2{i}(1,1);
    false_positive2_1{i} = C2{i}(2,1) + C2{i}(3,1);
    false_negative2_1{i} = C2{i}(1,2) + C2{i}(1,3);
    true_negative2_1{i} = C2{i}(2,2) + C2{i}(2,3) + C2{i}(3,2) + C2{i}(3,3);
    
    true_positive2_2{i} = C2{i}(2,2);
    false_positive2_2{i} = C2{i}(1,2) + C2{i}(3,2);
    false_negative2_2{i} = C2{i}(2,1) + C2{i}(2,3);
    true_negative2_2{i} = C2{i}(1,1) + C2{i}(3,1) + C2{i}(1,3) + C2{i}(3,3);
    
    true_positive2_3{i} = C2{i}(3,3);
    false_positive2_3{i} = C2{i}(1,3) + C2{i}(2,3);
    false_negative2_3{i} = C2{i}(3,1) + C2{i}(3,2);
    true_negative2_3{i} = C2{i}(1,1) + C2{i}(2,1) + C2{i}(1,2) + C2{i}(2,2); 

   
    preciznost2_1{i} = true_positive2_1{i} / (true_positive2_1{i} + false_positive2_1{i});
    osjetljivost2_1{i} = true_positive2_1{i} / (true_positive2_1{i} + false_negative2_1{i});
    specificnost2_1{i} = true_negative2_1{i} / (true_negative2_1{i} + false_positive2_1{i});
    tacnost2_1{i} = (true_positive2_1{i} + true_negative2_1{i}) / (true_positive2_1{i} + true_negative2_1{i} + false_positive2_1{i} + false_negative2_1{i});
   
    preciznost2_2{i} = true_positive2_2{i} / (true_positive2_2{i} + false_positive2_2{i});
    osjetljivost2_2{i} = true_positive2_2{i} / (true_positive2_2{i} + false_negative2_2{i});
    specificnost2_2{i} = true_negative2_2{i} / (true_negative2_2{i} + false_positive2_2{i});
    tacnost2_2{i} = (true_positive2_2{i} + true_negative2_2{i}) / (true_positive2_2{i} + true_negative2_2{i} + false_positive2_2{i} + false_negative2_2{i});

    preciznost2_3{i} = true_positive2_3{i} / (true_positive2_3{i} + false_positive2_3{i});
    osjetljivost2_3{i} = true_positive2_3{i} / (true_positive2_3{i} + false_negative2_3{i});
    specificnost2_3{i} = true_negative2_3{i} / (true_negative2_3{i} + false_positive2_3{i});
    tacnost2_3{i} = (true_positive2_3{i} + true_negative2_3{i}) / (true_positive2_3{i} + true_negative2_3{i} + false_positive2_3{i} + false_negative2_3{i});

    preciznost2{i} = (preciznost2_1{i} + preciznost2_2{i} + preciznost2_3{i}) / 3 * 100;
    osjetljivost2{i} = (osjetljivost2_1{i} + osjetljivost2_2{i} + osjetljivost2_3{i}) / 3 * 100;
    specificnost2{i} = (specificnost2_1{i} + specificnost2_2{i} + specificnost2_3{i}) / 3 * 100;
    tacnost2{i} = (tacnost2_1{i} + tacnost2_2{i} + tacnost2_3{i}) / 3 * 100;
    parametri1{i} = [preciznost1{i}' osjetljivost1{i}' specificnost1{i}' tacnost1{i}'];
%     disp('preciznost osjetljivost specificnost tacnost')
%     disp(parametri1{i})
end

vrsta12 = [preciznost2{1,1} preciznost2{1,2} preciznost2{1,3}]';
vrsta22 = [osjetljivost2{1,1} osjetljivost2{1,2} osjetljivost2{1,3}]';
vrsta32 = [specificnost2{1,1} specificnost2{1,2} specificnost2{1,3}]';
vrsta42 = [tacnost2{1,1} tacnost2{1,2} tacnost2{1,3}]';
tabela2_randomsearch = table(['L';'G';'P'],vrsta12, vrsta22, vrsta32, vrsta42);
tabela2_randomsearch.Properties.VariableNames = {'kernel\karakteristike' 'preciznost' 'osjetljivost' 'specificnost' 'tacnost'};
writetable(tabela2_randomsearch, 'Rezultati za drugi target_randomsearch.dat');
%%

%%RACUNJANJE MERA ZA EVALUACIJU MODELA
% true_positive2_1 = C2(1,1);
% false_positive2_1 = C2(2,1) + C2(3,1);
% false_negative2_1 = C2(1,2) + C2(1,3);
% true_negative2_1 = C2(2,2) + C2(2,3) + C2(3,2) + C2(3,3);
% 
% true_positive2_2 = C2(2,2);
% false_positive2_2 = C2(1,2) + C2(3,2);
% false_negative2_2 = C2(2,1) + C2(2,3);
% true_negative2_2 = C2(1,1) + C2(3,1) + C2(1,3) + C2(3,3);
% 
% true_positive2_3 = C2(3,3);
% false_positive2_3 = C2(1,3) + C2(2,3);
% false_negative2_3 = C2(3,1) + C2(3,2);
% true_negative2_3 = C2(1,1) + C2(2,1) + C2(1,2) + C2(2,2); 
% 
% preciznost2_1 = true_positive2_1 / (true_positive2_1 + false_positive2_1);
% osjetljivost2_1 = true_positive2_1 / (true_positive2_1 + false_negative2_1);
% specificnost2_1 = true_negative2_1 / (true_negative2_1 + false_positive2_1);
% tacnost2_1 = (true_positive2_1 + true_negative2_1) / (true_positive2_1 + true_negative2_1 + false_positive2_1 + false_negative2_1);
% 
% preciznost2_2 = true_positive2_2 / (true_positive2_2 + false_positive2_2);
% osjetljivost2_2 = true_positive2_2 / (true_positive2_2 + false_negative2_2);
% specificnost2_2 = true_negative2_2 / (true_negative2_2 + false_positive2_2);
% tacnost2_2 = (true_positive2_2 + true_negative2_2) / (true_positive2_2 + true_negative2_2 + false_positive2_2 + false_negative2_2);
% 
% preciznost2_3 = true_positive2_3 / (true_positive2_3 + false_positive2_3);
% osjetljivost2_3 = true_positive2_3 / (true_positive2_3 + false_negative2_3);
% specificnost2_3 = true_negative2_3 / (true_negative2_3 + false_positive2_3);
% tacnost2_3 = (true_positive2_3 + true_negative2_3) / (true_positive2_3 + true_negative2_3 + false_positive2_3 + false_negative2_3);
% 
% preciznost2 = (preciznost2_1 + preciznost2_2 + preciznost2_3) / 3 * 100;
% osjetljivost2 = (osjetljivost2_1 + osjetljivost2_2 + osjetljivost2_3) / 3 * 100;
% specificnost2 = (specificnost2_1 + specificnost2_2 + specificnost2_3) / 3 * 100;
% tacnost2 = (tacnost1_1 + tacnost2_2 + tacnost1_3) / 3 * 100;
% parametri2 = [preciznost2 osjetljivost2 specificnost2 tacnost2];
% disp('preciznost osjetljivost specificnost tacnost')
% disp(parametri2)
