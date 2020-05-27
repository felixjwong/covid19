k = 1; j = 1; l = 1; m = 1;
ndate = []; sdate = [];
nmagnitude = []; smagnitude = []; 
[xsize ysize] = size(dat);
indices = []; nindices = [];
nmotility_data = []; smotility_data = [];
sindices = []; mobnindices = [];

figure; 
for i = 1:xsize
    this_dat = dat(i,:);
    if (max(this_dat) > 10) && (min(diff(this_dat))>=0) % more than 50 people have it, no decreasing
        
        td = this_dat/max(this_dat); % normalized timeseries
        td = moving_avg(td,10); % 10-point moving average
        [s idx] = max(diff(td,1)); % compute max derivative

            
        if (dates(i) ~= 7) && (dates(i) ~= 12) % not china
            if length(td)-5 > idx % spike cannot be ongoing, within past 5 days

                if ~isempty(MO)
                mot = cell2mat(MO{i});
                if ~isempty(mot)
                    dips = [];
                    for whichmo = 2:7 %%which motility data
                        grf = (mot(:,whichmo)- min(mot(:,whichmo))); % make positive
                        if max(isnan(grf))
                            dips = horzcat(dips, [NaN NaN]);
                            continue
                        end
                        %grf = grf/max(grf); % normalize
                        grf = moving_avg(grf,10);
                        [ds didx] = min(diff(grf,1)); % compute min derivative
                        %if ((whichmo == 4) || (whichmo == 6)) && (didx+min(mot(:,1))-1 < 40) %% international
                         %   dips = horzcat(dips, [NaN NaN]);
                          %  continue
                        %end
                        if (whichmo == 7) % residential
                            [ds didx] = max(diff(grf,1));
                            ds = -ds;
                        end              
                        dips = horzcat(dips, [didx+min(mot(:,1))-1 ds]); % absolute value for date
                        
                        figure(3) 
                        subplot(6,6,1+(whichmo-2)*6); hold on;
                        if dates(i) == 0 % social distancing not enforced
                            plot(moving_avg(mot(:,1),10),grf,'b'); box on;
                        else
                            plot(moving_avg(mot(:,1),10),grf,'k'); box on;
                        end
                    end
                    if dates(i) == 0 % social distancing not enforced
                        nmotility_data(l,:) = [idx s dips];
                        mobnindices(l) = i;
                        l = l + 1;
                    else
                        smotility_data(m,:) = [idx s dips];
                        sindices(m) = i;
                        m = m + 1;
                    end
                end
                end
               
                
                if dates(i) == 0 % social distancing not enforced
                    ndate(j) = idx;
                    nmagnitude(j) = s;
                    nindices(j) = i;
                    j = j + 1;
                    figure(1) 
                    subplot(2,2,1); hold on; 
                    plot([1:length(td)],td,'b')
                    subplot(2,2,2); hold on; 
                    plot([1:length(diff(td,1))],diff(td,1),'b')
                else % social distancing enforced
                    sdate(k) = idx;
                    smagnitude(k) = s;
                    indices(k) = i;
                    k = k + 1;
                    figure(1) 
                    subplot(2,2,1); hold on; 
                    plot([1:length(td)],td,'k')
                    subplot(2,2,2); hold on; 
                    plot([1:length(diff(td,1))],diff(td,1),'k')
                end
                
                
            end
            
        else % plot china data anyway
            figure(1) 
            subplot(2,2,1); hold on; 
            plot([1:length(td)],td,'r')
            subplot(2,2,2); hold on; 
            plot([1:length(diff(td,1))],diff(td,1),'r')
        end
    end
end

figure(1) 
subplot(2,2,1); box on; xlabel('Time (days)'); ylabel('%confirmed'); xlim([1 81])
subplot(2,2,2); box on; xlabel('Time (days)'); ylabel('d%confirmed/dt'); xlim([1 81])

X = ndate;
Y = sdate;
edges = [30:2:100];
subplot(2,2,3); hold on; histogram(X,edges,'Normalization','probability','FaceColor','b'); histogram(Y,edges,'Normalization','probability','FaceColor','k'); 
[h p] = ttest2(X,Y);
[h p mean(X) mean(Y) length(X) length(Y)]
str=['Mean b = ',num2str(mean(X)),', N b = ', num2str(length(X)), 'Mean k = ',num2str(mean(Y)),', N k = ', num2str(length(Y))];
title(str)
ylabel('Probability')
xlabel('Spike date')
box on 

X = nmagnitude;
Y = smagnitude;
edges = [0:0.005:0.1];
subplot(2,2,4); hold on; histogram(X,edges,'Normalization','probability','FaceColor','b'); histogram(Y,edges,'Normalization','probability','FaceColor','k'); 
[h p] = ttest2(X,Y);
[h p mean(X) mean(Y) length(X) length(Y)]
str=['Mean b = ',num2str(mean(X)),', N b = ', num2str(length(X)), 'Mean k = ',num2str(mean(Y)),', N k = ', num2str(length(Y))];
title(str)
ylabel('Probability')
xlabel('Spike magnitude')
box on 


figure; 

