% ---------------------------------------------------------------------------------------%
% Baybayin and Latin Script Recognition System                                           %                           
% by Rodney Pino, Renier Mendoza, and Rachelle Sambayan                                  %
% Programmed by Rodney Pino at University of the Philippines - Diliman                   %
% Programming dates: January 2021 to August 2021                                                          % 
% ---------------------------------------------------------------------------------------%


%a=input Baybayin-Latin block text image
%orig code

function output2=Baybayin_identifier(a)
tic;
format compact
clf();
load LvsB_classifier_00125.mat LvsB_classifier_00125;
load Baybayin_Character_Classifier_00379.mat Baybayin_Character_Classifier_00379;



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

text1=ocr(v2, 'Language','Tagalog','Language','Japanese','TextLayout','Block');

RW  = text1.Words;

%----------------------------------------------------------------------------%

%======================== Word Segmentation Process ========================%

output=zeros(1,length(RW)); %preallocating the number of words found
WBB = text1.WordBoundingBoxes;
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

%if i==2
%    j=11;
%end

for ii=1:m                                              %word extraction
    crop=CBB{1,ii};
    crop=[crop(1)-1 crop(2)-1 crop(3)+1 crop(4)+1];
    character=imcrop(PPP,crop);                         %Isolating the character
    character=bwareaopen(character,70);
    character=imdilate(character, strel('disk',1));
%    if i==3
%        j=1;
%    end
%   imshow(character);
    LvsB_label=LVSB(LvsB_classifier_00125,character);                         %Latin and Baybayin character function classifier
    L_B(1,ii)=LvsB_label;                               %Each categorization result is stored
end  

      L_B=sign(sum(L_B));                               %The word script depends on the sign of the sum of the categorization result
    if L_B==1 || L_B==0                                 %Latin if 1 or 0
        Latin=Latin+1;
        output(i)=1;
    else
        Baybayin=Baybayin+1;                            %If -1, it is Baybayin
        output(i)=-1;
    end
    
end

%------------------------------ Setting the output image/s ------------------------------%

message=sprintf('Total number of words found is %d. It consists of %d Baybayin\nword/s (bounded by red boxes) and %d Latin word/s\n(bounded by blue boxes).',Latin+Baybayin, Baybayin, Latin); %output caption

count=0; [row_out, ~]=find(output<0); row_out1=sum(row_out);
transliterations=cell(row_out1,1);

iniTime = clock;
limit   = 60;  %transliteration limit time in seconds 
    
    for jj=1:row       
             
        if output(jj)~=1
           J=imcrop(A, WBB(jj,:)); 
           [transli,Idk]=Baybayin_word_reader(Baybayin_Character_Classifier_00379, J);      %Transliterating each Baybayin word found
           
           if etime(clock, iniTime) > limit
               break;
           end
           
           count=1+count;
           if Idk==0 && length(transli)>3
               transli=transli(1:3,1);          %If the generated word is not in the dictionary, the system considers the first 3 Latin strings produced.
           end
           transliterations{count,1}=transli;
        end


    end
  etime_check=etime(clock, iniTime);  
     
%pad1=ceil(pad(2)/2);
pad=size(A); pad2=uint8(ones(pad(1),365)*255); pad3=uint8(pad2); pad3(:,:,2)=pad3;
pad4=cat(3,pad3,pad2); padresult=cat(2, A,pad4);

padresult=insertText(padresult,[pad(2)+1 1], message, 'Fontsize',12,'BoxOpacity', 0,'Textcolor','black');       %inserting caption

if ~isempty(transliterations)
A4=A;   
for shift=1:row
    
   if output(shift)~=1
       
           
A1=WBB(shift,:);
A2_check=0;
 if A1(2)+A1(4) > size(A,1)
        A2=A(A1(2):size(A,1),A1(1):A1(1)+A1(3),:); 
        A2_check=1;
    A3=255; A2(:)=A3; 
A4(A1(2):size(A,1),A1(1):A1(1)+A1(3),:)=A2;        
 end
 
 if A1(1)+A1(3) > size(A,2)
        A2=A(A1(2):A1(2)+A1(4),A1(1):size(A,2),:);
        A2_check=1;
    A3=255; A2(:)=A3; 
