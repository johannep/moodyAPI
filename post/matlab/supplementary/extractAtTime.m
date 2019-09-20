function rowVal = extractAtTime(f,t,flag)
if (nargin<3)
    flag='';
end
cntr=0;
if strcmp(flag, 'row')
    % return f-values at row no. t
    while (cntr<t)
        cntr = cntr+1;
        rowStr = fgetl(f);
    end
    rowVal = str2num(rowStr);
else
    % return f-values at row with t as first value
    
    found = false;
    rowStr ='';
    while (~found && ~strcmp(rowStr,'-1'))
        rowStr = fgetl(f);        
        cntr=cntr+1; 
        rowVal = str2num(rowStr);        
        if ( abs(rowVal(1)-t)<1e-8 )
            found=true;
        end
    end
    
end

fseek(f,0,-1);
