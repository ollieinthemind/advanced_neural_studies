%BME502 Project 1 Dennis McIlhany

clc; clear all;

%constants
dt=.03;
t=0:dt:100;
C=1;
ENa=55;
EK=-90;
EL=-70;
gNabar=120;
gKbar=36;
gL=1;
Iinj=30:140;
IinjN=Iinj+10.*randn(1,length(Iinj));

%preallocate
V=-70*ones(length(Iinj),length(t));
m_inf=zeros(1,length(t));
tau_m=zeros(1,length(t));
m=zeros(1,length(t));
m3=zeros(1,length(t));
h_inf=zeros(1,length(t));
tau_h=zeros(1,length(t));
h=zeros(1,length(t));
n_inf=zeros(1,length(t));
tau_n=zeros(1,length(t));
n=zeros(1,length(t));
n4=zeros(1,length(t));
gNa=zeros(1,length(t));
gK=zeros(1,length(t));
INa=zeros(1,length(t));
IK=zeros(1,length(t));
IL=zeros(1,length(t));
IC=zeros(1,length(t));
am=zeros(1,length(t));
bm=zeros(1,length(t));
ah=zeros(1,length(t));
bh=zeros(1,length(t));
an=zeros(1,length(t));
bn=zeros(1,length(t));

%iterations for injected current and time
for w=1:length(Iinj);
    for k=1:length(t);
        if k==1;
            an(k)=-.01*(V(w,k)+60)/(exp(-(V(w,k)+60)/10)-1);
            am(k)=-.1*(V(w,k)+45)/(exp(-(V(w,k)+45)/10)-1);
            ah(k)=.07*exp(-(V(w,k)+70)/20);
            bn(k)=.125*exp(-(V(w,k)+70)/80);
            bm(k)=4*exp(-(V(w,k)+70)/18);
            bh(k)=1/(exp(-(V(w,k)+40)/10)+1);
            n_inf(k)=an(k)/(an(k)+bn(k));
            tau_n(k)=1/(an(k)+bn(k));
            h_inf(k)=ah(k)/(ah(k)+bh(k));
            tau_h(k)=1/(ah(k)+bh(k));
            m_inf(k)=am(k)/(am(k)+bm(k));
            tau_m(k)=1/(am(k)+bm(k));
            n(k)=n_inf(k);
            n4(k)=n(k)^4;
            m(k)=m_inf(k);
            h(k)=h_inf(k);
            m3(k)=m(k)^3;
            gNa(k)=m3(k)*h(k)*gNabar;
            gK(k)=n4(k)*gKbar;
            IK(k)=(V(w,k)-EK)*gK(k);
            INa(k)=(V(w,k)-ENa)*gNa(k);
            IL(k)=(V(w,k)-EL)*gL;
            IC(k)=0;
        else
            n(k)=n(k-1)+dt*((-n(k-1)+n_inf(k-1))/tau_n(k-1));
            m(k)=m(k-1)+dt*((-m(k-1)+m_inf(k-1))/tau_m(k-1));
            h(k)=h(k-1)+dt*((-h(k-1)+h_inf(k-1))/tau_h(k-1));
            n4(k)=n(k)^4;
            m3(k)=m(k)^3;
            gNa(k)=m3(k)*h(k)*gNabar;
            gK(k)=n4(k)*gKbar;
            V(w,k)=V(w,k-1)+(dt/C)*(IinjN(w)-(gNa(k)+gK(k)+gL)*V(w,k-1)+gNa(k)*ENa+gK(k)*EK+gL*EL);
            if (abs(V(w,k) + 45) <=0.01)
                am(k) = 1;
            else
                am(k)=-.1*(V(w,k)+45)/(exp(-(V(w,k)+45)/10)-1);
            end;
            if (abs(V(w,k) + 60) <=0.01)
                an(k) = .1;
            else
                an(k)=-.01*(V(w,k)+60)/(exp(-(V(w,k)+60)/10)-1);
            end;
            ah(k)=.07*exp(-(V(w,k)+70)/20);
            bn(k)=.125*exp(-(V(w,k)+70)/80);
            bm(k)=4*exp(-(V(w,k)+70)/18);
            bh(k)=1/(exp(-(V(w,k)+40)/10)+1);
            n_inf(k)=an(k)/(an(k)+bn(k));
            tau_n(k)=1/(an(k)+bn(k));
            h_inf(k)=ah(k)/(ah(k)+bh(k));
            tau_h(k)=1/(ah(k)+bh(k));
            m_inf(k)=am(k)/(am(k)+bm(k));
            tau_m(k)=1/(am(k)+bm(k));
            IK(k)=(V(w,k)-EK)*gK(k);
            INa(k)=(V(w,k)-ENa)*gNa(k);
            IL(k)=(V(w,k)-EL)*gL;
            IC(k)=C*(V(w,k)-V(w,k-1))/dt;
        end
    end
    pks(w)=length(findpeaks(V(w,:)))*10;
end
plot(IinjN,pks)
xlabel('Injected Current (mA)')
ylabel('Spike Frequency (hz)')
title('F-I Curve')