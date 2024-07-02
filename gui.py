"""
このファイルはGUIを作成するためのファイルです。
"""

import tkinter as tk
import shutil
from tkinter import filedialog, messagebox
import os
from subprocess import call, CalledProcessError  # CalledProcessErrorをインポート


# 認証ファイルのパスとスプレッドシートIDの設定
class App:
    """
    GUIを作成するクラス
    """

    def __init__(self, root_window):
        self.root = root_window
        self.root.title("てすとScraper Setup Tool")
        # 認証ファイルのラベルとボタン
        self.auth_label = tk.Label(self.root, text="てすとcredentials file")
        self.auth_label.pack()
        self.auth_button = tk.Button(
            self.root, text="Select", command=self.select_auth_file
        )
        self.auth_button.pack()

        # スプレッドシートIDのラベルとエントリー
        self.sheet_id_label = tk.Label(self.root, text="Spreadsheet ID")
        self.sheet_id_label.pack()
        self.sheet_id_entry = tk.Entry(self.root)
        self.sheet_id_entry.pack()

        # 実行ボタン
        self.auth_file_path = ""
        self.run_button = tk.Button(
            self.root, text="Run Scraper", command=self.run_scraper
        )
        self.run_button.pack()

    def select_auth_file(self):
        """
        認証ファイルを選択するための関数
        """
        # ファイルダイアログを開いてファイルを選択
        self.auth_file_path = filedialog.askopenfilename(
            title="Select Credentials file"
        )
        if self.auth_file_path:
            messagebox.showinfo(
                "Success", f"Credentials file selected:\n{self.auth_file_path}"
            )

    def run_scraper(self):
        """
        スクレイパーを実行する関数
        """
        # スプレッドシートIDを取得
        sheet_id = self.sheet_id_entry.get()
        # 認証ファイルをコピー
        target_path = os.path.join(os.getcwd(), "scraping_credentials.json")
        # 認証ファイルが存在していて、認証ファイルのパスがターゲットパスと異なる場合はコピー
        if os.path.exists(self.auth_file_path) and self.auth_file_path != target_path:
            # 認証ファイルをコピー
            shutil.copy(self.auth_file_path, target_path)
        # スプレッドシートIDが入力されていない場合はエラーメッセージを表示
        if not sheet_id:
            messagebox.showerror("Error", "Please enter a Spreadsheet ID")
            return
        if not self.auth_file_path or not sheet_id:
            messagebox.showerror(
                "Error", "select a Credentials file and enter a Spreadsheet ID"
            )
            return

        # 環境変数に設定
        os.environ["SPREADSHEET_ID"] = sheet_id

        # 認証ファイルを適切な場所にコピー
        if os.path.exists("scraping_credentials.json"):
            os.remove("scraping_credentials.json")
        os.rename(self.auth_file_path, "scraping_credentials.json")

        # スクレイパーとデータ送信スクリプトを実行
        try:
            call(["python3", "scraper.py"])
            call(["python3", "send_to_sheets.py"])
            messagebox.showinfo("success!!", "Data sent to Google Sheets")
        except CalledProcessError as e:
            messagebox.showerror(
                "error!!!!!", f"An error occurred while running the script:\n{e}"
            )


if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.mainloop()
