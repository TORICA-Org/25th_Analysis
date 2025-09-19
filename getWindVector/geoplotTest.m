% geoplotで矢印ベクトルを表示するテスト


% 緯度と経度のデータを定義
lat = [34.05, 36.16]; % 例: ロサンゼルスとサンフランシスコの緯度
lon = [-118.25, -120.65]; % 例: ロサンゼルスとサンフランシスコの経度

% 地理座標上にベクトルをプロット
figure;
geoplot(lat, lon, 'r-', 'LineWidth', 2); % 赤い線でプロット
hold on;

% 矢印の始点と終点を定義
arrow_start_lat = lat(1); % 矢印の始点の緯度
arrow_start_lon = lon(1); % 矢印の始点の経度
arrow_length = 0.1; % 矢印の長さ
arrow_angle = 30; % 矢印の角度

% 矢印の先端を計算
end_lat = arrow_start_lat + arrow_length * sind(arrow_angle);
end_lon = arrow_start_lon + arrow_length * cosd(arrow_angle);

% 矢印を描画
geoplot([arrow_start_lat, end_lat], [arrow_start_lon, end_lon], 'k-', 'LineWidth', 2); % 矢印の線

% 矢印の先端を示すための点を追加
geoscatter(end_lat, end_lon, 100, 'k', 'filled'); % 矢印の先端

title('Geoplot with Arrow Example');
geobasemap topographic; % トポグラフィックなベースマップを設定
hold off;


% 緯度と経度のデータを定義
lat = [34.05]; % 例: ロサンゼルスの緯度
lon = [-118.25]; % 例: ロサンゼルスの経度

% 地理座標上にマーカーをプロット
figure;
geoscatter(lat, lon, 100, 'b', 'filled'); % 青いマーカーでプロット
hold on;

% 矢印の始点と終点を定義
arrow_length = 0.1; % 矢印の長さ
arrow_angle = 45; % 矢印の角度

% 矢印を追加
annotation('arrow', ...
           [lon, lon + arrow_length * cosd(arrow_angle)], ... % 矢印のX座標
           [lat, lat + arrow_length * sind(arrow_angle)], ... % 矢印のY座標
           'Color', 'k', ... % 矢印の色
           'LineWidth', 2); % 矢印の線の太さ

title('Geoscatter with Rotated Arrow Example');
geobasemap topographic; % トポグラフィックなベースマップを設定
hold off;