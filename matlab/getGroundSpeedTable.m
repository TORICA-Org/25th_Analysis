function outputT = getGroundSpeedTable(inputT)

    % 行数を取得
    numRows = height(inputT);
    
    % 対地速度計算用テーブルを初期化
    sz = [100 8];
    verTypes = ["double", "double", "double", "double", "double", "double", "double", "double"];
    varNames = ["Time", "Latitude", "Longitude", "Altitude", "DeltaX", "DeltaY", "DeltaZ", "DeltaDistance"];
    tempT = table('Size', sz, 'VariableTypes', verTypes, 'VariableNames', varNames);
    
    loopCount = 0;
    lastTime = 0;
    lastLatitude = 0;
    lastLongitude = 0;
    
    for i = 1:numRows
    
        % 時間を取得
        currentTime = inputT{i, 1};
    
        % GPSのデータを取得
        latitude = inputT{i, 'data_main_gps_latitude_deg'};
        longitude = inputT{i, 'data_main_gps_longitude_deg'};

        % 高度を取得
        altitude = inputT{i, 'estimated_altitude_lake_m'};
    
        % 初回，または前回と異なりかつ0.8秒以上の間隔がある場合
        % GPSのデータレートは今回1spsだが，取得と保存のためにそれ以上の時間がかかっている
        % そのため，1秒毎に刻むとずれが蓄積しデータを飛ばしてしまうため，0.8秒ごとに刻む
        if (i == 1 || ((latitude ~= lastLatitude || longitude ~= lastLongitude) && currentTime - lastTime >= 0.8))
    
            % ループした回数を加算
            loopCount = loopCount + 1;
    
            % 新しい行を生成
            tempRow = table(currentTime, latitude, longitude, altitude);
    
            % 新しい行をtempTに追加
            tempT(loopCount, 1:4) = tempRow;
    
            % 次回比較で使用
            lastTime = currentTime;
            lastLatitude = latitude;
            lastLongitude = longitude;
    
        end
    
    end
    
    % 行数を取得
    numRows = height(tempT);
    
    % 余分な行を削除
    tempT(loopCount+1:numRows, :) = [];
    
    
    tempT{1, "DeltaDistance"} = 0;
    tempT{1, "DeltaX"} = 0;
    tempT{1, "DeltaY"} = 0;
    tempT{1, "DeltaZ"} = 0;
    
    
    % 行数を取得
    numRows = height(tempT);
    
    for i = 2:numRows
    
        [x, y, z, d] = calculateDistance( ...
            tempT{i-1, "Latitude"}, ...
            tempT{i-1, "Longitude"}, ...
            tempT{i-1, "Altitude"}, ...
            tempT{i, "Latitude"} - tempT{i-1, "Latitude"}, ...
            tempT{i, "Longitude"} - tempT{i-1, "Longitude"}, ...
            (tempT{i, "Altitude"} - tempT{i-1, "Altitude"})*(-1) ... % 下方向が正
        );
        tempT{i, "DeltaX"} = x;
        tempT{i, "DeltaY"} = y;
        tempT{i, "DeltaZ"} = z;
        tempT{i, "DeltaDistance"} = d;
        
    end
    
    % テーブルを表示
    % disp("DeltaZを見る")
    % disp(tempT);
    
    % 対地速度出力用テーブルを初期化
    sz = [100 8];
    verTypes = ["double", "double", "double", "double", "double", "double", "double", "double"];
    varNames = ["Time", "MidLatitude", "MidLongitude", "MidAltitude", "GSx", "GSy", "GSz", "GroundSpeed"];
    outputT = table('Size', sz, 'VariableTypes', verTypes, 'VariableNames', varNames);
    
    outputT{1, {'MidLatitude', 'MidLongitude', 'MidAltitude'}} = tempT{1, {'Latitude', 'Longitude', 'Altitude'}};

    for i = 2:numRows
    
        % 測定点の時間間隔
        deltaTime = tempT{i, "Time"} - tempT{i-1, "Time"};
    
        % 測定点の中点の時間
        outputT{i, "Time"} = tempT{i-1, "Time"} + deltaTime/2;

        % 測定点の中点の緯度
        outputT{i, "MidLatitude"} = (tempT{i, "Latitude"} + tempT{i-1, "Latitude"}) / 2;

        % 測定点の中点の経度
        outputT{i, "MidLongitude"} = (tempT{i, "Longitude"} + tempT{i-1, "Longitude"}) / 2;

        % 測定点の中点の高度
        outputT{i, "MidAltitude"} = (tempT{i, "Altitude"} + tempT{i-1, "Altitude"}) / 2;
    
        % 東西方向の推定対地速度
        outputT{i, "GSx"} = tempT{i, "DeltaX"} / deltaTime;
        % 南北方向の推定対地速度
        outputT{i, "GSy"} = tempT{i, "DeltaY"} / deltaTime;
        % 上下方向の推定対地高度
        outputT{i, "GSz"} = tempT{i, "DeltaZ"} / deltaTime;
        % 中点の推定対地速度
        outputT{i, "GroundSpeed"} = tempT{i, "DeltaDistance"} / deltaTime;
    
    end
    
    % 余分な行を削除
    outputT(numRows+1:height(outputT), :) = [];

end