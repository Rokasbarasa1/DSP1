%has fs, x(signal), y(correct answer signal)
load filtering_codeChallenge.mat

%Show answer and signal
figure(1), clf
subplot(211), hold on
plot(x);
plot(y);

freqSig = abs(fft(x)).^2; 
freqAns = abs(fft(y)).^2;

subplot(212), hold on
plot(freqSig);
plot(freqAns);
xlim([0,800])



%Show the filter

srate   = fs;
nyquist = srate/2;
frange  = [5,33];
transw  = .1;
order   = round(20*srate/frange(1));

if rem(order,2) == 2
    order = order + 1;
end

filtkern = fir1(order,frange/nyquist);



filtpow = abs(fft(filtkern)).^2;
hz = linspace(0,srate/2, floor(length(filtkern)/2)+1);
filtpow = filtpow(1:length(hz));

%Check the filter
figure(2)
subplot(211)
plot(filtkern);

subplot(212), hold on
plot(hz, 10*log10(filtpow));
%plot(filtpow);
%plot([0, frange(1), frange(1), frange(2), frange(2),nyquist], [0,0,1,1,0,0]);
xlim([0,500]);

%Do the first filter
firstPart = x(order:-1:1);
secondPart = x(end:-1:end-order+1);
fdata = cat(1,firstPart, x, secondPart);

fdata = filtfilt(filtkern,1,fdata);

fdata = fdata(order+1:end-order);

figure(3)
subplot(211), hold on
plot(x);
plot(fdata);


freqFdata1 = abs(fft(fdata)).^2;

subplot(212), hold on
plot(freqSig);
plot(freqFdata1);
xlim([0,800]);

%DO the second part

srate   = fs;
nyquist = srate/2;
frange  = [16,25];
transw  = .1;
order   = round(20*srate/frange(1));

if rem(order,2) == 2
    order = order + 1;
end

filtkern = fir1(order,frange/nyquist);

firstPart = x(order:-1:1);
secondPart = x(end:-1:end-order+1);
fdata2 = cat(1,firstPart, x, secondPart);

fdata2 = filtfilt(filtkern,1,fdata2);

fdata2 = fdata2(order+1:end-order);

figure(4)
subplot(211), hold on
plot(x);
plot(fdata2);


freqFdata1 = abs(fft(fdata2)).^2;

subplot(212), hold on
plot(freqSig);
plot(freqFdata1);
xlim([0,800]);

%Get the final data

fdataFinal = fdata - fdata2;
freqFdataFinal = abs(fft(fdataFinal)).^2;

figure(5)
subplot(211), hold on
plot(x);
plot(fdataFinal);

subplot(212), hold on
plot(freqSig);
plot(freqFdataFinal);
xlim([0,800]);


