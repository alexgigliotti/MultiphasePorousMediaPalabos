<<<<<<< HEAD
%function [geom4palabos]=create_geom_edist(data,name,num_slices,add_mesh,swapXZ,scale_2)
function [geom4palabos]=create_geom_edist(data,struct)
%%%% Inputs:
% data: image, where the pore-space is represented with zeros
% struct: structure with different fields

=======
function [geom4palabos]=create_geom_edist(data,name,num_slices,add_mesh,swapXZ,scale_2,output_dir)

%%%% Inputs:
% data: image, where the pore-space is represented with zeros
% name: string with the name of the file for printing
% output_dir: string with where to save the geometry file
>>>>>>> rel_perm_automation
tic

% Swap x and z data if needed to ensure Palabos simulation in Z-direction
if struct.swapXZ == true
    data=permute(data,[3 2 1]);
end


% Double the grain (pore) size if needed to prevent single pixel throats
% for tight/ low porosity geometries
if struct.scale_2 == true
    data = imresize3(data, 2, 'nearest');
end

%creates the computationally efficent geometry
edist = bwdist(~data);
geom4palabos = edist;
geom4palabos([1,end],:,:)=1; %makes sure that the outer box boundaries have
geom4palabos(:,[1,end],:)=1; %a wetting BC to avoid problems
geom4palabos(:,:,[1,end])=1;
geom4palabos(edist==0)=0;

geom4palabos(geom4palabos>0 & geom4palabos<2)=1;
geom4palabos(geom4palabos>1)=2;


% add a mesh if requested
if struct.add_mesh == true
    mesh = toeplitz(mod(1:size(geom4palabos,2),2),mod(1:size(geom4palabos,3),2));
    mesh(mesh==1)=4; %change the mesh to be neutral-wet
    mesh_s = zeros([1 size(mesh)]);
    mesh_s(mesh==4)=4;
    geom4palabos = cat(1, geom4palabos, mesh_s);
end

% add additional slices if requested
blank_slice  = geom4palabos(1:struct.num_slices,:,:)*0 ;
geom4palabos = cat(1, blank_slice, geom4palabos);
geom4palabos = cat(1, geom4palabos, blank_slice);

<<<<<<< HEAD
% print the geometry

if struct.print_size == true
    geom_name = [struct.name '_' num2str( size(geom4palabos,1) ) '_' ...
                                 num2str( size(geom4palabos,2) ) '_' ...
                                 num2str( size(geom4palabos,3) ) '.dat'];
else
    geom_name = [struct.name '.dat'];
end

fid = fopen(['input/' geom_name], 'w'); % open the output file to write in
=======
% print the geometry 
geom_name = [name '_' num2str( size(geom4palabos,1) ) '_' ...
     num2str( size(geom4palabos,2) ) '_' num2str( size(geom4palabos,3) ) '.dat'];
 
fid = fopen([output_dir '/' geom_name], 'w'); % open the output file to write in
>>>>>>> rel_perm_automation

for x_coor=1:size(geom4palabos,1)
    fprintf(fid, '%i\n', squeeze( geom4palabos(x_coor,:,:) ) );
end

fclose(fid);

toc
end
