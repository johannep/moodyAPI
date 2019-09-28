function ind = timeIndex(folder,t)
% Extract the index vector of desired output time t %

% Choose input format
if ischar(folder)
    tVec = load(strcat(folder,'/time.dat') );
elseif isstruct(folder)
    tVec = folder.t;
end

% Extract and save time
ind = zeros(size(t));
N = length(t);
nn=1;
jj=1;
while nn<=N
    
    if t(nn) == tVec(jj) 
        ind(nn) = jj;
        nn=nn+1;
    elseif t(nn)<tVec(jj)
        if ( tVec(jj)+tVec(jj-1) )>2*t(nn)
            ind(nn) = jj-1;
        else
            ind(nn) = jj;
        end
        nn=nn+1;
    end
    
    jj=jj+1;
    
    % [~,ind(nn)] = min(abs(tVec-t(nn)));
    
end

% * * * * * END OF FILE * * * * * %
