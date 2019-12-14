#!/bin/bash
# 現在の年 ex) 2019
yyyy=$(date '+%Y')

# 現在の年・月 ex) 201912
yyyymm=$(date '+%Y%m')

# 録画した最新のファイル名をフルリンクで取得する
file=$(ls -1t $(find /home/pi/radio-eikaiwa/) | head -1)


# 年度でフォルダわけしているので、1月、2月、3月の場合は前年のフォルダ名に入れたい。

# 1～3月かどうかのチェック
echo $yyyymm | egrep '0[1-3]$'

# 1月～3月だった場合
if [ $? = 0 ]; then
    # 前年の年を得る
    yyyy=$(date -d '1 year ago' '+%Y')

    # 現在の月を得る
    mm=$(date '+%m月')

    # 現在の月のフォルダを確認する （yyyyは年度なのでyyyyフォルダはあるはず）
    rclone lsd google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy/$mm

    # フォルダが無ければ作成する
    if [ $? = 1 ]; then
        rclone mkdir google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy/$mm
    fi

    # ファイルを転送する
    rclone copy $file google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy/$mm

    # 処理を終了する
    exit 0

# 4月～12月だった場合
else
    # 現在の年 ex) 2019
    yyyy=$(date '+%Y')

    # 現在の月を得る
    mm=$(date '+%m月')

    # 現在の年のディレクトリがあるかどうか確認する。4月はないと思うので作成が必要。
    rclone lsd google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy

    # 年のフォルダが無ければ作成する
    if [ $? = 1 ]; then
        rclone mkdir google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy
    fi

    # 現在の月のフォルダを確認する （yyyyは年度）
    rclone lsd google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy/$mm

    # フォルダが無ければ作成する
    if [ $? = 1 ]; then
        rclone mkdir google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy/$mm
    fi

    # ファイルを転送する
    rclone copy $file google-drive-for-Eikaiwa:01_語学学習/eikaiwa$yyyy/$mm

    # 処理を終了する
    exit 0

fi


