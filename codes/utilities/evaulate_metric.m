function [meanse, stdse, mean_ang, std_ang, flip]=evaulate_metric(fn,f,face,uv)
global ang
meanse = mean(vecnorm( (fn-f)'));
stdse = std(vecnorm( (fn-f)'));

ang = estimate_angle(face,uv,fn,linspace(min(fn(:,1)), max(fn(:,1)), 10) , linspace(min(fn(:,2)), max(fn(:,2)), 10) );

ang(isnan(ang))=[];

mean_ang= mean(abs(ang-pi/2));
std_ang = std(abs(ang-pi/2));



% % remove face lay on boundary
bd = compute_bd(face);
fv = face_area(face,fn); 
fu = face_area(face,uv); 
face(ismember(face(:,1),bd)| ismember(face(:,2),bd) |ismember(face(:,3),bd) | fv<1e-4| fu<1e-4,: )=[]; 
flip = length(find(abs(compute_bc(face,uv,fn))>1)); 

end