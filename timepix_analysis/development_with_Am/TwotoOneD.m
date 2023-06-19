function OneD = TwotoOneD(TwoD)
    [RowSize, ColumnSize] = size(TwoD);
    k = 1;
    OneD = [];
    for i = 1:1:RowSize
        for j = 1:1:ColumnSize
            OneD(k) = TwoD(i,j);
            k = k+1;
        end
    end
end