A4(A1(2):A1(2)+A1(4),A1(1):size(A,2),:)=A2;        
 end
 
 if A2_check==0   
    A2=A(A1(2):A1(2)+A1(4),A1(1):A1(1)+A1(3),:);
    A3=255; A2(:)=A3; 
A4(A1(2):A1(2)+A1(4),A1(1):A1(1)+A1(3),:)=A2;
 end
 
   end
   
end

end


%text(17,11,yourtext,'Color','blue','FontUnits','Pixels','FontSize',20,'VerticalAlignment', 'top')
padresult2=padresult;
%padresult=cat(2,padresult,A4);

if ~isempty(transliterations)
messagenew=sprintf('Possible Baybayin word/s transliteration are shown at the\nother image.');
padresult2=insertText(padresult2,[pad(2)+1 48], messagenew, 'Fontsize',12,'BoxOpacity', 0,'Textcolor','black');  %inserting caption
end

output2=imshow(padresult2);         %first image output

hold on

Baybayin_counter=[];
    for j=1:row
        if output(j)==1
            rectangle('Position', WBB(j,:),'Edgecolor','b');    %Latin words are bounded by blue boxes
        else
            Baybayin_counter=cat(1,Baybayin_counter,j);
            rectangle('Position',WBB(j,:),'Edgecolor','r');     %Baybayin words are bounded by red boxes
        end
    end
    
 if etime_check > limit
     error('Oops. System timeout for transliterations.');
 %    return;
 end
    
    
% =============================================================== %
% Note:                                                           %
% If there are no Baybayin word detected, the system only outputs %
% the word script distinction image, where each recognized word   %
% is boxed by blue (for Latin words).                             %
% --------------------------------------------------------------- %    

%------------------- Second Image Output Setup -------------------%
if ~isempty(transliterations)

    kk=zeros(1,length(transliterations));

       single_line=cell(1,length(transliterations));
       
       
       
       for seq3=1:length(transliterations)
                if length(transliterations{seq3})>1
                    kk(seq3)=length(transliterations{seq3});
                    
                else
                    kk(seq3)=1;
                end
       end
       kk1=max(kk);
       
       for seq1=1:length(transliterations)
          
           k1=transliterations{seq1};
           if length(k1)==kk1
               single_line{seq1}=k1;
           else
              pad_k=kk1-length(k1);
              k1=cat(1,k1,cell(pad_k,1));  
              single_line{seq1}=k1;             
           end
       end
       
       single_lines=[];
        for seq4=1:length(single_line)
          single_lines=cat(2,single_lines,single_line{seq4});  
        end
         permn1=(1:kk1); permn2=permn(permn1,length(transliterations)); [permn2_row, permn2_col]=size(permn2);  
         
         single_lines2=cell(permn2_row, permn2_col);
         for set=1:permn2_row
             for set1=1:permn2_col
            single_lines2{set,set1}=single_lines{permn2(set,set1),set1};
             end
         end
     %    for set2=1:permn2_row
     %        discard_line=any(cellfun(@isempty, single_lines2(set2,:)), 2);
     %    end
     
     set3=zeros(1,permn2_row);
     for set2=1:permn2_row
        Check2=find(~cellfun(@isempty,single_lines2(set2,:)));
        if length(Check2)==length(transliterations)
            set3(set2)=1;
        end
     % single_lines3=single_lines2(~cellfun(@isempty, single_lines2(:,set2)), :);
     end
     nnz1=nnz(set3); single_lines3=cell(nnz1,length(transliterations)); kini=find(set3);
     
     for set4=1:length(kini)
     single_lines3(set4,:)=single_lines2(kini(set4),:);     % The system takes all the combinations of transliterated Baybayin words
                                                            % and are set to replace the Baybayin writings in the input image. 
     end
  

[line_row, ~]=size(single_lines3);
        
       
  if line_row>6
      single_lines3=single_lines3(1:6,:);   % The system only takes at most 6 combinations of transliterated words for presentation purposes
  end
  
  
[row_line, ~]=size(single_lines3);
sqrt_check=(mod(sqrt(row_line),1)==0);
  
