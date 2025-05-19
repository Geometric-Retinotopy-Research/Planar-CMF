 function p = plot_surf(face,vertex,color,varargin)
if nargin < 2
    disp('warning: no enough inputs');
    return;
end
dim = 3;
if size(vertex,2) == 1
    vertex = [real(vertex),imag(vertex),vertex*0];
    dim = 2;
end
if size(vertex,2) == 2
    vertex(:,3) = 0;
    dim = 2;
end
if nargin == 2
    po = trisurf(face,vertex(:,1),vertex(:,2),vertex(:,3),...
        'EdgeColor',[36 169 225]/255*0,...
        'LineWidth',1.0,...    
        'CDataMapping','scaled');
elseif nargin == 3
    po = trisurf(face,vertex(:,1),vertex(:,2),vertex(:,3),'FaceVertexCData',color,...        
        'LineWidth',1.0,...    
        'CDataMapping','scaled');
elseif nargin > 3
    if isempty(color) || isa(color,'string')
        po = trisurf(face,vertex(:,1),vertex(:,2),vertex(:,3),varargin{:});
    else
        po = trisurf(face,vertex(:,1),vertex(:,2),vertex(:,3),color,varargin{:});
    end
end
g = gca;
g.Clipping = 'off';
axis equal;

% special modifications
axis off;
view(90,0);
hold on;
faces_to_highlight = [518 519 520 547];
% Loop through each face to highlight its edges
for i = 1:length(faces_to_highlight)
    f_idx = faces_to_highlight(i); % Face index
    % Get vertex indices of the face
    v_idx = face(f_idx, :);
    % Get coordinates of the vertices
    v1 = vertex(v_idx(1), :);
    v2 = vertex(v_idx(2), :);
    v3 = vertex(v_idx(3), :);
    % Plot edges of the face as red lines
    plot3([v1(1), v2(1)], [v1(2), v2(2)], [v1(3), v2(3)], 'r-', 'LineWidth', 2); % Edge 1-2
    plot3([v2(1), v3(1)], [v2(2), v3(2)], [v2(3), v3(3)], 'r-', 'LineWidth', 2); % Edge 2-3
    plot3([v3(1), v1(1)], [v3(2), v1(2)], [v3(3), v1(3)], 'r-', 'LineWidth', 2); % Edge 3-1
end



if dim == 2
    view(0,90);
end
if nargout > 0
    p = po;
end

if(size(vertex,1)>1e2)
%set(po, 'EdgeColor', 'None');
end

mesh = struct('Face',face,'Vertex',vertex);
setappdata(gca,'Mesh',mesh);
% graph = gcf;
dcm_obj = datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@datatip_callback,'Enable','off')

function output_txt = datatip_callback(obj,event)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos  = get(event,'Position');
ax   = get(get(event,'Target'),'Parent');
mesh = getappdata(ax,'Mesh');

d = dist(mesh.Vertex,pos);
[~,index] = min(d);
output_txt = {['index: ',num2str(index)],...
    ['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)],...
    ['Z: ',num2str(pos(3),4)]};

function d = dist(P,q)
Pq = [P(:,1)-q(1),P(:,2)-q(2),P(:,3)-q(3)];
d = sqrt(dot(Pq,Pq,2));
