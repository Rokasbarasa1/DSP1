%% Import the data

% Imports variables: signal, srate, time
load spectral_codeChallenge.mat

plot(signal);

% Do the calculation
n = length(signal);
winLength = 0.5*srate;
winOnsets = 1:winLength:n-winLength;
hzW = linspace(0, srate/2, floor(winLength));
hannWin = 0.5 - cos(2*pi*linspace(0,1, winLength))./2;

signalPow = zeros(1,length(hzW));

matrix = zeros(length(winOnsets), length(hzW));

for wi=1:length(winOnsets)
    dataChunk = signal(winOnsets(wi):winOnsets(wi)+winLength-1);
    dataChunk = dataChunk .* hannWin;
    tmpPow = abs(fft(dataChunk)/winLength).^2;
    matrix(wi,:) = matrix(wi,:) + tmpPow(1:length(hzW));
    signalPow = signalPow + tmpPow(1:length(hzW));
end

plot(hzW, signalPow)
set(gca,'xlim',[0 40])

imagesc(time,hzW, matrix')
ylim([0,40]);