figure;
%imshow(padresult);
if row_line<4
    
    for sequence=1:row_line    
        subplot(1,row_line,sequence);
        imshow(A4);
        numseq=num2str(sequence);
        message3=['\underline{\bf Transliteration No. ',numseq,'}'];
        title(message3,'Fontsize', 15,'Interpreter','latex');
        transliterations=single_lines3(sequence,:);
        
        for trans=1:length(transliterations) 
        display_strings=transliterations{trans};
        text(WBB(Baybayin_counter(trans),1)+WBB(Baybayin_counter(trans),3)/2,WBB(Baybayin_counter(trans),2)+WBB(Baybayin_counter(trans),4)/2,display_strings,'Color','blue','FontUnits','Pixels','FontSize',0.75*WBB(Baybayin_counter(trans),4)/(row_line*0.75),'HorizontalAlignment','center')
        rectangle('Position',WBB(Baybayin_counter(trans),:),'Edgecolor','r');
        end
        
    end

elseif row_line>3 && sqrt_check==1
   
    for sequence=1:row_line 
        subplot(sqrt(row_line),sqrt(row_line),sequence)
        imshow(A4);
        numseq=num2str(sequence);
        message3=['\underline{\bf Transliteration No. ',numseq,'}'];
        title(message3,'Fontsize', 15,'Interpreter','latex');
        transliterations=single_lines3(sequence,:);
        
        for trans=1:length(transliterations) 
        display_strings=transliterations{trans};
        text(WBB(Baybayin_counter(trans),1)+WBB(Baybayin_counter(trans),3)/2,WBB(Baybayin_counter(trans),2)+WBB(Baybayin_counter(trans),4)/2,display_strings,'Color','blue','FontUnits','Pixels','FontSize',0.75*WBB(Baybayin_counter(trans),4)/(row_line*0.75),'HorizontalAlignment','center')
        rectangle('Position',WBB(Baybayin_counter(trans),:),'Edgecolor','r');
        end        
            
    end
    
elseif row_line>3 && sqrt_check~=1
    
    check1=floor(sqrt(row_line));
    
    if row_line<=check1*(check1+1)
        
    for sequence=1:row_line 
        subplot(check1,check1+1,sequence)
        imshow(A4);
        numseq=num2str(sequence);
        message3=['\underline{\bf Transliteration No. ',numseq,'}'];
        title(message3,'Fontsize', 15,'Interpreter','latex');
        transliterations=single_lines3(sequence,:);
        
        for trans=1:length(transliterations) 
        display_strings=transliterations{trans};
        text(WBB(Baybayin_counter(trans),1)+WBB(Baybayin_counter(trans),3)/2,WBB(Baybayin_counter(trans),2)+WBB(Baybayin_counter(trans),4)/2,display_strings,'Color','blue','FontUnits','Pixels','FontSize',0.75*WBB(Baybayin_counter(trans),4)/(row_line*0.75),'HorizontalAlignment','center')
        rectangle('Position',WBB(Baybayin_counter(trans),:),'Edgecolor','r');
        end        
        
    end
    
    elseif row_line>check1*(check1+1) && row_line<(check1+1)*(check1+1)
        
    for sequence=1:row_line 
        subplot(check1+1,check1+1,sequence)
        imshow(A4);
        numseq=num2str(sequence);
        message3=['\underline{\bf Transliteration No. ',numseq,'}'];
        title(message3,'Fontsize', 15,'Interpreter','latex');
        transliterations=single_lines3(sequence,:);
        
        for trans=1:length(transliterations) 
        display_strings=transliterations{trans};
        text(WBB(Baybayin_counter(trans),1)+WBB(Baybayin_counter(trans),3)/2,WBB(Baybayin_counter(trans),2)+WBB(Baybayin_counter(trans),4)/2,display_strings,'Color','blue','FontUnits','Pixels','FontSize',0.75*WBB(Baybayin_counter(trans),4),'HorizontalAlignment','center')
        rectangle('Position',WBB(Baybayin_counter(trans),:),'Edgecolor','r');
        end        
        
    end
        
    end
    

end
  

end
%-----------------------------------------------------------------%

%----------------------------------------------------------------------------------------%

hold off
toc;
end
