% U tabeli sa podacima pacijenata iz KCV, ponudjeno je 19 obelezja. Za
% svako obelezje izvuceni su statisticki znacajni parametri. Formirane su
% nove matrice obelezja i izdvojene su labele.

clear all
close all

[podaci] = xlsread('lower_extremity_amputation.xlsx');
br_pacijenata = size(podaci,1);


%% 1.POL
pol = podaci(:, 26);              % uzimamo 26. kolonu jer su tek tu, naknadno, razdvojeni pacijenti
pol_nan = 0;                      % 1-muski i 0-zenski          
for i = 1:br_pacijenata     
    if isnan(pol(i))  
        pol_nan = pol_nan + 1;    % nema nedostajucih podataka
    end
end
muski = sum(pol);                 % 80 muskaraca
zenski = br_pacijenata - muski;   % 24 zena

%% 2.STAROST
starost = podaci(:, 3);                       % izrazena u godinama
starost_nan = 0;                         
for i = 1:br_pacijenata     
    if isnan(starost(i))
        starost_nan = starost_nan + 1;        % nema nedostajucih podataka
    end
end
najstariji = max(starost);                    % najstariji ima 82 godine
najmladji = min(starost);                     % najmladji ima 19
prosecna_starost = round(mean(starost));      % prosek 62 godine

%% 3.MSPSS - Multidimensional Scale of Perceived Social Support
mspss = podaci(:, 5);               % 12-stepena skala izrazava se u vrednostima od 12 do 84 
mspss_nan = 0;                         
for i = 1:br_pacijenata     
    if isnan(mspss(i))
        mspss_nan = mspss_nan + 1;  % nema nedostajucih podataka
    end
end
najlosiji_mspss = min(mspss);       % najmanja vrednost 18
najbolji_mspss = max(mspss);        % najveca vrednost 84
prosek_mspss = round(mean(mspss));  % prosek 70

%% 4.SKOLA - nivo obrazovanja
skola = podaci(:, 6);                 % koliko ima godina skole
skola_nan = 0;                         
for i = 1:br_pacijenata     
    if isnan(skola(i))
        skola_nan = skola_nan + 1;    % nema nedostajucih podataka 
    end
end
najmanje_godina_skole = min(skola);   % 0, bez skole
najobrazovaniji = max(skola);         % 18 godina skolovanja
prosek_skola = round(mean(skola));    % prosecno 10
               
%% 5.MMSE - Mini Mental State Examination 
mmse = podaci(:, 7);                % test za procenu kognitivnog statusa, max 30 poena
mmse_nan = 0;                         
for i = 1:br_pacijenata     
    if isnan(mmse(i))
        mmse_nan = mmse_nan + 1;    % nema nedostajucih podataka
    end
end
min_bodova_mmse = min(mmse);        % minimalno osvojeno 16
max_bodova_mmse = max(mmse);        % maksimalno osvojeno 30
prosek_mmse = round(mean(mmse));    % prosek 27

%% 6.BDI - Beck Depression Inventory
bdi = podaci(:, 8);                                                       % test za procenu depresivnosti, skala od 0 do 63
bdi_nan = 0;  
suma_bdi = 0;
fali_ind_bdi = [];
for i = 1:br_pacijenata     
    if isnan(bdi(i)) == 0
        suma_bdi = suma_bdi + bdi(i);                                     % racunamo sumu da bismo mogli posle 
    end                                                                   % da radimo rednju vrednost obelezja
    if isnan(bdi(i))
        bdi_nan = bdi_nan + 1;                                            % imamo 7 pacijenata bez informacije od BDI
        fali_ind_bdi = [fali_ind_bdi i];
        bdi(i) = round(suma_bdi / (br_pacijenata - numel(fali_ind_bdi))); % nedostajuce podatke zamenimo sa srednjom vrednoscu
    end
end

%% 7.UZROK AMPUTACIJE
uzrok = podaci(:, 9);               % uzroci predstavljenji kao 1-vaskularni
uzroci = unique(uzrok);             % 2-trauma i 3-ostalo
uzrok_nan = 0;                         
for i = 1:br_pacijenata     
    if isnan(uzrok(i))
        uzrok_nan = uzrok_nan + 1;   % nema nedostajucih podataka
    end
