function [ A_U,A_L,B_U,B_L ] = DelayDensity_GPCModel( AU,AL,BU,BL )
%Greedy Processing Components
%Reference: Wandeler, Ernesto Modular Performance Analysis and Interface-Based Design for Embedded Real-Time Systems

tmp1=DelayDensity_MinPlusConvolution(AU,BU);
tmp2=DelayDensity_MinPlusDeconvolution(tmp1,BL);
A_U=DelayDensity_MinArray(tmp2,BU);

tmp3=DelayDensity_MinPlusDeconvolution(AL,BU);
tmp4=DelayDensity_MinPlusConvolution(tmp3,BL);
A_L=DelayDensity_MinArray(tmp4,BL);

tmp5=BU-AL;
tmp6=zeros(1,length(AU));
B_U=DelayDensity_MaxPlusDeconvolution(tmp5,tmp6);

%zur test validation B_U
for i=1:length(B_U)
    if B_U(i)<=0
        B_U(i)=0;
    end
end

tmp7=BL-AU;
tmp8=zeros(1,length(AU));
B_L=DelayDensity_MaxPlusConvolution(tmp7,tmp8);

%zur test validation B_L
for i=1:length(B_L)
    if B_L(i)<=0
        B_L(i)=0;
    end
end


end

