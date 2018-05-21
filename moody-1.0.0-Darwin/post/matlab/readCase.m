function [ d ] = readCase(folderName,varargin)
%READCASE is used to load moody results into an array of data structures.
% Input:
%   folderName: name of result folder. (default is present dir.)
%   varargin  : is a list of variables to load. Options are
%               'p'     for position   (nq by dim) each time
%               'v'     for velocity   (nq by dim) each time
%               'tan'   for tangent    (nq by dim) each time
%               'T'     for tension    (nq by 1) each time
%               'eps'   for strain     (nq by 1) each time
%               'epsR'  for strainRate (nq by 1) each time
%                              
% Output: 
%   d        :  output cell array where each cell is a cable structure. 
%               d.t contains output times
%               Each variable field is a nTimes by 1 cell. 

if nargin==0
    folderName = '.';
end

% Extract cable names in directory
cNames = getCableNames(folderName);


% Do for all cables:
d = cell(length(cNames),1);
for cn = 1:length(cNames)
    objName = cNames{cn};
    
    data=struct();
    
    % Read outputFormat
    outputFormat = findKey(strcat(folderName,'/','setup.txt'),'print.format');
    % Legacy check: 
    if outputFormat == -1 
        outputFormat = findKey(strcat(folderName,'/','setup.txt'),'outputformat');
    end
    
    % Choose output format:
    if strcmp(outputFormat,'ascii') || (outputFormat(1) == 0)
        outputFormat = 0;
    else % default is binary...
        outputFormat = 1;
    end
    
    data.caseName = folderName;
    % Read dimension number
    dim=findKey(strcat(folderName,'/','setup.txt'),'dimensionNumber');
    data.dim=dim;
    
    [t,N,els]=readMesh(objName,folderName);
    data.s = cell(length(t),1);
    sFile=fopen(strcat(folderName,'/',objName,'_sPlot.dat'),'r');
    for ii = 1:length(t)
        data.s{ii} = (extractNextLine(sFile))';
        data.s{ii} = data.s{ii}(2:end);
    end
    fclose(sFile);
    
    adaptingMesh=false;
    if size(N,1) ~= 1
        adaptingMesh=true;
        
    else
        nNodes = N(3);
        nModes = N(2);
        data.s = data.s{1};
    end
    
    nLines=length(t);
    
    % totalSize = sum(N);
    
    fileList={'position','velocity','tangent','tension','strain','strainRate','modal';
        'p'     ,   'v'    ,    'tan'  ,  'T'     , 'eps'   , 'epsR'   ,'m'   };
    
    % Default is to process all results
    if (isempty(varargin))
        inputList=fileList(1,:);        
    else
        inputList=varargin;
    end
    
    inArgs=length(inputList);
    
    for vv=1:inArgs
        switch inputList{vv}
            case {'position','p'}
                
                data.p = getData('_position','nodal',dim);
                
            case {'velocity','v'}
                
                data.v = getData('_velocity','nodal',dim);
                
            case {'tangent','tan'}
                
                data.tan = getData('_tangent','nodal',dim);
                
            case {'tension','T'}
                
                data.T = getData('_tension','nodal',1);
                
            case {'strain','eps'}
                
                data.eps = getData('_strain','nodal',1);
                
            case {'strainRate','epsR'}
                try
                    data.epsR = getData('_strainRate','nodal',1);
                catch e
                    disp('strain rate data not found')
                end
            case {'modal','m'}
                if any(strcmp(varargin,'legacy'))
                    data.m = getData('','modal',5*dim);
                else
                    data.m = getData('','modal',4*dim);
                end
                
        end
        
    end
    
    %% Save mesh variables in data structure
    
    data.t = t;
    data.elements=els;
    data.N = N;
    data.name=objName;
    
    if length(cNames)>1
        d{cn} = data;
    else
        d= data;
    end
end

%% Read and store any variable
    function outVals = getData(fname,nodalModalSwitch,mult)
        
        % Create output cell
        outVals = cell(nLines,1);
        
        % Switch to modal
        
        nodalModalSwitch = strcmp(nodalModalSwitch,'nodal');
        locSize = [1,mult];
        if (~adaptingMesh)
            if nodalModalSwitch
                locSize(1) = nNodes;
            else
                locSize(1) = nModes;
            end
        end
        
        % Open file for reading
        fid = fopen(strcat(folderName,'/',objName,fname,'.dat'),'r');
        
        % Do for each line
        for nn=1:nLines
            
            
            if (adaptingMesh)
                locSize(1) = nodalModalSwitch*N(nn,3) + ...
                    (1-nodalModalSwitch)*N(nn,2);
                %                         locSize(1)
                %                         locSize(2)
                %                         locSize(1)*locSize(2)+1
            end
            
            if (outputFormat)
                % Binary mode
                [rawData]=fread(fid,locSize(1)*locSize(2)+1,'double');
                
                
            else
                % Ascii mode
                rawData =  (extractNextLine(fid))';
                
            end
            
            outVals{nn} = zeros(locSize);
            outVals{nn}(:) = rawData(2:end);
            
        end
        fclose(fid);
        
    end % getData nested function


    function cNames = getCableNames(folder)
        
        C=dir(folder);
        C=struct2cell(C);
        C = C(1,:);
        
        keepIt = false(length(C),1);
        
        for  nn=1:length(C)
            % Operate only on cable-files with no _ = cableX.dat %
            nameLength = length(C{nn});            
            if nameLength>=5 && strcmp(C{nn}(1:5),'cable') && isempty( strfind(C{nn},'_') )
                % Strip from ending .dat
                ind=strfind(C{nn},'.');
                keepIt(nn)=1;
                C{nn} = C{nn}(1:ind-1);
            end
        end
        cNames=C(keepIt);
        
    end
end % function

