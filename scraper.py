import sys
import os
import platform
import time
import pandas as pd
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support import expected_conditions
from selenium.webdriver.support.wait import WebDriverWait


# 現在のディレクトリのパスを取得
current_dir = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))

# 環境変数RUNNING_IN_DOCKERが設定されている場合は、Docker環境で実行されていることを示します。
if os.environ.get('RUNNING_IN_DOCKER'):
    chromedriver_path = '/usr/bin/chromedriver'
else:
    chromedriver_path = os.path.join(current_dir, 'chromedriver.exe')

# WebDriverのサービスを設定
# サービスを設定することで、WebDriverを実行するためのバックグラウンドプロセスが作成されます。
webdriver_service = Service(chromedriver_path)

# ディレクトリのパス
dir_path = 'data'

# ディレクトリが存在しない場合は作成する
if not os.path.exists(dir_path):
    os.makedirs(dir_path)

# システムごとのデフォルトのChromeのバイナリのパス
default_chrome_paths = {
    'Linux': '/usr/bin/google-chrome-stable',
    'Windows': 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
}

# 現在のシステムの名前を取得
system_name = platform.system()

# Chromeの設定
chrome_options = Options()
chrome_options.binary_location = os.getenv('CHROME_PATH', default_chrome_paths.get(system_name, '/usr/bin/google-chrome-stable'))
chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--remote-debugging-port=9222") 

# WebDriverの設定
driver = webdriver.Chrome(service=webdriver_service, options=chrome_options)
# ココナラのページにアクセス
driver.get('https://www.coconala.com/categories')

# データ収集の例
titles = []
# 1から10までの範囲でループ
for i in range(1, 11):  
# try-except文を使用して、例外が発生した場合にエラーメッセージを表示します。
    try:
        # find_elementメソッドを使用して、指定された要素を取得します。
        title = driver.find_element(By.XPATH, f'//*[@id="__layout"]/div/div[2]/div[1]/div/ul/li[1]/ul/li[{i}]/a').text
        # appendメソッドを使用して、リストに要素を追加します。
        titles.append(title)
        # exceptブロックを使用して、例外が発生した場合にエラーメッセージを表示します。
    except Exception as e:
        # print関数を使用して、エラーメッセージを表示します。
        print(f"Error: {e}")
        # timeモジュールのsleep関数を使用して、プログラムの実行を一時停止します。
        time.sleep(1)
# driver.quitメソッドを使用して、ブラウザを終了します。
driver.quit()

# データフレームに整形
df = pd.DataFrame(titles, columns=['🐼category title🐼'])

# データをCSVファイルとして保存
df.to_csv('./data/coconala_titles.csv', index=False, encoding='utf-8')