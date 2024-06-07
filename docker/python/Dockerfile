FROM python:3.12.3-slim-bookworm

ENV PYTHONUNBUFFERED=1

RUN apt-get update

ARG USERNAME=pyuser
ARG GROUPNAME=pyuser
ARG UID=1000
ARG GID=1000
ARG WORKDIR=/usr/src/app

ENV TZ Asia/Tokyo
ENV PYTHONPATH $WORKDIR

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

RUN mkdir -p $WORKDIR
RUN chown -R $UID:$GID $WORKDIR

ENV PATH /home/$USERNAME/.local/bin:$PATH

USER $USERNAME

WORKDIR $WORKDIR

RUN pip install -U pip && \
    pip install pipenv==2024.0.0 && \
    pipenv sync --system && \
    pip uninstall --yes pipenv