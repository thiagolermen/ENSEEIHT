clear
close all

%% Toy Example
load('/DonneesTP2/ToyExample.mat') % Load data from ToyExample.mat

sig_values = [0.1 0.3 0.7 0.9 1 10 50 100]; % Sigma values for testing

for sig = sig_values
    test = classification_spectrale(Data, 6, sig); % Perform spectral classification on Data
    
    figure
    subplot(1, 3, 1)
    image(Data(:, 1), 'CDataMapping', 'scaled') % Display the first column of Data
    subplot(1, 3, 2)
    image(Data(:, 2), 'CDataMapping', 'scaled') % Display the second column of Data
    subplot(1, 3, 3)
    image(test, 'CDataMapping', 'scaled') % Display the classified data
end

%% Transverse and Sagittal Data
load('/DonneesTP2/DataTransverse.mat') % Load DataTransverse.mat
load('/DonneesTP2/DataSagittale.mat') % Load DataSagittale.mat

DataTempsT = reshape(Image_DataT, 64*54, 20); % Reshape Image_DataT
DataTempsS = reshape(Image_DataS, 64*54, 20); % Reshape Image_DataS

k = 6; % Number of clusters
sig = 10; % Sigma value

[~, n] = size(DataTempsT); % Get the number of columns in DataTempsT

csT = classification_spectrale(DataTempsT, k, sig); % Perform spectral classification on DataTempsT
csS = classification_spectrale(DataTempsS, k, sig); % Perform spectral classification on DataTempsS

Image_DataT_cs = reshape(csT, 64, 54); % Reshape classified data for Image_DataT
Image_DataS_cs = reshape(csS, 64, 54); % Reshape classified data for Image_DataS

%% Display Results
close all

figure
subplot(1, 2, 1)
image(Image_ROI_T, 'CDataMapping', 'scaled') % Display the ROI image for Image_DataT
subplot(1, 2, 2)
image(Image_DataT_cs, 'CDataMapping', 'scaled') % Display the classified data for Image_DataT

figure
subplot(1, 2, 1)
image(Image_ROI_S, 'CDataMapping', 'scaled') % Display the ROI image for Image_DataS
subplot(1, 2, 2)
image(Image_DataS_cs, 'CDataMapping', 'scaled') % Display the classified data for Image_DataS