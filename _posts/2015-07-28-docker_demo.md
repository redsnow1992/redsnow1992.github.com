---
title: Docker Demo
date: 2015-07-28 18:05
categories: linux
tags: docker
---
本文所有东西都可以在docker的[官网](http://docs.docker.com/mac/started/)上查到。

# docker commands
| docker commands           | meaning |
| ---                       | ---     |
| `docker run hello-world`  | 起一个新的container来跑名为hello-world的image，若这个image不在本地，则从docker hub上拉取。 |
| `docker images`           | 察看本地的images |
| `docker build -t  docker-whale-fortunes .` | 使用当前目录下的Dockerfile来生成image |
| `docker tag 361616c40b8a redsnow1992/docker-whale-fortunes:latest` | 将一个image加入repo，用于之后的push |
| `docker push redsnow1992/docker-whale-fortunes` | 将image push到个人repo |
| `docker rmi -f docker-whale-fortunes` | 通过名称删除image |
| `docker rmi -f 361616c40b8a` | 通过IMAGE ID删除image |
| `docker pull redsnow1992/docker-whale-fortunes` | 从docker hub拉取image |
| `docker ps` | 列出containers，只列出在运行的 |
| `docker ps -l` | 列出containers，包括没有在运行的 |
| `docker info` | docker详细信息 |

# some output
**`docker images`**
```bash
REPOSITORY                          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
docker-whale-fortunes               latest              361616c40b8a        About a minute ago   273.9 MB
redsnow1992/docker-whale-fortunes   latest              361616c40b8a        About a minute ago   273.9 MB
docker/whalesay                     latest              fb434121fc77        9 weeks ago          247 MB
hello-world                         latest              91c95931e552        3 months ago         910 B
```
**Dockfile docker-whale-fortunes**
```bash
FROM docker/whalesay:latest
RUN apt-get -y update && apt-get install -y fortunes
CMD /usr/games/fortune -a | cowsay
```
**`docker build -t  docker-whale-fortunes .`**
```bash
tep 0 : FROM docker/whalesay:latest
 ---> fb434121fc77
Step 1 : RUN apt-get -y update && apt-get install -y fortunes
 ---> Running in afa741e7959d
Ign http://archive.ubuntu.com trusty InRelease
Ign http://archive.ubuntu.com trusty-updates InRelease
Ign http://archive.ubuntu.com trusty-security InRelease
Hit http://archive.ubuntu.com trusty Release.gpg
....
Setting up fortunes (1:1.99.1-7) ...
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
 ---> a1bc634843ce
Removing intermediate container afa741e7959d
Step 2 : CMD /usr/games/fortune -a | cowsay
 ---> Running in 57abc3a13d4c
 ---> 361616c40b8a
Removing intermediate container 57abc3a13d4c
Successfully built 361616c40b8a
```
**`docker ps -l`**
```bash
CONTAINER ID   IMAGE                               COMMAND                CREATED         STATUS                     PORTS   NAMES
564051841e42   redsnow1992/docker-whale-fortunes   "/bin/sh -c '/usr/ga   8 minutes ago   Exited (0) 8 minutes ago           happy_leakey
```
**Dockerfile rails**
```bash
FROM ruby:2.2

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_VERSION 4.2.3

RUN gem install rails --version "$RAILS_VERSION"
```
