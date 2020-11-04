clear; clc;
main();

function main()
    % Read image
    img = imread('defective-weld.tif');
    imgSize = size(img);
    x = imgSize(1);
    y = imgSize(2);
    
    % Created our seed. At the start is empty
    s = [];
    
    for i = 1:x
        for j = 1:y
            if img(i,j) > 254 % 254 because instruction says 254
                % now we have s a list of points(Location where intensity
                % is white aka 255.
                s = [s [i j]];
            end
        end
    end
    
	% Modify T here, T = 78 -> best tunning
    output = ConnectedSet(s, 68, img, 255);

    image(output);
    colormap(gray(256));
    truesize;
    
    % Save image
    imwrite(uint8(output), 'output_68.tif');    
end



function Y = ConnectedSet(s, T, img, Label)
    
    % Initialize Yr for all r in S aka make Y with a bunch of zeros
    imgSize = size(img);
    x = imgSize(1);
    y = imgSize(2);
    Y = zeros(x, y);
    
    % B<- {s0}
    % aka, store the starting seed (s) in a List (B)
    B = s;   

    % Get xs
    x_s = img(B(1),B(2));
    
    % Have a helper variable to help us check if we visited the neihgtbour
    % This is to savev computational time
    isChecked = zeros(x,y);
    n = size(B);
    % we do this to initial all points
    % our B is this form [ 1 2;  1 2; 1 2 ; 1 2]
    for x = 1:2:n(2)
        isChecked(B(x), B(x+1)) = 1;
    end
    
    % While B is not empty
    while not(isempty(B))

        % s <- any elemnt of B aka transfer B into s
        currentPointB = [B(1) B(2)];
        
        % B <- B\{s} aka pop s in B
        B(1:2) = [];
        
        % Ys <- ClassLAbel aka label point
        Y(currentPointB(1), currentPointB(2)) =  Label;  

        % B <- B U {r e c(s): Yr = 0} aka find connected neightbors
        for row = -1:1
            for col =  -1:1
                xCurrentPointB = currentPointB(1) + row;
                yCurrentPointB = currentPointB(2) + col;
                
                % 8 neightboard check
                if (xCurrentPointB >= 1 && xCurrentPointB <= x && ...
                   yCurrentPointB >= 1 && yCurrentPointB <= y && ...
                   ~isChecked(xCurrentPointB,yCurrentPointB))
                
                    % Update checker 
                    isChecked(xCurrentPointB,yCurrentPointB) = 1;
               
                    
                    % Check if it is inside the boundaries
                    if abs(x_s - img(xCurrentPointB, yCurrentPointB)) < T
                        
                        % Check if label is updated
                        if (Y(xCurrentPointB, yCurrentPointB) == 0)
                            B = [B [xCurrentPointB, yCurrentPointB]];
                        end
                        
                    end
                end
           
           end
        end
        
        
    end
end


