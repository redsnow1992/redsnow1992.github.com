---
title: Dockerfile reference
date: 2015-07-29 09:10
categories: linux
tags: docker
---
本文所有东西都可以在docker的[官网](http://docs.docker.com/reference/builder/)上查到。

# 环境替换
相关指令：
+ `ENV`
+ `ADD`
+ `COPY`
+ `WORKDIR`
+ `EXPOSE`
+ `VOLUME`
+ `USER`

example:
```bash
FROM busybox
ENV foo /bar
WORKDIR ${foo}   # WORKDIR /bar
ADD . $foo       # ADD . /bar
COPY \$foo /quux # COPY $foo /quux
```
pitfall:
```bash
ENV abc=hello
ENV abc=bye def=$abc
ENV ghi=$abc
```
在整个一条命令中，环境变量替换时将对每个变量使用相同的值，所以`def`的值为`hello`，而`ghi`为`bye`。

# `FROM`
```bash
FROM <image>
FROM <image>:<tag>
FROM <iamge>@<digest>
```
**Dockerfile的第一个指令必须是`FROM`来指定基础image。**

# `MAINTAINER`
```bash
MAINTAINER <name>
```
# `RUN`([详细](https://docs.docker.com/reference/run/))
1. `RUN <command>`(run in a shell `/bin/sh -c` *shell form*)
2. `RUN ["executable", "param1", "param2"]`(*exec form*)

**Note:**
+ 如果想使用一个不同的shell可以用第二种形式`RUN ["/bin/bash", "-c" "echo hello"] `
+ 第二种形式将会解析成json数组，所以要用`"`而不是`'`
+ 第二种形式不会引发一个shell命令，所以要用shell命令，可以直接用第一种形式。

# `CMD`
1. `CMD ["executable", "param1", "param2"]`(*exec form*)
2. `CMD ["param1", "param2"]`(*as default parameters to ENTRYPOINT*)
3. `CMD command param1 param2`(*shell form*)
```bash
FROM ubuntu
CMD echo "This is a test" | wc -
```
**Note:**

+ 在一个Dockfile种只能有一个`CMD`命令，如果有多个将执行最后一个。
+ `CMD`最主要的作用是给一个可执行的container一个默认项。
+ `RUN`是真正执行一个命令，并且提交这个结果，而`CMD`在build time并不执行任何命令，只是指定对于该image所希望的命令。
我认为`RUN`指定build time，`CMD`指定run time。

# `LABEL`
```bash
LABEL <key>=<value> <key>=<value> <key>=<value>
```
多行形式：

>    LABEL com.example.label-with-value="foo"
    LABEL version="1.0"
    LABEL description="This text illustrates \
    that label-values can span multiple lines."

单行形式：

>    LABEL multi.label1="value1" multi.label2="value2" other="value3"

通过`docker inspect <image>`可以察看一个image的label：
```bash
"Labels": {
    "com.example.vendor": "ACME Incorporated"
    "com.example.label-with-value": "foo",
    "version": "1.0",
    "description": "This text illustrates that label-values can span multiple lines.",
    "multi.label1": "value1",
    "multi.label2": "value2",
    "other": "value3"
},
```
# `ENV`
当一个container跑一个image时，使用`ENV`设置的环境变量是一直有效的。  
`docker run --env <key>=<value> `可以在运行时修改这些参数。

# `ADD`
1. `ADD <src> ... <dest>`
2. `ADD ["<src>",... "<dest>"]`

+ 该指令用于从`<src>`拷贝新文件、目录或远端文件url到container文件系统下的`<dest>`路径。
+ `<src>`指定的文件或目录使用的是相对于build时的目录
+ `<src>`使用GO的`filepath.Match`来匹配文件、目录。
+ `<dest>`是绝对路径或者相对于`WORKDIR`的路径

```bash
ADD hom* /mydir/        # adds all files starting with "hom"
ADD hom?.txt /mydir/    # ? is replaced with any single character
ADD test aDir/          # adds "test" to `WORKDIR`/aDir/
```
# `ENTRYPOINT`
1. `ENTRYPOINT ["executable", "param1", "param2"]`
2. `ENTRYPOINT command param1 param2`

`ENTRYPOINT`将把一个container配置成可执行的。

示例：

```bash
# Dockerfile: 
FROM ubuntu
ENTRYPOINT ["top", "-b"]
CMD ["-c"]
```

1. `docker build -t test_entrypoint .`
2. `docker run -it --rm --name test  test_entrypoint -H`(设置container的名称为test，并在其退出的时候自动移除)
   ```bash
   top - 02:37:51 up  1:49,  0 users,  load average: 0.27, 0.25, 0.28
   Threads:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
   %Cpu(s):  2.9 us,  2.4 sy,  0.1 ni, 90.3 id,  4.3 wa,  0.0 hi,  0.0 si,  0.0 st
   KiB Mem:   3997276 total,  3846216 used,   151060 free,    70740 buffers
   KiB Swap:  4142076 total,   211320 used,  3930756 free.   829988 cached Mem

     PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
       1 root      20   0   19744   2276   2020 R  0.0  0.1   0:00.01 top
   ```
3. `docker exec -it test ps aux`(top的参数变成了`-b -H`，而不是`-b -c`， 并且PID为1)
   ```bash
   USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
   root         1  0.2  0.0  19752  2392 ?        Ss+  02:39   0:00 top -b -H
   root         5  0.0  0.0  15572  2160 ?        Rs+  02:40   0:00 ps aux
   ```
4. `docker stop test`
