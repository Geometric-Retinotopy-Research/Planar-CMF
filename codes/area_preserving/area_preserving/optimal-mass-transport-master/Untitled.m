[face, vertex, extra]=read_mfile('100610lh.m')

plot_mesh(face,vertex)

u = disk_harmonic_map(face, vertex);


figure
plot_mesh(face, u)


u = disk_area_map(face, vertex);

%%
v = extra.Vertex_prf(:,1:2);

plot_mesh(face,  extra.Vertex_prf(:,1:2))


% find the relation between u and v


plot_surf(face, u, prf_value_2_color('ecc',  extra.Vertex_prf(:,2)))

