FROM python:3.12.3-slim-bookworm

ENV PYTHONUNBUFFERED=1

ENV TZ Asia/Tokyo

ENV RUNNING_IN_DOCKER=true

# 必要なパッケージをインストール
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
    rm -rf /var/lib/apt/lists/*

# Google Chromeのインストール
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google.gpg && \
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable

# Chromedriverをインストール
RUN wget https://storage.googleapis.com/chrome-for-testing-public/126.0.6478.55/linux64/chromedriver-linux64.zip
RUN unzip chromedriver-linux64.zip
RUN mv chromedriver-linux64/chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver


ARG USERNAME=pyuser
ARG GROUPNAME=pyuser
ARG UID=1000
ARG GID=1000
ARG WORKDIR=/usr/src/app

# ユーザーとグループを作成
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME && \
    mkdir -p $WORKDIR && \
    chown -R $UID:$GID $WORKDIR

WORKDIR $WORKDIR

ENV PYTHONPATH $WORKDIR

ENV PATH /home/$USERNAME/.local/bin:$PATH

USER $USERNAME

# 必要なファイルを先にコピー
COPY --chown=$UID:$GID Pipfile Pipfile.lock requirements.txt ./
# pipを最新版にアップデートし、pipenvを特定のバージョンにインストールします。
RUN pip install -U pip && \
    pip install pipenv==2024.0.0 && \
    pip install -r requirements.txt
    # pipenv install --system　# pipenvを使用してシステム全体にパッケージをインストールする場合は、この行をコメントアウトを解除します。

# 必要なファイルをコピー
COPY --chown=$UID:$GID . .

CMD ["python", "scraper.py"]
