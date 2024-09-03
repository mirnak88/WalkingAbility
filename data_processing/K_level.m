% Kako setovi podataka nisu balansirani, odnosno broj pacijenata po klasama
% se razlikuje, neophodnno je izvrsiti balansiranost kako ne bi doslo do 
% favorizacije klase sa najvecim brojem ispitanika.

clear all
close all

load tabela
load dijagnoza
%%  K-LEVEL

% K-LEVEL

klevel = unique(K_level);                 % K-level ima moguce vrednosti: 1,2,3
klevel_1 = tabela(K_level==1, :);         % imamo 35 pacijenata
klevel_2 = tabela(K_level==2, :);         % imamo 54 pacijenta
klevel_3 = tabela(K_level==3, :);         % imamo 15 pacijenta             ---> ukupno 104

%% BALANSIRANJE K-LEVEL
% K1
br = [];
for i = 1:35
   br(i) = i; 
end
klevel_1 = [klevel_1 br']; 
% razlika_1 = 54-35   ---> razlika izmedju broja pacijenata 2. i 1. klase
indeksi_1 = [];
klevel_1_novo = zeros(19,20);                       
for i = 1:(54-35)                                  
     indeksi_1(i) = round(rand(1)*(35-1)+1);      
     klevel_1_novo(i, :) = klevel_1(klevel_1(:, 20)==indeksi_1(i), :);
end
klevel_1 = [klevel_1(:,1:end-1); klevel_1_novo(:,1:end-1)];

% K3
br = [];
for i = 1:15
   br(i) = i; 
end
klevel_3 = [klevel_3 br'];
% razlika_3 = 54-15   ---> razlika izmedju broja pacijenata 2. i 3. klase
indeksi_3 = [];
klevel_3_novo = zeros(39,20);                       
for i = 1:(54-15)                                  
     indeksi_3(i) = round(rand(1)*(15-1)+1);      
     klevel_3_novo(i, :) = klevel_3(klevel_3(:, 20)==indeksi_3(i), :);
end
klevel_3 = [klevel_3(:,1:end-1); klevel_3_novo(:,1:end-1)];

% K level balansirano
tabela = [klevel_1; klevel_2; klevel_3];
tabela = tabela(:, [2 5 8 10 15 16 17 19]);
% tabela = tabela(:, [2 3 6 8 10 14 15 16 17]);
dijagnoza = [ones(54,1); 2*ones(54,1); 3*ones(54,1)];

% opt_br_stab = 25;
% model_DT = fitctree(tabela, dijagnoza, 'MaxNumSplits', opt_br_stab, 'Prior', 'uniform');  
% view(model_DT)  
% view(model_DT,'mode','graph')

sacuvaj = 'tabela.mat';
save(sacuvaj, 'tabela');
sacuvaj = 'dijagnoza.mat';
save(sacuvaj, 'dijagnoza');