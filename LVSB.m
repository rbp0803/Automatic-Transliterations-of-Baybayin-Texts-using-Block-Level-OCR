%============================================================================%
%Note:                                                                       %
%This is a subfunction from the Baybayin and Latin Script Recognition System % 
%(Baybayin_identifier.m) for discriminating Baybayin from Latin at character %
%level                                                                       %  
%----------------------------------------------------------------------------%

function LABEL=LVSB(Mdl,input)


Letter2=input;
s=regionprops(Letter2,'basic');
ss=struct2cell(s);
S=cell2mat(ss(1,:));

%===================================================================================
%If more than one component, this part is intended for the Baybayin character 'E/I'
if length(S)>=2
    E3=max(S(S<max(S)));
    if isempty(E3)
        M=56;
        Letter=imresize(Letter2,[M M]);
        Letter1=feature_vector_extractor(Letter);
        load LvsB_classifier_00125.mat LvsB_classifier_00125 ; 
        [LABEL, ~]=predict(LvsB_classifier_00125,Letter1);
    return;
    end
EE=max(S)/E3-1;
if EE<=1
    L=find(S==max(S)); 
    SS=max(S(S<max(S)));
    LL=find(S==SS);
    
    B=ss(:,L);
    BB=ss(:,LL);
    
    A=cat(1,B{3},BB{3});
    AA(1)=min(A(:,1)); AA(2)=min(A(:,2)); AA(3)=max(A(:,3)); AA(4)=abs(A(1,2)-A(2,2));
    if A(1,2)>A(2,2)
       AA(4)=AA(4)+A(1,4);
    else
       AA(4)=AA(4)+A(2,4);
    end
    
    Letter=imcrop(Letter2,AA);
    Letter=imresize(Letter,[56 56]);
    Letter1=feature_vector_extractor(Letter);
    load LvsB_classifier_00125.mat LvsB_classifier_00125 ; 
    [LABEL, ~]=predict(LvsB_classifier_00125,Letter1);
    return;
end
end
%-----------------------------------------------------------------------------------

%Identifying the main body's significant features or bounding box
L=find(S==max(S));

SS=max(S(S<max(S)));
LL=find(S==SS);

B=ss(:,L);
BB=ss(:,LL);

if isempty(B)==1
    LABEL=-1;
    return;
end

b=B{2};
b=b(2);


L=find(S==max(S));
B=ss(:,L);
A=B{3};
A(1)=A(1)-1; A(2)=A(2)-1; A(3)=A(3)+1; A(4)=A(4)+1;

%Cropping the main body with only its essential features
Letter=imcrop(Letter2,A);
M=56;
%Rescaling the cropped image
Letter=imresize(Letter, [M M]);
R1=regionprops(Letter,'Area');
R2=struct2cell(R1);
R3=cell2mat(R2(1,:));
%Denoising of the 56x56 size image
if length(R3)>=2
    R4=max(R3(R3<max(R3)));
    Letter=bwareaopen(Letter, R4+1);
else
    Letter=bwareaopen(Letter, 10);
end

%feature vector extraction
Letter1=feature_vector_extractor(Letter);

%main body classification
%load LvsB_classifier_00125.mat LvsB_classifier_00125 ; 
[LABEL, ~]=predict(Mdl,Letter1);

end