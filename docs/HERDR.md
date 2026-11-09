# HERDR 단축키 가이드 (Git Worktree 워크플로우)

> AI 코딩 에이전트용 터미널 멀티플렉서 herdr 사용 가이드 (기준 버전: 0.9.5)
> 공식 문서: https://herdr.dev/tui/docs/

## 기본 개념

- **Prefix Key**: `C-b` (Ctrl+b) - tmux와 같다. `prefix+n`은 `C-b`를 누른 뒤 `n`을 누른다는 뜻
- **Server**: 백그라운드에서 터미널을 붙잡고 있는 프로세스. 터미널을 닫아도 작업이 유지된다
- **Session**: 이름 붙은 독립 서버 (`--session <name>`). tmux의 세션에 대응
- **Workspace**: 사이드바에 보이는 작업 공간 (저장소·worktree 단위). tmux에는 없는 계층
- **Tab**: 워크스페이스 안의 탭. tmux의 window에 대응
- **Pane**: 탭을 분할한 영역
- **Agent**: 페인에서 실행 중인 Claude Code·Codex 등. 상태(`idle`, `working`, `blocked`, `done`)가 사이드바에 표시된다

```
Session
└── Workspace (사이드바)
    └── Tab
        └── Pane (agent 실행)
```

### tmux와 다른 점

| 동작 | tmux | herdr |
|------|------|-------|
| detach | `C-b d` | `C-b q` |
| 수직 분할 (좌우) | `C-b %` | `C-b v` |
| 수평 분할 (상하) | `C-b "` | `C-b -` |
| 페인 이동 | `C-b 방향키` | `C-b h/j/k/l` |
| 탭(윈도우) 종료 | `C-b &` | `C-b X` (Shift+x) |
| 크기 조절 | `C-b C-방향키` | `C-b r` → 리사이즈 모드 |

## 1. 세션 관리

#### 단축키

| 단축키 | 설명 |
|--------|------|
| `C-b q` | 현재 세션에서 detach |
| `C-b s` | 설정 화면 열기 |
| `C-b R` | 설정 파일 다시 읽기 (Shift+r) |

#### CLI

| 명령어 | 설명 |
|--------|------|
| `herdr` | 기본 세션 실행 또는 연결 |
| `herdr --session <name>` | 이름 붙은 세션 실행 또는 연결 (없으면 생성) |
| `herdr session list` | 세션 목록과 실행 상태 조회 |
| `herdr session attach <name>` | 세션에 연결 |
| `herdr session stop <name>` | 세션 서버 중지 (페인 프로세스도 종료됨) |
| `herdr session delete <name>` | 중지된 세션 삭제 |
| `herdr status` | 클라이언트·서버 상태 조회 |

## 2. 워크스페이스 관리 (worktree별 작업 공간)

#### 단축키

| 단축키 | 설명 |
|--------|------|
| `C-b w` | 워크스페이스 목록에서 선택 |
| `C-b g` | goto (워크스페이스·에이전트로 이동) |
| `C-b N` | 새 워크스페이스 생성 (Shift+n) |
| `C-b G` | 새 git worktree를 만들고 워크스페이스로 열기 (Shift+g) |
| `C-b W` | 워크스페이스 이름 변경 (Shift+w) |
| `C-b D` | 워크스페이스 닫기 (Shift+d) |
| `C-b b` | 사이드바 표시/숨김 |
| `C-b o` | 알림이 온 에이전트 페인으로 이동 |

#### CLI (herdr 안의 페인에서 실행)

| 명령어 | 설명 |
|--------|------|
| `herdr workspace list` | 워크스페이스 목록 조회 |
| `herdr worktree list` | worktree 워크스페이스 목록 조회 |
| `herdr worktree create` | git worktree를 만들고 워크스페이스로 열기 (저장소 본체 워크스페이스에서 실행) |
| `herdr worktree open` | 기존 git worktree를 워크스페이스로 열기 |
| `herdr worktree remove` | worktree 체크아웃 삭제 |

> worktree 기본 생성 위치는 `~/.herdr/worktrees`이고, `config.toml`의 `[worktrees] directory`로 바꿀 수 있다.

## 3. 탭 관리

| 단축키 | 설명 |
|--------|------|
| `C-b c` | 새 탭 생성 |
| `C-b T` | 탭 이름 변경 (Shift+t) |
| `C-b n` | 다음 탭으로 이동 |
| `C-b p` | 이전 탭으로 이동 |
| `C-b 1-9` | 특정 탭으로 이동 |
| `C-b X` | 현재 탭 종료 (Shift+x) |

## 4. 페인 분할 (동시 작업)

