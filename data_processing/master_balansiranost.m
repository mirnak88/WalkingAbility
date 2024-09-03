% Kako setovi podataka nisu balansirani, odnosno broj pacijenata po klasama
% se razlikuje, neophodnno je izvrsiti balansiranost kako ne bi doslo do 
% favorizacije klase sa najvecim brojem ispitanika.

clear all
close all

load tabela
load tabelaT
load dijagnoza
load dijagnozaT

%% ORIGINALNO
% K-LEVEL
% 
% klevel = unique(K_level);                 % K-level ima moguce vrednosti: 0,1,2,3,4
% klevel_0 = tabela(K_level==0, :);         % imamo 6 pacijenata
% klevel_1 = tabela(K_level==1, :);         % imamo 29 pacijenata
% klevel_2 = tabela(K_level==2, :);         % imamo 54 pacijenta
% klevel_3 = tabela(K_level==3, :);         % imamo 13 pacijenata
% klevel_4 = tabela(K_level==4, :);         % imamo 2 pacijenta            ---> ukupno 104
%
% NIVO OSPOSOBLJENOSTI ZA HOD
% 
% nivoi = unique(nivo);                % Nivo osposobljenosti za hod ima moguce vrednosti: 0,1,2,3,4
% nivo_0 = tabela(nivo==0, :);         % imamo 6 pacijenata
% nivo_1 = tabela(nivo==1, :);         % imamo 17 pacijenata
% nivo_2 = tabela(nivo==2, :);         % imamo 45 pacijenta
% nivo_3 = tabela(nivo==3, :);         % imamo 31 pacijenata
% nivo_4 = tabela(nivo==4, :);         % imamo 5 pacijenata                ---> ukupno 104

%% MODIFIKOVANO
% % NIVO OSPOSOBLJENOSTI ZA HOD
% 
% nivoi = unique(nivo);                % Nivo osposobljenosti za hod ima moguce vrednosti: 1,2,3
% nivo_1 = tabela(nivo==1, :);         % imamo 23 pacijenata
% nivo_2 = tabela(nivo==2, :);         % imamo 45 pacijenta
% nivo_3 = tabela(nivo==3, :);         % imamo 36 pacijenata                 ---> ukupno 104

% K-LEVEL

klevel = unique(K_level);                 % K-level ima moguce vrednosti: 1,2,3
klevel_1 = tabela(K_level==1, :);         % imamo 35 pacijenata
klevel_2 = tabela(K_level==2, :);         % imamo 54 pacijenta
klevel_3 = tabela(K_level==3, :);         % imamo 15 pacijenta             ---> ukupno 104

% TUG
TUG = unique(tug);                      % TUG ima moguce vrednosti: 1,2,3
TUG_1 = tabelaT(tug==1, :);              % imamo 38 pacijenata
TUG_2 = tabelaT(tug==2, :);              % imamo 32 pacijenta
TUG_3 = tabelaT(tug==3, :);              % imamo 28 pacijenta              ---> ukupno 98

% TMWT
TMWT = unique(tmwt);                      % TUG ima moguce vrednosti: 1,2,3
TMWT_1 = tabelaT(tmwt==1, :);              % imamo 41 pacijenata
TMWT_2 = tabelaT(tmwt==2, :);              % imamo 37 pacijenta
TMWT_3 = tabelaT(tmwt==3, :);              % imamo 20 pacijenta             ---> ukupno 98

%% BALANSIRANJE 

