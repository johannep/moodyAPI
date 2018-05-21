function F = moodyAPI(stageName,varargin)
%moodyAPI Interface between Moody API and matlab .m-files.
%   This function is a wrapper for access to functions moodyInit, moodySolve and moodyClose
switch stageName
    case {1 , 'init'}
        moodyInit(varargin{:});        
        F = -1;        
    case {2 , 'solve'}
        F = moodySolve(varargin{:});        
    
    case {3 , 'close'}
        moodyClose();        
        F = -1;
        
end

end

%% INITIALIZATION CALL TO MOODY
function moodyInit(name,X,startTime)
  if (ismac)
    loadlibrary('libmoody.dylib','moodyWrapper.h');
  else
    loadlibrary('libmoody.so','moodyWrapper.h');
   end
    calllib('libmoody','moodyInit',name,length(X),X,startTime);        
end

%% SOLVE MOORING DYNAMICS BETWEEN T1 and T2. 
%  RETURN MOORING FORCES FOR EACH DOF OF X AS F
function F = moodySolve(X,T1,T2)       
    F_value = zeros(size(X));    
    F_p = libpointer('doublePtr',F_value);
    calllib('libmoody','moodySolve',X,F_p,T1,T2);    
    F = F_p.value;
end

%% CLOSE MOODY LIB
function moodyClose()
    calllib('libmoody','moodyClose');    
    unloadlibrary('libmoody');
end

