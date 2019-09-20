function out = probeCable(d,sProbe)
%% probeCable(d,sProbe) extract data at point s or in interval [s0,s1]  s\in[0 1] 
% d is formatted as output from readCase.
%
% If sProbe is single-valued : sProbe is an s-value \in [0, 1].
% If not an exact match of output point, a linear interpolation of all
% values is made.
%
% If sProbe = [s0 s1] : sProbe specifies an s-range\in [0,1]. This option
% works only for non-adaptive meshes.
% out has the fields specified below.  It contains only time histories at
% the point specified by sProbe.

% loop through all times
adaptFlag = iscell(d.s);
% if not adaptive: do constant evaluation of blending
if ~adaptFlag
    L=d.s(end);
    sProbe=sProbe*L;
else
    L=d.s{1}(end);  % assuming the length of line is unchanged (which it always is at present).
    sProbe=sProbe*L;
end

nt = length(d.t);
out.t = d.t;

[fields,dofs] = chooseFields(d);

%% Do for a single sProbe
if size(sProbe)==1
      
    out.s = sProbe;
    if ~adaptFlag
        [ind,blend] = sIndex(d.s,sProbe(1));        
    end
        
    %% Loop through time:    
    for ff = 1:length(fields)
        fn=fields{ff};
        data=d.(fn);
        odata =zeros(nt,dofs(ff));
        
        for tt=1:nt
            % check every time if adaptive results (yes many checks not needed)
            if adaptFlag
                [ind,blend] = sIndex(d.s{tt}(2:end),sProbe(1));
            end
            
            odata(tt,:) = blendValues(data{tt},ind,blend);
        end
        out.(fn) = odata;
    end
    
%% Do for an s-interval on static meshes
elseif length(sProbe)==2
    if ~adaptFlag
        inds=getInds(d.s,sProbe);
        out.s = d.s(inds(1):inds(2));         
        out.nq = length(out.s);   
        out.dim = d.dim;
        fns = {'p','v','tan','T','eps' 'epsR'};
        ndofs = [d.dim d.dim d.dim 1 1 1];
        for ff= 1:length(fns)
            fn=fns{ff};
            %data=
            odata = zeros(nt,out.nq*ndofs(ff));
            for tt=1:nt
                x = d.(fn){tt}(inds(1):inds(2),:);
                odata(tt,:) = x(:)';
            end
            out.(fn)=odata;
        end
    else
        disp('The mesh is adapting. sProbe=[s0 s1] interval is not supported for adaptive results.')
        out = -1;
        return
    end
else
    disp('Warning: sProbe should be a single value of s or an interval of values as [sMin smax]')    
end

%% Nested function getsIndex
    function [ind,blend] =sIndex(s,sProbe)
        ind = find(s>=sProbe,1);
    
        if ( ind>1 )
            ind = [ind-1 ind]; % add interval below
        elseif ind==1
            ind = [ind ind+1];
        else % sProbe is larger than s(end) assume ind=size(s)
            ind = length(s);
            ind = [ind-1 ind];
        end
            
        ss = s(ind); % s-range
        
        % HARDCODED TOLERANCE: to check if we are at an element boundary.  
        if ( diff(ss) <= 1e-10*s(end) )
            ind(2)=ind(2)+1; % increase one step up. (never at end anyway)
            ss = s(ind);
        end
        
        blend = [ss(2)-sProbe sProbe-ss(1)]/diff(ss);        
    end

%% Nested function blendValues:
    function v=blendValues(x,ind,blend)
        v=x(ind(1),:)*blend(1) + x(ind(2),:)*blend(2);
    end


%% Nested function get indices:
    function inds=getInds(s,sProbe)
        inds= [find(s>=sProbe(1),1) find(s<=sProbe(2),1,'last')];
    end

end % END OF FILE