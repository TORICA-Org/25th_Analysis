% 表示形式を設定
format long;

% csvファイルをテーブルとして読み込む
% VariableNamingRuleをpreservenに設定し，元ファイルのヘッダーを変数にする
srcT = readtable("src/2025LOG_input.csv", 'VariableNamingRule', 'preserve');

% データのプロット
PATH = "output/";
TITLE = "Tatsumi";

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
