% 表示形式を設定
format long;

% csvファイルをテーブルとして読み込む
% VariableNamingRuleをpreservenに設定し，元ファイルのヘッダーを変数にする
srcT = readtable("src/2024Flight_anl_input.csv", 'VariableNamingRule', 'preserve');

% データのプロット
PATH = "output/";
TITLE = "Ray";

%{
s = "Altitude";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end

s = "Airspeed";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end

s = "Roll";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end

s = "Pitch";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end

s = "Yaw";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end

s = "Rudder";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end

s = "AoS";
if ismember(s, srcT.Properties.VariableNames)
    f = figure;
    plot(srcT.Time, srcT.(s));
    xlabel('Time');
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end
%}

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

    % 距離を計算
    dis = distance(lat1, lon1, lat2, lon2, wgs84);

    f = figure;
    s = "StraightLineDistance";
    plot(thinned_T.Time, dis);
    xlabel("Time");
    ylabel(s);
    title(TITLE);
    grid on;
    exportgraphics(f, PATH + TITLE + "_" + s + ".png");
end