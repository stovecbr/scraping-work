# Python 3.12.3のslimバージョンをベースにしたDockerイメージを使用します。
FROM python:3.12.3-slim-bookworm

# Pythonがバッファリングを行わないように環境変数を設定します。
ENV PYTHONUNBUFFERED=1

# タイムゾーンを東京に設定します。
ENV TZ Asia/Tokyo

# イメージ内のパッケージリストを更新し、必要なツールをインストールします。
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg \
    curl \
    ca-certificates \
    fonts-liberation \
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
    xdg-utils \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Google Chrome をインストール
# RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux-signing-key.gpg && \
#     sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-key.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
#     apt-get update && apt-get install -y google-chrome-stable

# Google Chromeのインストール
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable


# RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install


# Chromedriverをインストール
RUN wget https://storage.googleapis.com/chrome-for-testing-public/126.0.6478.55/linux64/chromedriver-linux64.zip
RUN unzip chromedriver-linux64.zip
RUN mv chromedriver-linux64/chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver
    



# # ChromeDriver をインストール
# RUN CHROME_DRIVER_VERSION="126.0.6478.55"  && \
#     wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" && \
#     unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
#     rm /tmp/chromedriver.zip && \
#     chmod +x /usr/local/bin/chromedriver

# ユーザーとグループを作成し、作業ディレクトリを作成します。
ARG USERNAME=pyuser
ARG GROUPNAME=pyuser
ARG UID=1000
ARG GID=1000
ARG WORKDIR=/usr/src/app

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME && \
    mkdir -p $WORKDIR && \
    chown -R $UID:$GID $WORKDIR

# 作業ディレクトリを設定します。
WORKDIR $WORKDIR
ENV PYTHONPATH $WORKDIR
ENV PATH /home/$USERNAME/.local/bin:$PATH

# 以降のRUN、CMD、ENTRYPOINT命令が新しいユーザーの権限で実行されるようにします。
USER $USERNAME

# 必要なファイルを先にコピー
COPY --chown=$UID:$GID Pipfile Pipfile.lock requirements.txt ./
RUN pip install -U pip && \
    pip install pipenv==2024.0.0 && \
    pip install -r requirements.txt
    # pipenv install --system

# 必要なファイルをコピー
COPY --chown=$UID:$GID . .

# デフォルトのコマンドを設定
CMD ["python", "scraper.py"]
