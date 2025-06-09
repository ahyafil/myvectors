function [meansubj missingsbj]= missingsubj(meansubj, subvalues, warnoff, errwrn)
%[data missingsbj]= missingsubj(data, subvalues [,'off'])
%data is a matrix or a cell whose first dimension is subject
%add 'off' to remove warning msg

%wrn=1;
%if nargin==3 & streq(warnoff, 'off'), wrn=1; end
wrn = nargin<3 || ~strcmp(warnoff, 'off');
doerr = nargin<4 || ~strcmp(errwrn, 'warning');
if nargin<2, subjvalues = [1:size(meansubj,1)]; end
if isnumeric(subvalues), subvalues = {subvalues}; end

if isnumeric(meansubj),  %find the  NaNs
    missingpoint = isnan(meansubj); %detects missing data points
else                    %cells: find the empty ones
    nbmeas = cellfun(@length, meansubj);
    missingpoint = ~nbmeas;
end

%combinations with no data for any subject
missingcombi = all(missingpoint);
[dem missingcombi2] = enligne(squeeze(missingcombi));
missingcombi3 = missingcombi2(:,find(squeeze(missingcombi)));
if size(missingcombi3,2)
for i=1:size(missingcombi3,2),
               txt = 'missing combination : ';
               for j=1:size(missingcombi3,1),
                   txt = [txt, subvalues{1+j}{missingcombi3(j,i)} ', '];
               end
               disp(txt(1:end-2));
end
        if doerr,
        error('missing data for all subjects');
        else
                    warning('missing data for all subjects');
        end
end
           

%remove combinations with no data from subject analysis
missingpoint = missingpoint & ~repmat(missingcombi, [size(missingpoint,1) 1]);

for d=2:ndims(meansubj)  %collects over all dimensions except the first( subject)
    missingpoint = any(missingpoint,d); 
end
missingsbj = find(missingpoint);
msgsbjval = subvalues{1}(missingsbj);

if length(missingsbj),  %if any subject missing data poins
%     if length(missingsbj)==length(missingpoint)
% 
%         [missingcombi1 missingcombi2] = enligne(missingcombi);
%         missingcombi = missingcombi2(:,find(missingcombi));
%         if size(missingcombi,2) & length(subvalues)>1
%            for i=1:size(missingcombi,2),
%                txt = 'missing combination : ';
%                for j=1:size(missingcombi,1),
%                    txt = [txt, subvalues{1+j}{missingcombi(j,i)} ', '];
%                end
%                disp(txt(1:end-2));
%            end
%         end
%         if doerr,
%         error('insufficient data for all subjects');
%         else
%                     warning('insufficient data for all subjects');
%         end
%     end
    if wrn,
    warning off backtrace    
    warning(['data points missing : ' num2str(length(msgsbjval)) ' subjects (' num2str(msgsbjval) ') removed from analysis']);
    warning on backtrace
    end
    siz=size(meansubj);
    siz1=siz(1); %will be useful later
    siz(1)=1;
    keepdata=repmat(~missingpoint, siz); %positions that have to be kept (all datapoints corresponding to an incomplete sub)
    meansubj= meansubj(keepdata);    %remove the data points
    siz(1)=siz1 - length(missingsbj);
    meansubj=reshape(meansubj, siz); %return to a ndim array form because the remove had turned it into a vector
end

