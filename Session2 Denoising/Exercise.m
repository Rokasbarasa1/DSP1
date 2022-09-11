%% Import the data

% Imports variables: cleanedSignal, origSignal
load denoising_codeChallenge.mat
figure(1), clf
plot(origSignal);
figure(2), clf
histogram(origSignal,100);

%% Remove the spikes
n = 4000;

signal = origSignal;

lowThreshold = -7;
highThreshold = 7;

suprathresh = find( origSignal < lowThreshold | origSignal > highThreshold);

filtsig = signal;

k = 20; 
for ti=1:length(suprathresh)
    lowbnd = max(1,suprathresh(ti)-k);
    uppbnd = min(suprathresh(ti)+k,n);
    
    filtsig(suprathresh(ti)) = median(signal(lowbnd:uppbnd));
end

figure(3), clf
plot(1:n,filtsig, 'linew',2)
zoom on

%% Use gausian to smooth the data

fwhm = 80;
k = 100;
gtime = -k:k;
gauswin = exp( -(4*log(2)*gtime.^2) / fwhm^2 );
gauswin = gauswin / sum(gauswin);

% initialize filtered signal vector
filtsigG = filtsig;

% implement the running mean filter
for i=k+1:n-k-1
    % each point is the weighted average of k surrounding points
    filtsigG(i) = sum( filtsig(i-k:i+k).*gauswin );
end

figure(4), clf
plot(1:n,filtsigG, 'linew',2)
zoom on

figure(5), clf
plot(1:n, cleanedSignal, 'linew',2)
zoom on