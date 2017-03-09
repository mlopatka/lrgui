function isvalid = confirmWorkflowValidity(wrkflw)
    isvalid = true;
    
    s2 = regexp(wrkflw, '>', 'split');
    
    global feature_data
    global h
    
    %%begin checking for possible failures
    %%% last element is not in the list of valid score metrics
    if sum(strcmp(strtrim(s2{end}),strtrim({'absolute dif';'bray-curtis ';...
            'cannbera    ';'chebychev   ';'cityblock   ';'correlation ';...
            'cosine      ';'euclidean   ';'mahalanobis '; 'minkowski   '}...
        )))<1
        isvalid = false;
        disp('last element in workflow must ALWAYS be a score metric');
    end
    
    %%% log is taken when possible negative values occur in data 
    if find([strcmpi('log', strtrim(s2))]) > find([strcmpi('-mean', strtrim(s2))])
        isvalid = false;
        disp('workflow takes the log of negative values!'); 
    end
    
    %%% mahalonobis distance is likely to fail
    if strcmp(strtrim(s2{end}),strtrim('mahalanobis'))
        ind_temp = logical(cell2mat(get(h.c, 'Value')));
        [~,err] = cholcov(cov(feature_data(:,ind_temp)), 0);
        if err>0 %fails positive definite test
            isvalid = false;
            disp('due to data dimensionality, Mahalanobis metric is likely to fail! Covariance matrix is not positive definite');
        end    
    end
        disp('workflow verified');
end