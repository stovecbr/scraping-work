# pandasを使ってCSVファイルのデータをGoogle Sheetsに送信する
import pandas as pd

from google.oauth2 import service_account
# この関数を使用して、Google Sheets APIを構築します。
from googleapiclient.discovery import build

# 環境変数を読み込む
from dotenv import load_dotenv  
# osモジュールを使用して環境変数を読み込む
import os

# .envファイルを読み込む
load_dotenv()

# Google Sheets APIの設定
# 読み取り専用のアクセスが必要な場合、
# スコープをhttps://www.googleapis.com/auth/spreadsheets.readonlyに変更
SCOPES = ['https://www.googleapis.com/auth/spreadsheets']

SERVICE_ACCOUNT_FILE = 'scraping_credentials.json'

# サービスアカウントの資格情報を使用して認証します。
creds = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)

# 使用するスプレッドシートのIDと範囲を設定
# SPREADSHEET_ID = '1bXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
# 環境変数を取得する
SPREADSHEET_ID = os.getenv('SPREADSHEET_ID')


RANGE_NAME = 'Sheet1!A1'

# データをCSVファイルから読み込む
df = pd.read_csv('./data/coconala_titles.csv')

# データをリストに変換
values = [df.columns.values.tolist()] + df.values.tolist()

# データをGoogle Sheetsに書き込む
service = build('sheets', 'v4', credentials=creds)
# spreadsheetsメソッドを使用して、スプレッドシートにアクセスします。
sheet = service.spreadsheets()

# valuesメソッドを使用して、スプレッドシートにデータを書き込みます。
request = sheet.values().update(spreadsheetId=SPREADSHEET_ID, range=RANGE_NAME,
                                valueInputOption='RAW', body={'values': values})
# executeメソッドを使用して、リクエストを実行します。
response = request.execute()

# メッセージを表示
print("Data successfully sent to Google Sheets")