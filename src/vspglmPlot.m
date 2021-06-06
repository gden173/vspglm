function vspglmPlot(Y,X, betas, links,phat)   
    % vspglmPlot(Y,X, betas, links,phat)   
    % Produces diagnostic plots of the output distribution
    % of the vspglm function.     
    
    
    K = length(Y);    
    ypred = cell(1,K);
    for i = 1:K
        XB = sum((betas{i}.').*X{i},2); 
        switch links{i}            
            case 'id'                
                ypred{i} = XB;
            case 'inv'
                ypred{i} = 1./XB;
            case 'log'
                ypred{i} = exp(XB);
            case 'logit'
                ypred{i} = exp(XB)./(1 + exp(XB));
        end
    end
    for i  = 1:K
        for j = 1:K
            subplot(K, K, ((i-1) * K) + j)
            if i == j             
                vars = arrayfun(@(k) var(Y{i}, phat(k,:)), 1:length(Y{i}));
                plot(ypred{i}, vars, "bo")   
                xl = xlabel(['$\mu_',num2str(j) , '$' ]);
                yl = ylabel(['$\sigma^2_',num2str(i) , '$' ]);
                tl = title(['$\sigma^2_',num2str(i) , '$' ]);
                yl.Rotation = 0;
                set([xl, yl, tl], 'interpreter', 'latex')
                axis auto
                grid on 
            else 
                yj = phat.*(Y{j}.');
                yi = phat.*(Y{i}.');
                
                N = size(phat, 1);
                corrs = zeros(N);
                for m = 1:N
                    for n = 1:N
                        corrs(m,n) = corr(yi(m, :).', yj(n, :).');
                    end
                end               
                
                [x,y] = meshgrid(ypred{j}, ypred{i});
                scatter(x(:),y(:), [], corrs(:), 'filled')
                colormap(parula)
                caxis([-1, 1])
                grid on 
                colorbar;
                mu1 = ['\mu_',num2str(j)];
                mu2 = ['\mu_',num2str(i)];
                xl = xlabel(['$', mu1,'$']);
                yl = ylabel(['$', mu2,'$']);
                tl = title(['$\rho(', mu1, ',', mu2,')$']);
                yl.Rotation = 0;
                set([xl, yl, tl], 'interpreter', 'latex')
                
            end
        end
    end
end