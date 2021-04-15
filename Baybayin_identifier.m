% ---------------------------------------------------------------------------------------%
% Baybayin and Latin Script Recognition System                                           %                           
% by Rodney Pino, Renier Mendoza, and Rachelle Sambayan                                  %
% Programmed by Rodney Pino at University of the Philippines - Diliman                   %
% Programming dates: January 2021 to April 2021                                                          % 
% ---------------------------------------------------------------------------------------%


%a=input Baybayin and/or Latin block text image
%orig code

function output=Baybayin_identifier(a)
format compact
%tic;

%Start of preprocessing
A=imread(a);
[~, v2]=c2bw(A);        % rgb to binary image conversion
size(v2);               % image size information
v2=bwareaopen(v2,10);   % removing small or noise components

%=======Acquisition of Text Properties using the built-in ocr function=======%

% ================================================================= %
% Note:                                                             %
% The template is set this way for the reason that the ocr function %
% may still produce the text properties even if the languages used  %
% cannot be applied to the input characters. This is due to the     %
% novelty of Baybayin OCR and there are no available Baybayin       %
% OCR at the time of making this project                            %
% ------------------------------------------------------------------%

text=ocr(v2, 'Language','Tagalog','Language','Japanese','TextLayout','Block');

RW  = text.Words;

%----------------------------------------------------------------------------%

%======================== Word Segmentation Process ========================%

output=cell(1,length(RW)); %preallocating the number of words found
WBB = text.WordBoundingBoxes;
[row, ~]=size(WBB);

Latin=0; Baybayin=0;
for i=1:row
    P=WBB(i,:);
    PP=[P(1)-1 P(2)-1 P(3)+1 P(4)+1];
    PPP=imcrop(v2, PP);
    PPP=bwareaopen(PPP,13);
%    figure;
%  imshow(PPP);
    S=regionprops(PPP,'basic');
s=struct2cell(S);
[~,cs]=size(s);
CC=zeros(1, cs);
BBs=s(3,:);
for j=1:cs
    C=s{2,j};
    CC(j)=C(1);
end
C3=sort(CC);
CCC=sort(CC);

[~, colPPP]=size(PPP);
threshold_val=colPPP/(length(CCC)+1);

%----------------- computing each character bounding boxes -----------------%
for jj=1:cs-1
    for k=jj+1:cs
    if abs(CCC(jj)-CCC(k))<threshold_val
        CCC(k)=0;
    end
    end
end

K=part_of_the_character_finder(CCC);   %determines the component(s) of a Baybayin character
                                       %from (each) word bounding boxes obtained from 
                                       %OCR function

CBB=cell(1,length(K));
kcol1=0;
for q=1:length(K)
    
    [~, kcol]=size(K{q});
    C5=C3(1,1+kcol1:kcol1+kcol);
    
    kcol1=kcol1+kcol;
    
    Q=zeros(1,length(C5));
    BB=[];
    for qq=1:length(C5)
        [~, idx]=find(CC==C5(qq));
        if length(idx)>1
            idx=idx(1);
        end
        Q(qq)=idx;
        BB=cat(1,BB,BBs{Q(qq)});
    end

    BB1=BB(:,1);
    BB2=BB(:,2);
    BB3=BB(:,3);
    BB4=BB(:,4);
    
    AA1=min(BB2); AA2=max(BB2);
    AA3=abs(AA1-AA2);
    [~, idx]=max(BB2);
    AA4=AA3+BB4(idx);
   
    CBB{q}=[min(BB1) min(BB2) max(BB3) AA4];
    
    
end
%---------------------------------------------------------------------------%

%======================== Baybayin and Latin Script Recognition ========================%

[~, m]=size(CBB);
L_B=zeros(1,m);

for ii=1:m                                              %word extraction
    crop=CBB{1,ii};
    crop=[crop(1)-1 crop(2)-1 crop(3)+1 crop(4)+1];
    character=imcrop(PPP,crop);                         %Isolating the character
    character=bwareaopen(character,70);
    character=imdilate(character, strel('disk',1));
%   imshow(character);
    LvsB_label=LVSB(character);                         %Latin and Baybayin character function classifier
    L_B(1,ii)=LvsB_label;                               %Each categorization result is stored
end  

      L_B=sign(sum(L_B));                               %The word script depends on the sign of the sum of the categorization result
    if L_B==1 || L_B==0                                 %Latin if 1 or 0
        Latin=Latin+1;
        output{i}='Latin';
    else
        Baybayin=Baybayin+1;                            %If -1, it is Baybayin
        output{i}='Baybayin';
    end
    
end

fprintf('Total number of words found is %d. It consists of %d Baybayin word/s\nand %d Latin word/s.\n',Latin+Baybayin, Baybayin, Latin); %The system tells then how many words found; how many of those are Baybayin and/or Latin.
%toc;
end
