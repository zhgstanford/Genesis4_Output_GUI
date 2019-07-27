function [OUT,TopArea] = AreaLength(Vector, Ratio)

if(iscolumn(Vector))
    Vector=Vector.';
end

Cumulative=sum(Vector);
MaxSize=length(Vector);
MinSize=1;
while((MaxSize-MinSize)>2)
    Size=(MaxSize+MinSize)/2;
    Area=conv(Vector,ones(1,round(Size)));
    if(max(Area)>Cumulative*Ratio)
       MaxSize=Size; 
    else
       MinSize=Size;
    end
end

[~,Location]=max(Area);
TopArea(1)=Location-round(Size)+1;
TopArea(2)=TopArea(1)+round(Size);

OUT=Size;
