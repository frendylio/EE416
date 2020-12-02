%================
% Frendy Lio
% HW 6 coding part
%================

%======================
% PART A
%======================
% Get training data
trainingCouple  = importdata('./couple/sigma20/I1.mat');
trainingHill = importdata('./hill/sigma20/I1.mat');
trainingLena = importdata('./lena/sigma20/I1.mat');

kernelSize = [5,5];

% Use Dr. Chun im2col fnction, we use ' to transpose
Z = [
    my_im2col(trainingCouple, kernelSize, 1)'; ...
    my_im2col(trainingHill, kernelSize, 1)'; ...
    my_im2col(trainingLena, kernelSize, 1)'; ...
];
%disp(Z)

%======================
% PART B
%======================
% get output data
outputCouple = importdata('./couple/sigma20/I7.mat');
outputHill = importdata('./hill/sigma20/I7.mat');
outputLena = importdata('./lena/sigma20/I7.mat');

% x = [outputCouple; outputHill; outputLena]

%modify our output data to fit the order patches 
outputCouple = outputCouple(3:512-2, 3:512-2);
outputHill = outputHill(3:512-2, 3:512-2);
outputLena = outputLena(3:512-2, 3:512-2);

x = [outputCouple(:); outputHill(:); outputLena(:)];
%disp(x)

%======================
% PART C
%======================
% theta = (R_z,z)^-1 r_zx
theta = inv(Z' * Z)*(Z' * x);
twoDFilter = reshape(theta, kernelSize);

% disp(twoDFilter)

%======================
% PART D
%======================
% Get Testing Input label
trainingBarbara = importdata('./barbara/sigma20/I1.mat');
% Get Output testing input label 
outputBarbara = importdata('./barbara/sigma20/I7.mat');

convolution = twoC(trainingBarbara, rot90(twoDFilter,2));

figure; imshow([trainingBarbara, convolution, outputBarbara], [1,255]);

%Moving average filter
averageFitler = ones(5, 5) / 25;
movingConvolution = twoC(trainingBarbara, averageFitler);
figure; imshow([trainingBarbara, movingConvolution, outputBarbara], [1,255]);

%======================
% PART E
%======================
%psnr function gives me an error...
%psnrMMSE = psnr(convolution, uint8(outputBarbara), 255);
%disp(psnrMMSE);

%psnrMA = psnr(movingConvolution, uint8(outputBarbara), 255);
%disp(psnrMA);

% calculating manually

psnrMMSE = sqrt(immse(convolution, outputBarbara));
psnrMMSE = 20 * log10(255 / psnrMMSE); 
disp(psnrMMSE)
psnrMA = sqrt(immse(movingConvolution, outputBarbara));
psnrMA = 20 * log10(255 / psnrMA); 
disp(psnrMA)

% Conclusion: the first denoising image is better than the secnd one
% (moving average filter)

%================
% Code from Ch 2 Problem 2
% Slighlty modified to fit the problem for ch 6
%================
function returnImage = twoC(trainingBarbara, twoDFilter)
    
    % Variables
    % Double cause cuts values
    img = double(trainingBarbara);
    % Z is the pizel, so we don't need it.
    [X,Y,Z] = size(img);
    % Make an empty outputImage
    outImg = zeros(X,Y);
        
    % need to rrotate
    filter = rot90(twoDFilter, 2);
    for x = 1:X
        
        for y = 1:Y
            % Do convolution
            sum = 0;
            
            % Filter -2 to 2
            for m = -2:2
                for n = -2:2
                   
                    % If in range do convolution
                    if (x+m >= 1 && x+m <= X && y+n >= 1 && y+n <= Y)
                        % m+3 and n+3 because we want from 1 to 5
                        sum = sum + img(x+m, y+n).*filter(m+3,n+3);
                    end                  
                end
            end
            
            % Storage output image
            % This is from the equation
                outImg(x, y) = sum;
           
        end
        
    end
    
    % Output image
    returnImage = outImg;
end




