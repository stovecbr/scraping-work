### 注意：exeファイルはWindows用なのでWSLでは動かない
- 実行方法は２パターン
1. Windows PowerShell 等で実行
   - exeファイルが保存されているディレクトリに移動
   - `cd C:\path\to\your\project`
   - 以下の順で実行
   - `scraper.exe`
   - `send_to_sheets.exe`
1. Windows 上にコピーして実行
   - cp コマンドで dist フォルダごとコピーする
   - `cp -r dist /mnt/c/Windows/path/to/your/directory`
   - 以下の順でダブルクリックで実行
   - `scraper.exe`
   - `send_to_sheets.exe`
