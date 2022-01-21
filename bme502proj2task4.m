% dennis mcilhany BME 502 Project 2 task 2

clc; clear all;

sequenceE=zeros(50,25);
for k=3:50;
    N=50;
    f=0.1;
    n=N*f;
    for run=1:25;
        input=zeros(N,1);
        temporary=randperm(N);
        input(temporary(1:n))=1;
        T=zeros(k,N);
        T2=zeros(k,(N*(N-1))/2);
        T(1,:)=input;
        W=zeros((N*(N-1))/2,N);
        for i=2:k;
            input=zeros(N,1);
            temporary=randperm(N);
            input(temporary(1:n))=1;
            T(i,:)=input;  
%             W=W+T(i-1,:)'*T(i,:);
        end

        for m1=1:k;
            z1=1;
            for i1=1:N;
                for j1=i1:N;
                    if z1<=(N*(N-1))/2
                        T2(m1,z1)=T(m1,i1)*T(m1,j1);
                        z1=z1+1;
                    else
                    end
                end
            end
        end

        for h=2:k;
            W=W+T2(h-1,:)'*T(h,:);
        end
        
        for p=1:(N*(N-1))/2;
            for l=1:N;
                if W(p,l)>=1;
                    W(p,l)=1;
                end
            end
        end
        
        R=zeros(k,N);
        R2=zeros(k,(N*(N-1))/2);
        R(1,:)=T(1,:);
        R2(1,:)=T2(1,:);
        for z=1:k-1;
            newinput=R2(z,:)*W;
            R(z+1,:)=newinput;
            z2=1;
            for m=1:N;
                if R(z+1,m)>=n;
                    R(z+1,m)=1;
                else
                    R(z+1,m)=0;
                end
            end
            for a1=1:N;
                for s1=a1:N;
                    if z2<=(N*(N-1))/2
                        R2(z+1,z2)=R(z+1,a1)*R(z+1,s1);
                        z2=z2+1;
                    else
                    end
                end
            end
        end
        for b=1:N;
            if R(k,b)~=T(k,b);
                sequenceE(k,run)=sequenceE(k,run)+1;
            end
        end
        avgerror(k)=mean(sequenceE(k,:));
    end
end
capacity=1;
while avgerror(capacity)==0;
    capacity=capacity+1;
end
capacity


K=1:k;
plot(K,avgerror,10,sequenceE(10,:),'xb',15,sequenceE(15,:),'xb',20,sequenceE(20,:),'xb',25,sequenceE(25,:),'xb',30,sequenceE(30,:),'xb',35,sequenceE(35,:),'xb',40,sequenceE(40,:),'xb',45,sequenceE(45,:),'xb');
title('Average Sequence Errors for Increasing k Values')
xlabel('k')
ylabel('Average Sequence Error')
axis([3 50 0 45]);



