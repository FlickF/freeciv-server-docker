ARG FREECIV_VERSION=3.0.2
ARG USER=freeciv
ARG UID=1000
ARG GID=1000


FROM frolvlad/alpine-gcc as builder
ARG FREECIV_VERSION

WORKDIR /opt/freeciv


# apk add build-base # GCC, libc-dev, binutils
RUN apk update && apk upgrade && apk add --no-cache \
    make \
    curl-dev \
    icu-dev \
    sqlite-dev \
    pkgconfig \
    automake \
    autoconf \
    libtool \
    gettext \
    python3 \
    gtk+3.0-dev


# --disable-gtktest
# --enable-fcdb=sqlite3
# --enable-ipv6=no
# --disable-dependency-tracking
RUN cd ./freeciv-${FREECIV_VERSION} \
    && ./autogen.sh \
        --enable-shared \
        --enable-aimodules=yes \
        --enable-server=yes \
        --enable-client=no

RUN wget "https://files.freeciv.org/stable/freeciv-${FREECIV_VERSION}.tar.xz" \
    && tar xf freeciv-${FREECIV_VERSION}.tar.xz

RUN cd ./freeciv-${FREECIV_VERSION} \
    && make
    && make install


#FROM alpine:latest
#COPY --from=builder /usr/local/bin/freeciv-* /usr/local/bin/
#WORKDIR /usr/local/bin/

ARG USER
ARG UID
ARG GID

RUN addgroup -g "${GID}" -S "${USER}" \
    && adduser --disabled-password --gecos "freeciv-docker" --uid "${UID}" --ingroup "${USER}" "${USER}"

USER ${USER}

EXPOSE 5556

#VOLUME [ "/freeciv" ]

ENTRYPOINT [ "/bin/sh", "-c" ]
CMD [ "/usr/local/bin/freeciv-server" ]
