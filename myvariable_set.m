function varargout = myvariable_set(allvariables, varz, fild, valu)
%struct = myvariable_set(struct, variablename, fild, valu)
%myvariable_set(mystatfile, variablename, fild, valu)

withfile = 0;
if ischar(allvariables), % mystat file
    load(allvariables);
    withfile =1;
end

v = find([allvariables.name] == varz);
if isempty(v),
    error('variable not found');
end
v = v(1); %in case more than one var with that name (should not occur), take the first one

switch lower(fild)
    case 'name',
        allvariables(v).name = valu;
    case 'valuename',
        allvariables(v).valuename = valu;
end

if withfile,
    varargout = {};
else varargout = allvariables;
end