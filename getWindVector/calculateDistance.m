function [n, e, d, dis] = calculateDistance(lat, lon, alt, deltaLat, deltaLon, deltaAlt)

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


    % 南北方向の距離を計算
    n = distance(lat1, lon1, lat2, lon1, wgs84);
    if (lat2 < lat1)
        % 南北方向の距離が負の（南に進む）場合、符号を反転
        n = -n;
    end

    % 東西方向の距離を計算
    e = distance(lat1, lon1, lat1, lon2, wgs84);
    if (lon2 < lon1)
        % 東西方向の距離が負の（西に進む）場合，符号を反転
        e = -e;
    end

    % 高度方向の距離を計算
    d = alt1 - alt2; % 上昇する場合，距離は負
    
    % 3次元距離を計算
    dis = sqrt(n^2 + e^2 + d^2);

end