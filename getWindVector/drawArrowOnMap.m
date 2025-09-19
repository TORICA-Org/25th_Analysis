function drawArrowOnMap(lat, lon, Nvec, Evec)

    scale = 0.0001;

    lat1 = lat; 
    lon1 = lon; 
    lat2 = lat + scale * Nvec; 
    lon2 = lon + scale * Evec;

    geoplot([lat1, lat2], [lon1, lon2], 'y-', 'LineWidth', 1.0);

    % 現在のプロットを保持
    hold on;

    % ===== 矢じりを定義＆計算 =====
    % 1. 幹の向き（方位角）を計算
    main_azimuth = azimuth(lat1, lon1, lat2, lon2);
    
    % 2. 矢じりの見た目を設定
    arrowhead_angle = 30; % 幹に対する矢じりの開き角度（度）
    arrowhead_length_deg = 0.00005; % 矢じりの長さ（緯度・経度の度単位）
                                  % 地図の縮尺によって調整が必要

    % 3. 矢じりの両端の座標を計算
    % 矢の先端から「逆向き」に描くため、幹の方位角に180度を足す
    az1 = main_azimuth + 180 + arrowhead_angle;
    az2 = main_azimuth + 180 - arrowhead_angle;
    
    % reckon(始点緯度, 始点経度, 距離(度), 方位角)
    [lat_h1, lon_h1] = reckon(lat2, lon2, arrowhead_length_deg, az1);
    [lat_h2, lon_h2] = reckon(lat2, lon2, arrowhead_length_deg, az2);

    % 4. 矢じりを描画
    geoplot([lat2, lat_h1], [lon2, lon_h1], 'y-', 'LineWidth', 1.0);
    geoplot([lat2, lat_h2], [lon2, lon_h2], 'y-', 'LineWidth', 1.0);
    
    hold on;

end