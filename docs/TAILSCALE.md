# Tailscale Exit Node 설정 가이드

> Ubuntu 서버를 Tailscale Exit Node로 설정하면서 실제로 적용한 방식 기준으로 정리한 문서입니다.

## 개요

Exit Node는 외부 기기의 인터넷 트래픽을 대신 내보내는 역할을 합니다.
설정 자체는 간단하지만, 실제로는 IPv6 forwarding 경고와 UDP GRO forwarding 경고를 함께 정리해야 안정적으로 사용할 수 있습니다.

## 전제 조건

- Tailscale 설치 완료
- Exit Node로 사용할 서버가 Tailscale 네트워크에 로그인된 상태
- `sudo` 사용 가능
- 예시 네트워크 인터페이스: `enp8s0`

네트워크 인터페이스 이름은 환경마다 다를 수 있으니 `ip a` 또는 `ip link`로 먼저 확인합니다.

## 1. IPv4, IPv6 forwarding 활성화

Exit Node는 트래픽을 라우팅해야 하므로 커널 레벨에서 IP forwarding이 켜져 있어야 합니다.
IPv4만 켜져 있으면 `IPv6 forwarding` 경고가 계속 남을 수 있으므로 함께 설정하는 편이 안전합니다.

```bash
sudo tee -a /etc/sysctl.conf > /dev/null <<'SYSCTL'
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
SYSCTL

sudo sysctl -p
```

이미 동일한 설정이 들어 있다면 중복 라인이 생길 수 있습니다.
필요하면 `/etc/sysctl.conf`를 정리한 뒤 다시 `sudo sysctl -p`를 실행합니다.

## 2. UDP GRO forwarding 최적화

Tailscale Exit Node를 올리면 다음과 비슷한 성능 관련 경고가 나올 수 있습니다.

- `UDP GRO forwarding is suboptimally configured on enp8s0`

이 경고는 동작 자체를 막지는 않지만 처리량 저하로 이어질 수 있어서 같이 정리하는 편이 좋습니다.

### 2-1. ethtool 설치

```bash
sudo apt update
sudo apt install -y ethtool
```

### 2-2. 현재 세션에 바로 적용

```bash
sudo ethtool -K enp8s0 rx-udp-gro-forwarding on rx-gro-list off
```

이 설정은 재부팅 후 초기화될 수 있으므로, 실제 운영에서는 부팅 시 자동 적용되도록 systemd 서비스로 등록하는 방식을 추천합니다.

## 3. systemd로 ethtool 설정 영구 적용

### 3-1. 서비스 파일 생성

```bash
sudo tee /etc/systemd/system/tailscale-eth-fix.service > /dev/null <<'SERVICE'
[Unit]
Description=Tailscale UDP GRO Forwarding Fix
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -K enp8s0 rx-udp-gro-forwarding on rx-gro-list off
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICE
```

### 3-2. 서비스 등록 및 실행

```bash
sudo systemctl daemon-reload
sudo systemctl enable tailscale-eth-fix.service
sudo systemctl start tailscale-eth-fix.service
```

### 3-3. 적용 확인

```bash
systemctl status tailscale-eth-fix.service
```

## 4. Exit Node 광고 활성화

이제 Exit Node 기능을 활성화합니다.

```bash
sudo tailscale up --advertise-exit-node
```

이 단계만으로는 아직 끝나지 않습니다.
광고만 한 상태이므로, Tailscale Admin Console에서 해당 장비를 실제 Exit Node로 승인해야 다른 기기에서 선택할 수 있습니다.

## 5. Admin Console에서 Exit Node 승인

`sudo tailscale up --advertise-exit-node`를 실행한 뒤 Tailscale Admin Console에서 아래 작업을 반드시 진행합니다.

- `Machines`로 이동
- Exit Node로 올린 서버 선택
- `Edit route settings` 열기
- `Use as exit node` 활성화
- 저장

이 승인을 하지 않으면 서버 쪽 설정이 모두 정상이어도 클라이언트에서 Exit Node로 사용하지 못할 수 있습니다.

## 6. 동작 확인

### 서버 쪽 확인

```bash
tailscale status
```

필요하면 아래처럼 광고 상태도 확인합니다.

```bash
tailscale debug prefs | grep -i exit
```

### 클라이언트 쪽 확인

다른 Tailscale 기기에서 이 서버를 Exit Node로 선택한 뒤, 공인 IP가 서버의 IP로 보이는지 확인합니다.

```bash
curl ifconfig.me
```

## 자주 보는 이슈

### Admin Console에서 승인하지 않은 경우

`sudo tailscale up --advertise-exit-node`까지 했더라도 Admin Console에서 `Use as exit node`를 켜지 않으면 실제로는 사용 불가 상태입니다.
Exit Node가 목록에 안 보이거나 선택이 안 되면 이 항목부터 확인합니다.

### `IPv6 forwarding is disabled`

`net.ipv6.conf.all.forwarding = 1`이 적용되지 않았거나, 설정 후 `sudo sysctl -p`를 실행하지 않은 경우입니다.

### `UDP GRO forwarding is suboptimally configured`

`ethtool` 설정이 아직 적용되지 않았거나, 재부팅 후 초기화된 경우입니다.
이때는 `tailscale-eth-fix.service` 상태를 먼저 확인합니다.

### 인터페이스 이름이 `enp8s0`가 아닌 경우

문서의 `enp8s0`를 실제 NIC 이름으로 바꿔서 적용해야 합니다.
잘못된 인터페이스 이름으로 systemd 서비스를 만들면 부팅 후에도 설정이 적용되지 않습니다.

## 내가 최종적으로 적용한 흐름

```bash
sudo tee -a /etc/sysctl.conf > /dev/null <<'SYSCTL'
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
SYSCTL
sudo sysctl -p

sudo apt update
sudo apt install -y ethtool
sudo ethtool -K enp8s0 rx-udp-gro-forwarding on rx-gro-list off

sudo tee /etc/systemd/system/tailscale-eth-fix.service > /dev/null <<'SERVICE'
[Unit]
Description=Tailscale UDP GRO Forwarding Fix
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -K enp8s0 rx-udp-gro-forwarding on rx-gro-list off
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable tailscale-eth-fix.service
sudo systemctl start tailscale-eth-fix.service

sudo tailscale up --advertise-exit-node
```

그 다음 Admin Console에서 해당 장비의 `Edit route settings`로 들어가 `Use as exit node`를 켭니다.

필요하면 이 문서를 기준으로 Tailscale 설치부터 로그인까지 포함한 초기 세팅 문서로 확장해도 됩니다.
