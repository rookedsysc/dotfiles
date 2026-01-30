## About

That is my Linux(Ubuntu, Kali) and Mac OS setting.

## Install

In Mac OS
wget https://raw.githubusercontent.com/rookedsysc/linux-macos-setting/master/mac-setting.sh
sh macSetting.sh

Setting for Users

    wget https://raw.githubusercontent.com/rookedsysc/linux-macos-setting/master/user-setting.sh
    sh user-setting.sh

> When zsh shell is activated, enter "exit" to continue the next installation.

If this error message is printed,

> [oh-my-zsh] plugin 'zsh-autosuggestions' not found

    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    source ~/.zshrc

In root

    su root
        wget https://raw.githubusercontent.com/rookedsysc/linux-macos-setting/master/root-setting.sh
    sh root-setting.sh

## TMUX 사용법

[열기](./docs/TMUX.md)

## Claude Code & SuperClaude 설치

### 사전 요구사항

- Node.js와 npm 설치 필요
- Git 설치 필요
- Python 3.7+ 설치 필요
- 인터넷 연결

### 설치 방법 

리눅스 시스템용 자동 설치 스크립트 사용:

    wget https://raw.githubusercontent.com/rookedsysc/linux-macos-setting/master/linux-claude-installer.sh
    chmod +x linux-claude-installer.sh
    ./linux-claude-installer.sh

설치 프로그램이 다음을 수행합니다:
1. npm을 통해 Claude Code를 전역 설치
2. uv 설치 (SuperClaude에 필요한 Python 패키지 매니저)
3. SuperClaude Framework 저장소 클론
4. Python 가상환경 설정
5. SuperClaude 패키지 설치
6. SuperClaude 설치 설정 실행


## Docs

- [AeroSpace](./docs/how-to-use-aerospace.md)

### Jekkyll

Install in Ubuntu

    wget https://raw.githubusercontent.com/rookedsysc/Linux_MacOS_Setting/master/jekyllSetting.sh
    sh jekyllSetting.sh

Install in MacOS

    wget https://raw.githubusercontent.com/rookedsysc/Linux_MacOS_Setting/master/macJekyll.sh
    sh macJekyll.sh

How to start a server

    jekyll serve

If you receive an error to install Gemfile:

    cd [your gitblog local address]
    bundler
    sudo gem install jekyll bundler
    bundle add webrick
    sudo bundle exec jekyll serve

![jekyllServe](./imgSrc/jekyllServe.png)

#### algolia

    export ALGOLIA_API_KEY='ADMIN KEY"
    bundle exec jekyll algolia

### mkdocs

```console
pip3 install mkdocs
pip3 install mkdocs-material
mkdocs serve --dev-addr 0.0.0.0:8080
```

It's working in mac

## KDE plasma for Kali Linux

KDE plasma is a kind of Linux theme.

![KDE plasma](./imgSrc/KDEplasma.jpeg)
Install
apt-get install kali-defaults kali-root-login desktop-base kde-plasma-desktop
sudo update-alternatives --config x-session-manager > set kde as default

## Remark

`F9` is a script runner

`F12` is a singlecompiler and runner

`\gd` is gtags/def

`\gr` is gtags/ref

If you want to tracecode you need to change to your directory of source
and enter a command , which is `gtags`.

## Setting

Timezone Setting (Korea)

    sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

Ubuntu Dock Hide
![Dock](./imgSrc/Dock_1.png)
![Dock](./imgSrc/Dock_2.png)

## Reference

- Vundle
  https://github.com/gmarik/Vundle.vim

- Powerline
  https://github.com/Lokaltog/vim-powerline
  https://github.com/Lokaltog/vim-powerline/tree/develop/fontpatcher
  https://github.com/Lokaltog/powerline-fonts

- Unite/unite-gtags
  https://github.com/Shougo/unite.vim
  https://github.com/hewes/unite-gtags

- Follow lokihardt
  https://github.com/l0kihardt/vimrc
