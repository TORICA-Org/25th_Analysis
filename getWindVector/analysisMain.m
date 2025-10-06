% 表示形式を設定
format long;

% csvファイルをテーブルとして読み込む
% VariableNamingRuleをpreservenに設定し，元ファイルのヘッダーを変数にする
srcT = readtable("src/2025FlightLog.csv", 'VariableNamingRule', 'preserve');

% 対地速度計算用関数を呼び出す
groundSpeedT = getGroundSpeedTable(srcT);

% テーブルを表示
% disp(groundSpeedT);

% 風向ベクトル計算用テーブルを初期化
sz = [100 15];
verTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
varNames = ["Time", "Latitude", "Longitude", "Altitude", "Roll", "Pitch", "Yaw", "AirSpeed", "AoA", "AoS", "V_N_g", "V_E_g", "V_D_g", "GroundSpeed", "GroundDirectionAngle"];
tempT = table('Size', sz, 'VariableTypes', verTypes, 'VariableNames', varNames);

% 行数を取得
numRows = height(groundSpeedT);

for i = 1:numRows

    % 目標値
    targetValue = groundSpeedT{i, 'Time'};

    % 目標値に最も近い行のインデックスを取得
    closestRowIndex = getClosestRowIndex(srcT, 1, targetValue);

    % 取得した行のインデックスから必要な列をコピー
    tempT{i, {'Time', 'Roll', 'Pitch', 'Yaw', 'AirSpeed', 'AoA', 'AoS'}} = srcT{closestRowIndex, {'FlightTime', 'bno_roll', 'bno_pitch', 'bno_yaw', 'data_air_sdp_airspeed_ms', 'data_air_AoA_angle_deg', 'data_air_AoS_angle_deg'}};
    tempT{i, {'Latitude', 'Longitude', 'Altitude', 'V_N_g', 'V_E_g', 'V_D_g', 'GroundSpeed', 'GroundDirectionAngle'}} = groundSpeedT{i, {'MidLatitude', 'MidLongitude', 'MidAltitude', 'V_N_g', 'V_E_g', 'V_D_g', 'GroundSpeed', 'GroundDirectionAngle'}};

end

% 余分な行を削除
tempT(numRows+1:height(tempT), :) = [];

tempT(:, "AoA") = tempT(:, "AoA") - 103.8 - 9.2;
tempT(:, "AoS") = tempT(:, "AoS") - 312.36;

% テーブルを表示
%disp(tempT);

% テーブルをCSVに書き出す
%writetable(tempT, "output/FlightLog.csv");

%{
hold on;
plot(tempT.Time, tempT.AirSpeed, "Color", "b");
plot(tempT.Time, tempT.GroundSpeed, "Color", "g");
legend("AirSpeed", "GroundSpeed");
xlabel("Time [s]");
ylabel("Speed [m/s]");
hold off;
%}

windInfo = getWindFromFlightData(tempT);

% テーブルを表示
disp(windInfo);

% 地図の表示を設定
figure;
title('Wind Data Plot');
xlabel('Longitude');
ylabel('Latitude');
grid on;

% 経路をプロット
geoplot(windInfo.latitude, windInfo.longitude, '-c', 'LineWidth', 0.5);

% プロットを保持
hold on;

% 行数を取得
numRows = height(windInfo);

for i = 1:numRows
    
    % 始点の緯度と経度
    lat = windInfo{i, "latitude"};
    lon = windInfo{i, "longitude"};

    v_n_g = windInfo{i, "V_N_g"};
    v_e_g = windInfo{i, "V_E_g"};
    drawArrowOnMap(lat, lon, v_n_g, v_e_g, '-r');

    v_n_a = windInfo{i, "V_N_a"};
    v_e_a = windInfo{i, "V_E_a"};
    drawArrowOnMap(lat, lon, v_n_a, v_e_a, '-b');

    % 風速ベクトルの成分 (V_N_w:南北成分, V_E_w:東西成分)
    v_north = windInfo{i, "V_N_w"};
    u_east  = windInfo{i, "V_E_w"};

    % 風上を指すベクトルをプロット
    drawArrowOnMap(lat, lon, v_north, u_east, '-y');

end

disp("finish");