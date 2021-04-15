%================================================================================%
%Note:                                                                           %
%This is a subfunction from the the Baybayin and Latin Script Recognition System %              % 
%(Baybayin_identifier.m) for determining the components of a Baybayin or Latin   %
%character which will further hints us the true number of                        % 
%characters from the input Baybayin and/or Latin word.                           %  
%--------------------------------------------------------------------------------%

%X=predetermined abscissa locations (zero represents it is a part of the preceding component)

function K=part_of_the_character_finder(X)

Kn=nnz(X);
K=cell(Kn,1);
Finder=find(X);

for i=1:Kn
    if i==Kn
        
        K{i}=zeros(1,length(X)+1-Finder(Kn));
        C=K{i};
        C(1)=X(Finder(i));
        K{i}=C;
        break;
    end
 K{i}=zeros(1,Finder(i+1)-Finder(i));
 C=K{i};
 C(1)=X(Finder(i));
 K{i}=C;
end

end


