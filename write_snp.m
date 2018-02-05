function write_snp(fileName, S, f, varargin)
% write_snp(fileName,S,f)
% write_snp(fileName,S,f,param_name,param_val,...)
% 
% Writes a TS file. Currently supports only version 1.
% 
% Inputs:
% fileName - (string) Name of file, with path, no extensions.
% S - (complex) [Nports Nports Nfreqs] S-parameters.
% f - Frequencies in Hz.
% 
% Possible parameters:
% 'filetype' - ('S'), 'Y' or 'Z'.
% 'fileMode' - 'RI', ('MA'), 'DB'
% 'freqFactor' - ('Hz'), 'KHz', 'MHZ', 'GHZ', 'THz'
% 'Z0' - Default 50. Complex not supported yet.
% 
% Example:
% write_snp('Example_TS',S,f,'filetype','S','freqfactor','GHz');


% Default parsing parameters
fileType = 'S';
fileMode = 'MA';
freqFactor = 'Hz';
Z0 = 50;
isZ0natural = 1;

nPorts = size(S,1);

paramNames = {'filetype','filemode','freqfactor','Z0'};

% Parse optional inputs:
% 1. Check if number of inputs is even
if(mod(numel(varargin),2) ~= 0)
  error('Parameter row should be of an even number of elements');
end

% Iterate pair by pair
for cVarIdx = 1:(numel(varargin)/2)
  % Extract name-value pair
  cVarName = varargin{(cVarIdx-1)*2 + 1};
  cVarVal = varargin{(cVarIdx-1)*2 + 2};
  
  % Validate the string name
  cVarName = validatestring(cVarName,paramNames,'write_snp',cVarName);
  
  switch (cVarName)
    case paramNames{1}  % file type - 'S', 'Y', and 'Z'
      fileType = validatestring(cVarVal,{'S','Y','Z'},'write_snp',cVarVal);
    case paramNames{2}  % file mode - 'RI' ; 'MA' ; 'DB' 
      fileMode = validatestring(cVarVal,{'RI','MA','DB'},'write_snp',cVarVal);
    case paramNames{3}  % Frequency multiplier factor
      freqFactor = validatestring(cVarVal,{'Hz','KHz','MHz','GHz','THz'},'write_snp',cVarVal);
    case paramNames{4}  % Z0 (characteristic impedance) 
      % Check if this is a number
      if ~isnumeric(cVarVal)
        error(['''' cVarName ''' must be numeric']);
      end
      Z0 = cVarVal;
      % Check if it is complex (only TS 2.0)
      if iscomplex(Z0)
        warning('Complex impedance is not supported yet. Only real part will be used');
        Z0 = real(Z0);
      end
      % Check if Z0 is natural (for header row)
      if(int32(Z0) == Z0)
        isZ0natural = 1;
      end
  end
end

% Open file to write
fHdl = fopen([fileName '.s' num2str(nPorts) 'p'],'w+');

% Write header line
if(isZ0natural)
  impFormat = '%d';
else
  impFormat = '%.2f';
end
fprintf(fHdl,['! Created by GNU Octave' date '\n']);
fprintf(fHdl,['# %s %s %s R ' impFormat '\n'],freqFactor,fileType,fileMode,Z0);

% Define format line
formatLine = ['%f ' repmat(['%f %f '],[1 nPorts*nPorts]) '\n'];

% Convert data according to file mode
switch (fileType)
  case 'S'
    D = S;
  case 'Z'
    D = Z0*convS2Z(S);
  case 'Y'
    D = (1/Z0)*convS2Y(S);
end

% Set frequency multiplier
freqMult = parseFreq(freqFactor);

% Convert data according to mode
switch(fileMode)
  case 'RI'
    D1 = real(D);
    D2 = imag(D);
  case 'MA'
    D1 = abs(D);
    D2 = angle(D)*180/pi;
  case 'DB'
    D1 = 20*log10(abs(D));
    D2 = angle(D)*180/pi;
end

% Start writing data
for lineIdx = 1:size(S,3)
  % Flatten both pairs of data
  cD1 = reshape(D1(:,:,lineIdx),[],1);
  cD2 = reshape(D2(:,:,lineIdx),[],1);
  
  % Interlace current line
  cLine = zeros([numel(cD1)+numel(cD2) 1]);
  cLine(1:2:end) = cD1;
  cLine(2:2:end) = cD2;
  
  % Write line to file
  fprintf(fHdl,formatLine,[f(lineIdx)/freqMult cLine.']);
end

% Close file
fclose(fHdl);
end

function Z = convS2Z(S)
  D = size(S);
  Scell = mat2cell(S,D(1),D(2),ones([1 D(3)]));
  S2Z = @(S) (eye(D(1)) - S)\(eye(D(2)) + S);
  Zcell = cellfun(@S2Z,Scell);
  Z = cell2mat(Zcell);
end

function Y = convS2Y(S)
  D = size(S);
  Scell = mat2cell(S,D(1),D(2),ones([1 D(3)]));
  S2Y = @(S) (eye(D(1)) + S)\(eye(D(2)) - S);
  Ycell = cellfun(@S2Y,Scell);
  Y = cell2mat(Zcell);
end

function freqMult = parseFreq(freqFactor)
  switch(freqFactor)
    case 'Hz'
      freqMult = 1;
    case 'KHz'
      freqMult = 1e3;
    case 'MHz'
      freqMult = 1e6;
    case 'GHz'
      freqMult = 1e9;
    case 'THz'
      freqMult = 1e12;
  end
end