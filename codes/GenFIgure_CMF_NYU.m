clear; clc; close all;

%% load data
subi = 6;
LIM = 2;

side = 'rh';
load("../result/OT_CMF_NYU/" + string(subi) + side + ".mat");
CM_rh = CM;
visxy_rh = visxy_s;
visxy_rh(:,2) = visxy_rh(:,2) + 0.5*pi;

side = 'lh';
load("../result/OT_CMF_NYU/" + string(subi) + side + ".mat");
CM_lh = CM;
visxy_lh = visxy_s;
visxy_lh(:,2) = visxy_lh(:,2) - 0.5*pi;

%% calculate CMF on 2 side
Ng = 100;
CM_mat = NaN * zeros(Ng,Ng);
hit_mat = zeros(Ng,Ng);
CM_mat_cart = CM_mat;
hit_mat_cart = hit_mat;

a = [0, min( min(visxy_rh(:,2)), min(visxy_lh(:,2)) )]; % use the first subject as the scope
b = [10, max( max(visxy_rh(:,2)), max(visxy_lh(:,2)) )];

[xg, yg]=meshgrid(linspace(a(1),b(1),Ng), linspace(a(2),b(2),Ng));

a_cart = [-b(1), -b(1)]; % use the first subject as the scope
b_cart = [b(1), b(1)];

[xg_cart, yg_cart]=meshgrid(linspace(a_cart(1),b_cart(1),Ng), linspace(a_cart(2),b_cart(2),Ng));

for j = 1:size(visxy_rh,1)
    if 0.5*pi<visxy_rh(j,2) && visxy_rh(j,2)<1.5*pi
        r = round((visxy_rh(j,1) - a(1))/(b(1)-a(1))*Ng+0.5);
        c = round((visxy_rh(j,2) - a(2))/(b(2)-a(2))*Ng+0.5);

        r = min(max(r,1),Ng);
        c = min(max(c,1),Ng);
        CM_mat(r,c) = CM_rh(j);
        hit_mat(r,c) = hit_mat(r,c) + 1;
        
        r_cart = xg(r,r) * cos(yg(c,c));
        c_cart = xg(r,r) * sin(yg(c,c));
        r_cart = round((r_cart - a_cart(1))/(b_cart(1)-a_cart(1))*Ng+0.5);
        c_cart = round((c_cart - a_cart(2))/(b_cart(2)-a_cart(2))*Ng+0.5);
        CM_mat_cart(r_cart,c_cart) = CM_rh(j);
        hit_mat_cart(r_cart,c_cart) = hit_mat_cart(r_cart,c_cart) + 1;
        
    end
end

for j = 1:size(visxy_lh,1)
    if -0.5*pi<visxy_lh(j,2) && visxy_lh(j,2)<0.5*pi
        r = round((visxy_lh(j,1) - a(1))/(b(1)-a(1))*Ng+0.5);
        c = round((visxy_lh(j,2) - a(2))/(b(2)-a(2))*Ng+0.5);

        r = min(max(r,1),Ng);
        c = min(max(c,1),Ng);
        CM_mat(r,c) = CM_lh(j);
        hit_mat(r,c) = hit_mat(r,c) + 1;
        
        r_cart = xg(r,r) * cos(yg(c,c));
        c_cart = xg(r,r) * sin(yg(c,c));
        r_cart = round((r_cart - a_cart(1))/(b_cart(1)-a_cart(1))*Ng+0.5);
        c_cart = round((c_cart - a_cart(2))/(b_cart(2)-a_cart(2))*Ng+0.5);
        CM_mat_cart(r_cart,c_cart) = CM_rh(j);
        hit_mat_cart(r_cart,c_cart) = hit_mat_cart(r_cart,c_cart) + 1;
        
    end
    
    if 0.5*pi<visxy_lh(j,2) && visxy_lh(j,2)<1.0*pi
        r = round((visxy_lh(j,1) - a(1))/(b(1)-a(1))*Ng+0.5);
        c = round((visxy_lh(j,2) - a(2))/(b(2)-a(2))*Ng+0.5);

        r = min(max(r,1),Ng);
        c = min(max(c,1),Ng);
        CM_mat(r,c) = CM_lh(j);
        hit_mat(r,c) = hit_mat(r,c) + 1;
        
        r_cart = xg(r,r) * cos(yg(c,c));
        c_cart = xg(r,r) * sin(yg(c,c));
        r_cart = round((r_cart - a_cart(1))/(b_cart(1)-a_cart(1))*Ng+0.5);
        c_cart = round((c_cart - a_cart(2))/(b_cart(2)-a_cart(2))*Ng+0.5);
        CM_mat_cart(r_cart,c_cart) = CM_rh(j);
        hit_mat_cart(r_cart,c_cart) = hit_mat_cart(r_cart,c_cart) + 1;
    end
end

avgCM = CM_mat ./ hit_mat;
avgCM_cart = CM_mat_cart ./ hit_mat_cart;

fprintf('Number of valid values in 2 CM: %d | %d\n', 1e4-sum(isnan(avgCM(:))), 1e4-sum(isnan(avgCM_cart(:))));

%% Color map 1

avgCM_smoothed = smoothn(avgCM);
avgCM_smoothed(avgCM_smoothed(:)<0) = 0;

%avgCM_filtered_smoothed = smoothn(avgCM_filtered);
avgCM_filtered_smoothed = avgCM_smoothed;


figure
[M,c]=contourf(xg.*cos(yg), xg.*sin(yg), avgCM_filtered_smoothed', [0:200:1.5e3], 'ShowText','on');
c.LineWidth = 2;
clabel(M,c,'FontSize',14,'Color','black')
xlabel('\rho_X')
ylabel('\rho_Y')


set(gca,'FontSize',18)

grid on
title('CMF (mm^2/deg^2)')
colormap('parula') 
colorbar



%% Color map 2

avgCM_smoothed = smoothn(avgCM_cart);
avgCM_smoothed(avgCM_smoothed(:)<0) = 0;

%avgCM_filtered_smoothed = smoothn(avgCM_filtered);
avgCM_filtered_smoothed = avgCM_smoothed;


figure
[M,c]=contourf(xg_cart, yg_cart, avgCM_filtered_smoothed', [0:200:1.5e3], 'ShowText','on');
c.LineWidth = 2;
clabel(M,c,'FontSize',10,'Color','black')
xlabel('\rho_X')
ylabel('\rho_Y')

hold on;
plot([-6 6], [0 0],'r', 'LineWidth', 3);
plot([0 0], [-6 6],'r', 'LineWidth', 3);

set(gca,'FontSize',18);

grid on
title('CMF (mm^2/deg^2)')
colormap('parula') 
%colorbar

xlim([-LIM, LIM]);
ylim([-LIM, LIM]);

exportgraphics(gca, sprintf('../CMF_figure/bothside_NYU/%d.emf', subi), BackgroundColor='none');
