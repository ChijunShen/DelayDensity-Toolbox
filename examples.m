% running example
% a = rtcpjdu(150, 450, 0);
% b = rtctdmal(6, 10, 1);
% ed = 20;
% c = delaydensity(a, b, ed);
% display(c);
% 
%further examples
a = rtcpjdu(3, 5, 1);
b = rtctdma(2, 7, 4);
ed = 3;
c = delaydensity(a, b, ed);
display(c);
% 
% a = rtcpjdu(3, 5, 0);
% b = rtctdma(3, 10, 4);
% ed = 3;
% c = delaydensity(a, b, ed);
% display(c);
% 
% % delaydensity doesn't work with this example
% % a = rtcpjdu(3, 0, 0);
% % b = rtctdma(3, 7, 4);
% % ed = 3;
% % c = delaydensity(a, b, ed);
% % display(c);
% 
% a = rtcpjdu(150, 450, 0);
% b = rtctdma(6, 10, 1);
% ed = 20;
% c = delaydensity(a, b, ed);
% display(c);


% distributed system
% S1 -> S4
% alpha1 = rtcpjd(150, 450, 0);
% beta1 = rtctdma(6, 10, 1);
% beta5 = rtctdma(3, 10, 1);
% beta9 = rtcfs(1);
% 
% [alpha5,  beta2,  ~, ~] = rtcgpc(alpha1, beta1, [20, 20]); %t1
% [alpha9,  beta6,  ~, ~] = rtcgpc(alpha5, beta5, [ 5,  5]); %c1
% [alpha13, beta10, ~, ~] = rtcgpc(alpha1, beta9, [15,  5]); %t5
% 
% beta1s = rtcfloor(rtcrdivide(rtcminus(beta1(2), beta2(2) ), 20));
% beta5s = rtcfloor(rtcrdivide(rtcminus(beta5(2), beta6(2) ),  5));
% beta9s = rtcfloor(rtcrdivide(rtcminus(beta9(2), beta10(2)), 15));
% betap1 = rtcminconv(beta1s, beta5s, beta9s);
% 
% delaydensity(alpha1, betap1, 1)


% S2 -> S5
% alpha14 = rtcpjd(150, 300, 0);
% beta6 = rtctdma(3,10,1);
% 
% [alpha10, beta11, ~, ~] = rtcgpc(alpha14, beta10, [4, 4]); %t6
% [alpha6 , beta7 , ~, ~] = rtcgpc(alpha10, beta6, [16, 8]); %c2
% [alpha2 , beta3 , ~, ~] = rtcgpc(alpha6 , beta2, [20,20]); %t2
% 
% beta10s = rtcfloor(rtcrdivide(rtcminus(beta10(2), beta11(2)),  4));
% beta6s  = rtcfloor(rtcrdivide(rtcminus(beta6(2),  beta7(2) ), 16));
% beta2s  = rtcfloor(rtcrdivide(rtcminus(beta2(2),  beta3(2) ), 20));
% betap2  = rtcminconv(beta10s, beta6s, beta2s);
% delaydensity(alpha14, betap2, 1)


% S3 -> S6
% alpha3 = rtcpjd(250, 125, 0);
% beta3 = rtctdma(2,10,1);
% beta4 = rtctdma(2,10,1);
% beta7 = rtctdma(2,10,1);
% beta8 = rtctdma(2,10,1);
% 
% [alpha7 , beta4N, ~, ~] = rtcgpc(alpha3 , beta3 , [15,15]); %t3
% [alpha11, beta8N, ~, ~] = rtcgpc(alpha7 , beta7 , [10,10]); %c3
% [alpha15, beta12, ~, ~] = rtcgpc(alpha11, beta11, [12, 9]); %t7
% [alpha12, betaC2, ~, ~] = rtcgpc(alpha15, beta12, [11,10]); %t8
% [alpha8 , betaB , ~, ~] = rtcgpc(alpha12, beta8 , [10, 5]); %c4
% [alpha4 , betaC1, ~, ~] = rtcgpc(alpha8 , beta4 , [ 3, 3]); %t4
% 
% beta3s  = rtcfloor(rtcrdivide(rtcminus(beta3(2),  beta4N(2)), 15));
% beta7s  = rtcfloor(rtcrdivide(rtcminus(beta7(2),  beta8N(2)), 10));
% beta11s = rtcfloor(rtcrdivide(rtcminus(beta11(2), beta12(2)), 12));
% beta12s = rtcfloor(rtcrdivide(rtcminus(beta12(2), betaC2(2)), 11));
% beta8s  = rtcfloor(rtcrdivide(rtcminus(beta8(2),  betaB(2) ), 10));
% beta4s  = rtcfloor(rtcrdivide(rtcminus(beta4(2),  betaC1(2)),  3));
% betap3  = rtcminconv(beta3s, beta7s, beta11s, beta12s, beta8s, beta4s);
% delaydensity(alpha3, betap3, 1)