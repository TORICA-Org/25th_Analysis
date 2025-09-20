% 表示形式を設定
format long;

[file, path] = uigetfile('*.csv');

if isequal(file, 0)
    disp('キャンセルされました．');
else
    fullpath = fullfile(path, file);
    % csvファイルをテーブルとして読み込む
    % VariableNamingRuleをpreservenに設定し，元ファイルのヘッダーを変数にする
    srcT = readtable(fullpath, 'VariableNamingRule', 'preserve');
    file = strrep(file, '.csv', '');
    disp(append("path: ", path));
    disp(append("file:" + file));
end

% データのプロット

s = "Altitude";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end

s = "Airspeed";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end

s = "Roll";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end

s = "Pitch";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end

s = "Yaw";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end

s = "Rudder";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end

s = "AoS";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end

if (ismember('Latitude', srcT.Properties.VariableNames) && ismember('Longitude', srcT.Properties.VariableNames))
    Time = srcT.Time;
    Latitude = srcT.Latitude;
    Longitude = srcT.Longitude;
    T = table(Time, Latitude, Longitude);

    % 1. LatitudeとLongitudeの連続する行の差分を計算
    lat_diff = diff(T.Latitude);
    lon_diff = diff(T.Longitude);

    % 2. 差分が0でない行（値が変化した行）を logical 配列で取得
    %    (lat_diff ~= 0) | (lon_diff ~= 0) は、どちらかの値が変化した場合に true になる
    rows_to_keep_after_first = (lat_diff ~= 0) | (lon_diff ~= 0);

    % 3. 最初の行は常に保持するため、先頭に true を追加
    keep_indices = [true; rows_to_keep_after_first];

    % 4. logical インデックスを使ってテーブルを間引く
    thinned_T = T(keep_indices, :);

    %disp(thinned_T);

    % 初期位置を定義
    lat1 = thinned_T{1, "Latitude"};
    lon1 = thinned_T{1, "Longitude"};

    % 移動後の位置を定義
    lat2 = thinned_T.Latitude;
    lon2 = thinned_T.Longitude;

    % WGS84楕円体を定義
    wgs84 = wgs84Ellipsoid('m');

    % 直線距離を計算
    dis = distance(lat1, lon1, lat2, lon2, wgs84);

    f = figure;
    s = "StraightLineDistance";
    plot(thinned_T.Time, dis);
    xlabel("Time");
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
    
    % 緯度経度の配列
    thinned_lat = thinned_T.Latitude;
    thinned_lon = thinned_T.Longitude;

    lat1 = thinned_lat(1:end-1);
    lon1 = thinned_lon(1:end-1);

    lat2 = thinned_lat(2:end);
    lon2 = thinned_lon(2:end);

    % WGS84楕円体を定義
    wgs84 = wgs84Ellipsoid('m');

    % 区間距離を計算
    dis = distance(lat1, lon1, lat2, lon2, wgs84);

    cumulative_dis = [0; cumsum(dis)];

    f = figure;
    s = "CumulativeDistance";
    plot(thinned_T.Time, cumulative_dis);
    xlabel("Time");
    ylabel(s);
    title(file, 'Interpreter', 'none');
    grid on;
    exportgraphics(f, append("output/", file, "_" , s, ".png"));
end