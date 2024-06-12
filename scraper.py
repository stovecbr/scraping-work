# timeモジュールをインポートします。
# これにより、スクリプトの実行を一時停止するための関数などが利用可能になります。
import time
# pandasライブラリをpdという名前でインポートします。
# これにより、データ分析や操作のための強力なデータ構造が利用可能になります。
import pandas as pd
# seleniumライブラリからwebdriverモジュールをインポートします。
# これにより、プログラムからブラウザを操作するためのAPIが利用可能になります。
from selenium import webdriver
# seleniumのwebdriverモジュールからServiceクラスをインポートします。
# これにより、Chromeドライバのサービスを管理するためのクラスが利用可能になります。
from selenium.webdriver.chrome.service import Service
# seleniumのwebdriverモジュールからByクラスをインポートします。
# これにより、要素を特定するための方法を定義するためのクラスが利用可能になります。
from selenium.webdriver.common.by import By
# seleniumのwebdriverモジュールからOptionsクラスをインポートします。
# これにより、Chromeブラウザのオプションを管理するためのクラスが利用可能になります。
from selenium.webdriver.chrome.options import Options

# Chromeの設定
# Optionsクラスのインスタンスを作成します。
# これにより、Chromeブラウザのオプションを設定することができます。
chrome_options = Options()
# ヘッドレスモードを有効にします。
# これにより、GUIなしでブラウザを実行することができます。
chrome_options.add_argument("--headless")
# サンドボックスモードを無効にします。
# これは、通常はセキュリティ上の理由から使用されますが、一部の環境では問題を引き起こすことがあります。
chrome_options.add_argument("--no-sandbox")
# デバッグ用のシャーレを無効にします。
# これにより、一部の環境で問題を引き起こすことがあるメモリの使用量を削減できます。
chrome_options.add_argument("--disable-dev-shm-usage")

# WebDriverの設定
# Serviceクラスのインスタンスを作成します。
# これにより、Chromeドライバのサービスを管理するためのオブジェクトが作成されます。
service = Service('/usr/local/bin/chromedriver')
# WebDriverのインスタンスを作成します。
# 
driver = webdriver.Chrome(service=service, options=chrome_options)

# ココナラのページにアクセス
# getメソッドを使用して、指定されたURLにアクセスします。
driver.get('https://www.coconala.com/categories')

# データ収集の例
# タイトルを収集するための空のリストを作成します。
titles = []
# 1から10までの範囲でループします。
for i in range(1, 11):  # 上から10個のアイテムを収集
# try-except文を使用して、例外が発生した場合にエラーメッセージを表示します。
# これにより、プログラムがクラッシュすることなく続行できます。
# tryブロックを使用して、例外が発生する可能性のあるコードを囲みます。
    try:
        # find_elementメソッドを使用して、指定された要素を取得します。
        # これにより、指定されたXPathパターンに一致する要素が取得されます。
        title = driver.find_element(By.XPATH, f'//*[@id="some_xpath_pattern_{i}"]').text
        # appendメソッドを使用して、リストに要素を追加します。
        # これにより、収集されたタイトルがリストに追加されます。
        titles.append(title)
        # exceptブロックを使用して、例外が発生した場合にエラーメッセージを表示します。
        # これにより、プログラムがクラッシュすることなく続行できます。
    except Exception as e:
        # print関数を使用して、エラーメッセージを表示します。
        print(f"Error: {e}")
        # timeモジュールのsleep関数を使用して、プログラムの実行を一時停止します。
        # これにより、サーバーへの負荷を軽減することができます。
        # 1秒間の一時停止を追加します。

    time.sleep(1)
# driver.quitメソッドを使用して、ブラウザを終了します。
driver.quit()

# データフレームに整形
# DataFrameクラスのインスタンスを作成します。
# これにより、データを表形式で表示することができます。
# タイトルを列名として持つデータフレームを作成します。
# 
df = pd.DataFrame(titles, columns=['Title'])

# データをCSVファイルとして保存
# to_csvメソッドを使用して、データフレームをCSVファイルとして保存します。
# これにより、データをファイルに保存することができます。
# ファイル名を指定して、データを保存します。
# index=Falseを指定して、行番号を保存しないようにします。
df.to_csv('./data/coconala_titles.csv', index=False)