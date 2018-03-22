# Todo: change CMD to ENTRYPOINT so docker run can pass arguments.
# https://docs.docker.com/engine/reference/builder/#entrypoint
FROM base/archlinux:latest

ARG STEAMCMD_DL_URL='https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz'
ARG STEAM_USER=steam
ARG STEAM_DIR=/home/${STEAM_USER}/Steam

RUN pacman -Syy --noconfirm --noprogressbar --quiet \
    && pacman -S archlinux-keyring --noconfirm --noprogressbar --quiet \
    && pacman -S lib32-gcc-libs --noconfirm --noprogressbar --quiet \
    && useradd -m ${STEAM_USER}

USER ${STEAM_USER}

RUN mkdir -p ${STEAM_DIR} \
    && cd ${STEAM_DIR} \
    && curl -sqL ${STEAMCMD_DL_URL} | tar -zxf - \
    && ./steamcmd.sh +quit # SteamCMD will self-update.

WORKDIR ${STEAM_DIR}

CMD ./steamcmd.sh
