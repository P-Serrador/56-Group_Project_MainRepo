function [timeData,altitudeData,velocity,acceleration] = numericalDiffFunction(valueRequired,method,stepSize)
% testFunction: Computes velocity or acceleration from elevator data based on the 
% Inputs:
% valueToBeFound: 'Altitude', 'Velocity', or 'Acceleration'
% method: 'Forward', 'Backward', or 'Central'
% stepSize: step interval for data plotting
% Outputs:
%   timeData        : Time values from the dataset
%   altitudeData    : Altitude values from the dataset
%   velocity        : Computed velocity vector
%   acceleration    : Computed acceleration vector

%%  Import Elevator motion data as a script

opts = spreadsheetImportOptions("NumVariables", 5);

% Specify sheet and range
opts.Sheet = "Pressure and velocity";
opts.DataRange = "A5:E77";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Import the data
Elevator2025_10_1016_49_50 = readtable("C:\Users\Asus\OneDrive - UTS\Documents\Semster 2\ENG COMP\Assignment\Elevator 2025-10-10 16-49-50.xls", opts, "UseExcel", false);

%% Convert to output type
Elevator2025_10_1016_49_50 = table2array(Elevator2025_10_1016_49_50);

%% Clear temporary variables
clear opts
%% Assign the imported Data to a variable 
elavatorData = Elevator2025_10_1016_49_50; 
%% Extract individual columnn
timeData = elavatorData(:,1);             %% This collects the columnn with the time data from the imported data matrix
altitudeData = elavatorData(:,3);         %% This collects the columnn with the altitude data from the imported data matrix
velocityData = elavatorData(:,5);         %% This collects the columnn with the velocity data from the imported data matrix

 %% Nested conditional statements are used to choose the quantity and method to be used to find those quantities
 % This conditional section runs if the required data is velocity which is based on the inputs given by the user in Inputs: valueToBeFound

 if strcmpi(valueRequired, "Velocity")
        % This conditional section runs if the required numerical method is forward; based on the inputs given by the user in Inputs: method 
        if strcmpi(method, "Forward")
           
            lengthOfVelocityVector = 1:stepSize:length(timeData) - 1 ; %% This finds how long the matrix for velocity need to be based on step size; the number of data is decreased by one for not using the last time data for forward difference method  
            dataNumber = 1;                                            %% Assigning starting cell in the velocity vector to the first cell
            acceleration = zeros(length(timeData), 1);                 %% Used to give an data less output for acceleration, otherwise the function returns a error
            velocity = zeros(length(lengthOfVelocityVector), 1);       %% Sets a matrix where calculated values will be stored

            % This loop calculates the velocity using altitude and time data by forward method then stores result in corresponding cell the velocity matrix 
            for loopIndex = 1 : stepSize : length(timeData) - 1        %% The number of iterations is decreased by one for not using the last time data for forward difference method  
                velocity(dataNumber) = (altitudeData(loopIndex+1) - altitudeData(loopIndex)) / (timeData(loopIndex+1) - timeData(loopIndex));
                dataNumber  = dataNumber + 1;                          %% Updates the assigning cell number
            end

         % This conditional section runs if the required numerical method is backward; based on the inputs given by the user in Inputs: method 
         elseif strcmpi(method, "Backward")

                lengthOfVelocityVector = 1 : stepSize : length(timeData) - 1;     %% This finds how long the matrix for velocity need to be based on step size; the number of data is decreased by one for not using the first time data for backward difference method  
                dataNumber = 1;                                                   %% Assigning starting cell in the velocity vector to the first cell
                acceleration = zeros(length(timeData), 1);                        %% Used to give an data less output for acceleration, otherwise the function returns a error
                velocity = zeros(length(lengthOfVelocityVector), 1);              %% Sets a matrix where calculated values will be stored

                % This loop calculates the velocity using altitude and time data by backward method then stores result in corresponding cell the velocity matrix
                for loopIndex = 2 : stepSize : length(timeData)                   %% The number of iterations is decreased by one for not using the first time data for backward difference method 
                    velocity(dataNumber) = (altitudeData(loopIndex) - altitudeData(loopIndex- 1)) / (timeData(loopIndex) - timeData(loopIndex - 1));
                    dataNumber = dataNumber + 1;                                  %% updates the assigning cell number
                end

        % This conditional section runs if the required numerical method is central; based on the inputs given by the user in Inputs: method    
        else
                lengthOfVelocityVector = 1 : stepSize : length(timeData) - 2;     %% This finds how long the matrix for velocity needs to be based on step size; the number of data is decreased by one for not using the first and last time data for central difference method
                dataNumber = 1;                                                   %% Assigning starting cell in the velocity vector to the first cell
                acceleration = zeros(length(timeData), 1);                        %% Used to give an data less output for acceleration, otherwise the function returns a error
                velocity = zeros(length(lengthOfVelocityVector), 1);              %% Sets a matrix where calculated values will be stored

                % This loop calculates the velocity using altitude and time data by central method then stores result in corresponding cell the velocity matrix
                for loopIndex = 1 : stepSize :length(timeData) - 2                %% The number of iterations is decreased by two for not using the first and last time data for central difference method 
                    velocity(dataNumber) = (altitudeData(loopIndex + 2) - altitudeData(loopIndex)) / (timeData(loopIndex + 2) - timeData(loopIndex));
                    dataNumber = dataNumber + 1;                                  %% Updates the assigning cell number
                end    
        end

  % This conditional section runs if the required data is altitude which is based on the inputs given by the user in Inputs: valueToBeFound      
  elseif strcmpi(valueRequired, "Altitude")

         velocity = zeros(length(timeData), 1);                                   %% Used to give an data less output for velocity, otherwise the function returns a error
         acceleration = zeros(length(timeData), 1);                               %% Used to give an data less output for acceleration, otherwise the function returns a error

 % This conditional section runs if the required data is acceleration which is based on the inputs given by the user in Inputs: valueToBeFound           
  else
       % This conditional section runs if the required numerical method is forward; based on the inputs given by the user in Inputs: method 
       if strcmpi(method, "Forward")

           lengthOfAccelerationVector = 1:stepSize:length(timeData) - 1;           %% This finds how long the matrix for acceleration need to be based on step size; the number of data is decreased by one for not using the last time data for forward difference method  
           dataNumber = 1;                                                         %% Assigning starting cell in the acceleration vector to the first cell
           acceleration = zeros(length(lengthOfAccelerationVector), 1);            %% Sets a matrix where calculated values will be stored
           velocity = zeros(length(timeData), 1);                                  %% Used to give an data less output for velocity, otherwise the function returns a error

         % This loop calculates the acceleration using velocity and time data by forward method then stores result in corresponding cell the acceleration matrix   
         for loopIndex = 1 : stepSize : length(timeData) - 1                       %% The number of iterations is decreased by one for not using the last time data for forward difference method  
            acceleration(dataNumber) = (velocityData(loopIndex+1) - velocityData(loopIndex)) / (timeData(loopIndex+1) - timeData(loopIndex));
            dataNumber = dataNumber + 1;                                           %% updates the assigning cell number
         end

      % This conditional section runs if the required numerical method is backward; based on the inputs given by the user in Inputs: method    
      elseif strcmpi(method, "Backward")

           lengthOfAccelerationVector = 1:stepSize:length(timeData) - 1;           %% This finds how long the matrix for acceleration need to be based on step size; the number of data is decreased by one for not using the first time data for backward difference method  
           dataNumber = 1;                                                         %% Assigning starting cell in the acceleration vector to the first cell
           acceleration = zeros(length(lengthOfAccelerationVector) , 1);           %% Sets a matrix where calculated values will be stored
           velocity = zeros(length(timeData), 1);                                  %% Used to give an data less output for velocity, otherwise the function returns a error

            % This loop calculates the acceleration using velocity and time data by backward method then stores result in corresponding cell the acceleartion matrix   
            for loopIndex = 2 :stepSize : length(timeData)                         %% The number of iterations is decreased by one for not using the first time data for backward difference method 
                  acceleration(dataNumber) = (velocityData(loopIndex) - velocityData(loopIndex-1)) / (timeData(loopIndex) - timeData(loopIndex - 1));
                  dataNumber = dataNumber + 1;                                     %% updates the assigning cell number
            end

       % This conditional section runs if the required numerical method is central; based on the inputs given by the user in Inputs: method 
       else
           lengthOfAccelerationVector = 1:stepSize:length(timeData) - 2;             %% This finds how long the matrix for acceleration need to be based on step size; the number of data is decreased by two for not using the first and last time data for central difference method  
           dataNumber = 1;                                                           %% Assigning starting cell in the acceleration vector to the first cell
           acceleration = zeros(length(lengthOfAccelerationVector), 1);              %% Sets a matrix where calculated values will be stored
           velocity = zeros(length(timeData), 1);                                    %% Used to give an data less output for velocity, otherwise the function returns a error

           % This loop calculates the acceleration using velocity and time data by backward method then stores result in corresponding cell the acceleartion matrix
           for loopIndex = 1 :stepSize : length(timeData) - 2                        %% The number of iterations is decreased by two for not using the first and last time data for central difference method 
                  acceleration(dataNumber) = (velocityData(loopIndex + 2) - velocityData(loopIndex)) / (timeData(loopIndex + 2) - timeData(loopIndex));
                  dataNumber = dataNumber + 1;                                       %% updates the assigning cell number
           end   
       end
  end