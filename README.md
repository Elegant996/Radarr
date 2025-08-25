# Radarr
Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available. Note that only one type of a given movie is supported. If you want both an 4k version and 1080p version of a given movie you will need multiple instances.

Docker
-----------------------------------------------
This repo will periodically check Radarr for updates and build a container image from scratch using an Alpine base layout:

For `master` branch releases use:
```
docker pull ghcr.io/elegant996/radarr:5.26.2.10099
docker pull ghcr.io/elegant996/radarr:master
```

For `develop` branch pre-releases use:
```
docker pull ghcr.io/elegant996/radarr:5.27.5.10184
docker pull ghcr.io/elegant996/radarr:develop
```