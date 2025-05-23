function [pc, hc] = polybool(pa, pb, op, ha, hb, ug);
%function [pc, hc] = polybool(pa, pb, op, ha, hb, ug);
%
% polybool : a function to perform boolean set operations on 
%            planar polygons
% 
% INPUT:
% pa : EITHER a nx2 matrix of vertices describing a polygon 
%      OR a cell array with polygons, each of which is a nx2 matrix
%      of vertices (one vertex per row)
% pb : EITHER a nx2 matrix of vertices describing a polygon 
%      OR a cell array with polygons, each of which is a nx2 matrix
%      of vertices (one vertex per row)
% ha : (Optional) logical array with hole flags for polygons in
%      pa. If ha(k) > 0, pa{k} is an interior boundary of a polygon 
%      with at least one hole.
% hb : (Optional) logical array with hole flags for polygons in pb.
% op : type of algebraic operation:
%       'notb' : difference - points in polygon pa and not in polygon pb
%       'and'  : intersection - points in polygon pa and in polygon pb
%       'xor'  : exclusive or - points either in polygon pa or in polygon pb
%       'or'   : union - points in polygons pa or pb
% ug : (Optional) conversion factor from user coordinates to
%      integer grid coordinates. Default is 10^6.
% pc : cell array with the result(s) of the boolean set operation
%      of polygons pa and pb (can be more than one polygon)
% hc : logical array with hole flags for each of the output
%      polygons. If hc(k) > 0, pc{k} is an interior boundary of a 
%      polygon with at least one hole.

% This function is based on the Clipper Library for C++ by Angus Johnson 
% http://www.angusj.com/delphi/clipper.php
% The Clipper software is free software under the Boost software license.

% Ulf Griesmann, NIST, August 2014

   % check arguments
   if nargin < 3
      error('polybool :  expecting at least 3 arguments.');
   end
   if nargin < 4, ha = []; end
   if nargin < 5, hb = []; end
   if nargin < 6, ug = []; end

   if isempty(ha), ha = logical(zeros(1,length(pa))); end
   if isempty(hb), hb = logical(zeros(1,length(pb))); end
   if isempty(ug), ug = 1e6; end

   if ~islogical(ha) || ~islogical(hb)
      error('polybool :  hole flags must be logical arrays.');
   end
   
   % prepare arguments
   if ~iscell(pa), pa = {pa}; end
   if ~iscell(pb), pb = {pb}; end
   
   % call polygon clipper
   [pc, hc] = polyboolmex(pa, pb, op, ha, hb, ug);

   if(isempty(pc))
      pc{1}=zeros(size(pa{1}));
   end
end
