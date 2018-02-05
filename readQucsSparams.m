function [S,Z0,f] = readQucsSparams(qucsDataFile)
  % Read variables using QUCS "api"
  qucsVars = loadQucsDataSet(qucsDataFile);
  
  % Currently defaults at 50 Ohm
  Z0 = 50;
  
  Stemp = [];
  Sidxs = [];
  
  % Separate frequency and S-parameters from the rest of the results.
  for varIdx = 1:numel(qucsVars)
    cVar = qucsVars(varIdx);
    
    % Special case, handle the frequency case
    if(strcmp(cVar.name,'frequency'))
      f = reshape(cVar.data,[],1);
      continue;
    end
    
    [values, count,~ ,~] = sscanf (cVar.name,'S[%d,%d]');
    % Save positions of values before reshaping
    if(count == 2)
      Sidxs = [Sidxs ; values(:).'];
      Stemp = [Stemp cVar.data(:)];
    end
  end
  
  
  Sdims = max(Sidxs,[],1);
  S = zeros([Sdims numel(f)]);
  
  % Arrange by dimensions
  for sIdx = 1:size(Sidxs,1)
    S(Sidxs(sIdx,1),Sidxs(sIdx,2),:) = Stemp(:,sIdx);
  end
end