% Box plot of TUG and TMWT
[podaci] = xlsread('lower_extremity_amputation.xlsx');
load dijagnozaT

tug_ = podaci(:, 22);
tug_orig = [tug_(1:21);tug_(23:31);tug_(33:53);tug_(55);tug_(57:59);tug_(61:95);tug_(97:end)];
figure, boxplot(tug_orig, tug)
title('Timed up and go test')
ylabel('Time (s)')
xlabel('TUG class')

tmwt_ = podaci(:, 21);
tmwt_orig = [tmwt_(1:21);tmwt_(23:31);tmwt_(33:53);tmwt_(55);tmwt_(57:59);tmwt_(61:95);tmwt_(97:end)];
figure, boxplot(tmwt_orig, tmwt)
title('Two minute walk test')
ylabel('Distance (m)')
xlabel('TMWT class')