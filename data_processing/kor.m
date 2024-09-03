clear all
close all

load tabela
load tabelaT
load dijagnoza
load dijagnozaT
korelacija = corr(tabela);
%%

%%CRTANJE GRAFIKA KORELACIJE

imagesc(korelacija);
colormap(jet);
colorbar;

labelNames = {'Starost','TM','TV','Pusenje','WBC','NEU','LYM','MONO','EOS','BASO','RBC','HGB','HCT','MCV','MCH','MCHC','RDW','RETC','IRF','NRBC','PLT','MPV','%rP','aPTT','PT','TT','Aptt','PT','TT','FBG','D-dimer','AT','vWF','AGR ADP','AGR TRAP','AGR ASPI','AGR COL','sec.','sec.','mA/min','%','mA','%'};
set(gca,'XTickLabel',labelNames);   
set(gca,'YTickLabel',labelNames); 
plottools('on');