subplot(2,2,1)
hold on; 
X = ndate;
Y = sdate;
errorbar([mean(X) mean(Y)],[std(X) std(Y)],'b'); bar([mean(X) mean(Y)],'FaceColor','b')
box on 
ylabel('Spike date')
%ylim([65 75])

subplot(2,2,2)
hold on; 
X = nmagnitude;
Y = smagnitude;
errorbar([mean(X) mean(Y)],[std(X) std(Y)],'b'); bar([mean(X) mean(Y)],'FaceColor','b')
box on
ylabel('Spike magnitude')



subplot(2,2,3)
X = sdate; Y = dates(indices);
%pc = 1;
[R,P] = corrcoef(X,Y); scatter(X,Y,'MarkerFaceColor','k','MarkerEdgeColor','k',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
xlabel('Spike date'); ylabel('Social distancing policy date')
box on 

subplot(2,2,4)
X = smagnitude; Y = dates(indices);
[R,P] = corrcoef(X,Y); scatter(X,Y,'MarkerFaceColor','k','MarkerEdgeColor','k',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
xlabel('Spike magnitude'); ylabel('Social distancing policy date')
box on 


if ~isempty(MO)
%% mobility
figure(3); 
DAT = {vertcat(nmotility_data,smotility_data)};%{nmotility_data smotility_data};%%%{vertcat(nmotility_data,smotility_data)};%
colo = ['b','k'];
for i = 1:1
motility_data = DAT{i};
for indx=1:6
subplot(6,6,2+(indx-1)*6); hold on;
X = motility_data(:,1); Y = motility_data(:,1+(indx)*2);
X = [X Y]; X(any(isnan(X), 2), :) = []; Y=X(:,2); X = X(:,1);
[R,P] = corrcoef(X,Y); scatter(Y,X,'MarkerFaceColor',colo(i),'MarkerEdgeColor',colo(i),...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
ylabel('Spike date'); xlabel('Dip date'); box on

subplot(6,6,3+(indx-1)*6); hold on;
X = motility_data(:,1); Y = motility_data(:,2+(indx)*2)/100;
X = [X Y]; X(any(isnan(X), 2), :) = []; Y=X(:,2); X = X(:,1);
[R,P] = corrcoef(X,Y); scatter(Y,X,'MarkerFaceColor',colo(i),'MarkerEdgeColor',colo(i),...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
ylabel('Spike date'); xlabel('Dip magnitude'); box on

subplot(6,6,4+(indx-1)*6); hold on;
X = motility_data(:,2); Y = motility_data(:,1+(indx)*2);
X = [X Y]; X(any(isnan(X), 2), :) = []; Y=X(:,2); X = X(:,1);
[R,P] = corrcoef(X,Y); scatter(Y,X,'MarkerFaceColor',colo(i),'MarkerEdgeColor',colo(i),...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
ylabel('Spike magnitude'); xlabel('Dip date'); box on

subplot(6,6,5+(indx-1)*6); hold on;
X = motility_data(:,2); Y = motility_data(:,2+(indx)*2)/100;
X = [X Y]; X(any(isnan(X), 2), :) = []; Y=X(:,2); X = X(:,1);
[R,P] = corrcoef(X,Y); scatter(Y,X,'MarkerFaceColor',colo(i),'MarkerEdgeColor',colo(i),...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
ylabel('Spike magnitude'); xlabel('Dip magnitude'); box on

subplot(6,6,6+(indx-1)*6); hold on;
X = motility_data(:,2+(indx)*2)/100; Y = motility_data(:,1+(indx)*2);
X = [X Y]; X(any(isnan(X), 2), :) = []; Y=X(:,2); X = X(:,1);
[R,P] = corrcoef(X,Y); scatter(Y,X,'MarkerFaceColor',colo(i),'MarkerEdgeColor',colo(i),...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
xlabel('Dip date'); ylabel('Dip magnitude'); box on
end
end

figure;
for indx = 1:6
   subplot(6,1,indx); hold on;
   scatter(smotility_data(:,1+(indx)*2),dates(sindices),'MarkerFaceColor',colo(i),'MarkerEdgeColor',colo(i),...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
   plot([40:80],[40:80]); box on
   ylabel('Social distancing policy date')
   xlabel('Dip date')
end

end


figure;
%subplot(2,1,1)
X = sdate; Y = smagnitude;
[R,P] = corrcoef(X,Y); scatter(X,Y,'MarkerFaceColor','k','MarkerEdgeColor','k',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); %str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
xlabel('Spike date'); ylabel('Spike magnitude')
box on 

hold on;
%subplot(2,1,2)
X = ndate; Y = nmagnitude;
[R,P] = corrcoef(X,Y); scatter(X,Y,'MarkerFaceColor','b','MarkerEdgeColor','b',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); 
X = [sdate ndate]; Y = [smagnitude nmagnitude];
[R,P] = corrcoef(X,Y);
str=['R = ',num2str(R(1,2)),', p = ', num2str(P(1,2)),', N = ', num2str(length(X))]; title(str)
xlabel('Spike date'); ylabel('Spike magnitude')
box on 