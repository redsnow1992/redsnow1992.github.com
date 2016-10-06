---
title: Linux Commands
date: 2015-07-28 10:00
categories: linux
---
# Linux Commands
| command | meaning |
| ---     | ---     |
| `diff -ur dir1 dir2` | 深入比较目录下的文件（`colordiff`更棒） |
| sudo usermod -aG docker donald | 将docker添加到docker组  |
| sudo update-rc.d jenkins disable | 从开机启动移除 |
| start-stop-daemon --stop --quiet --pidfile $PIDFILE | 关闭后台进程 |
| dpkg-query -S jenkins | 查找jenkins包 |
| sudo netstat -tapen \| grep ":8000" | 查询使用8000端口的程序 |
| lsof -i :8000 | 使用8000端口的文件 |
| ps -fp 1289 | | pid为1289的进程信息 |

*不定时更新*

