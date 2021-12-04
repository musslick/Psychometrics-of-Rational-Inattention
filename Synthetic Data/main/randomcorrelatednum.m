function [Zv Zs]= randomcorrelatednum(rho)
Zv= rand(1);
Zs = rho*Zv + sqrt(1-rho^2)*rand(1);
while Zv> 1.00000001
Zv= rand(1);
Zs = rho*Zv + sqrt(1-rho^2)*rand(1);
end
end