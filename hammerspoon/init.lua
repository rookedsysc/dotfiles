-- 모든 디스플레이에서 Space 전환을 시뮬레이션
function switchSpaceAllDisplays(direction)
    -- direction: "left" or "right"
    local key = direction == "right" and "Right" or "Left"

    -- 현재 마우스 포인터 위치 저장
    local mousePoint = hs.mouse.absolutePosition()

    -- 연결된 디스플레이 목록 가져오기
    local screens = hs.screen.allScreens()

    -- 각 스크린의 중앙 좌표를 구해서 해당 위치로 마우스를 옮기고 전환 키 입력
    for i, screen in ipairs(screens) do
        local frame = screen:frame()
        local center = hs.geometry.rectMidPoint(frame)

        hs.mouse.absolutePosition(center)
        hs.timer.usleep(100000) -- 0.1초 (100,000 마이크로초)
        -- fn 추가해야 함 ref : https://github.com/Hammerspoon/hammerspoon/issues/1946#issuecomment-449604954
        hs.eventtap.keyStroke({"fn", "ctrl"}, key, 0)
        hs.timer.usleep(50000) -- 0.05초 (50,000 마이크로초)
    end

    -- 마우스 원위치
    hs.mouse.absolutePosition(mousePoint)
    -- 이벤트 성공여부 알림
    -- hs.alert.show("Space 이동: " .. direction)
end


-- key mapping for vim 
-- Convert input soruce as English and sends 'escape' if inputSource is not English.
-- Sends 'escape' if inputSource is English.
-- key bindding reference --> https://www.hammerspoon.org/docs/hs.hotkey.html
local inputEnglish = "com.apple.keylayout.ABC"
local esc_bind

-- 맥 잠들기 모드로 진입
hs.hotkey.bind({ 'ctrl', 'cmd', 'shift' }, 'L', function()
    hs.caffeinate.lockScreen()
end)
-- END

-- 'escape' 키를 눌렀을 때의 동작을 담은 함수와 이를 트리거하는 단축키 설정
function convert_to_eng_with_esc()
    local inputSource = hs.keycodes.currentSourceID()
    if not (inputSource == inputEnglish) then
        hs.keycodes.currentSourceID(inputEnglish)
    end
    esc_bind:disable()
    hs.eventtap.keyStroke({}, 'escape')
    esc_bind:enable()
end

esc_bind = hs.hotkey.new({}, 'escape', convert_to_eng_with_esc):enable()
-- END

-- REFERENCE : https://www.philgineer.com/2021/01/m1-hammerspoon.html
-- GITHUB : https://github.com/hetima/hammerspoon-foundation_remapping
--
-- START cmd to f18
local FRemap = require('foundation_remapping')
local remapper = FRemap.new()
remapper:remap('rcmd', 'f18')
remapper:register()
-- END

hs.hotkey.bind({"ctrl", "cmd", "shift"}, "right", function()
    switchSpaceAllDisplays("right")
end)
hs.hotkey.bind({"ctrl", "cmd", "shift"}, "left", function()
    switchSpaceAllDisplays("left")
end)

-- Alert 스타일 알림 임시 숨김 / 복원
-- Close AXAction은 NC 리스트에서도 영구 삭제되므로,
-- alert 윈도우의 AXPosition을 화면 밖으로 이동시키는 방식으로 "옆으로 슬쩍 치우기" 구현.
-- ] : 화면에 보이는 모든 NC 윈도우를 (-9999, -9999)로 이동, 원래 좌표를 Lua state에 stash
-- [ : stash된 좌표로 복원. stash 없으면 우상단 기본 위치로 복원.
-- ⚠️ 시스템 설정 → 개인정보 보호 및 보안 → 손쉬운 사용 에서 Hammerspoon 허용 필요.

local hiddenStash = nil  -- JSON 문자열: stash된 윈도우 좌표 배열

local hideAlertsJXA = [==[
function run() {
  const se = Application('System Events');
  let nc;
  try { nc = se.processes.byName('NotificationCenter'); } catch(e) { return '[]'; }
  if (nc.windows.length === 0) return '[]';
  let positions = [];
  for (let w of nc.windows()) {
    try {
      let p = w.position();
      if (p && p[0] > -5000) {
        positions.push([p[0], p[1]]);
        w.position = [-9999, -9999];
      }
    } catch (_) {}
  }
  return JSON.stringify(positions);
}
]==]

local function hideAlerts()
    local ok, result, err = hs.osascript.javascript(hideAlertsJXA)
    if not ok then
        hs.alert.show("Hide 실패: " .. tostring(err))
        print("Hide err:", err)
        return
    end
    if result == "[]" then
        print("Hide: 화면에 보이는 알림 없음")
        return
    end
    hiddenStash = result
    print("Hide stashed:", result)
end

local function showAlerts()
    local script
    if hiddenStash then
        script = string.format([[
function run() {
  const POS = %s;
  const se = Application('System Events');
  let nc;
  try { nc = se.processes.byName('NotificationCenter'); } catch(e) { return 'no NC'; }
  let restored = 0;
  let idx = 0;
  for (let w of nc.windows()) {
    try {
      let p = w.position();
      if (p && p[0] < -5000 && idx < POS.length) {
        w.position = POS[idx];
        idx++;
        restored++;
      }
    } catch (_) {}
  }
  return 'restored: ' + restored;
}
        ]], hiddenStash)
    else
        -- 폴백: stash 없으면 우상단 기본 위치로
        local screen = hs.screen.primaryScreen()
        local frame = screen:fullFrame()
        local baseX = frame.x + frame.w - 380
        local baseY = frame.y + 30
        script = string.format([[
function run() {
  const se = Application('System Events');
  let nc;
  try { nc = se.processes.byName('NotificationCenter'); } catch(e) { return 'no NC'; }
  if (nc.windows.length === 0) return 'no windows';
  let restored = 0;
  let bx = %d, by = %d;
  for (let w of nc.windows()) {
    try {
      let p = w.position();
      if (p && p[0] < -5000) {
        w.position = [bx, by];
        by += 100;
        restored++;
      }
    } catch (_) {}
  }
  return 'restored(default): ' + restored;
}
        ]], baseX, baseY)
    end

    local ok, result, err = hs.osascript.javascript(script)
    if not ok then
        hs.alert.show("Show 실패: " .. tostring(err))
        print("Show err:", err)
        return
    end
    print("Show:", result)
    hiddenStash = nil
end

-- 알림 옆으로 슬쩍 치우기
hs.hotkey.bind({"ctrl", "cmd", "shift"}, "]", hideAlerts)

-- 치워뒀던 알림 다시 보이기
hs.hotkey.bind({"ctrl", "cmd", "shift"}, "[", showAlerts)