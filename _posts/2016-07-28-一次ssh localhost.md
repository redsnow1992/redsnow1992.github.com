---
title: ssh localhost debug
date: 2016-07-28 14:00
category: linux
---
具体过程如下：

1. `ssh -v localhost`
2. 报错：Permission denied (publickey,password)
3. `less /var/log/auth.log`  `userauth_pubkey: key type ssh-dss not in PubkeyAcceptedKeyTypes [preauth]
Connection closed by 127.0.0.1 port 57060 [preauth]
`
4. `/etc/ssh/sshd_config 添加一行 PubkeyAcceptedKeyTypes=+ssh-dss`
5. 重启ssh服务，OK
