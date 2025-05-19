% disk areal map by OMT
function uv_new=disk_omt(F,V,uv)
try
    if ~exist('uv','var')
        uv = disk_harmonic_map(F, V);
    end
    sigma = @(xy) 1;
    
    face =F;
    vertex = V;
    area = vertex_area(face,vertex)/3;
    % normalize area, total area should be total area of unit disk (may not be
    % exactly pi). THIS IS IMPORTANT. This demo will fail if you remove
    % following two lines.
    va2 = vertex_area(face,uv)/3;
    area = area/sum(area)*sum(va2);
    
    bd = compute_bd(face);
    disk = uv(bd,:);
    % make sure disk is really a disk
    dl = sqrt(dot(disk,disk,2));
    disk = disk./[dl dl];
    
    
    pd = power_diagram(face,uv);
    
    % compute power diagram with desired area
    % sigma is the soure measure, set to be constant 1
    
    [pd2,h,maxdh] = discrete_optimal_transport(disk,face,uv,sigma,area);
    fprintf("---OT Finished---\n");
    
    %%
    % save result to mfile. View data/alex.omt.m with texture to see area preserving map
    uv_new = compute_centroid(disk,pd2);
catch
    fprintf("---OT Failed---\n");
    uv_new = Inf;
end

end