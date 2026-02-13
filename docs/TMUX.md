# TMUX 단축키 가이드 (Git Worktree 워크플로우)

> Git worktree와 함께 사용하는 tmux 세션 관리 가이드

## 기본 개념

- **Prefix Key**: `C-b` (Ctrl+b) - 모든 tmux 명령어는 이 키를 먼저 누른 후 실행
- **Session**: 독립적인 작업 환경 (worktree별로 하나씩)
- **Window**: 세션 내의 탭과 유사 (하나의 worktree 내 여러 작업)
- **Pane**: 윈도우를 분할한 영역

## Worktree 워크플로우에 맞춘 사용법

### 1. 세션 관리 (Zellij의 za, zd와 대응)

#### 단축키

| 단축키 | 설명 | Zellij 대응 |
|--------|------|-------------|
| `C-b d` | 현재 세션에서 detach | `C-o` (zellij) |
| `C-b s` | 세션 목록 보기 및 전환 | - |
| `C-b (` / `C-b )` | 이전/다음 세션으로 전환 | - |
| `C-b $` | 세션 이름 변경 | - |

#### CLI

| 명령어 | 설명 | 주요 옵션 |
|--------|------|-----------|
| `tmux ls` | 세션 목록 조회 | `-F <format>` 출력 포맷 지정 |
| `tmux new -s <name>` | 새 세션 생성 | `-d` 백그라운드 생성, `-c <dir>` 시작 디렉토리, `-n <window-name>` 초기 윈도우 이름 |
| `tmux attach -t <name>` | 세션에 연결 | `-d` 다른 클라이언트 detach 후 연결 |
| `tmux kill-session -t <name>` | 세션 삭제 | `-a` 지정한 세션 외 모두 삭제 |

### 2. 윈도우 관리 (브랜치별 작업 공간)

#### 단축키

| 단축키 | 설명 |
|--------|------|
| `C-b c` | 새 윈도우 생성 |
| `C-b ,` | 윈도우 이름 변경 |
| `C-b n` | 다음 윈도우로 이동 |
| `C-b p` | 이전 윈도우로 이동 |
| `C-b 0-9` | 특정 윈도우로 이동 |
| `C-b w` | 윈도우 목록 보기 및 선택 |
| `C-b &` | 현재 윈도우 종료 |
| `C-b l` | 마지막 윈도우로 전환 |

#### CLI

| 명령어 | 설명 | 주요 옵션 |
|--------|------|-----------|
| `tmux lsw -t <session>` | 윈도우 목록 조회 | `-a` 모든 세션의 윈도우 조회 |
| `tmux neww -t <session> -n <name>` | 새 윈도우 생성 | `-d` 백그라운드 생성, `-c <dir>` 시작 디렉토리 |
| `tmux selectw -t "<session>:<window>"` | 특정 윈도우로 전환 | 인덱스 또는 이름 지정. 윈도우 이름에 공백이 있으면 `""` 필수 |
| `tmux killw -t <session>:<index>` | 윈도우 삭제 | `-a` 지정한 윈도우 외 모두 삭제 |

### 3. 페인 분할 (동시 작업)

| 명령어 | 단축키 | 설명 |
|--------|--------|------|
| `C-b %` | `Prefix + %` | 수직 분할 (좌우) |
| `C-b "` | `Prefix + "` | 수평 분할 (상하) |
| `C-b o` | `Prefix + o` | 다음 페인으로 이동 |
| `C-b ;` | `Prefix + ;` | 이전 활성 페인으로 이동 |
| `C-b 방향키` | `Prefix + ↑↓←→` | 특정 방향 페인으로 이동 |
| `C-b z` | `Prefix + z` | 현재 페인 확대/축소 토글 |
| `C-b x` | `Prefix + x` | 현재 페인 종료 |
| `C-b {` / `C-b }` | `Prefix + {` / `}` | 페인 위치 교환 |

### 4. 페인 크기 조절

| 명령어 | 단축키 | 설명 |
|--------|--------|------|
| `C-b C-방향키` | `Prefix + Ctrl + ↑↓←→` | 1칸 단위로 크기 조절 |
| `C-b M-방향키` | `Prefix + Alt + ↑↓←→` | 5칸 단위로 크기 조절 |

### 5. 복사 모드 (스크롤 및 텍스트 복사)

