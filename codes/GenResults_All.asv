clear;clc;close all;


side = 'lh';
subjects = dir(['../data/mesh_data/*' side '.m']);
rng(0)

%% things to save
PRF_side = cell(181,1);
visxy_side = cell(181,1);
CM_side = cell(181,1);
avgCM_side = cell(181,1);
hitmat_side = cell(181,1);


%% start
for subi = 2:2
    %% Prepare data
    fn = subjects(subi).name;
    [Fm, Vm, Em]=read_mfile(['../data/mesh_data/' fn]);

    % Load the full hemisphere
    %[Ffull,Vfull, Efull]=read_mfile(['../data/mesh_data/' fn(1:end-2) '_ecc.m']);
    uvm = disk_harmonic_map(Fm, Vm);


    % load cut info
    roipatch = load(['../data/v1v2v3' side]);
    id2delete = roipatch.id2delete;

    [Froi, V_roi, vfather] = gf_remove_mesh_vertices(Fm, Vm, id2delete);

    uv_roi = disk_conformal_map(Froi, V_roi);
    uv_roi = disk_omt(Froi, V_roi, uv_roi);
    if uv_roi == Inf
        uv_roi = uvm(vfather, :);
        OT = false;
    else
        OT = true;
    end

    prf = Em.Vertex_prf(vfather,:);

    visxy_corrected = correct_vis(Em, side);
    visxy_corrected = visxy_corrected(vfather, :);

    [uv_p1, uv_p2] = cart2pol(uv_roi(:,1), uv_roi(:,2));
    uv_p = [uv_p2, -uv_p1]; % r, theta

    % anchor = roipatch.anchor;
    anchor = compute_bd(Froi);
    %anchorpos = roipatch.anchorpos;
    anchorpos = visxy_corrected(anchor,:);
 
    %%  Proposed
    R2 = prf(:,5);
    bd = compute_bd(Froi);
    % anchorpos(:,1)=anchorpos(:,1);
    % anchorpos(:,2)=anchorpos(:,2);
    changetol = 0;
    smooth_lambda0 = 0.001;
    smooth_avg_k = 3;
    meanddth = 1;
    visxy_s = topological_smoothing(Froi, uv_p, visxy_corrected, R2,...
        bd, anchorpos, changetol, ...
        smooth_lambda0, smooth_avg_k, meanddth);
    [meanse, std_vd, mean_ang, std_ang, flip]=evaulate_metric(visxy_s,visxy_corrected,Froi,uv_p);
    fprintf('Proposed smoothing meanse = %f, std_vd = %f, meanang = %f, maxang = %f flip =%d\n', meanse, std_vd, mean_ang, std_ang, flip);

    % for lefthemi, remove the added pi when fixing phase jumping
    if strcmp(side, 'lh')
        vis_c = restore_vis(visxy_s);
        %visxy_s = [visxy_s(:,1) visxy_s(:,2)-pi];
    else
    % for righthemi, no added pi when phase jumping
        vis_c = visxy_s;
        %visxy_s = [visxy_s(:,1) visxy_s(:,2)-pi];
    end
     
    %% calculate CMF 
    CM = estimate_CMF(Froi, V_roi, visxy_s, 1); 

    Ng = 100;
    CM_mat1 = NaN * zeros(Ng,Ng);
    hit_mat1 = zeros(Ng,Ng);

    a = [-0.5, min(visxy_s(:,2))-0.2]; % use the first subject as the scope
    b = [10, max(visxy_s(:,2))+0.2];
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
    save("../result/OT_CMF/" + string(subi) + side + ".mat",...
         'prf', 'visxy_s', 'CM', 'avgCM1', 'hit_mat1', 'OT');
    
    fprintf('---Subject %d Finished---\n\n', subi);

    
end

% save("../result/OT_CMF/" + side + ".mat", 'PRF_side', 'visxy_side', 'CM_side', 'avgCM_side', 'hitmat_side');
close all;


%% show the inflated surface together with smoothed visual coordinate.

function vis_c = restore_vis(visxy)
vis_c = [visxy(:,1) visxy(:,2)-pi];
end