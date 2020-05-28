clear all;
stats = [];

j = 1;
SEIR = 0; % set to 1 for SEIR model

while j <= 300

%% Parameters
beta = max(0.4*(1+randn*0.3),0); % units 1/time, set by spike date
gamma = beta/3; % R0, units 1/time, set by reproduction number
dip_mag = -max(randn*.2+0.5,0)/10; % literally is dip mag
alpha = 3; % strength of effect, fitted to spike magnitude with one param
alphas = 0;
if SEIR
    delta = 1/4; 
    E(1) = 0;
end

I(1) = 1*10^(-5);
S(1) = 1-I(1);

totalI(1) = I(1);
R(1) = 0;
dt = 0.1;
tend = 10000;

new_beta = beta*(1+dip_mag*alpha); 
rand_time = rand;
tsd = max((10*(1+10*dip_mag))/dt,0); 
new_S = max(1+dip_mag*alphas,0);

for t=2:tend
    
    S(t) = max(S(t-1) - (beta*I(t-1)*S(t-1))*dt ,0);

    if (t - tsd < 1) && (t - tsd > 0) % time window
        S(t) = S(t)*new_S;
    end

    if t > tsd % time window
        beta = new_beta;
    end

    
    if SEIR
        E(t) = E(t-1) + beta*I(t-1)*S(t-1)*dt - delta*E(t-1)*dt;
        I(t) = I(t-1) + delta*E(t-1)*dt -gamma*I(t-1)*dt;
        totalI(t) = totalI(t-1) + delta*E(t-1)*dt;
        R(t) = 1 - I(t) - S(t) - E(t); 
    else
        I(t) = I(t-1) + (beta*I(t-1)*S(t-1)-gamma*I(t-1))*dt;
        totalI(t) = totalI(t-1) + (beta*I(t-1)*S(t-1))*dt;
        R(t) = 1 - I(t) - S(t); 
    end
end


[s idx] = max(diff(totalI,1)/dt);
[hds hdidx] = min(abs(totalI-0.6));

stats(j,:) = [idx*dt s/max(totalI) hdidx*dt];
vars(j,:) = [tsd*dt dip_mag];
totalIs(j) = totalI(end);
timepoints(j,:) = [totalI(300) totalI(400) totalI(600)];
j = j + 1;
end


figure;

axx = 1;
subplot(1,5,1); hold on; scatter(vars(:,1)+40,stats(:,1)+40,'MarkerFaceColor','r','MarkerEdgeColor','r',...
'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); xlabel('Dip date'); ylabel('Spike date'); box on;
if axx 
ylim([80 110])
end
subplot(1,5,3); hold on; scatter(vars(:,1)+40,stats(:,2),'MarkerFaceColor','r','MarkerEdgeColor','r',...
'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);  xlabel('Dip date'); ylabel('Spike magnitude'); box on;
if axx 
ylim([0.02 0.08])
end
subplot(1,5,2); hold on; scatter(vars(:,2),stats(:,1)+40,'MarkerFaceColor','r','MarkerEdgeColor','r',...
'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);  xlabel('Dip magnitude'); ylabel('Spike date'); box on;
if axx 
xlim([-0.1 -0.0])
ylim([80 110])
end
subplot(1,5,4); hold on; scatter(vars(:,2),stats(:,2),'MarkerFaceColor','r','MarkerEdgeColor','r',...
'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);  xlabel('Dip magnitude'); ylabel('Spike magnitude'); box on;
if axx 
ylim([0.02 0.08])
xlim([-0.1 -0.0])
end
subplot(1,5,5); hold on; scatter(vars(:,1)+10,vars(:,2),'MarkerFaceColor','r','MarkerEdgeColor','r',...
'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2); xlabel('Dip date'); ylabel('Dip magnitude'); box on;

As = zeros(6,1);bs = zeros(6,1);Rs = zeros(6,1);

[r p]=corrcoef(vars(:,1),stats(:,1))
Y = vars(:,1); X = stats(:,1);
p = polyfit(Y,X,1); yfit = polyval(p,Y); yresid = X-yfit; SSresid=sum(yresid.^2); 
SStotal=(length(X)-1) * var(X); rsq = 1 - SSresid/SStotal;
thisi = 1; As(thisi) = p(1); bs(thisi) = p(2); Rs(thisi) = rsq; 

[r p]=corrcoef(vars(:,2),stats(:,1))
Y = vars(:,2); X = stats(:,1);
p = polyfit(Y,X,1); yfit = polyval(p,Y); yresid = X-yfit; SSresid=sum(yresid.^2); 
SStotal=(length(X)-1) * var(X); rsq = 1 - SSresid/SStotal;
thisi = 2; As(thisi) = p(1); bs(thisi) = p(2); Rs(thisi) = rsq; 

[r p]=corrcoef(vars(:,1),stats(:,2)) 
Y = vars(:,1); X = stats(:,2);
p = polyfit(Y,X,1); yfit = polyval(p,Y); yresid = X-yfit; SSresid=sum(yresid.^2); 
SStotal=(length(X)-1) * var(X); rsq = 1 - SSresid/SStotal;
thisi = 3; As(thisi) = p(1); bs(thisi) = p(2); Rs(thisi) = rsq; 

[r p]=corrcoef(vars(:,2),stats(:,2)) 
Y = vars(:,2); X = stats(:,2);
p = polyfit(Y,X,1); yfit = polyval(p,Y); yresid = X-yfit; SSresid=sum(yresid.^2); 
SStotal=(length(X)-1) * var(X); rsq = 1 - SSresid/SStotal;
thisi = 4; As(thisi) = p(1); bs(thisi) = p(2); Rs(thisi) = rsq; 
