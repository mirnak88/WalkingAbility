% Kako setovi podataka nisu balansirani, odnosno broj pacijenata po klasama
% se razlikuje, neophodnno je izvrsiti balansiranost kako ne bi doslo do 
% favorizacije klase sa najvecim brojem ispitanika.

clear all
close all

load tabelaT
load dijagnozaT
%%  TUG

% TUG
TUG = unique(tug);                      % TUG ima moguce vrednosti: 1,2,3
TUG_1 = tabelaT(tug==1, :);              % imamo 38 pacijenata
TUG_2 = tabelaT(tug==2, :);              % imamo 29 pacijenta
TUG_3 = tabelaT(tug==3, :);              % imamo 28 pacijenta              ---> ukupno 98

%% BALANSIRANJE TUG
% TUG2
br = [];
for i = 1:29
   br(i) = i; 
end
TUG_2 = [TUG_2 br'];
% razlika_2 = 41-29   ---> razlika izmedju broja pacijenata 1. i 2. klase
indeksi_2 = [];
TUG_2_novo = zeros((41-29),20);                        % ima ih 6 jer je razlika izmedju broja pacijenata 6
for i = 1:(41-29)                                  
     indeksi_2(i) = round(rand(1)*(29-1)+1);       % vektor slucajnih indeksa
     TUG_2_novo(i, :) = TUG_2(TUG_2(:, 20)==indeksi_2(i), :);
end
TUG_2 = [TUG_2(:,1:end-1); TUG_2_novo(:,1:end-1)];   % konkatenacija stare matrice nivoa 1 i matrice random izabrnih

% TUG3
br = [];
for i = 1:28
   br(i) = i; 
end
TUG_3 = [TUG_3 br'];
% razlika_3 = 38-28   ---> razlika izmedju broja pacijenata 1. i 3. klase
indeksi_3 = [];
TUG_3_novo = zeros((41-28),20);                       
for i = 1:(41-28)                                  
     indeksi_3(i) = round(rand(1)*(28-1)+1);      
     TUG_3_novo(i, :) = TUG_3(TUG_3(:, 20)==indeksi_3(i), :);
end
TUG_3 = [TUG_3(:,1:end-1); TUG_3_novo(:,1:end-1)];

%%
% K level balansirano
tabela = [TUG_1; TUG_2; TUG_3];
tabela = tabela(:, [2 5 8 10 15 16 17 19]);
dijagnoza = [ones(41,1); 2*ones(41,1); 3*ones(41,1)];

% opt_br_stab = 25;
% model_DT = fitctree(tabela, dijagnoza, 'MaxNumSplits', opt_br_stab, 'Prior', 'uniform');  
% view(model_DT)  
% view(model_DT,'mode','graph')

sacuvaj = 'tabela.mat';
save(sacuvaj, 'tabela');
sacuvaj = 'dijagnoza.mat';
save(sacuvaj, 'dijagnoza');