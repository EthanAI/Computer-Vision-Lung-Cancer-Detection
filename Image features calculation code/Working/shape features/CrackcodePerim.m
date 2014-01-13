%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% New Perimeter Algorithm %%%%%%
%%%%%% Shu Xie                 %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function P = CrackcodePerim(I) %#ok<*INUSD,*STOUT>

%%%%  Create Binary image  %%%%
for xi = 1:size(I,1)
    for yi = 1:size(I,2)
        if I(xi,yi) ~= 0
            I(xi,yi) = 1;
        end
    end
end
        
counter_p=0;    % Counter for Perimeter
if size(I,1)>1 && size(I,2)>1 % When Image size is larger that 1*1 pixels    
    for x = 1:size(I,1)
        for y = 1:size(I,2)
            if I(x,y) == 1
                if x == 1
                % perimeter9(): x = 1 and y = 1
                    if y == 1
                        counter_p = counter_p + 2;  % Boundary that outside image
                        if I(x,y+1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x+1,y) == 0
                            counter_p = counter_p + 1;
                        end
                % perimeter8(): x = 1 and y = max
                elseif y == size(I,2)
                    counter_p = counter_p + 2;  % Boundary that outside image
                    if I(x,y-1) == 0
                        counter_p = counter_p + 1;
                    end
                    if I(x+1,y) == 0
                        counter_p = counter_p + 1;
                    end 
                % perimeter7(): x = 1 and y = mid
                else
                    counter_p = counter_p + 1;  % Boundary that outside image
                    if I(x,y+1) == 0
                        counter_p = counter_p + 1;
                    end
                        if I(x,y-1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x+1,y) == 0
                            counter_p = counter_p + 1;
                        end  
                    end
                elseif x == size(I,1)
                    % perimeter6(): x = max and y = 1
                    if y == 1
                        counter_p = counter_p + 2;  % Boundary that outside image
                        if I(x,y+1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x-1,y) == 0
                            counter_p = counter_p + 1;
                        end  
                    % perimeter5(): x = max and y = max
                    elseif y == size(I,2)
                        counter_p = counter_p + 2;  % Boundary that outside image
                        if I(x,y-1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x-1,y) == 0
                            counter_p = counter_p + 1;
                        end  
                    % perimeter4(): x = max and y = mid
                    else
                        counter_p = counter_p + 1;  % Boundary that outside image
                        if I(x,y+1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x,y-1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x-1,y) == 0
                            counter_p = counter_p + 1;
                        end  
                    end
                else
                    % perimeter3(): x = mid and y = 1
                    if y == 1
                        counter_p = counter_p + 1;  % Boundary that outside image
                        if I(x,y+1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x+1,y) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x-1,y) == 0
                            counter_p = counter_p + 1;
                        end  
                    % perimeter2(): x = mid and y = max
                    elseif y == size(I,2)
                        counter_p = counter_p + 1;  % Boundary that outside image
                        if I(x,y-1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x+1,y) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x-1,y) == 0
                            counter_p = counter_p + 1;
                        end 
                    % perimeter1(): x = mid and y = mid
                    else
                        if I(x,y+1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x,y-1) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x+1,y) == 0
                            counter_p = counter_p + 1;
                        end
                        if I(x-1,y) == 0
                            counter_p = counter_p + 1;
                        end
                    end
                end
            end
        end
    end
end           
P = counter_p;
