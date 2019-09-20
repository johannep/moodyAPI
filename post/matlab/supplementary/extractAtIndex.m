function [val] = extractAtIndex(f,ind)

% Extract a single time
ii=1;
while ( ii<ind)
    fgetl(f);
    ii=ii+1;
end

str = fgetl(f);
val = str2num(str);

fseek(f,0,-1);
   
