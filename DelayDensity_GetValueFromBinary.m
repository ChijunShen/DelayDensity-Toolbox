function [ Value ] = DelayDensity_GetValueFromBinary( Binary,startBit,endBit )
%Get Value from Binary
Value=0;
for i=startBit:endBit
    if Binary(i) == 1
        Value = Value+2^(i-1-(startBit-1));
    end        
end
end
