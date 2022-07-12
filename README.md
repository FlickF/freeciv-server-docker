# Freeciv server - Docker Alpine edition

Freeciv is a Free and Open Source empire-building strategy game inspired by the history of human civilization.

This project embeds the Freeciv server in an blazingly fast and small Alpine Docker container with a total size of ~32MB OS & dependencies excluding game files, total size less than 200MB.

## How to run

Clone the repository
```
git clone https://github.com/FlickF/freeciv-server-docker.git
```

Build the Docker container
```
docker compose build
```

Run the Docker container
```
docker compose up -d
```

Connect to your own server! :)

## Roadmap

- Provide the Docker image on Dockerhub
- Add arguments to start the server loading a savegame
- Add entrypoint.sh to set user permissions dynamically
- Add authorization to host password protected games (https://github.com/freeciv/freeciv/blob/master/doc/README.fcdb)

## Links

Freeciv website: [Freeciv.org](https://www.freeciv.org/)

Community forum: [forum.freeciv.org](https://forum.freeciv.org/)

Freeciv Github: [github.com/freeciv/freeciv](https://github.com/freeciv/freeciv/)
