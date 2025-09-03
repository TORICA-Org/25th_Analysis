% 表示形式を設定
format long;

% csvファイルをテーブルとして読み込む
% VariableNamingRuleをpreservenに設定し，元ファイルのヘッダーを変数にする
srcT = readtable("src/2025FlightLog.csv", 'VariableNamingRule', 'preserve');
srcT(:, "time") = srcT(:, "time") - 3.813; % 推定高度が10mを超えてから

% 対地速度計算用関数を呼び出す
groundSpeedT = getGroundSpeedTable(srcT);

% テーブルを表示
% disp(groundSpeedT);

% 風向ベクトル計算用テーブルを初期化
sz = [100 13];
verTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
varNames = ["Time", "Latitude", "Longitude", "Altitude", "Roll", "Pitch", "Yaw", "AirSpeed", "AoA", "AoS", "GSx", "GSy", "GSz"];
tempT = table('Size', sz, 'VariableTypes', verTypes, 'VariableNames', varNames);

% 行数を取得
numRows = height(groundSpeedT);

for i = 1:numRows

    % 目標値
    targetValue = groundSpeedT{i, 'Time'};

    % 目標値に最も近い行のインデックスを取得
    closestRowIndex = getClosestRowIndex(srcT, 1, targetValue);

    % 取得した行のインデックスから必要な列をコピー
    tempT{i, {'Time', 'Roll', 'Pitch', 'Yaw', 'AirSpeed', 'AoA', 'AoS'}} = srcT{closestRowIndex, {'time', 'bno_roll', 'bno_pitch', 'bno_yaw', 'data_air_sdp_airspeed_ms', 'data_air_AoA_angle_deg', 'data_air_AoS_angle_deg'}};
    tempT{i, {'Latitude', 'Longitude', 'Altitude', 'GSx', 'GSy', 'GSz'}} = groundSpeedT{i, {'MidLatitude', 'MidLongitude', 'MidAltitude', 'GSx', 'GSy', 'GSz'}};

end

% 余分な行を削除
tempT(numRows+1:height(tempT), :) = [];

% disp(tempT);

tempT(:, "AoA") = tempT(:, "AoA") - 103.8 - 9.2;
tempT(:, "AoS") = tempT(:, "AoS") - 312.36;

% disp(tempT);

windInfo = getWindFromFlightData(tempT);

disp(windInfo);


% 1. サンプルデータの準備 (フライトログから得られたと仮定)
% 始点の緯度と経度
lat = windInfo.latitude;
lon = windInfo.longitude;

% 風速ベクトルの成分 (V_N_w:南北成分, V_E_w:東西成分)
v_north = windInfo.V_N_w;
u_east  = windInfo.V_E_w;

% 2. 地図座標軸の作成
figure;
worldmap('japan'); % 表示領域として日本地図を設定

% 3. 背景地図の描画
geoshow('landareas.shp', 'FaceColor', [0.9 0.9 0.7]); % 陸地を色付け

framem on; % 地図の枠線を表示

% 4. ベクトル矢印の描画
% quiverm(緯度, 経度, V成分(南北), U成分(東西), スケール, 'プロパティ', 値)
% 引数の順番が V(南北) -> U(東西) である点に注意してください。
quiverm(lat, lon, v_north, u_east, 1.5, 'Color', 'r', 'LineWidth', 1.5);

title('フライトログに基づく風ベクトル');
