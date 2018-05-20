function  [Allpoints2, Allpointsxvaule] = RNBI2D(C, A, b, lb, ub)
%problem description:
%min  Cx,
%s.t. Ax <=b,
%     ub> x > lb.
%     objnum = rownum of C;
%     [m,n] = size(A);
%     For real radiation problem, the ideal point is known.

LPnumber=0;
starttime= clock; %The starting time

[m,n] = size(A);
[objnum,temp] = size(C);
if temp~=n
    disp('The column number of A and C doesnot match');
    return;
end
 %************************************************************************************************************************************************************
fid=fopen('DirectSamplelog.txt','w');
fprintf(fid, 'Direct Sample with the parallel ray report\n');

for i = 1:objnum
   f = C(i,:)';                %cost vector
  [xopt,opt,exitflag,output,lambda] = linprog(f,A,b,[],[],lb,ub); 
   Xvar = xopt;
   LPnumber = LPnumber +1;
   oa = C*Xvar;
   yAI(i) = C(i,:)*Xvar(1:n); % it is a row vector    
end
% yAI=[28 68];
ybar = yAI' ; % it is a column vector

%compute beta 
%min <e,y>, s.t. y in Y., 
% 45°角
%% 原来的约束
% ftem = [ones(1,objnum), zeros(1,n)]';   % added for constraints y in Y.
% B = [-eye(objnum),   C;
%        zeros(m,objnum), A];
% lbnew = [-Inf*ones(objnum,1);lb];
% ubnew = [ybar;ub];
% newb = [zeros(objnum,1);b];
% [xopt,opt,exitflag,output,lambda] = linprog(ftem,B,newb,[],[],lbnew,ubnew);
%% 新的约束
ftem = C(1,:)+C(2,:);
B = [-eye(objnum),   C;
       zeros(m,objnum), A];
lbnew = [-Inf*ones(objnum,1);lb];
ubnew = [ybar;ub];
newb = [zeros(objnum,1);b];
[xopt,opt,exitflag,output,lambda] = linprog(ftem,A,b,[],[],lb,ub); 
%%
if (exitflag ~=1)    
       disp('-----infeasible or unbounded ---------');
       return;
end
LPnumber = LPnumber +1;
beta = opt;
% construct q simlex to cover the solution space.
% v represent the vertex of th q simplex, if there are three objectives,
% then q is equal to four.

for j =1:objnum+1
    for i = 1:objnum
        if (i == j) 
            tem = sum(ybar);
           v(j,i)=beta+ybar(i)-tem;
        else    
           v(j,i) = ybar(i);   
        end
    end
end

fprintf(fid, 'The vertices of the simplex cover is defined as follows\n');
for i = 1:objnum+1
    for j =1:objnum
    fprintf(fid, '%12.6f', v(i,j));
    end
    fprintf(fid, '\n');
end

sidelength = norm(v(1,:)-v(2,:));
fprintf('-----The estimate side length of the sampling triangle is %f \n', sidelength);
fprintf('Please input the number of sampling points on one edge of the triangle, it will decide the distance between the sampling points \n\n');
flag =0;
while flag == 0
    numOfPonedge =input('Points on the edge ? > ');
    distance =  sidelength/(numOfPonedge-1)
    fprintf('The distance between the sampling points on the sampling plane is %f \n\n', distance);
    charinput =input('Is this acceptable? Yes(1) or No(0) >');
    if charinput == 1
        flag =1;
    end
end

fprintf(fid,'The distance between the sampling points is %f\n\n', distance);



coverplane = planeEquation(v, distance);
% coverplane = planeEquation(coverfacever, 2);
 % Produce grid points
 % Caculate the distance of two adjacency points on the edge of the equilateral triangle.
coverfacever = v(1:2,:);
changerate = 1/(numOfPonedge-1);
lambda = 0;
for i = 1:numOfPonedge    
    pointedge1(i,:) = lambda*coverfacever(2,:) + (1-lambda)*coverfacever(1,:);
%     pointedge2(i,:) = lambda*coverfacever(3,:) + (1-lambda)*coverfacever(1,:);
    lambda = lambda + changerate;
end
%pointInbetween store all the inital points of the parallel line, they are in the big cover equilateral
 %triangle.
k = 1;
for i =3:numOfPonedge-1
    NewSample =i -2;
    lambda = 0;
    changerate = 1/(i-1);
    for j = 1:NewSample  
         lambda = lambda + changerate;
         pointInbetween(k,:) = lambda*pointedge1(i,:) + (1-lambda)*pointedge2(i,:);
         k = k+1;
     end     
end  
NofSampleP = k -1;

% compute the intersection point between the line r(t) = rayinitial + raydir * t   and the boundary of Y
% compute the sample point on Y'

