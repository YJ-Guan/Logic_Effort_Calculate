% ///////////////////////////////////////////////////////////////////////////////
% // Copyright(C) YJ-Guan. Open source License: MIT.
% // ALL RIGHT RESERVED
% // File name   : LE_calculate_solve.m
% // Author      : YJ-Guan               
% // Date        : 2020-11-22
% // Description : calculate the logic effort in critical path of Brent-Kung ADD16
% //  
% // Modification History:
% //   Date   |   Author   |   Version   |   Change Description
% //==============================================================================
% // 20-11-22 |  YJ-Guan   |     0.1     |  Original Version
% ////////////////////////////////////////////////////////////////////////////////
%clc;clear;
wp = 330; wn = 220;
cg_std = wp+wn;
S1 = 1;
%=========================Fan Out=========================%
cg_bit = 2*wn+wp+2*wn+2*wp;
F = 1/((17.651+12.294+10.344+28.144+22.18+37.996)/1000*S1*cg_bit/cg_std);


syms S2;syms S3;syms S4;syms S5;syms S6;syms S7;syms S8;syms S9;
syms b_2;syms b_3;syms b_4;syms b_5;syms b_6;syms b_7;syms h;
%==================1st stage: bitwise P&G=========================%
g_1 = cg_bit/cg_std;
b_1 = 1;

%==================2nd stage: nega G block========================%
% For the p input of this cell (beacuse it's slow in bitwise)
g_2 = (2*wp+2*wn)/cg_std;
% Suppose same scales in branches
e2 = b_2-(S3*(2*wp+2*wn)+cg_std)/(S2*(2*wp+2*wn));

%==================3rd stage: pos G block=========================%
g_3 = (2*wp+2*wn)/cg_std;
e3 = b_3 - (S4*(2*wp+2*wn)+cg_std)/(S4*(2*wp+2*wn));

%==================4th stage: neg G block=========================%
g_4 = (2*wp+2*wn)/cg_std;
e4 = b_4 - (S5*cg_std+(2*wp+2*wn))/(S5*cg_std);

%==================5th stage: BUF=================================%
g_5 = 1;
e5=b_5 - (cg_std+S6*(2*wp+2*wn))/(S6*(2*wp+2*wn));

%==================6th stage: pos G block=========================%
g_6 = (2*wp+2*wn)/cg_std;
e6 = b_6 - (S7*(2*wp+2*wn)+cg_std)/(S7*(2*wp+2*wn));

%==================7th stage: nrga G block========================%
g_7 = (2*wp+2*wn)/cg_std;
e7 = b_7 - (S8*(2*wp+2*wn)+cg_std)/(S8*(2*wp+2*wn));

%==================8th stage: nega G block========================%
g_8 = (2*wp+2*wn)/cg_std;
b_8 = 1;

%==================9th stage: SUM XOR=============================%
g_9 = (2*wp+2*wn)/cg_std;
b_9 = 1;

%========================LOGIC EFFORT=============================%
G = g_1*g_2*g_3*g_4*g_5*g_6*g_7*g_8*g_9;
e8 = h - (F*G*b_1*b_2*b_3*b_4*b_5*b_6*b_7*b_8*b_9)^(1/9);

%============================SCALING=============================%

e10 = S2 - h*S1*g_1/(g_1*b_1*g_2);
e11 = S3 - h*S2*g_2/(g_2*b_2*g_3);
e12 = S4 - h*S3*g_3/(g_3*b_3*g_4);
e13 = S5 - h*S4*g_4/(g_4*b_4*g_5);
e14 = S6 - h*S5*g_5/(g_5*b_5*g_6);
e15 = S7 - h*S6*g_6/(g_6*b_6*g_7);
e16 = S8 - h*S7*g_7/(g_7*b_7*g_8);
e17 = S9 - h*S8*g_8/(g_8*b_8*g_9);

S = vpasolve([e2==0,e3==0,e4==0,e5==0,e6==0,e7==0,e8==0,e10==0,e11==0,e12==0,e13==0,e14==0,e15==0,e16==0,e17==0],[S2,S3,S4,S5,S6,S7,S8,S9,b_2,b_3,b_4,b_5,b_6,b_7,h]);
SOUT = [S.S2 S.S3 S.S4 S.S5 S.S6 S.S7 S.S8 S.S9]
plot(2:9,SOUT);hold on;
