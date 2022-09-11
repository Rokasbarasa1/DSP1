%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Time-domain denoising
%      VIDEO: Mean-smooth a time series
% Instructor: sincxpress.com
%
%%

% create signal
srate = 10000; % Hz
time  = 0:1/srate:3;
n     = length(time);
p     = 15; % poles for random interpolation

% noise level, measured in standard deviations
noiseamp = 5; 

% amplitude modulator and noise level
ampl   = interp1(rand(p,1)*30,linspace(1,p,n));
noise  = noiseamp * randn(size(time));
signal = ampl + noise;

% initialize filtered signal vector
filtsig = zeros(size(signal));

% implement the running mean filter
k = 20; % filter window is actually k*2+1
for i=k+1:n-k-1
    % each point is the average of k surrounding points
    filtsig(i) = mean(signal(i-k:i+k));
end

% compute window size in ms
windowsize = 1000*(k*2+1) / srate;


% plot the noisy and filtered signals
figure(1), clf, hold on
plot(time,signal, time,filtsig, 'linew',2)

% draw a patch to indicate the window size
tidx = dsearchn(time',1);
ylim = get(gca,'ylim');
patch(time([ tidx-k tidx-k tidx+k tidx+k ]),ylim([ 1 2 2 1 ]),'k','facealpha',.25,'linestyle','none')
plot(time([tidx tidx]),ylim,'k--')

xlabel('Time (sec.)'), ylabel('Amplitude')
title([ 'Running-mean filter with a k=' num2str(round(windowsize)) '-ms filter' ])
legend({'Signal';'Filtered';'Window';'window center'})

zoom on

%% create Gaussian kernel

% full-width half-maximum: the key Gaussian parameter
fwhm = 100; % in ms

% normalized time vector in ms
k = 200;
gtime = 1000*(-k:k)/srate;

% create Gaussian window
gauswin = exp( -(4*log(2)*gtime.^2) / fwhm^2 );

% then normalize Gaussian to unit energy
gauswin = gauswin / sum(gauswin);

%% now repeat in the frequency domain

% compute N's
nConv = n + 2*k+1 - 1;

% FFTs
dataX = fft(signal,nConv);
gausX = fft(gauswin,nConv);

% IFFT
convres = ifft( dataX.*gausX );

% cut wings
convres = convres(k+1:end-k);

%% plots
figure(1), clf, hold on

% lines
plot(time,signal,'r')
%plot(time,filtsig,'k*-')
plot(time,convres,'bo')

% frills
xlabel('Time (s)'), ylabel('amp. (a.u.)')
legend({'Signal';'Time-domain';'Spectral multiplication'})
title('Gaussian smoothing filter')
