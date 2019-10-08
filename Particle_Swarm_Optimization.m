%% f = @(x, y) 100*(y - x^2)^2 + (1 - x)^2;
%% f = @(x,y) 1- (1 - sin(sqrt(x**2 + y**2))**2)/(1+0.001*(x**2 + y**2));
f = @(x,y) -cos(x)*cos(y)*exp(-((x-pi)^2 + (y-pi)^2));

n=100;            %% Numero de partiulas
momentum = 0.7;   %% Momento de inercia
lambda1 = 1;
lambda2 = 1;
max_cont = 100;
cont = 0;

%% limites da funcao
l = 10;    %% +- 10 em x
h = 10;    %% +- 10 em Y

%% Gera as particulas
%% As particulas sao montadas na matriz da seguinte forma
%% [posicao X, posicao Y, lbest X, lbest Y, velocidade X, velocidade Y]
p = [];

%% plot
X = linspace(-l,l,100);
Y = linspace(-h,h,100);
fig = figure();

[xplot, yplot] = meshgrid(X,Y);

zplot = -cos(xplot).*cos(yplot).*exp(-((xplot-pi).^2 + (yplot-pi).^2));

surf(xplot, yplot, zplot);

hold on;

for a=1:n
  p(a,1) = -l + rand*2*l;
  p(a,2) = -h + rand*2*h;
  p(a,3) = p(a,1);
  p(a,4) = p(a,2);
  p(a,5) = 0;
  p(a,6) = 0;
end

%% Encontra o melhor ponto inicial
gbest = [0,0,10000];
for i=1:n
    if f(p(i,1),p(i,2)) < gbest(3)
      gbest(1) = p(i,1);
      gbest(2) = p(i,2);
      gbest(3) = f(p(i,1),p(i,2));
    end  
end

while cont < max_cont
  cont = cont+1;
  %%  calcula a proxima posicao e velocidade de cada particula
  for a=1:n
    aux = [];
    %% Proxima posicao
    aux(1) = p(a,1) + p(a,5);   %% X
    aux(2) = p(a,2) + p(a,6);   %% Y

    if aux(1) > l
      aux(1) = l;
    end
    
    if aux(1) < -l
      aux(1) = -l;
    end
    
    if aux(2) > h
      aux(2) = h;
    end
    
    if aux(2) < -h
      aux(2) = h;
    end
    
    %% Proxima velocidade
    aux(3) = momentum*p(a,5) + lambda1*rand*(p(a,3) - p(a,1)) + lambda2*rand*(gbest(1) - p(a,1));
    aux(4) = momentum*p(a,6) + lambda1*rand*(p(a,4) - p(a,2)) + lambda2*rand*(gbest(2) - p(a,2));
    
    p(a,1) = aux(1);
    p(a,2) = aux(2);
    p(a,5) = aux(3);
    p(a,6) = aux(4);
    
    %% Verifica se ha um novo local_best
    if f(aux(1),aux(2)) < f(p(a,3),p(a,4))
      p(a,3) = aux(1);
      p(a,4) = aux(2);
    end
  end
  
  %% Verifica se ha um novo global_best 
  for i=1:n
    if f(p(i,1),p(i,2)) < gbest(3)
      gbest(1) = p(i,1);
      gbest(2) = p(i,2);
      gbest(3) = f(p(i,1),p(i,2));
      cont = 0;
      
      %% Plot
      scatter3(gbest(1), gbest(2), gbest(3),50, 2);
      hold on;
    end  
  end
end

  disp("valor minimo aproximado: ")
  disp(gbest(3))
  disp("Se encontra em (x,y): ")
  disp([gbest(1) gbest(2)])