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

# 元のコード　エラーが出る
# pipをアップグレードし、pipenvをインストールします。その後、PipfileとPipfile.lockから依存関係をインストールし、pipenv自体をアンインストールします。
# RUN pip install -U pip && \
#     pip install pipenv==2024.0.0 && \
#     pipenv sync --system && \
#     pip uninstall --yes pipenv

# 酒家さん修正後のコード　
# 依存関係をインストールするためにPipfileとPipfile.lockをコピーします。
COPY --chown=$UID:$GID ./python/Pipfile ./python/Pipfile.lock ./

# PipfileとPipfile.lockから依存関係をインストールします。
# --systemオプションを指定することで、依存関係をシステム全体にインストールします。
RUN pip install -U pip && \
# pipenvをインストールします。
# 2024.0.0はpipenvのバージョンです。必要に応じて変更してください。
    pip install pipenv==2024.0.0 && \
# Pipfileからpipfile.lockを生成します。pipfile.lockが存在する場合は、pipfile.lockを更新します。
    pipenv install --system


# copilot　で生成されたコード。　動く。
# PipfileとPipfile.lockから依存関係をインストールします。
# RUN pip install pipenv && \
# Pipfileからpipfile.lockを生成します。pipfile.lockが存在する場合は、pipfile.lockを更新します。
# pipfile.lockが存在しない場合は、pipfileからpipfile.lockを生成します。
    # pipenv lock && \
# pipfile.lockから依存関係をインストールします。
# --systemオプションを指定することで、依存関係をシステム全体にインストールします。
# Pipfile.lockが存在することを前提としています。
    # pipenv sync --system

