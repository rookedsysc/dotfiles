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

### TPM (Tmux Plugin Manager) 설치

tmux 플러그인 관리를 위해 TPM을 설치해야 합니다.

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

설치 후 tmux에서 `prefix + I`를 눌러 플러그인을 설치합니다.

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
- [Tailscale Exit Node](./docs/TAILSCALE.md)

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

## VMware Workstationd 관련 CLI

`workstationd`는 보통 직접 조작하는 메인 CLI라기보다 VMware Workstation의 백그라운드 서비스에 가깝습니다. 실제로 자주 쓰는 명령은 VM 제어용 `vmrun`, 컨테이너 런타임용 `vctl`, 그리고 호스트 점검용 `vmrest`/`vmware-modconfig` 쪽입니다.

### 1. VM 제어: `vmrun`

`vmrun`은 가상 머신 전원, 스냅샷, 게스트 내부 명령 실행까지 자동화할 때 가장 먼저 보는 CLI입니다.

```bash
# 실행 중인 VM 목록
vmrun list

# GUI 없이 VM 시작/종료
vmrun start "/path/to/my.vmx" nogui
vmrun stop "/path/to/my.vmx" soft

# 스냅샷 생성/복구
vmrun snapshot "/path/to/my.vmx" before-test
vmrun revertToSnapshot "/path/to/my.vmx" before-test

# 게스트 OS 내부에서 프로그램 실행
vmrun -gu guestUser -gp guestPassword runProgramInGuest \
  "/path/to/my.vmx" /usr/bin/id
```

핵심 포인트:

- VM 전체 lifecycle 제어에 적합합니다.
- 스냅샷 기반 테스트, 게스트 내부 스크립트 실행, 파일 복사 자동화에 유용합니다.
- Docker 기준으로 보면 `docker`처럼 컨테이너를 다루는 도구라기보다, 전체 머신을 제어하는 `virsh`/`VBoxManage` 쪽에 더 가깝습니다.

### 2. Docker와 가장 가까운 CLI: `vctl`

`vctl`은 Workstation Pro 안에서 컨테이너를 다루는 CLI입니다. Docker와 가장 직접적으로 비교되는 명령군도 이쪽입니다.

```bash
# 컨테이너 런타임 시작
vctl system start

# 이미지/컨테이너 조회
vctl images
vctl ps

# 컨테이너 실행
vctl run --name web -d nginx

# Dockerfile 기반 이미지 빌드
vctl build --file Dockerfile --tag docker.io/me/app:1.0 .

# 컨테이너를 담고 있는 CRX VM 내부 셸 접속
vctl execvm --sh -c web

# KIND 환경 준비
vctl kind
```

핵심 포인트:

- `vctl run`, `vctl ps`, `vctl build`, `vctl pull`, `vctl push`, `vctl login`은 각각 `docker run`, `docker ps`, `docker build`, `docker pull`, `docker push`, `docker login`과 거의 1:1로 대응됩니다.
- 차이는 `vctl`이 컨테이너를 그냥 host namespace에서 실행하는 것이 아니라, 각 컨테이너를 `CRX VM`이라는 경량 VM 안에서 돌린다는 점입니다.
- 그래서 Docker보다 VM 경계가 더 강하고, 반대로 네트워크/볼륨 기능은 더 제한적입니다.

### 3. Docker와의 대응 관계

| VMware Workstation CLI | Docker에서 대응되는 개념 | 설명 |
| --- | --- | --- |
| `vmrun start/stop/snapshot` | 직접 대응 없음 | VM 전체를 다루는 명령입니다. 컨테이너보다 훨씬 큰 단위입니다. |
| `vctl run` | `docker run` | 이미지를 기반으로 컨테이너를 실행합니다. |
| `vctl ps` | `docker ps` | 실행 중인 컨테이너 또는 전체 컨테이너를 조회합니다. |
| `vctl build` | `docker build` | Dockerfile로 이미지를 빌드합니다. |
| `vctl exec` | `docker exec` | 실행 중인 컨테이너 내부 명령을 실행합니다. |
| `vctl execvm` | 대응 없음 | 컨테이너가 아닌, 그 컨테이너를 담고 있는 CRX VM 자체로 들어갑니다. |
| `vctl kind` | Docker 기반 `kind` 대체 | `kind`가 Docker 대신 `vctl` 컨테이너를 node로 사용하게 만듭니다. |

실무적으로는 이렇게 이해하면 편합니다.

