# Python 3.12.3のslimバージョンをベースにしたDockerイメージを使用します。
# FROM python:3.12.3-slim-bookworm

# # Pythonがバッファリングを行わないように環境変数を設定します。
# ENV PYTHONUNBUFFERED=1

# # イメージ内のパッケージリストを更新します。
# RUN apt-get update

# # Dockerビルド時に指定できる引数を定義します。ここではユーザー名、グループ名、ユーザーID、グループID、作業ディレクトリを定義しています。
# ARG USERNAME=pyuser
# ARG GROUPNAME=pyuser
# ARG UID=1000
# ARG GID=1000
# ARG WORKDIR=/usr/src/app

# # タイムゾーンを東京に設定します。
# ENV TZ Asia/Tokyo
# # Pythonのモジュール検索パスに作業ディレクトリを追加します。
# ENV PYTHONPATH $WORKDIR

# # 新しいユーザーグループを作成し、新しいユーザーをそのグループに追加します。
# RUN groupadd -g $GID $GROUPNAME && \
#     useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

# # 作業ディレクトリを作成します。
# RUN mkdir -p $WORKDIR
# # 作業ディレクトリの所有者を新しいユーザーとグループに変更します。
# RUN chown -R $UID:$GID $WORKDIR

# # PATH環境変数に新しいユーザーのローカルbinディレクトリを追加します。
# ENV PATH /home/$USERNAME/.local/bin:$PATH

# # 以降のRUN、CMD、ENTRYPOINT命令が新しいユーザーの権限で実行されるようにします。
# USER $USERNAME

# # 作業ディレクトリを設定します。
# WORKDIR $WORKDIR

# # 元のコード　エラーが出る
# # pipをアップグレードし、pipenvをインストールします。その後、PipfileとPipfile.lockから依存関係をインストールし、pipenv自体をアンインストールします。
# # RUN pip install -U pip && \
# #     pip install pipenv==2024.0.0 && \
# #     pipenv sync --system && \
# #     pip uninstall --yes pipenv

# # 依存関係をインストールするためにPipfileとPipfile.lockをコピーします。
# COPY --chown=$UID:$GID Pipfile Pipfile
# COPY --chown=$UID:$GID Pipfile.lock Pipfile.lock

# # 必要なファイルをコピー
# COPY requirements.txt requirements.txt
# COPY scraper.py scraper.py
# COPY send_to_sheets.py send_to_sheets.py
# COPY scraping_credentials.json scraping_credentials.json



# # PipfileとPipfile.lockから依存関係をインストールします。
# # --systemオプションを指定することで、依存関係をシステム全体にインストールします。
# RUN pip install -U pip && \
# # pipenvをインストールします。
# # 2024.0.0はpipenvのバージョンです。必要に応じて変更してください。
#     pip install pipenv==2024.0.0 && \
# # Pipfileからpipfile.lockを生成します。pipfile.lockが存在する場合は、pipfile.lockを更新します。
#     pipenv install --system

# # ChromeDriverとGoogle Chromeのインストール
# USER root
# RUN apt-get clean && \
#     apt-get update && \
#     apt-get install -y wget unzip gnupg && \
#     wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#     sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.debstable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
#     apt-get update && \
#     apt-get update && \
#     apt-get install -y google-chrome-stable && \
#     wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
#     unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ && \
#     rm /tmp/chromedriver.zip && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

#     # RUN apt-get update && apt-get install -y wget unzip || (echo "Failed to install packages" && exit 1)

# # Pythonパッケージのインストール
# RUN pip install --no-cache-dir -r requirements.txt


# # copilot　で生成されたコード。　動く。
# # PipfileとPipfile.lockから依存関係をインストールします。
# # RUN pip install pipenv && \
# # Pipfileからpipfile.lockを生成します。pipfile.lockが存在する場合は、pipfile.lockを更新します。
# # pipfile.lockが存在しない場合は、pipfileからpipfile.lockを生成します。
#     # pipenv lock && \
# # pipfile.lockから依存関係をインストールします。
# # --systemオプションを指定することで、依存関係をシステム全体にインストールします。
# # Pipfile.lockが存在することを前提としています。
#     # pipenv sync --system

# # デフォルトのコマンドを設定
# CMD ["python", "scraper.py"]



# Python 3.12.3のslimバージョンをベースにしたDockerイメージを使用します。
FROM python:3.12.3-slim-bookworm

# Pythonがバッファリングを行わないように環境変数を設定します。
ENV PYTHONUNBUFFERED=1

# イメージ内のパッケージリストを更新します。
RUN apt-get update

# Dockerビルド時に指定できる引数を定義します。ここではユーザー名、グループ名、ユーザーID、グループID、作業ディレクトリを定義しています。
ARG USERNAME=pyuser
ARG GROUPNAME=pyuser
ARG UID=1000
ARG GID=1000
ARG WORKDIR=/usr/src/app

# タイムゾーンを東京に設定します。
ENV TZ Asia/Tokyo
# Pythonのモジュール検索パスに作業ディレクトリを追加します。
ENV PYTHONPATH $WORKDIR

# 新しいユーザーグループを作成し、新しいユーザーをそのグループに追加します。
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

# 作業ディレクトリを作成します。
RUN mkdir -p $WORKDIR
# 作業ディレクトリの所有者を新しいユーザーとグループに変更します。
RUN chown -R $UID:$GID $WORKDIR

# PATH環境変数に新しいユーザーのローカルbinディレクトリを追加します。
ENV PATH /home/$USERNAME/.local/bin:$PATH

# 以降のRUN、CMD、ENTRYPOINT命令が新しいユーザーの権限で実行されるようにします。
USER $USERNAME

# 作業ディレクトリを設定します。
WORKDIR $WORKDIR

# 必要なファイルを先にコピー
COPY --chown=$UID:$GID Pipfile Pipfile
COPY --chown=$UID:$GID Pipfile.lock Pipfile.lock

# pipenvをインストールし、依存関係をインストール
RUN pip install -U pip && \
    pip install pipenv==2024.0.0 && \
    pipenv install --system

# 必要なファイルをコピー
COPY requirements.txt requirements.txt
COPY scraper.py scraper.py
COPY send_to_sheets.py send_to_sheets.py
COPY scraping_credentials.json scraping_credentials.json

# 必要なパッケージをインストール
USER root
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y wget unzip gnupg curl && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux-signing-key.gpg && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-key.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Pythonパッケージのインストール
RUN pip install --no-cache-dir -r requirements.txt

# デフォルトのコマンドを設定
CMD ["python", "scraper.py"]

