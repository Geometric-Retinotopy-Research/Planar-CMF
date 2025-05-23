function plot_power_diagram(pd)
% plot cells of power diagram, can be slow
gcf;
hold on
bd = compute_bd(pd.face);
bd= [bd; bd(1)] ;
disk = pd.uv(bd,:);
plot(disk(:,1),disk(:,2),'r-')
for i = 1:length(pd.cell)
    try
        pi = pd.dpe(pd.cell{i},:);
        plot(pi(:,1),pi(:,2),'b-','Linewidth',1.5);
    catch
    end
end
box = [min(pd.uv(:,1)),max(pd.uv(:,1)),min(pd.uv(:,2)),max(pd.uv(:,2))];
axis equal
axis(box)