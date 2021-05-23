clear all;
clc;
close all;

x=2.5;
X = [0 1 2 3];
Y = [1 0 1 10];

dt = zeros(length(X), length(X) + 1);


% difference table
for i = 1:length(X)
    dt(i, 1) = X(i);
    dt(i, 2) = Y(i);
end
n = length(X) - 1;
for j = 3:length(X) + 1
    for i = 1:n
        dt(i, j) = dt((i + 1), (j - 1)) - dt(i, (j - 1));
    end
    n = n - 1;
end
dt

% finding x0 in table
xnIndex = length(X);
h = X(2)-X(1);
t = term(x,X,length(X),h);
p = (x - X(xnIndex)) / h;

% find interpolation using backwardDifference formula
f = backwardDifference(Y,t,p);

% Select cell programmatically
fig = figure;
table = uitable(fig,'Data',dt,'Position',[20 20 262 204]);
table.Position = [350 350 table.Extent(3) table.Extent(4)];

jUIScrollPane = findjobj(table);
jUITable = jUIScrollPane.getViewport.getView;

hightLightStartColumns = 3;
jUITable.changeSelection(xnIndex-1,0, true, false);
jUITable.changeSelection(xnIndex-1,1, true, false);
jUITable.changeSelection(0,length(X), true, false);
for i = hightLightStartColumns: length(X) % column 
    for j = 0 : length(X) % row 
        
        if j < length(X)
            
            if dt(j+1,i) == 0
                dt(j,i)
                jUITable.changeSelection(j-1,i-1, true, false);
                break;
            end
        end
    end
end

% error
error=abs(f-x);


function f = backwardDifference(y,t,p)
    f = 0;
    k = p;
    for i=1:t-1
        d = diff(y,i);
        f = f+d(t-i)*k*(1/factorial(i));
        k = k*(p+i);
    end
    f = y(t)+f;
end


function t = term(a,x,n,h)
    d = abs(a-x);
    for i = 1:n
        j = i;
        if d(j)<=h
            if j>(n+1)/2
                j=j+1;
            end
            break
        end
    end
    t = j;
end