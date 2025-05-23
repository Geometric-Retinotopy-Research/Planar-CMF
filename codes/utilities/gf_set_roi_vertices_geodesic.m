%% Set ROI in the struct of hemi
%% Syntax
 
% hemi = gf_set_roi_vertices(hemi,Y)
%% Description

% hemi:  hemi sphere, contains inflated and sphere and pial; cut the mesh
% by geodesic 
 

%% Contribution
%  Author : Yanshuai Tu
%  Created: 2019/2/25
%  Revised: Not yet
%
%  Copyright @ Geometry Systems Laboratory
%  School of Computing, Informatics, and Decision Systems Engineering, ASU
%  http://gsl.lab.asu.edu/

%% Reference :
 
function hemi = gf_set_roi_vertices_geodesic(hemi,foveaid, radius)

if nargin <3
    radius =100;
end
    

start_points = foveaid;
vertex = hemi.pial.vertices;
faces = hemi.pial.faces;
[D,S,Q] = perform_fast_marching_mesh(double(vertex), double(faces), start_points);
 

% Loop thru hemispheres
ind2del  = find(D > radius);
ind2save = find(D <= radius);

% First, remove the vertex from mesh.

F = hemi.inflated.faces;
V = hemi.inflated.vertices;
[Fout, ~, vertex_father] = gf_remove_mesh_vertices(F, V, ind2del);


hemi.ROI.faces = Fout;
hemi.ROI.father = vertex_father; %
hemi.ROI.verticesPial =     double(hemi.pial.vertices(ind2save,:)); %
hemi.ROI.verticesInflated = double(hemi.inflated.vertices(ind2save,:)); %;
hemi.ROI.verticesSphere =   double(hemi.sphere.vertices(ind2save,:)); 

hemi.ROI.id2del = ind2del;
hemi.ROI.id2save = ind2save;