% % NIVO OSPOSOBLJENOSTI ZA HOD
% % NIVO 1
% br = [];
% for i = 1:23
%    br(i) = i; 
% end
% nivo_1 = [nivo_1 br'];
% % razlika_1 = 45-23   ---> razlika izmedju broja pacijenata 2. i 1. klase
% indeksi_1 = [];
% nivo_1_novo = zeros(22,20);                        % ima ih 22 jer je razlika izmedju broja pacijenata 22
% for i = 1:(45-23)                                  
%      indeksi_1(i) = round(rand(1)*(23-1)+1);       % vektor slucajnih indeksa
%      nivo_1_novo(i, :) = nivo_1(nivo_1(:, 20)==indeksi_1(i), :);
% end
% nivo_1 = [nivo_1(:,1:end-1); nivo_1_novo(:,1:end-1)];   % konkatenacija stare matrice nivoa 1 i matrice random izabrnih
% 
% % NIVO 3
% br = [];
% for i = 1:36
%    br(i) = i; 
% end
% nivo_3 = [nivo_3 br'];
% % razlika_3 = 45-36   ---> razlika izmedju broja pacijenata 2. i 3. klase
% indeksi_3 = [];
% nivo_3_novo = zeros(9,20);                       
% for i = 1:(45-36)                                  
%      indeksi_3(i) = round(rand(1)*(36-1)+1);      
%      nivo_3_novo(i, :) = nivo_3(nivo_3(:, 20)==indeksi_3(i), :);
% end
% nivo_3 = [nivo_3(:,1:end-1); nivo_3_novo(:,1:end-1)];

% % K-LEVEL
% % K1
% br = [];
% for i = 1:35
%    br(i) = i; 
% end
% klevel_1 = [klevel_1 br'];
% % razlika_1 = 54-35   ---> razlika izmedju broja pacijenata 2. i 1. klase
% indeksi_1 = [];
% klevel_1_novo = zeros(19,20);                       
% for i = 1:(54-35)                                  
%      indeksi_1(i) = round(rand(1)*(35-1)+1);      
%      klevel_1_novo(i, :) = klevel_1(klevel_1(:, 20)==indeksi_1(i), :);
% end
% klevel_1 = [klevel_1(:,1:end-1); klevel_1_novo(:,1:end-1)];
% 
% % K3
% br = [];
% for i = 1:15
%    br(i) = i; 
% end
% klevel_3 = [klevel_3 br'];
% % razlika_3 = 54-15   ---> razlika izmedju broja pacijenata 2. i 3. klase
% indeksi_3 = [];
% klevel_3_novo = zeros(39,20);                       
% for i = 1:(54-15)                                  
%      indeksi_3(i) = round(rand(1)*(15-1)+1);      
%      klevel_3_novo(i, :) = klevel_3(klevel_3(:, 20)==indeksi_3(i), :);
% end
% klevel_3 = [klevel_3(:,1:end-1); klevel_3_novo(:,1:end-1)];

% TIMED UP AND GO
% TUG2
br = [];
for i = 1:39
   br(i) = i; 
end
TUG_2 = [TUG_2 br'];
% razlika_2 = 41-39   ---> razlika izmedju broja pacijenata 1. i 2. klase
indeksi_2 = [];
TUG_2_novo = zeros((41-39),20);                        % ima ih 6 jer je razlika izmedju broja pacijenata 6
for i = 1:(41-28)                                  
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
for i = 1:(38-28)                                  
     indeksi_3(i) = round(rand(1)*(28-1)+1);      
     TUG_3_novo(i, :) = TUG_3(TUG_3(:, 20)==indeksi_3(i), :);
end
TUG_3 = [TUG_3(:,1:end-1); TUG_3_novo(:,1:end-1)];

% % 2 MINUTE WALK TEST
% % TMWT2
% br = [];
% for i = 1:37
%    br(i) = i; 
% end
% TMWT_2 = [TMWT_2 br'];
% % razlika_2 = 41-37   ---> razlika izmedju broja pacijenata 2. i 1. klase
% indeksi_2 = [];
% TMWT_2_novo = zeros(4,20);                       
% for i = 1:(41-37)                                  
%      indeksi_2(i) = round(rand(1)*(37-1)+1);      
%      TMWT_2_novo(i, :) = TMWT_2(TMWT_2(:, 20)==indeksi_2(i), :);
% end
% TMWT_2 = [TMWT_2(:,1:end-1); TMWT_2_novo(:,1:end-1)];
% 
% % TMWT3
% br = [];
% for i = 1:20
%    br(i) = i; 
% end
% TMWT_3 = [TMWT_3 br'];
% % razlika_3 = 41-20   ---> razlika izmedju broja pacijenata 1. i 3. klase
% indeksi_3 = [];
% TMWT_3_novo = zeros(21,20);                       
% for i = 1:(41-20)                                  
%      indeksi_3(i) = round(rand(1)*(20-1)+1);      
%      TMWT_3_novo(i, :) = TMWT_3(TMWT_3(:, 20)==indeksi_3(i), :);
% end
% TMWT_3 = [TMWT_3(:,1:end-1); TMWT_3_novo(:,1:end-1)];

%% NOVE TABELE
% % nivo osposobljenosti za hod
% tabela = [nivo_1; nivo_2; nivo_3];
% tabela = tabela(:, [3 5 6 8 9 14 17]);
% dijagnoza = [ones(23,1); 2*ones(45,1); 3*ones(36,1)];
% 
% sacuvaj = 'tabela.mat';
% save(sacuvaj, 'tabela');
% sacuvaj = 'dijagnoza.mat';
% save(sacuvaj, 'dijagnoza');


% % nivo osposobljenosti za hod balansirano
% tabela = [nivo_1; nivo_2; nivo_3];
% %tabela = tabela(:, [5 6 8 17]);
% dijagnoza = [ones(45,1); 2*ones(45,1); 3*ones(45,1)];
% 
% sacuvaj = 'tabela.mat';
% save(sacuvaj, 'tabela');
% sacuvaj = 'dijagnoza.mat';
% save(sacuvaj, 'dijagnoza');

% % k-level 
% tabela = [klevel_1; klevel_2; klevel_3];
% tabela = tabela(:, [2 5 6 8 10 16 17]);
% dijagnoza = [ones(35,1); 2*ones(54,1); 3*ones(15,1)];
% 
% sacuvaj = 'tabela.mat';
% save(sacuvaj, 'tabela');
% sacuvaj = 'dijagnoza.mat';
% save(sacuvaj, 'dijagnoza');

% % k-level balansirano
% tabela = [klevel_1; klevel_2; klevel_3];
% tabela = tabela(:, [2 5 8 10 15 16 17 19]);
% dijagnoza = [ones(54,1); 2*ones(54,1); 3*ones(54,1)];
% 
% sacuvaj = 'tabela.mat';
% save(sacuvaj, 'tabela');
% sacuvaj = 'dijagnoza.mat';
% save(sacuvaj, 'dijagnoza');

% TUG balansirano 
tabela = [TUG_1; TUG_2; TUG_3];
tabela = tabela(:, [2 5 6 8 10 16]);
dijagnoza = [ones(38,1); 2*ones(38,1); 3*ones(38,1)];
OOOO = numel(dijagnoza)

sacuvaj = 'tabela.mat';
save(sacuvaj, 'tabela');
sacuvaj = 'dijagnoza.mat';
save(sacuvaj, 'dijagnoza');


% % TMWT balansirano 
% tabela = [TMWT_1; TMWT_2; TMWT_3];
% tabela = tabela(:, [2 8 10 16]);
% dijagnoza = [ones(41,1); 2*ones(41,1); 3*ones(41,1)];
% 
% sacuvaj = 'tabela.mat';
% save(sacuvaj, 'tabela');
% sacuvaj = 'dijagnoza.mat';
% save(sacuvaj, 'dijagnoza');

%%

% for i = 1 : size(tabela,2)
%     sr_vr_1 = mean(nivo_1(:,i));
%     sr_vr_2 = mean(nivo_2(:,i));
%     sr_vr_3 = mean(nivo_3(:,i));
%     
%     std_1 = std(nivo_1(:,i));
%     std_2 = std(nivo_2(:,i));
%     std_3 = std(nivo_3(:,i));
%     
%     n1 = (sr_vr_1 - 3*std_1) : 0.0001 : (sr_vr_1 + 3*std_1);
%     n2 = (sr_vr_2 - 3*std_2) : 0.0001 : (sr_vr_2 + 3*std_2);
%     n3 = (sr_vr_3 - 3*std_3) : 0.0001 : (sr_vr_3 + 3*std_3);
%     
%     mini = min([min(n1), min(n2), min(n3)]);
%     maxi = max([max(n1), max(n2), max(n3)]);
%     x = mini : 0.0001 : maxi;
%     
%     norm_1 = normpdf(x, sr_vr_1, std_1);
%     norm_2 = normpdf(x, sr_vr_2, std_2);
%     norm_3 = normpdf(x, sr_vr_3, std_3);
%    
%     figure, plot(x, norm_1, x, norm_2, x, norm_3, 'LineWidth',2)
%     legend('NIVO 1','NIVO 2','NIVO 3')
% end



