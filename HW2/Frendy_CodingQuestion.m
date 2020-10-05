tiledlayout(2,1)

nexttile
twoA()
nexttile
twoB()

twoC()


function twoA()
    [mu,nu] = meshgrid(-pi:0.1:pi,-pi:0.1:pi);
    H = (1/25).*(2.*cos(2.*mu) + 2.*cos(mu) + 1).*(2.*cos(2.*nu) + 2.*cos(nu) + 1);
    H = abs(H);
    surf(mu,nu,H)
    c = colorbar;
    c.Label.String = 'Intensity';    
    xlabel("\mu (Hz)")
    ylabel("\nu (Hz)")
    zlabel("|H(e^{i\mu},e^{i\nu})| (dB)")
    xlim([-5  5])
    ylim([-5  5])
    xticks([-5:1:5])
    yticks([-5:1:5])
    title('Problem 2 A')
end

function twoB()
    [mu,nu] = meshgrid(-pi:0.1:pi,-pi:0.1:pi);
    H = (1/25).*(2.*cos(2.*mu) + 2.*cos(mu) + 1).*(2.*cos(2.*nu) + 2.*cos(nu) + 1);
    G = 1 + 1.5 - 1.5.*H;
    G = abs(G);
    surf(mu,nu,G)
    c = colorbar;
    c.Label.String = 'Intensity';    
    xlabel("\mu (Hz)")
    ylabel("\nu (Hz)")
    zlabel("|G(e^{i\mu},e^{i\nu})| (dB)")
    xlim([-5  5])
    ylim([-5  5])
    xticks([-5:1:5])
    yticks([-5:1:5])
    title('Problem 2 B')
end

function twoC()
    
    % Variables
    % Double cause cuts values
    img = double(imread('blurry-moon.tif'));
    % Z is the pizel, so we don't need it.
    [X,Y,Z] = size(img);
    % Make an empty outputImage
    outImg = zeros(X,Y);
    lambdav = [0.2, 0.8, 1.5];
    
    for i=1:length(lambdav)
        lambda = lambdav(i);
        %disp(lambda);
        filter = twoCHelper(lambda);
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
        imwrite(uint8(outImg), ['output', int2str(lambda), '.tif']);
    end
end


% Filter function
function filter  = twoCHelper(lambda)
    % Make dirac function, m = 0, n = 0 -> 1, 
    % Matrix is from -2 to 2
    
    dirac = zeros(5,5);
    dirac(3,3) = 1;
    
    % make h that is 5x5 matrix with 1/25 (since in the formula you
    % multiply by 1/25
    h = zeros(5,5);
    h(1:5,1:5) = 1/25;
    
    % Technically we should flip image, but when flip is the same
    % We don't use flip()
    filter = dirac + lambda*(dirac - h);

end
