function [x, y, z, d] = calculateDistance(lat, lon, alt, deltaLat, deltaLon, deltaAlt)

    % 初期位置を定義
    lat1 = lat;
    lon1 = lon;
    alt1 = alt;

    % 移動後の位置を定義
    lat2 = lat + deltaLat;
    lon2 = lon + deltaLon;
    alt2 = alt + deltaAlt;

    % WGS84楕円体を定義
    wgs84 = wgs84Ellipsoid('m');

    % 東西方向の距離を計算
    x = distance(lat1, lon1, lat1, lon2, wgs84);
    % 南北方向の距離を計算
    y = distance(lat1, lon1, lat2, lon1, wgs84);
    % 高度方向の距離を計算
    z = alt2 - alt1;
    
    % 3次元距離を計算
    d = sqrt(x^2 + y^2 + z^2);

end