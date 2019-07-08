function arrayOut=statusChange(arrayIn,options)

siz=length(arrayIn);
arrayOut=zeros(1,siz);

if(options.state==0)
    arrayOut=arrayIn;
    
elseif(options.state==1)  
    for i=1:siz
        if(i==1)
            arrayOut(i)=6;
        elseif ((arrayIn(i)==arrayIn(i-1)))
            arrayOut(i)=arrayIn(i);
        else
            arrayOut(i)=6;
        end
    end
    
elseif(options.state==2)
    for i=1:siz
        if((i==1)||(i==2))
            arrayOut(i)=6;
        elseif ((arrayIn(i)==arrayIn(i-1))&&(arrayIn(i-1)==arrayIn(i-2)))
            arrayOut(i)=arrayIn(i);
        else
            arrayOut(i)=6;
        end
    end
else
    arrayOut=arrayIn;
end    


end