end
vaskularni = sum(uzrok==1);          % 92 pacijenta ciji je vaskularni uzrok amputacije 
trauma = sum(uzrok==2);              % 7 pacijenata sa traumom kao uzrokom amputacije
ostalo = sum(uzrok==3);              % 5 pacijenata sa ostalim uzrocima amputacije

%% 8.NIVO AMPUTACIJE
nivo = podaci(:, 10);
nivoi = unique(nivo);                                % 1-transfemoralni nivo
nivo_nan = 0;                                        % 0-transtibialni nivo            
for i = 1:br_pacijenata     
    if isnan(nivo(i))            
        nivo_nan = nivo_nan + 1;                     % nema nedostajucih podataka 
    end
end
transfemoralni = sum(nivo==1);                       % 64 pacijenta
transtibialni = br_pacijenata - transfemoralni;      % 40 pacijenata

%% 9.FCI - Functiona Comorbidity Index 
fci = podaci(:, 11);           
fcindeksi = unique(fci);       % 0-8 ???
fci_nan = 0;                             
for i = 1:br_pacijenata     
    if isnan(fci(i))
        fci_nan = fci_nan + 1; % nema nedostajucih podataka
    end
end

%% 10.BMI - Body Mass Index
bmi = podaci(:, 12);             % tezina(kg)/(visina(m)^2)
bmi_nan = 0;                             
for i = 1:br_pacijenata     
    if isnan(bmi(i))
        bmi_nan = bmi_nan + 1;   % nema nedostajucih podataka
    end
end
min_bmi = min(bmi);              % 16.51
max_bmi = max(bmi);              % 36.21
prosek_bmi = mean(bmi);          % 24.76

%% 11.DIJABETES
dijabetes = podaci(:, 13);                 % 1-ima dijabetes i 0-nema dijabetes
dijabetes_nan = 0;                             
for i = 1:br_pacijenata     
    if isnan(dijabetes(i))
        dijabetes_nan = dijabetes_nan + 1; % nema nedostajucih podataka
    end
end
ima_dijabetes = sum(dijabetes==1);         % 74 pacijenata

%% 12.FANTOMSKI BOL
fantomski_bol = podaci(:, 14);                                                   % 1-ima fantomski bol
fb_nan = 0;                                                                      % 0-nema fantomski bol
suma_fb = 0;
fali_ind_fb = [];
for i = 1:br_pacijenata  
    if isnan(fantomski_bol(i)) == 0
        suma_fb = suma_fb + fantomski_bol(i);                                      
    end
    if isnan(fantomski_bol(i))
        fb_nan = fb_nan + 1;                                                      % 3 pacijenta bez ove informacije 
        fali_ind_fb = [fali_ind_fb i];
        fantomski_bol(i) = round(suma_fb / (br_pacijenata - numel(fali_ind_fb)));
    end
end
ima_fb = sum(fantomski_bol==1);                                                    % 69 pacijenata

%% 13. KONTRAKTURA
kontraktura = podaci(:, 15);                    % 1-javlja se kontrakturu 
kontraktura_nan = 0;                            % 0-ne javlja se kontraktura                             
for i = 1:br_pacijenata     
    if isnan(kontraktura(i))
        kontraktura_nan = kontraktura_nan + 1;  % nema nedostajucih podataka
    end
end
prisustvo_kontrakture = sum(kontraktura==1);    % 26 pacijenata

%% 14. RE EKSTENZORI KUKA CELE OCENE
RE_e_kuk = podaci(:, 16);
re_ek_nan = 0;
for i = 1:br_pacijenata     
    if isnan(RE_e_kuk(i))
        re_ek_nan = re_ek_nan + 1;  % nema nedostajucih podataka
    end
end

%% 15. IE PLANTARNI FLEKSORI CELE OCENE
IE_pf = podaci(:, 17);
ie_pf_nan = 0;
for i = 1:br_pacijenata     
    if isnan(IE_pf(i))
        ie_pf_nan = ie_pf_nan + 1;  % nema nedostajucih podataka
    end
end

%% 16. IE EKSTENZORI KUKA  CELE OCENE
IE_e_kuk = podaci(:, 18);
ie_ek_nan = 0;
for i = 1:br_pacijenata     
    if isnan(IE_e_kuk(i))
        ie_ek_nan = ie_ek_nan + 1;  % nema nedostajucih podataka
    end