| 단축키 | 설명 |
|--------|------|
| `C-b v` | 수직 분할 (좌우) |
| `C-b -` | 수평 분할 (상하) |
| `C-b h/j/k/l` | 왼쪽/아래/위/오른쪽 페인으로 이동 |
| `C-b Tab` | 다음 페인으로 이동 |
| `C-b Shift+Tab` | 이전 페인으로 이동 |
| `C-b z` | 현재 페인 확대/축소 토글 |
| `C-b x` | 현재 페인 종료 |
| `C-b P` | 페인 이름 변경 (Shift+p) |

## 5. 페인 크기 조절

| 단축키 | 설명 |
|--------|------|
| `C-b r` | 리사이즈 모드 진입 (방향키로 조절, `Esc`로 종료) |

> 모드 없이 바로 조절하려면 `config.toml`에 `resize_pane_left = "ctrl+shift+alt+left"` 같은 바인딩을 추가한다 (기본값은 비어 있음).

## 6. 스크롤 및 텍스트 복사

| 동작 | 설명 |
|------|------|
| 마우스 휠 | 페인 스크롤백 스크롤 (기본 3줄 단위) |
| 마우스 드래그 | 선택 즉시 클립보드로 복사 (`copy_on_select = true`) |
| `C-b e` | 스크롤백을 에디터로 열기 (검색·복사할 때 편리) |

## 7. 유용한 추가 명령

| 단축키 / 명령어 | 설명 |
|-----------------|------|
| `C-b ?` | 현재 적용된 모든 키 바인딩 보기 |
| `herdr --default-config` | 기본 설정 전체 출력 |
| `herdr server reload-config` | 실행 중인 서버에 설정 다시 적용 |
| `herdr config reset-keys` | `config.toml`을 백업하고 커스텀 키 바인딩 초기화 |
| `herdr integration status` | Claude Code·Codex 등 에이전트 연동 상태 조회 |
| `herdr update` | 최신 버전 설치 |

## Git Worktree 권장 워크플로우

### 1. 새 Worktree에서 작업 시작

```bash
# 저장소 루트에서 herdr 실행
cd ~/Documents/myproject
herdr --session myproject
```

1. `C-b G` - 브랜치 이름을 입력하면 worktree와 워크스페이스가 함께 생성된다
2. 새 워크스페이스에서 `claude` 또는 `codex` 실행
3. `C-b v` - 옆 페인에서 서버·테스트 실행

### 2. 기존 세션에 재연결

```bash
# 세션 목록 확인
herdr session list

# 특정 세션에 연결
herdr session attach myproject
# 또는
herdr --session myproject
```

### 3. Worktree별 다중 작업 설정 예시

```
Session: myproject
├── Workspace: myproject (main)
├── Workspace: feature-login (worktree)
│   ├── Tab 1: agent
│   │   ├── Pane 1: claude
│   │   └── Pane 2: npm run dev
│   └── Tab 2: git
│       └── Pane 1: lazygit
└── Workspace: fix-payment (worktree)
    └── Tab 1: codex
```

**설정 방법**:
1. `C-b G` - feature-login worktree 워크스페이스 생성
2. `C-b v` - 좌우 분할하여 dev 서버 페인 생성
3. `C-b c` - Tab 2 생성 (git)
4. `C-b T` - 각 탭에 이름 지정

### 4. 워크스페이스·에이전트 간 빠른 전환

- `C-b w` - 워크스페이스 목록에서 선택
- `C-b g` - goto로 원하는 에이전트에 바로 이동
- `C-b o` - 마지막 알림을 보낸 에이전트 페인으로 이동

## .zshrc 추천 Alias (herdr용)

```bash
alias h='herdr'
alias hs='herdr --session'
alias hl='herdr session list'
alias ha='herdr session attach'

# 현재 디렉토리 이름으로 세션 실행/연결
alias hh='herdr --session "$(basename "$PWD")"'
```

## 팁

1. **세션 영속성**: 서버가 백그라운드에서 돌기 때문에 터미널을 닫아도 에이전트가 계속 실행된다.
2. **설정 파일**: `~/.config/herdr/config.toml` (TOML). 설정 파일이 없어도 기본값으로 동작한다.
3. **에이전트 세션 복원**: 서버 재시작 후 Claude Code·Codex 대화를 이어서 복원한다 (`[session] resume_agents_on_restore = true`).
4. **팝업 명령**: `[[keys.command]]`로 lazygit 같은 도구를 팝업 창에 띄울 수 있다.

```toml
[[keys.command]]
key = "prefix+alt+g"
type = "popup"
command = "lazygit"
width = "80%"
height = "80%"
```

## 자주 사용하는 명령어 조합

- **새 프로젝트 시작**: `herdr --session project-name`
- **작업 중단하고 나가기**: `C-b q`
- **작업 재개**: `herdr session attach project-name`
- **worktree + 에이전트 시작**: `C-b G` → `claude`
- **빠른 분할 및 이동**: `C-b v` → `C-b l` → 명령 실행
- **전체 화면 토글**: `C-b z`
