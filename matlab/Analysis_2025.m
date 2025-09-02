% 表示形式を設定
format long;

% csvファイルをテーブルとして読み込む
srcT = readtable("src/2025FlightLog.csv");

% 行数を取得
numRows = height(srcT);

% 対地速度計算用テーブルを初期化
sz = [100 5];
verTypes = ["double", "double", "double", "double", "double"];
varNames = ["Time", "Latitude", "Longitude", "X", "Y"];
tempT = table('Size', sz, 'VariableTypes', verTypes, 'VariableNames', varNames);

loopCount = 0;
lastTime = 0;
lastLatitude = 0;
lastLongitude = 0;

for i = 1:numRows

    % 時間を取得
    currentTime = srcT{i, 1};

    % GPSのデータを取得
    latitude = srcT{i, 45};
    longitude = srcT{i, 46};

    % 初回，または1秒以上の間隔がある，または前回と異なる場合
    if (i == 1 || currentTime - lastTime >= 1.0 || latitude ~= lastLatitude || longitude ~= lastLongitude)

        % ループした回数を加算
        loopCount = loopCount + 1;

        % 新しい行を生成
        tempRow = table(currentTime, latitude, longitude);

        % 新しい行をtempTに追加
        tempT(loopCount, 1:3) = tempRow;

        % 次回比較で使用
        lastTime = currentTime;
        lastLatitude = latitude;
        lastLongitude = longitude;

    end

end

% 行数を取得
numRows = height(tempT);

% 余分な行を削除
tempT(loopCount:numRows, :) = [];

% 新しいUI figureを作成
uiFig = uifigure;

% 確認ダイアログを表示
selection = uiconfirm(uiFig, ...
    'CSV出力を行いますか？', ... % メッセージ
    '確認', ...               % タイトル
    'Options', {'はい', 'いいえ'}, ... % 選択肢
    'DefaultOption', 'はい', ... % デフォルト選択肢
    'CancelOption', 'いいえ'); % キャンセル選択肢

% ユーザーの選択に応じた処理
if strcmp(selection, 'はい')

    disp('出力を実行します。');

    % テーブルをCSVに書き出す
    writetable(tempT, "output/FilteredFlightLog.csv");

else

    disp('出力はキャンセルされました。');

end

% 確認ダイアログを表示
selection = uiconfirm(uiFig, ...
    '地図へのプロットを行いますか？', ... % メッセージ
    '確認', ...               % タイトル
    'Options', {'はい', 'いいえ'}, ... % 選択肢
    'DefaultOption', 'はい', ... % デフォルト選択肢
    'CancelOption', 'いいえ'); % キャンセル選択肢

% ユーザーの選択に応じた処理
if strcmp(selection, 'はい')

    disp('プロットを実行します');

    % 地図の表示を設定
    figure;
    title('GPS Data Plot');
    xlabel('Longitude');
    ylabel('Latitude');
    grid on;

    % 行数を取得
    numRows = height(tempT);

    for i = 1:numRows

        % 地図にプロット
        geoplot(tempT, "Latitude", "Longitude", "Marker",".");

    end


else

    disp('プロットはキャンセルされました');

end

close(uiFig);

initialLatitude = tempT{1,"Latitude"};
initialLongitude = tempT{1, "Longitude"};


% 行数を取得
numRows = height(tempT);

for i = 1:numRows

    [x,y] = latlonToMeters(tempT{i, "Latitude"}, tempT{i, "Longitude"});
    tempT{i, "X"} = x;
    tempT{i, "Y"} = y;
    
end

disp(tempT);


function [x, y] = latlonToMeters(lat, lon)
       % 地球の半径 (メートル)
       R = 6371000; % 地球の平均半径

       % 緯度と経度をラジアンに変換
       lat_rad = deg2rad(lat);
       lon_rad = deg2rad(lon);

       % メートルに変換
       x = R * lon_rad * cos(lat_rad); % x座標
       y = R * lat_rad; % y座標
   end