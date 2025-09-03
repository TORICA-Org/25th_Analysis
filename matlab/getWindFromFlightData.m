function wind_table = getWindFromFlightData(flight_table)

% =====
% YAW：北方位が0deg、機体を上から見て時計回りが正方向、Z軸回り
% ROLL：水平が0deg、機体を後方から見て時計回り（右バンク）が正方向、X軸周り
% PITCH：水平が0deg、ピッチ上げが正方向、Y軸周り
% X軸：機体進行方向、前方が正方向
% Y軸：機体並進方向、進行方向に対して、右翼方向が正方向
% Z軸：重力方向、下方向が正方向
% AOA：機体進行方向と機体下方方向の成す角度、ピッチ下げ方向が正
% AOS：機体進行方向と進行方向に対して、右翼方向が成す角度、ヨー方向が正
% =====

% getWindInfo - 飛行データテーブルから風速・風向情報を計算する
%
% Inputs:
%   flight_table - 以下の変数を含むテーブル
%     .Roll, .Pitch, .Yaw      (度)
%     .AirSpeed                (m/s)
%     .AoA, .AoS               (度)
%     .GSx, .GSy, .GSz         (地理座標系(NED)での対地速度 m/s)
%
% Outputs:
%   wind_table - 以下の変数を含むテーブル
%     .V_N_w, .V_E_w, .V_D_w   (風速のNED成分 m/s)
%     .WINDSPEED               (風速 m/s)
%     .WindDirection           (風向, 北=0, 東=90 度)

    % --- 1. テーブルから変数を抽出 ---
    latitude = flight_table.Latitude;
    longitude = flight_table.Longitude;
    pitch    = flight_table.Pitch;
    roll     = flight_table.Roll;
    yaw      = flight_table.Yaw;
    airspeed = flight_table.AirSpeed;
    aoa      = flight_table.AoA;
    aos      = flight_table.AoS;
    
    velN = flight_table.GSx; % 対地速度 北(+)
    velE = flight_table.GSy; % 対地速度 東(+)
    velD = flight_table.GSz; % 対地速度 下(+)

    % --- 2. 対気速度を機体座標系から地理座標系(NED)へ変換 ---
    
    % Python版の定義に従い、crとsrを定義
    cr = cosd(-roll);
    sr = sind(-roll);
    
    cp = cosd(pitch); sp = sind(pitch);
    cy = cosd(yaw);   sy = sind(yaw);
    
    % 横滑り角の符号を反転
    aos = -aos;
    
    caoa = cosd(aoa); saoa = sind(aoa);
    caos = cosd(aos); saos = sind(aos);

    % 機体座標系での対気速度成分
    U = airspeed .* caoa .* caos; % 前方
    V = airspeed .* caoa .* saos; % 右方
    W = airspeed .* saoa .* caos; % 下方

    % 機体座標系 -> 地理座標系(NED)への回転行列を定義
    V_N_ac = (cp.*cy).*U + (sr.*sp.*cy - cr.*sy).*V + (cr.*sp.*cy + sr.*sy).*W;
    V_E_ac = (cp.*sy).*U + (sr.*sp.*sy + cr.*cy).*V + (cr.*sp.*sy - sr.*cy).*W;
    V_D_ac = (-sp)   .*U + (sr.*cp)             .*V + (cr.*cp)             .*W;


    %       [cy  -sy   0] ( [cp    0   sp] [1    0     0] )
    %   R = [sy   cy   0] | [ 0    1    0] [0   cr   -sr] |
    %       [ 0    0   1] ( [-sp   0   cp] [0   sr    cr] )
    
    %   [V_N_ac]     [U]
    %   [V_E_ac] = R [V]
    %   [V_D_ac]     [W]


    % --- 3. 風速ベクトルを計算 ---
    V_N_w = V_N_ac - velN;
    V_E_w = V_E_ac - velE;
    V_D_w = V_D_ac - velD;
    
    WINDSPEED = sqrt(V_N_w.^2 + V_E_w.^2 + V_D_w.^2);
    
    % --- 4. 風向を計算 ---
    % atan2d(Y,X)を使い、風が「向かう」角度を計算
    % 180を足して風が「吹いてくる」角度に変換し、0-360度に正規化
    WindDirection = mod(180 + atan2d(V_E_w, V_N_w), 360);
    
    % --- 5. 結果をテーブルに格納して出力 ---
    wind_table = table(latitude, longitude, V_N_w, V_E_w, V_D_w, WINDSPEED, WindDirection);

end