raydir = coverplane(1:2);
k =0;
fprintf(fid, 'Start points on the sampling plane \t \t \t  The intersection points on the boundary of Y \t\t\t  Dominated or not \n') ;
for i = 1: NofSampleP
    rayintial = pointInbetween(i,:);
    fprintf(fid, '%12.6f\t %12.6f\t %12.6f\t', rayintial(1), rayintial(2));
    f=[zeros(n,1);1];
    lbnew = [lb; 0];
    ubnew = [ub;Inf];
    [xopt2,opt2,exitflag] =linprog(f,[A,zeros(m,1)],b,[C,-raydir'],rayintial',lbnew,ubnew);
    LPnumber = LPnumber +1;
    if (exitflag ~=1)    
        fprintf(fid, 'no intersection\n');
        continue
    end
 
    t2 = xopt2(n+1); 
    x2 = xopt2(1:n);

    BoundaryPoint2 = rayintial + raydir * t2 ;
    fprintf(fid, '\t %12.6f\t %12.6f\t %12.6f\t', BoundaryPoint2);
    %%% check if it is nondominated using 
    %% min <lambda, y>
    % s.t. y > bary, y in Y=
    f = [zeros(n,1); ones(objnum,1)];
    lbnew = [lb; -Inf*ones(objnum,1)];
    ubnew = [ub;BoundaryPoint2'];
   [xopt2,opt2,exitflag] =linprog(f,[A,zeros(m,objnum)],b,[C,-eye(objnum)],zeros(objnum,1),lbnew,ubnew);
    LPnumber = LPnumber +1;
    if (exitflag ==-2)    
        disp('-----something wrong ---------');
        fprintf(fid, 'the boundary point is infeasible\t');
        continue;
    end
    y = xopt2(n+1:n+objnum);
    if abs(opt2-sum(BoundaryPoint2')) > 0.001
        %disp('it is not a nondominated points');
        fprintf(fid, '\t Dominated by %12.6f\t %12.6f\t %12.6f\t\n', y);
        continue;
    end      
    k = k+1;
    fprintf(fid, '%d\n', k);    
    %fprintf(fid, '%12.6f\t %12.6f\t %12.6f', BoundaryPoint2(1), BoundaryPoint2(2), BoundaryPoint2(3)); 
    Allpoints2(k,:) = BoundaryPoint2; 
    Allpointsxvaule(k,:) = x2(1:n-3);
    
end


if k == 0
    disp('The number of sampled non dominated points is zero');
    return;
end
%endtime = clock;
fprintf(fid, 'Total time to solve the problem is %12.6f\n', etime(clock,starttime));
fprintf(fid, 'The number of LP need to be solved is %d\n', LPnumber);
%fprintf(fid, 'The number of nondominated points is %d\n', NumPoint);
%figure;
[NumPoint, dim] = size(Allpoints2);
fprintf(fid, 'The number of nondominated points is %d\n', NumPoint);

for i = 1: NumPoint
      x = Allpoints2(i,1);
      y = Allpoints2(i,2);
      z = Allpoints2(i,3);
    plot3(x,y,z,'black','Marker','.','MarkerSize',10, 'Visible', 'On');%,xlabel,'alpha', ylabel,'beta',zlabel,'gamma');
    hold on
    fprintf(fid, '%12.6f\t %12.6f\t %12.6f\t \n', Allpoints2(i,1), Allpoints2(i,2), Allpoints2(i,3) );
end  
fclose(fid);
hold off

return;

function plane = planeEquation(vers, nverts)
%****************************************************************
%** Plane Equation -- computes the plane equation of an arbitrary 
%** 3D polygon using Newell's method.
% Input:
%   vers -- list of the vertices of the polygon
%   nvers -- number of vertices of the polygon 
% nverts = 2;
% Output:
%   plane -- normalized (unit normal) plane equation
%   plane equation:  plane(1)x + plane(2)y + plane(3)z + plane(4) = 0
%****************************************************************
%/* first, compute the normal of the input polygon */
%% 新的
vers(1,:)=[];
if nargin==1
    nverts = 0.1;
end
lengthV = sqrt(sum((vers(1,:)-vers(2,:)).^2));
referPtsNum = fix(lengthV/nverts)+1;
plane = zeros(referPtsNum,2);
% Q(1,:) = v(1,:);
for i=0:referPtsNum-1
        plane(i+1,:) =vers(1,:)+ i/referPtsNum*(vers(2,:)-vers(1,:));
end
plane(end+1,:) = vers(2,:);
%% 原来的
% normal = zeros(2,1);
% refpt = zeros(2,1); % reference point on the plane.
% for i = 1: nverts
%     u = vers(i,:);
%     temp = mod(i+1,nverts);
%     if temp == 0
%         temp = nverts;
%     end
%     v = vers(temp,:);
%     normal(1) = normal(1) + (u(2) - v(2)) * (u(3) + v(3));
%     normal(2) = normal(2) + (u(3) - v(3)) * (u(1) + v(1));
%     normal(3) = normal(3) + (u(1) - v(1)) * (u(2) + v(2));
%     refpt(1) = refpt(1) + u(1);
%     refpt(2) = refpt(2) + u(2);
%     refpt(3) = refpt(3) + u(3);
% end
% %    /* then, compute the normalized plane equation using the
% %       arithmetic average of the vertices of the input polygon to
% %       determine its last coefficient. Note that, for efficiency,
% %       'refpt' stores the sum of the vertices rather than the
% %       actual average; the division by 'polygon->numVertices' is
% %       carried out together with the normalization when computing
% %       'plane[4]'.
% %    */
% len = norm(normal);
% plane(1) = normal(1) / len;
% plane(2) = normal(2) / len;
% plane(3) = normal(3) / len;
% len = len * nverts;
% plane(4) = -dot(refpt, normal)/len;
%% 
return;