function newid2keep = gf_expand_region(F, id2keep)

vrs = compute_vertex_ring(F);

vre = [];
for i = 1: length(id2keep)
    vre = [vre vrs{id2keep(i)}];    
end

newid2keep = unique(vre);

end