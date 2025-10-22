function [tData,altOut,vOut,aOut] = appDifFunction(valIn,method,dataTable,sSize)
    
    % method will be used to select the method the function runs
    % dataTable is all the data being passed to the function
    % sSize determines how many samples to split the data into
    % valIn is the input data to be used

    % vOut is the velocity output
    % aOut is the acceleration output
    % altOut is the altitude output <-- to change

    %% Reading the input table and creating the output values
    tData = dataTable(:,1); % Time data
    altData = dataTable(:,3); % Altitude data
    vData = dataTable(:,5); % Velocity data

    % Pre-allocating arrays for efficency with larger data sets
    tempArrLeng = arraySet();
    vOut = tempArrLeng;
    aOut = tempArrLeng;
    altOut = tempArrLeng;
    clear tempArrLeng; % Clearing the temprary array to save memory

    %% Outputting velocity (? > ?) 
    if strcmpi(valIn, "Velocity")
        if strcmpi(method, "Forward")

            % Running internal forward differentiation function
            vOut = forwardDif(tData, aData, vOut, sSize);
            return;

        elseif strcmpi(method, "Backward")
            
            % Running the backward differentation function
            vOut = backDif(tData, aData, vOut, sSize);
            return;
            
        else
            
            % Running Central Derivative function
            vOut = centralDif(tData, aData, vOut, sSize);
            return;

        end

    %% Derivative of altitude (Location > Velocity)
    elseif strcmpi(valIn, "Altitude")

        if strcmpi(method, "Forward")

            % Running internal forward differentiation function
            altOut = forwardDif(tData, altData, altOut, sSize);
            return;

        elseif strcmpi(method, "Backward")
            
            % Running the backward differentation function
            altOut = backDif(tData, altData, altOut, sSize);
            return;
            
        else
            
            % Running centeral difference function
            altOut = centralDif(tData, altData, altOut, sSize);
            return;

        end

    %% Deriving Velocity (Velocity > Acceleration)
    else
        if strcmpi(method, "Forward")
            
            % Running the forward differentiation function
            aOut = forwardDif(tData, vData, aOut, sSize);
            return;

        elseif strcmpi(method, "Backward")

            %Running backward difference
            aOut = backDif(tData, vData, aOut, sSize);
            return;

        else
            
            % Running Central Difference
            aOut = centralDif(tData, vData, aOut, sSize);  
            return;

        end
    end
end

%% Output array sizing function
function arrOut = arraySet(sSize)

    % Outputs an array the correct size for the selected sample size
    arLeng = 1:sSize:length(tData) - 1;
    arrOut = zeros(length(arLeng));
end

%% Differentiation Functions

% Does backward differentiation of given size based on input data and time
function output = backDif(ftData, faData, arLeng, sSize)

    % ftData = Time data passed to function
    % faData = Input data to be derived
    % arLeng = The length of the output array to be generated

    %Setting output vector length
    arrLoc = 1; % Keeping track of out spot in the array as we loop through
    output = arLeng; % Pre-allocating for efficency

    %Looping through equation setting array value each time
    for i = 1:sSize:length(ftData) - 1

        %Setting the numerator and denomenator 
        aNumer = (faData(i) - faData(i+1));
        tDenom = (ftData(i) - ftData(i+1));

        %Finding the differentiation & putting into table
        output(arrLoc) = aNumer / tDenom;
        arrLoc = arrLoc + 1;
    end
    
end

% Does forward differentation of given size based on data and time
function output = forwardDif(ftData, faData, arLeng, sSize)

    % ftData = Time data passed to function
    % faData = Input data to be derived
    % arLeng = The length of the output array to be generated 

    %Setting the size of the velocity vector
    arrLoc = 1; % Array location on each loop
    output = arLeng;

    %Running the differentiation function for # of steps
    for i = 1 : sSize : length(ftData) - 1

        %Setting the numerator and denominator for the function
        aNumer = (faData(i+1) - faData(i));
        tDenom = (ftData(i+1) - ftData(i));

        %Finding the differentiation & putting into table
        output(arrLoc) = aNumer / tDenom;
        arrLoc  = arrLoc +1;
    end
end

% Does central differentation of given size based on data & time
function output = centralDif(ftData, faData, arLeng, sSize)

    % ftData = Time data passed to function
    % faData = Input data to be derived
    % arLeng = The length of the output array to be generated

    %Setting the size of the velocity vector
    arrLoc = 1; % Array location in each loop
    output = arLeng;
                
    %Running the differentiation function for # of steps
    for i = 1 : sSize :length(ftData) - 2
        aNumer = (faData(i + 2) - faData(i));
        tDenom = (ftData(i + 2) - ftData(i));

        %Finding the differentiation & putting into table
        output(arrLoc) = aNumer / tDenom;
        arrLoc = arrLoc + 1;
    end
end