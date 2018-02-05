function [S,Z0,f] = readQucsSparams(qucsDataFile)
  % Read variables using QUCS "api"
  qucsVars = loadQucsDataSet(qucsDataFile);
  
  % First iteration, find frequency
  for varIdx = 1:numel(qucsVars)
    cVar = qucsVars(varIdx);
    
    % Special case, handle the frequency case
    if(strcmp(cVar.name,'frequency'))
      f = reshape(cVar.data,[],1);
      break;
    end
    
  end
  
  Z0 = 0;
  Stemp = [];
  Sidxs = [];
  % Second iteration, populate S-parameters
  for varIdx = 1:numel(qucsVars)
    cVar = qucsVars(varIdx);
    [values, count,~ ,~] = sscanf (cVar.name,'S[%d,%d]');
    
    % Save positions of values before reshaping
    if(count == 2)
      Sidxs = [Sidxs ; values(:).'];
      Stemp = [Stemp cVar.data(:)];
    end
  end
  
  Sdims = max(Sidxs);
  S = zeros([Sdims numel(f)]);
  
  % Arrange by dimensions
  for sIdx = 1:size(Sidxs,1)
    S(Sidxs(sIdx,1),Sidxs(sIdx,2),:) = Stemp(:,sIdx);
  end
end