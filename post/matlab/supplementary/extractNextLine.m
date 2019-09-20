function rowVal = extractNextLine(f)

    rowStr = fgetl(f);
    if (rowStr ~= -1)
        rowVal = str2num(rowStr);
    else
        rowVal =-1;
    end
end
