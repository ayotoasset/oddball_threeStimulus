function matricesIntensity = batch_getPerSubjectMatrix_Intensity(dataNorm, erpComponent, erpDataType, fieldValue, noOfSubjects, noOfTrials, handles)
       
    conditionFields = fieldnames(dataNorm);
    sessionFields = fieldnames(dataNorm.dark);
    noOfSessions = length(sessionFields);

    %{
    matricesIntensity.dark = zeros(handles.parameters.EEG.nrOfChannels, noOfSessions, noOfTrials, noOfSubjects);
    matricesIntensity.dim = zeros(handles.parameters.EEG.nrOfChannels, noOfSessions, noOfTrials, noOfSubjects);
    matricesIntensity.bright = zeros(handles.parameters.EEG.nrOfChannels, noOfSessions, noOfTrials, noOfSubjects);
    %}

    dispNrOfCombinations = 0;
    for ii = 1 : length(conditionFields)                        

        for i = 1 : length(sessionFields)
            ERPtypes  = fieldnames(dataNorm.dark.(sessionFields{i}));

            for j = 1 : length(ERPtypes)
                subjectNames = fieldnames(dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component);

                for k = 1 : length(subjectNames)
                    chNames = fieldnames(dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType));

                    for l = 1 : length(chNames)
                        noOfTrials = length(dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType).(chNames{l}));

                        for lj = 1 : noOfTrials
                            try
                                compNames = fieldnames(dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType).(chNames{l}){lj});
                            catch err
                                [ii i j k l lj]
                                err
                                a1 = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{1}).component.(subjectNames{k})
                                a2 = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{1}).component.(subjectNames{k}).(erpDataType)
                                a3 = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{1}).component.(subjectNames{k}).(erpDataType).(chNames{l})
                            end

                            for m = 1 : 1 % length(compNames), we are only picking one

                                for n = 1 : 1 % length(statFields) we are only picking one                                        

                                    if dispNrOfCombinations == 0
                                        numberOfCombinations = length(conditionFields) * length(sessionFields) * length(ERPtypes) * length(subjectNames) * length(chNames) * noOfTrials * 1 * 1;
                                        disp(['  .. .   Number of combinations: ', num2str(numberOfCombinations)])
                                        dispNrOfCombinations = 1;
                                    end                                        

                                    % easier variable names
                                    if ~strcmp(erpComponent, 'RT')
                                        % disp([i lj k])
                                        try
                                            dataPoint = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType).(chNames{l}){lj}.(erpComponent).(fieldValue);
                                        catch err
                                            err
                                            error('Typo with what you wanted to get?')
                                        end
                                        if isstruct(dataPoint)
                                            error('Data point at this part should not be a structure, error in the code! Check how structures are nested and maybe you forgot one field?')
                                        end
                                        matricesIntensity.(ERPtypes{j}).(conditionFields{ii})(l,i,lj,k) = dataPoint;
                                    else      
                                        try 
                                            dataPoint = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType).(chNames{l}){lj}.(erpComponent);
                                        catch err
                                            err
                                            a1 = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType)
                                            a2 = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType).(chNames{l})
                                            whos
                                            a3 = dataNorm.(conditionFields{ii}).(sessionFields{i}).(ERPtypes{j}).component.(subjectNames{k}).(erpDataType).(chNames{l}){lj}
                                            whos
                                        end
                                        if isstruct(dataPoint)
                                            error('Data point at this part should not be a structure, error in the code! Check how structures are nested and maybe you forgot one field? Maybe an extra fieldValue for RT from previous steps?')
                                        end
                                        matricesIntensity.(ERPtypes{j}).(conditionFields{ii})(l,i,lj,k) = dataPoint;
                                            

                                    end
                                end
                            end
                        end                                
                    end                        
                end
            end
        end
    end