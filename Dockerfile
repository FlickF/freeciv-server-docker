ARG FREECIV_VERSION=3.0.2
ARG USER=freeciv
ARG UID=1000
ARG GID=1000


FROM frolvlad/alpine-gcc as builder
ARG FREECIV_VERSION

WORKDIR /opt/freeciv


# apk add build-base # GCC, libc-dev, binutils
RUN apk update && apk upgrade && apk add --no-cache \
    curl-dev \
    icu-dev \
    sqlite-dev \
    pkgconfig \
    make \
    automake \
    autoconf \
    libtool \
    gettext \
    python3 \
    gtk+3.0-dev

# build Freeciv server binaries
RUN wget "https://files.freeciv.org/stable/freeciv-${FREECIV_VERSION}.tar.xz" \
    && tar xf freeciv-${FREECIV_VERSION}.tar.xz

RUN cd ./freeciv-${FREECIV_VERSION} \
    && ./autogen.sh \
        --enable-shared \
        --enable-aimodules=yes \
        --enable-server=yes \
        --enable-client=no
# --enable-fcdb=sqlite3

RUN cd ./freeciv-${FREECIV_VERSION} \
    && make \
    && make install


FROM alpine:latest

ARG FREECIV_VERSION
ARG USER
ARG UID
ARG GID

COPY --from=builder /usr/local/bin/freeciv-* /usr/local/bin/
COPY --from=builder /usr/local/lib/libfreeciv* /usr/local/lib/
COPY --from=builder /usr/local/share/freeciv/ /usr/local/share/freeciv/
COPY --from=builder /usr/local/etc/freeciv/ /usr/local/etc/freeciv/
COPY --from=builder --chown=${USER}:${USER} /opt/freeciv/freeciv-${FREECIV_VERSION}/data/ /home/${USER}/.freeciv/

RUN apk update && apk upgrade && apk add --no-cache \
    curl \
    gettext \
    libbz2 \
    libtool \
    icu-libs

RUN addgroup -g "${GID}" -S "${USER}" \
    && adduser --disabled-password --gecos "freeciv-docker" --uid "${UID}" --ingroup "${USER}" "${USER}"

RUN mkdir -p /home/${USER}/game \
    && chown ${USER}:${USER} /home/${USER}/game

WORKDIR /home/${USER}/game

USER ${USER}

EXPOSE 5556

VOLUME [ "/home/${USER}/game" ]

ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "/usr/local/bin/freeciv-server" ]
