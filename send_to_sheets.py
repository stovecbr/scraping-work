# pandasを使ってCSVファイルのデータをGoogle Sheetsに送信する
# pandasライブラリをpdという名前でインポートします。
# これにより、データ分析や操作のための強力なデータ構造が利用可能になります。
import pandas as pd
# google.oauth2ライブラリからservice_accountモジュールをインポートします。
# これにより、Google Cloudのサービスアカウントを使用して認証するための関数が利用可能になります。
from google.oauth2 import service_account
# googleapiclient.discoveryライブラリからbuildモジュールをインポートします。
# これにより、Google APIを使用するための関数が利用可能になります。
# この関数を使用して、Google Sheets APIを構築します。
from googleapiclient.discovery import build

# Google Sheets APIの設定
# SCOPES変数にGoogle Sheets APIのスコープを設定します。
# これにより、スプレッドシートにアクセスするための権限が付与されます。
# Google Sheetsに対する全ての読み書き操作を許可します。
# 読み取り専用のアクセスが必要な場合、
# スコープをhttps://www.googleapis.com/auth/spreadsheets.readonlyに変更
SCOPES = ['https://www.googleapis.com/auth/spreadsheets']
# SERVICE_ACCOUNT_FILE変数にサービスアカウントの資格情報ファイルのパスを設定します。
# これにより、サービスアカウントを使用してGoogle Cloudに認証されます。
SERVICE_ACCOUNT_FILE = 'scraping_credentials.json'

# サービスアカウントの資格情報を使用して認証します。
# これにより、Google Cloudに認証されたクライアントが作成されます。
# このクライアントを使用して、Google Sheets APIにアクセスします。
creds = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)

# 使用するスプレッドシートのIDと範囲を設定
# SPREADSHEET_ID変数にスプレッドシートのIDを設定します。
# これにより、データが書き込まれるスプレッドシートが指定されます。
SPREADSHEET_ID = 'https://docs.google.com/spreadsheets/d/1bX63acuqzf3yQ-oF6QTEyybcg52wjh5gC78wvIWDdq0/edit?usp=sharing'
# RANGE_NAME変数にスプレッドシートの範囲を設定します。
# これにより、データが書き込まれるセルの範囲が指定されます。
RANGE_NAME = 'Sheet1!A1'

# データをCSVファイルから読み込む
# read_csv関数を使用して、CSVファイルからデータを読み込みます。
# これにより、データがDataFrameオブジェクトとして読み込まれます。
df = pd.read_csv('./data/coconala_titles.csv')

# データをリストに変換
# データフレームの列名と値をリストに変換します。
# これにより、データがGoogle Sheetsに書き込まれる形式に変換されます。
# 列名を含む最初のリストを作成し、その後のリストに値を追加します。
# これにより、データがGoogle Sheetsに書き込まれる形式に変換されます。
values = [df.columns.values.tolist()] + df.values.tolist()

# データをGoogle Sheetsに書き込む
# build関数を使用して、Google Sheets APIのサービスを作成します。
# これにより、Google Sheets APIにアクセスするためのサービスが作成されます。
service = build('sheets', 'v4', credentials=creds)
# spreadsheetsメソッドを使用して、スプレッドシートにアクセスします。
# これにより、スプレッドシートのデータを読み書きするためのオブジェクトが作成されます。
sheet = service.spreadsheets()

# valuesメソッドを使用して、スプレッドシートにデータを書き込みます。
# updateメソッドを使用して、スプレッドシートにデータを書き込みます。
# これにより、データがGoogle Sheetsに書き込まれます。
# spreadsheetIdパラメータにスプレッドシートのIDを指定します。
# rangeパラメータにスプレッドシートの範囲を指定します。
# valueInputOptionパラメータにRAWを指定して、データがそのまま書き込まれるようにします。
# bodyパラメータにデータを指定します。
# これにより、データがGoogle Sheetsに書き込まれます。
request = sheet.values().update(spreadsheetId=SPREADSHEET_ID, range=RANGE_NAME,
                                valueInputOption='RAW', body={'values': values})
# executeメソッドを使用して、リクエストを実行します。
# これにより、データがGoogle Sheetsに書き込まれます。
# リクエストが成功した場合、レスポンスが返されます。
# これにより、データがGoogle Sheetsに書き込まれたことが確認されます。
response = request.execute()

# メッセージを表示
# print関数を使用して、メッセージを表示します。
print("Data successfully sent to Google Sheets")