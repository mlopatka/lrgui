function LRval =  evalLR(varargin)

params = varargin{end};

if numel(varargin) == 2
   % obviously this is a distance and params situation
   distance = varargin{1};
elseif numel(varargin) == 3
   % this is a score1, score2, params situation
   score1 = varargin{1};
   score2 = varargin{2};
   error('You still need to fix this martin!!!')
else
    error('invalid number of input parameters!');
end

if strcmpi(varargin{1,2}.sameClass.modelType, 'kde') || strcmpi(varargin{1,2}.differentClass.modelType, 'kde')
   if ~strcmpi(varargin{1,2}.sameClass.modelType, 'kde') % ONLY the different class is KDE
       numerator = pdf(params.sameClass.modelType,distance,...
        params.sameClass.params(1),params.sameClass.params(2));
       %[~,denominator,~,~] = kde(params.distances.diff, distance, 2);
       denominator = ksdensity(params.distances.diff, distance);
        LRval = numerator/denominator;
        
   elseif  ~strcmpi(varargin{1,2}.differentClass.modelType, 'kde') % ONLY the same class is KDE
        denominator =  pdf(params.differentClass.modelType,distance,...
            params.differentClass.params(1),params.differentClass.params(2));
        %[~,numerator,~,~] = kde(params.distances.same, distance, 2);%, linspace(min(params.distances.same),max(params.distances.same),2^12));
         numerator = ksdensity(params.distances.same, distance);
        LRval = numerator/denominator;
   
  else % both are KDE
    %keyboard;
    %[~,numerator,~,~] = kde(params.distances.same, distance, 2);%, linspace(min(params.distances.same),max(params.distances.same),2^12));
    numerator = ksdensity(params.distances.same, distance);
    denominator = ksdensity(params.distances.diff, distance);
    %[~,denominator,~,~] = kde(params.distances.diff, distance, 2);%, linspace(min(params.distances.diff),max(params.distances.diff),2^12));
    LRval = numerator/denominator;
  end
   
else
    LRval = pdf(params.sameClass.modelType,distance,...
        params.sameClass.params(1),params.sameClass.params(2))...
        /pdf(params.differentClass.modelType,distance,...
        params.differentClass.params(1),params.differentClass.params(2));
end
