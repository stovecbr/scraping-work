# coding: utf-8

# tkinterライブラリの読み込み
import tkinter
import tkinter.font as tkFont

# ウィンドウの作成と、Tkinterオブジェクトの取得
window = tkinter.Tk()



# フォントの設定
default_font = tkinter.font.nametofont("TkDefaultFont")
default_font.configure(size=12, family='Noto Sans CJK JP')

# ウィンドウにタイトルを設定
window.title("Tkinter_test")
# label.pack()

# ウィンドウのループ処理
window.mainloop()