- VM 자동화가 필요하면 `vmrun`
- Docker와 비슷한 UX로 컨테이너를 돌리고 싶으면 `vctl`
- 다만 `vctl`은 내부적으로 Docker Engine이 아니라 `containerd + CRX VM` 모델을 사용합니다.

### 4. `vctl`이 Docker와 다른 점

- `vctl system start`로 container runtime을 먼저 올립니다.
- 컨테이너마다 경량 VM(CRX VM)이 붙기 때문에 Docker보다 격리가 강합니다.
- 공식 문서 기준 `--publish`로 host port를 바인딩하는 방식이 핵심이며, Docker의 subnet/link 같은 기능은 없습니다.
- `--volume`은 폴더의 절대 경로만 지원하고, named volume도 제한적입니다.
- `vctl kind`를 실행하면 `docker.exe` shortcut을 `vctl.exe`로 연결해 KIND 워크플로우를 대체할 수 있습니다.

### 5. 이 호스트에서 같이 보이는 보조 명령

현재 Linux 호스트에서 확인된 보조 명령은 다음과 같습니다.

```bash
# REST API 서버 옵션 확인
vmrest -h

# 커널 모듈/빌드 환경 점검용
vmware-modconfig --help

# VMware 백그라운드 서비스 상태 확인/재시작
systemctl status vmware.service
sudo systemctl restart vmware.service
```

간단히 정리하면:

- `vmrest`: REST API 서버를 띄울 때 보는 명령
- `vmware-modconfig`: 커널 헤더/GCC 환경과 VMware 모듈 재구성 관련 명령
- `systemctl ... vmware.service`: Linux에서 VMware 백그라운드 서비스를 관리할 때 사용하는 호스트 명령

### 6. `vmrun`으로 SSH 접속할 수 있나?

짧게 말하면 `직접 SSH 접속하는 기능은 없습니다`.

- `vmrun`의 guest 제어는 SSH가 아니라 `VMware Tools` 기반입니다.
- 그래서 인증도 SSH key/host/port가 아니라 `-gu`, `-gp`로 guest 계정을 넘기는 방식입니다.
- 즉 `ssh user@guest`를 대체하는 도구라기보다, host에서 guest 안의 프로그램이나 스크립트를 실행하는 자동화 도구에 가깝습니다.

대신 아래 흐름은 가능합니다.

```bash
# guest IP 확인
vmrun getGuestIPAddress "/path/to/my.vmx" -wait

# 확인한 IP로 일반 ssh 접속
ssh user@<guest-ip>
```

또는 NAT/포트포워딩을 쓰는 경우에는 `vmrun`으로 포워딩을 잡고, 실제 접속은 SSH 클라이언트로 합니다.

```bash
# 예시: host 2222 -> guest 22
sudo vmrun setPortForwarding vmnet8 tcp 2222 192.168.***.*** 22 ssh-vm

# 실제 접속은 ssh 사용
ssh -p 2222 user@127.0.0.1
```

### 참고 자료

- [`vmrun` 개요 - Broadcom](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/using-the-vmrun-command-to-control-virtual-machines.html)

  > "control virtual machines and automate guest operations"

- [`vmrun` 문법 - Broadcom](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/using-the-vmrun-command-to-control-virtual-machines/syntax-of-the-vmrun-command.html)

  > "authentication flags, commands, and parameters"

- [`vctl` 개요 - Broadcom](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/using-vctl-command-to-manage-containers-and-run-kubernetes-cluster.html)

  > "to manage containers"

- [`vctl` 문법/기능 - Broadcom](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/using-vctl-command-to-manage-containers-and-run-kubernetes-cluster/running-vctl-commands/syntax-of-vctl-commands.html)

  > "Builds a container image using a Dockerfile"

- [`vctl`와 KIND, Docker 대체 - Broadcom](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/17-0/using-vmware-workstation-pro/using-vctl-command-to-manage-containers-and-run-kubernetes-cluster/enabling-kind-to-use-vctl-container-as-nodes-to-run-kubernetes-clusters.html)

  > "It enables KIND to use vctl container instead of Docker container as nodes to run local Kubernetes clusters."

- [`vctl` 추가 설명 - VMware Archive](https://raw.githubusercontent.com/vmware-archive/vctl-docs/master/README.md)

  > "vctl allows users to Build, Run, Push and Pull containers and images, manage the system runtime settings, and configure the environment to support 'kind'."

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
