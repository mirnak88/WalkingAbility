clear all
close all


load tabela
load dijagnoza

%% SVM
[parametri_prosek_SVM, C_SVM] = master_SVM(tabela, dijagnoza);

