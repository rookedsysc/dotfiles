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

-- NotificationCenter 알림 모두 닫기
-- ⚠️ 시스템 설정 → 개인정보 보호 및 보안 → 손쉬운 사용 에서 Hammerspoon/osascript 허용 필요.
local function closeAllNotifications()
    local scriptPath = os.getenv("HOME") .. "/.hammerspoon/scripts/close_notifications_applescript.js"

    hs.task.new("/usr/bin/osascript", function(exitCode, stdout, stderr)
        if exitCode ~= 0 then
            hs.alert.show("알림 닫기 실패: " .. tostring(stderr))
        end
    end, { "-l", "JavaScript", scriptPath }):start()
end

hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "]", closeAllNotifications)