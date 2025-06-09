% srtsinglesingle(Tab) sorts matrix Tab and deletes all redundant values
%


function Tab=sortsingle(Tab)

warning('sortsingle : use unique instead');

Tab=sort(Tab);

if isempty(Tab), return; end

if isnumeric(Tab) || ischar(Tab),
    same = ~diff(double(Tab));
else
    same = strcmp(Tab, decale(Tab));
end
    
Tab(same) = [];