end

%% 17. BALANS
balans = podaci(:, 19);
balans_nan = 0;
for i = 1:br_pacijenata     
    if isnan(balans(i))
        balans_nan = balans_nan + 1;  % nema nedostajucih podataka
    end
end

%% 18. PUSAC
pusac = podaci(:, 20);              % 0-nije, 1-jeste, 2-nije duze od 6 meseci
pusac_nan = 0;
suma_pusac = 0;
fali_ind_pusac = [];
for i = 1:br_pacijenata     
    if isnan(pusac(i)) == 0
        suma_pusac = suma_pusac + pusac(i);                                      
    end
    if isnan(pusac(i))
        pusac_nan = pusac_nan + 1;  % 1 nedostajuci podatak
        fali_ind_pusac = [fali_ind_pusac i];
        pusac(i) = round(suma_pusac / (br_pacijenata - numel(fali_ind_pusac)));
    end
end 
    
%% 19.VREMENSKI PERIOD OD AMPUTACIJE DO PROTETICKE REHABILITACIJE
vreme = podaci(:, 4);                 % izrazeno u danima
vreme_nan = 0;                         
for i = 1:br_pacijenata     
    if isnan(vreme(i))
        vreme_nan = vreme_nan + 1;    % nema nedostajucih
    end
end
najduze_vreme = max(vreme);           % najvise se cekalo 517 dana na protezu
najkrace_vreme = min(vreme);          % najmanje se cekalo 43 dana na protezu
prosecno_vreme = round(mean(vreme));  % u proseku se cekalo 172 dana na protezu

%% TABELA OBELEZJA

tabela = [pol starost mspss skola mmse bdi uzrok nivo fci bmi dijabetes fantomski_bol...
    kontraktura RE_e_kuk IE_pf IE_e_kuk balans pusac vreme];
sacuvaj = 'tabela.mat';
save(sacuvaj, 'tabela');

nivo = podaci(:, 23);
K_level = podaci(:, 24);
for i = 1:br_pacijenata              % kako nam klase nisu balansirane, spajanjem klasa
    if nivo(i) == 0                  % pravimo nove:
        nivo(i) = 1;                 % za Nivo osposobljenosti za hod spajamo 0-tu i 1-u klasu,
    end                              % kao i 3-u i 4-u
    if nivo(i) == 4                  
        nivo(i) = 3;
    end
    if K_level(i) == 0
        K_level(i) = 1;
    end
    if K_level(i) == 4
        K_level(i) = 3;
    end 
end
labele = 'dijagnoza.mat';
save(labele, 'nivo', 'K_level');

%% TUG & 2MWT

tug_ = podaci(:, 22);
tug = [];
tmwt_ = podaci(:, 21);
tmwt = [];
for i = 1:br_pacijenata     
    if tug_(i) >= 60
        tug(i) = 1;
    end
    if tug_(i) < 60 & tug_(i) > 30
        tug(i) = 2;
    end
    if tug_(i) <= 30
        tug(i) = 3;
    end
 
    if tmwt_(i) >= 55
        tmwt(i) = 3;
    end
    if tmwt_(i) < 55 & tmwt_(i) > 25
        tmwt(i) = 2;
    end
    if tmwt_(i) <= 25;
        tmwt(i) = 1;
    end
end

ind = [];

for i = 1:104
    if tug(i) == 0
        ind = [ind, i];
    end
end

tug = tug';
tmwt = tmwt';

tabelaT = [tabela(1:21,:); tabela(23:31,:); tabela(33:53,:); tabela(55,:); tabela(57:59,:);tabela(61:95,:); tabela(97:104,:)];
tug = [tug(1:21,:); tug(23:31,:); tug(33:53,:); tug(55,:); tug(57:59,:);tug(61:95,:); tug(97:104,:)];
tmwt = [tmwt(1:21,:); tmwt(23:31,:); tmwt(33:53,:); tmwt(55,:); tmwt(57:59,:);tmwt(61:95,:); tmwt(97:104,:)];

sacuvaj = 'tabelaT.mat';
save(sacuvaj, 'tabelaT');

labeleT = 'dijagnozaT.mat';
save(labeleT, 'tug', 'tmwt');
