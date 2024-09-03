% Kako setovi podataka nisu balansirani, odnosno broj pacijenata po klasama
% se razlikuje, neophodnno je izvrsiti balansiranost kako ne bi doslo do 
% favorizacije klase sa najvecim brojem ispitanika.

clear all
close all

load tabelaT
load dijagnozaT
%%  TMWT

TMWT = unique(tmwt);                      % TUG ima moguce vrednosti: 1,2,3
TMWT_1 = tabelaT(tmwt==1, :);              % imamo 41 pacijenata
TMWT_2 = tabelaT(tmwt==2, :);              % imamo 36 pacijenta
TMWT_3 = tabelaT(tmwt==3, :);              % imamo 21 pacijenta             ---> ukupno 98

%% BALANSIRANJE TUG
% TUG2
br = [];
for i = 1:36
   br(i) = i; 
end
TMWT_2 = [TMWT_2 br'];
% razlika_2 = 41-36   ---> razlika izmedju broja pacijenata 1. i 2. klase
indeksi_2 = [];
TMWT_2_novo = zeros((41-36),20);                        % ima ih 6 jer je razlika izmedju broja pacijenata 6
for i = 1:(41-36)                                  
     indeksi_2(i) = round(rand(1)*(36-1)+1);       % vektor slucajnih indeksa
     TMWT_2_novo(i, :) = TMWT_2(TMWT_2(:, 20)==indeksi_2(i), :);
end
TMWT_2 = [TMWT_2(:,1:end-1); TMWT_2_novo(:,1:end-1)];   % konkatenacija stare matrice nivoa 1 i matrice random izabrnih
%% TUG3
br = [];
for i = 1:21
   br(i) = i; 
end
TMWT_3 = [TMWT_3 br'];
% razlika_3 = 41-21   ---> razlika izmedju broja pacijenata 1. i 3. klase
indeksi_3 = [];
TMWT_3_novo = zeros((41-21),20);                       
for i = 1:(41-21)                                  
     indeksi_3(i) = round(rand(1)*(21-1)+1);      
     TMWT_3_novo(i, :) = TMWT_3(TMWT_3(:, 20)==indeksi_3(i), :);
end
TMWT_3 = [TMWT_3(:,1:end-1); TMWT_3_novo(:,1:end-1)];

%%
% K level balansirano
tabela = [TMWT_1; TMWT_2; TMWT_3];
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