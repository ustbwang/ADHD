%problem description:
%Min Cx,
%s.t. Ax <=b,
%     x > 0.
C =  [3 6 4 5 2 3 5 4 3 5 4 2 4 5 3 6;
     2 3 5 4 5 3 4 3 5 2 6 4 4 5 2 5;
     4 2 4 2 4 2 4 6 4 2 6 3 2 4 5 3];
 
A1 =[1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 ;
     0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1;
     1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0;
     0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0;
     0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0;
     0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1];
 
A2= -[1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0; 
     0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1;
     1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0;
     0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0;
     0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0;
     0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1];
 A =[A1;A2];
 b =[1 1 1 1 1 1 1 1  -1 -1 -1 -1 -1 -1 -1 -1]';
 n = size(C, 2)
 lb = [zeros(n,1)];
 ub = [ones(n,1)];

figure;
 temp= [11,11,14;
       19,14,10;
       13, 16,11;];
                face(1).vertices = temp;
         fac = [1:1:3];
         %patch('Faces',fac,'Vertices',-temp,'FaceColor', 'darkyellow');
patch('Faces',fac,'Vertices',temp,'FaceColor', [191/256,191/256,0]);
hold on
 temp= [11,11,14;
                   15, 9,17;];
face(2).vertices = temp;
fac = [1:1:2];
         %patch('Faces',fac,'Vertices',-temp,'FaceColor', 'darkyellow');
patch('Faces',fac,'Vertices',temp,'FaceColor', [191/256,191/256,0]);
hold on

[Allpoints2, Allpointsxvaule] = RNBI3D(C, A, b, lb, ub)
