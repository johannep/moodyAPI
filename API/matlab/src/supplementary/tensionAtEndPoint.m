function T = tensionAtEndPoint(fileN,nLines)
if ischar(fileN)
    f = fopen(strcat(fileN,'_tension.dat'),'r');
    vals =extractNextLine(f);
    T=zeros(nLines,2);
    cntr =0;
    while ( vals(1)~=-1 )
        cntr = cntr+1;
        T(cntr,1)=vals(1);
        T(cntr,2)=vals(end);
        vals =extractNextLine(f);
    end
    fclose(f);
elseif isstruct(fileN)
   % Do if input is case data.
   T = zeros(size(fileN.t));
   for ii=1:length(fileN.t)
       T(ii) = fileN.T{ii}(end);        
   end
end

end % of function