| 명령어 | 단축키 | 설명 |
|--------|--------|------|
| `C-b [` | `Prefix + [` | 복사 모드 진입 (히스토리 보기) |
| `q` | `q` | 복사 모드 종료 |
| `Space` | `Space` | 복사 시작 (복사 모드 내) |
| `Enter` | `Enter` | 복사 완료 (복사 모드 내) |
| `C-b ]` | `Prefix + ]` | 복사한 텍스트 붙여넣기 |
| `C-b =` | `Prefix + =` | 버퍼 목록에서 선택하여 붙여넣기 |

### 6. 유용한 추가 명령

| 명령어 | 단축키 | 설명 |
|--------|--------|------|
| `C-b ?` | `Prefix + ?` | 모든 키 바인딩 목록 보기 |
| `C-b t` | `Prefix + t` | 시계 표시 |
| `C-b i` | `Prefix + i` | 현재 윈도우 정보 표시 |
| `C-b r` | `Prefix + r` | 화면 강제 새로고침 |
| `C-b Space` | `Prefix + Space` | 레이아웃 순환 변경 |

## Git Worktree 권장 워크플로우

### 1. 새 Worktree에서 작업 시작

```bash
# Worktree 생성
git worktree add -b feature-login ../myproject-feature-login

# Worktree 디렉토리로 이동하여 tmux 세션 시작
cd ../myproject-feature-login
tmux new -s myproject-feature-login
```

### 2. 기존 Worktree 세션에 재연결

```bash
# 세션 목록 확인
tmux ls

# 특정 세션에 연결
tmux attach -t myproject-feature-login
# 또는 짧게
tmux a -t myproject-feature-login
```

### 3. Worktree별 다중 작업 설정 예시

```
Session: myproject-feature-login
├── Window 0: editor (vim/nvim)
├── Window 1: server
│   ├── Pane 1: npm run dev
│   └── Pane 2: logs
└── Window 2: git
    ├── Pane 1: git status
    └── Pane 2: testing
```

**설정 방법**:
1. `C-b c` - Window 1 생성 (server)
2. `C-b "` - 수평 분할하여 logs 페인 생성
3. `C-b c` - Window 2 생성 (git)
4. `C-b "` - 수평 분할하여 testing 페인 생성
5. `C-b ,` - 각 윈도우에 이름 지정

### 4. 세션 간 빠른 전환

- `C-b s` - 세션 목록에서 선택
- `C-b (` / `C-b )` - 이전/다음 세션
- `tmux switch -t <session-name>` - 명령어로 전환

## .zshrc 추천 Alias (tmux용)

```bash
# tmux 기본
alias t='tmux'
alias ta='tmux attach -t'
alias tl='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'

# worktree + tmux 통합 (zwn 대체)
alias twn='f() {
  CURRENT_DIR=$(basename "$(dirname "$PWD")");
  TNAME="$1";
  DIRNAME="${CURRENT_DIR}-${TNAME//\//-}";
  SESSION_NAME="${CURRENT_DIR}-${TNAME//\//-}";
  git worktree add -b $TNAME ../$DIRNAME &&
  cd ../$DIRNAME &&
  tmux new -s $SESSION_NAME;
}; f'

# 세션 선택하여 연결 (fzf 사용)
alias tas='tmux attach -t $(tmux ls | fzf | cut -d: -f1)'
```

## 팁

1. **세션 영속성**: tmux 세션은 터미널을 닫아도 백그라운드에서 계속 실행됩니다.
2. **마우스 지원**: `set -g mouse on`을 설정하면 마우스로 페인 선택 및 크기 조절 가능
3. **설정 파일**: `~/.tmux.conf`에서 키 바인딩 및 옵션 커스터마이징
4. **플러그인**: TPM (Tmux Plugin Manager)으로 다양한 플러그인 사용 가능
5. **세션 복원**: tmux-resurrect 플러그인으로 재부팅 후에도 세션 복원 가능

## 자주 사용하는 명령어 조합

- **새 프로젝트 시작**: `tmux new -s project-name`
- **작업 중단하고 나가기**: `C-b d`
- **작업 재개**: `tmux a -t project-name`
- **빠른 분할 및 이동**: `C-b %` → `C-b o` → 명령 실행
- **전체 화면 토글**: `C-b z` (발표나 집중 작업 시 유용)
