function el = getElementData(d,elNum)
%% el=elementValues(d,elNum) collects the values of d at element elNum.
% note: this function can only work on nonadaptive meshes. 
% el is a return structure with the nodal fields of d. 

%% Check if case is adaptive
if iscell(d.elements)
    disp('This is an adaptive case. elementValues is not built for that')
    el =-1;
    return;
end

% number of timesteps
nt = length(d.t);

%% Collect element data
el.element = d.elements(elNum,:);
q = el.element(2);
Q = sum(d.elements(1:elNum-1,2));
el.s = d.s(Q+(1:q)); 

% collect valid fields and their size
[fields,dofs] = chooseFields(d);

%% Do for all fields
for ff = 1:length(fields)
    
    fn = fields{ff};            
    
    % extract field name data
    data = d.(fn);    
    % Set container size:    
    odata = zeros(nt,q*dofs(ff));
    
    % loop through time
    for ii = 1:nt
        elementValues=data{ii}(Q+(1:q),:);                    
        % Assign as column vector
        odata(ii,:) = elementValues(:)';        
    end
    % Save field data in output structure. 
    el.(fn) = odata;
end

end %% END OF FILE
