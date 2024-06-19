# Python 3.12.3のslimバージョンをベースにしたDockerイメージを使用します。
FROM python:3.12.3-slim-bookworm

# Pythonがバッファリングを行わないように環境変数を設定します。
ENV PYTHONUNBUFFERED=1

# タイムゾーンを東京に設定します。
ENV TZ Asia/Tokyo

# docker-compose.ymlファイルで環境変数RUNNING_IN_DOCKERを設定します。
# この環境変数は、Dockerコンテナ内で実行されていることを示します。
ENV RUNNING_IN_DOCKER=true

# イメージ内のパッケージリストを更新し、必要なツールをインストールします。
RUN apt-get update && apt-get install -y \
# フリーのユーティリティで、HTTP、HTTPS、FTPプロトコルを使用してネットワークからデータをダウンロードします。
    wget \  
    # ZIP圧縮ファイルを展開するためのユーティリティです。
    unzip \
    # GnuPGは、データの暗号化、デジタル署名の作成、検証、および鍵の管理を行うためのツールです。
    gnupg \
    # GNU Privacy Guard（GnuPGまたはGPGとも呼ばれる）は、データ暗号化とデジタル署名のためのツールです。
    curl \
    # 一般的なCA（認証局）からのSSL/TLS証明書の集まりです。
    ca-certificates \
    #  Liberationフォントは、Microsoftの一部のフォントとメトリック互換性を持つフリーフォントです。
    fonts-liberation \
    # これらは各種のシステムライブラリで、アプリケーションが正常に動作するために必要な機能を提供します
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    # XDG Utilsは、デスクトップ環境間での互換性を提供する一連のコマンドラインユーティリティです。
    xdg-utils \
    # このオプションは、パッケージの推奨される依存関係をインストールしないように指示します。
    # これにより、イメージのサイズを小さく保つことができます。
    --no-install-recommends && \
    # このコマンドは、不要なパッケージファイルを削除し、イメージのサイズをさらに小さくします。
    apt-get clean && \
    # このコマンドは、不要なパッケージファイルを削除し、イメージのサイズをさらに小さくします。
    rm -rf /var/lib/apt/lists/*

# Google Chromeのインストール
# この行は、Googleの公開鍵をダウンロードし、APTの鍵リングに追加します。
# これにより、Googleのパッケージが信頼できることが確認されます。
# RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
# apt-key add が非推奨になったため、以下のように変更します。
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google.gpg && \
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
# この行は、Googleの公開鍵をダウンロードし、APTの鍵リングに追加します。
# これにより、Googleのパッケージが信頼できることが確認されます。
    # && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
    # この行は、Google Chromeをインストールします。
    # この行は、apt-get updateコマンドを実行し、パッケージリストを更新します。
    apt-get update && \
    # この行は、Google Chromeをインストールします。
    # -yオプションは、インストール中にすべての質問に自動的に「はい」と回答します。
    apt-get install -y google-chrome-stable

# Chromedriverをインストール
# この行は、Googleのストレージから特定のバージョンのChromeDriverのzipファイルをダウンロードします。
RUN wget https://storage.googleapis.com/chrome-for-testing-public/126.0.6478.55/linux64/chromedriver-linux64.zip
# この行は、ダウンロードしたzipファイルを解凍し、chromedriverバイナリを/usr/binディレクトリに移動します。
RUN unzip chromedriver-linux64.zip
# この行は、解凍したChromeDriverを/usr/bin/chromedriverに移動します。
# これにより、任意の場所からchromedriverコマンドを実行できるようになります。
RUN mv chromedriver-linux64/chromedriver /usr/bin/chromedriver
# この行は、chromedriverバイナリの所有者をrootに変更し、実行権限を付与します。
# この行は、/usr/bin/chromedriverの所有者をrootユーザーとrootグループに変更します。
RUN chown root:root /usr/bin/chromedriver
# この行は、/usr/bin/chromedriverの実行権限を付与します。
# これにより、chromedriverバイナリが実行可能になります。
RUN chmod +x /usr/bin/chromedriver

# ユーザーとグループを作成し、作業ディレクトリを作成します。
# この行は、ビルド時の引数USERNAMEを定義し、デフォルト値としてpyuserを設定しています。
ARG USERNAME=pyuser
# この行は、ビルド時の引数GROUPNAMEを定義し、デフォルト値としてpyuserを設定しています。
ARG GROUPNAME=pyuser
# この行は、ビルド時の引数UIDを定義し、デフォルト値として1000を設定しています。
# これは、ユーザーのUID（ユーザーID）を設定します。
ARG UID=1000
# この行は、ビルド時の引数GIDを定義し、デフォルト値として1000を設定しています。
# これは、グループのGID（グループID）を設定します。
ARG GID=1000
# この行は、ビルド時の引数WORKDIRを定義し、デフォルト値として/usr/src/appを設定しています。
# これは、作業ディレクトリを設定します。
ARG WORKDIR=/usr/src/app

# この行は、ユーザーとグループを作成し、作業ディレクトリを作成します。
# この行は、新しいグループを作成します。-gオプションは、新しいグループのグループIDを指定します。
# $GIDと$GROUPNAMEは、ビルド時の引数で、それぞれ新しいグループのグループIDとグループ名を指定します。
RUN groupadd -g $GID $GROUPNAME && \
    # この行は、新しいユーザーを作成します。
    # -mオプションは、ユーザーのホームディレクトリを作成します。
    # -sオプションは、ユーザーのログインシェルを指定します。
    # -uオプションは、ユーザーのユーザーIDを指定します。
    # -gオプションは、ユーザーのプライマリグループを指定します。
    # $UID、$USERNAME、$GIDは、ビルド時の引数で、それぞれ新しいユーザーのユーザーID、ユーザー名、プライマリグループを指定します。
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME && \
    # この行は、作業ディレクトリを作成します。
    # -pオプションは、親ディレクトリを作成します。
    # $WORKDIRは、ビルド時の引数で、作業ディレクトリを指定します。
    mkdir -p $WORKDIR && \
    # この行は、新しいユーザーに作業ディレクトリの所有権を付与します。
    # -Rオプションは、ディレクトリとその中のファイルの所有権を再帰的に変更します。
    # $UID、$GID、$WORKDIRは、ビルド時の引数で、それぞれ新しいユーザーのユーザーID、グループID、作業ディレクトリを指定します。
    chown -R $UID:$GID $WORKDIR

# 作業ディレクトリを設定します。
# この行は、作業ディレクトリを設定します。
# $WORKDIRは、ビルド時の引数で、作業ディレクトリを指定します。
WORKDIR $WORKDIR
# この行は、新しいユーザーのホームディレクトリを設定します。
# $USERNAMEは、ビルド時の引数で、新しいユーザーのユーザー名を指定します。
ENV PYTHONPATH $WORKDIR
# この行は、新しいユーザーのホームディレクトリを設定します。
# $USERNAMEは、ビルド時の引数で、新しいユーザーのユーザー名を指定します。
# この行は、新しいユーザーのホームディレクトリを設定します。
# $USERNAMEは、ビルド時の引数で、新しいユーザーのユーザー名を指定します。
# :$PATHは、既存のPATHを保持します。
ENV PATH /home/$USERNAME/.local/bin:$PATH

# 以降のRUN、CMD、ENTRYPOINT命令が新しいユーザーの権限で実行されるようにします。
USER $USERNAME

# 必要なファイルを先にコピー
# Pipfile、Pipfile.lock、requirements.txtをコンテナの作業ディレクトリにコピーします。
# 所有者は先に作成したユーザーとグループに設定します。
COPY --chown=$UID:$GID Pipfile Pipfile.lock requirements.txt ./
# pipを最新版にアップデートし、pipenvを特定のバージョンにインストールします。
RUN pip install -U pip && \
    pip install pipenv==2024.0.0 && \
    # その後、requirements.txtに記載されたPythonパッケージをインストールします。
    pip install -r requirements.txt
    # pipenv install --system　# pipenvを使用してシステム全体にパッケージをインストールする場合は、この行をコメントアウトを解除します。

# 必要なファイルをコピー
# 作業ディレクトリ内のすべてのファイルとディレクトリをコンテナの作業ディレクトリにコピーします。
# 所有者は先に作成したユーザーとグループに設定します。
COPY --chown=$UID:$GID . .

# デフォルトのコマンドを設定
# コンテナが起動したときに実行されるデフォルトのコマンドを設定します。
# ここでは、Pythonのスクリプト"scraper.py"を実行します。
CMD ["python", "scraper.py"]
