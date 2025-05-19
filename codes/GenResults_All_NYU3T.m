clear;clc;close all;

side = "rh";
subjects = dir(['../data/NYU3T/*analyzePRF.mat']);
rng(0)

%% start
for subi = 1:1
    %% Prepare data
    fn = subjects(subi).name;
    load(['../data/NYU3T/' fn], 'subject');
    
    % Load the full hemisphere
    if side == "lh"
        Fm = subject.lh.faces;
        Vm = subject.lh.inflated;
        ROI = subject.lh.ROI;
        results = subject.lh.results;
    else
        Fm = subject.rh.faces;
        Vm = subject.rh.inflated;
        ROI = subject.rh.ROI;
        results = subject.rh.results;
    end
    
    % cut to ROI
    id2delete = setdiff(1:length(Vm), ROI);
    [Froi, Vroi, vfather] = gf_remove_mesh_vertices(Fm, Vm, id2delete);
    
    % refine ROI for isolated vertex (vertex that do not belong to any face)
    refined = true(size(ROI));
    for i = 1:length(ROI)
        if ~ismember(i, Froi)
            refined(i) = false;
            fprintf("Refined at %d\n", i);
        end
    end
    ROI = ROI(refined);
    Vroi = Vroi(refined, :);
    
    count = 0;
    for i = 1:length(refined)
        if refined(i) == false
            Froi(Froi>i-count) = Froi(Froi>i-count) - 1;
            count = count + 1;
        end
    end
    
    % disk OT mapping
    uv_roi = disk_conformal_map(Froi, Vroi);
    uv_roi = disk_omt(Froi, Vroi, uv_roi);
    
    uvm = disk_harmonic_map(Froi, Vroi);

    if uv_roi == Inf
        uv_roi = uvm;
        OT = false;
    else
        OT = true;
    end
    
    % load prf: visxy(r, theta), R2
    R2 = results.R2(refined);
    visxy = [results.ecc(refined), results.ang(refined)];
    visxy = visxy/360*pi;
    visxy_corrected = visxy;
    
    [uv_p1, uv_p2] = cart2pol(uv_roi(:,1), uv_roi(:,2));
    uv_p = [uv_p2, -uv_p1]; % r, theta

    anchor = compute_bd(Froi);
    anchorpos = visxy_corrected(anchor,:);
 
    %%  Proposed
    changetol = 0;
    smooth_lambda0 = 0.001;
    smooth_avg_k = 3;
    meanddth = 1;
    %visxy_s = topological_smoothing(Froi, uv_p, visxy_corrected, R2,...
    %    anchor, anchorpos, changetol, ...
    %    smooth_lambda0, smooth_avg_k, meanddth);
    visxy_s = visxy_corrected;
    [meanse, std_vd, mean_ang, std_ang, flip]=evaulate_metric(visxy_s,visxy_corrected,Froi,uv_p);
    fprintf('Proposed smoothing meanse = %f, std_vd = %f, meanang = %f, maxang = %f flip =%d\n', meanse, std_vd, mean_ang, std_ang, flip);

    % for lefthemi, remove the added pi when fixing phase jumping
    if strcmp(side, 'lh')
        visxy_c = restore_vis(visxy_s);
        %visxy_s = [visxy_s(:,1) visxy_s(:,2)-pi];
    else
    % for righthemi, no added pi when phase jumping
        visxy_c = visxy_s;
        %visxy_s = [visxy_s(:,1) visxy_s(:,2)-pi];
    end
     
    %% calculate CMF 
    CM = estimate_CMF(Froi, Vroi, visxy_s, 1); 

    Ng = 100;
    CM_mat1 = NaN * zeros(Ng,Ng);
    hit_mat1 = zeros(Ng,Ng);

    a = [-0.2, min(visxy_s(:,2))+0.5*pi]; % use the first subject as the scope
    b = [10, max(visxy_s(:,2))+0.5*pi];
    [xg, yg]=meshgrid(linspace(a(1),b(1),Ng), linspace(a(2),b(2),Ng));

    for j = 1:size(visxy_s,1)

        r = round((visxy_s(j,1) - a(1))/(b(1)-a(1))*Ng+0.5);
        c = round((visxy_s(j,2) - a(2))/(b(2)-a(2))*Ng+0.5);

        r = min(max(r,1),Ng);
        c = min(max(c,1),Ng);
        CM_mat1(r,c) = CM(j);
        hit_mat1(r,c) = hit_mat1(r,c) + 1;
    end

    avgCM1 = CM_mat1 ./ hit_mat1;

    %% get results
%     PRF_side{subi} = prf;
%     visxy_side{subi} = visxy_s;
%     CM_side{subi} = CM;
%     avgCM_side{subi} = avgCM1;
%     hitmat_side{subi} = hit_mat1;
    save("../result/OT_CMF_NYU/" + string(subi) + side + ".mat",...
         'visxy_s', 'CM', 'avgCM1', 'hit_mat1', 'OT');
    
    fprintf('---Subject %d Finished---\n\n', subi);

    
end

% save("../result/OT_CMF/" + side + ".mat", 'PRF_side', 'visxy_side', 'CM_side', 'avgCM_side', 'hitmat_side');
close all;


%% show the inflated surface together with smoothed visual coordinate.

function vis_c = restore_vis(visxy)
vis_c = [visxy(:,1) visxy(:,2)-pi];
end