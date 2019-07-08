function labelOut=postprocessing(count,arrayIn,options)

    state=options.state;

    if(state==0)
        labelOut=arrayIn(count);

    elseif(state==1)
        if(count==1)
            labelOut=6;
        elseif ((arrayIn(count)==arrayIn(count-1)))
            labelOut=arrayIn(count);
        else
            labelOut=6;
        end

    elseif(state==2)
        if((count==1)||(count==2))
            labelOut=6;
        elseif ((arrayIn(count)==arrayIn(count-1))&&(arrayIn(count-1)==arrayIn(count-2)))
            labelOut=arrayIn(count);
        else
            labelOut=6;
        end

    else
        labelOut=arrayIn(count);
    end

end