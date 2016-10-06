---
title: Shortcuts
date: 2015-07-09 11:24
tags: shortcuts
---
# Emacs Shortcuts
[EmacsNewbieKeyReference](http://emacswiki.org/emacs/EmacsNewbieKeyReference)

| shortcut | key-binding |
|:--------:|:-----------:|
| go to beginning of file | `M <` |
| go to end of the file | `M >` |
| kill line to beginning | `M 0 C-k` |
| save all open buffers | `C-x s` |
| compare tree with base version | `C-x v D` |
| compare with base version | `C-x v =`|
| search for files with names matching a wildcard pattern | `M-x find-name-dired` |
| Run `grep` via `find` | `M-x rgrep` |
| Update to Latest version | `C-x v +` |
| Compare with base version | `C-x v =` |
| Compare tree with base version | `C-x v D`

## Emacs macro Example
```
1   I am a random text
2   I am not
3   G, you've gone mad
4   Click on this link
5   Transfer in progress (we've started the transfer process)
6   But transfer happend yesterday
7   No you are
8   Oh please! this is getting too much!
9   I love emacs
10  I cant be bothered with this any more
11  its time to raise the bar
12  show me how to expand my territory
```
1. Place cursor at first line
2. Press `C-x (` to start recording macro [At this point all your key inputs are being recorded so please follow the instructions carefully]
3. Press `C-a` to go to the beginning of the line
4. Type "(" followed by `M-f` to move forward a word and then type ","
5. `C-n` to go to the next line, followed by `C-x )` to end the macro
6. `C-u 11 C-x e` repeat the macro n (11 in this case) times

```
(1,   I am a random text
(2,   I am not
(3,   G, youve gone mad
(4,   Click on this link
(5,   Transfer in progress (weve started the transfer process)
(6,   But transfer happend yesterday
(7,   No you are
(8,   Oh please! this is getting too much!
(9,   I love emacs
(10,  I cant be bothered with this any more
(11,  its time to raise the bar
(12,  show me how to expand my territory
```

## ECB 
    激活ecb模式        "M-x ecb-activate"
    Go to history:     "C-c . g h"
    Go to methods:     "C-c . g m"
    Go to sources:     "C-c . g s"
    Go to directories: "C-c . g d"
    Main buffer:       "C-c . g 1"
