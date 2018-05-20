function  [Allpoints2, Allpointsxvaule] = ExtendedNBISampletwoobjective(C, A, B, lb, ub)
%problem description:
%Min  Cx,
%s.t. Ax <=B,
%     Aeqx = beq,
%     ub> x > lb.
%     objnum = rownum of C;
%     [m,n] = size(A);
 LPnumber = 0;
 starttime = clock; %The starting time

[m,n] = size(A);
[objnum,temp] = size(C);   % C是双目标
if temp~=n
    disp('The column numbers of A and C do not match');
    return;
end

x0=[];
for i = 1:objnum     % c里面其实是双目标的两个目标函数
   f=C(i,:)';                %cost vector
   % A 是约束左边， B是约束右边 标准是 Ax<=B
   % A是列数就是优化问题变量的个数
   % lb是变量的下限  ub 是变量的上线
   % Aeq=[]  Beq=[] 是等式约束 这里是[]
   [xopt,opt,exitflag] = linprog(f,A,B,[],[],lb,ub,x0);
   if (exitflag ~=1)    
       disp('-----infeasible or unbounded ---------');
       return;
   end
   LPnumber = LPnumber +1;
   p(i,:)= C*xopt;          % P 存的是目标函数值
   yI(i) = opt;             % it is a row vector  
   
end
%%
%    [xopt,opt,exitflag] = linprog(f,A,B,[],[],lb,ub,x0);
%    if (exitflag ~=1)    
%        disp('-----infeasible or unbounded ---------');
%        return;
%    end
%    LPnumber = LPnumber +1;
%    p(i,:)= C*xopt;          % P 存的是目标函数值
%    yI(i) = opt;   
%%
for i = 1:objnum
   f=C(3-i,:)';                %cost vector
   [xopt,opt,exitflag] = linprog(f,A,B,C(i,:),p(i,i),lb,ub,x0);
   if (exitflag ~=1)    
       disp('-----infeasible or unbounded ---------');
       return;
   end
   LPnumber = LPnumber +1;
  u(i,:)=C*xopt;       % 求出来双目标的两个字典序点
  
%    yI(i) = opt; % it is a row vector  
end
%u=[0 4;4 0];
coverplane = u(2,:)-u(1,:);
fprintf('The vertices of reference plane are defined as follows: \n');
for i = 1:objnum
    fprintf( '%12.6f\t %12.6f\t \n', u(i,1), u(i,2));
end
sidelength = norm(u(1,:)-u(2,:));    % 两个点之间的长度

fprintf('-----The estimate side length of the sampling is %f \n', sidelength);
fprintf('Please input the number of sampling points, it will decide the distance between the sampling points \n\n');
flag =0;
% while flag == 0
numOfPonedge = 20;
%     numOfPonedge =input('Points on the edge ? > ');
distance =  sidelength/(numOfPonedge-1);
theta = 1/(numOfPonedge-1);
fprintf('The distance between the sampling points on the sampling plane is %f \n\n', distance);

fprintf('The distance between the sampling points is %f\n\n', distance);

 % Produce grid points
 % Caculate the distance of two adjacency points on the edge of the big cover
 % equilateral triangle.

k=1;
lambda=0;
% 计算网格点的坐标
 for i =1:numOfPonedge-2
     lambda = lambda+theta;
     pointInbetween(k,:)=lambda*u(2,:)+(1-lambda)*u(1,:);
     k=k+1;
 end

NofSampleP = k -1;

% Method 1: using Y
% compute the intersection point between the line r(t) = rayinitial + raydir * t   and the boundary of Y
% compute the sample point on Y

% max t;
% s.j.  %r(t) in Y  
%       r(t) - Cz < =0,
%       -r(t)<=-ybar
%       Az = B;
%       z >=0,
%       t >=0.

% Method 2: using Y   
% In this formula t is the only variable
% compute the intersection point between the line 
% r(t) =rayinitial +raydir * t   and the boundary of Y
% compute the sample point on Y

%        max t       <===>  (min  -t)
% s.j. %r(t) in Y
%       rayinitial +raydir * t  = Cz;
%       Az   <=B;
%        z >=0,
%        t >=0

raydir =-[-coverplane(2),coverplane(1)]; % a row vector

% fprintf(fid, 'Start points on the sampling plane \t \t  The intersection points on the boundary of Y \t\t  Dominated or not \n') ;
for i = 1: NofSampleP
    rayintial = pointInbetween(i,:);   % a row vector
    %fprintf(fid, '%12.6f\t %12.6f\t', rayintial(1), rayintial(2));
    fprintf('%12.6f\t %12.6f\t  \n', rayintial(1), rayintial(2));
    f=[zeros(n,1);-1];
    lbnew = [lb; 0];
    ubnew = [ub;Inf];
    % 此函数过程没有解会导致程序报错：
    % 未定义函数或变量 'Allpoints2'。
    
    [xopt2,opt2,exitflag] =linprog(f,[A,zeros(m,1)],B,[-C,raydir'],-rayintial',lbnew,ubnew,x0);
     LPnumber = LPnumber +1;
    if (exitflag ~=1)    
        fprintf('no intersection\n');
        continue
    end
    t2 = xopt2(n+1); 
    x2 = xopt2(1:n); % a column vecor
    BoundaryPoint2 = rayintial + raydir * t2; % a row vector
    %fprintf(fid, '\t %12.6f\t %12.6f\t', BoundaryPoint2);
    %check if it is nondominated using  
%     Allpoints2 = zeros(NofSampleP,2);
    Allpoints2(i,:) = BoundaryPoint2;  % a row vector
%     Allpointsxvaule = zeros(NofSampleP,n);
    Allpointsxvaule(i,:) = x2';
end


[NumPoint, dim] = size(Allpoints2);
fprintf('The number of nondominated points is %d\n', NumPoint);
 
for i = 1: NumPoint
      x = Allpoints2(i,1);
      y = Allpoints2(i,2);   
%       plot(y,x,'black','Marker','.','MarkerSize',10, 'Visible', 'On')
      hold on
      fprintf('%12.6f\t %12.6f\t\n', Allpoints2(i,1), Allpoints2(i,2) );
end  

  