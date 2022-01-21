% dennis mcilhany BME 502 Project 2 task 1
clc; clear all;

k=10;
N=50;
f=0.1;
n=N*f;

W=zeros(N);

input=zeros(N,1);
temporary=randperm(N);
input(temporary(1:n))=1;

T(1,:)=input;
for i=2:k;
    input=zeros(N,1);
    temporary=randperm(N);
    input(temporary(1:n))=1;
    T(i,:)=input;
    W=W+T(i-1,:)'*T(i,:);
end


for p=1:N;
    for l=1:N;
        if W(p,l)>=1;
            W(p,l)=1;
        end
    end
end

R=zeros(k,N);
R(1,:)=T(1,:);

for z=1:k-1;
    newinput=R(z,:)*W;
    R(z+1,:)=newinput;
    for m=1:N;
        if R(z+1,m)>=n;
            R(z+1,m)=1;
        else
            R(z+1,m)=0;
        end
    end
end

diff=T-R;
diff=sum(sum(diff));
if diff>0;
    disp('The Result Matrix and Training Matrix are not Identical');
else
    disp('The Result Matrix and Training Matrix are Identical');
end

% sequenceE=0;
% for b=1:N;
%     if R(k,b)~=T(k,b);
%         sequenceE=sequenceE+1;
%     end
% end
%         


    
    
    


    
    


