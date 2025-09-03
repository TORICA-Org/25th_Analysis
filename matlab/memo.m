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
        geoplot(tempT, "Latitude", "Longitude", "Marker", ".");

    end


else

    disp('プロットはキャンセルされました');

end

close(uiFig);