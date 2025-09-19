function closestRowIndex = getClosestRowIndex(inputTable, columnNum, targetValue)

    % 指定された列のデータを取得
    columnData = inputTable{:, columnNum};

    % 目標値との絶対差を計算
    differences = abs(columnData - targetValue);

    % 最小の差を持つインデックスを取得
    [~, closestRowIndex] = min(differences);

end