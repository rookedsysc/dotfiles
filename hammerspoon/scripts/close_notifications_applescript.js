function run() {
  const currentApp = Application.currentApplication();
  currentApp.includeStandardAdditions = true;

  const scriptName = 'close_notifications_applescript';
  const closeActionNames = [
    'Close',
    'Clear All',
    'Clear',
    '닫기',
    '모두 지우기',
    '지우기',
  ];
  const notificationSubroles = [
    'AXNotificationCenterAlert',
    'AXNotificationCenterAlertStack',
  ];
  const maxAttempts = 100;
  const timeoutMs = 30000;
  const startedAt = Date.now();
  const logs = [];

  const log = (message) => {
    const line = `${new Date().toISOString()} [${scriptName}] ${message}`;
    console.log(line);
    logs.push(line);
  };

  const safe = (fn, fallback) => {
    try {
      return fn();
    } catch (_) {
      return fallback;
    }
  };

  const lower = (value) => String(value || '').toLowerCase();
  const matchesActionName = (value) => closeActionNames.some((name) => lower(name) === lower(value));

  const getNotificationCenter = () => {
    const systemEvents = Application('System Events');
    systemEvents.includeStandardAdditions = true;
    return systemEvents.processes.byName('NotificationCenter');
  };

  const getChildren = (element) => {
    return safe(() => element.uiElements(), []);
  };

  const isNotificationContainer = (element) => {
    const subrole = safe(() => element.subrole(), '');
    return notificationSubroles.indexOf(subrole) !== -1;
  };

  const isClearButton = (element) => {
    const role = safe(() => element.role(), '');
    const description = safe(() => element.description(), '');
    const name = safe(() => element.name(), '');
    const title = safe(() => element.title(), '');

    return (role === 'AXButton' || description === 'button') &&
      (matchesActionName(name) || matchesActionName(title));
  };

  const findCloseAction = (element) => {
    const actions = safe(() => element.actions(), []);

    for (const action of actions) {
      const description = safe(() => action.description(), '');
      if (matchesActionName(description)) {
        return action;
      }
      if (isClearButton(element) && lower(description) === 'press') {
        return action;
      }
    }

    return null;
  };

  const findNextCloseAction = (elements) => {
    for (const element of elements) {
      if (isNotificationContainer(element) || isClearButton(element)) {
        const action = findCloseAction(element);
        if (action) {
          return action;
        }
      }

      const childAction = findNextCloseAction(getChildren(element));
      if (childAction) {
        return childAction;
      }
    }

    return null;
  };

  const getRootElements = () => {
    const notificationCenter = getNotificationCenter();
    const windows = safe(() => notificationCenter.windows(), []);
    let roots = [];

    for (const window of windows) {
      roots = roots.concat([window], getChildren(window));
    }

    return roots;
  };

  let closedCount = 0;

  try {
    for (let attempt = 0; attempt < maxAttempts && Date.now() - startedAt < timeoutMs; attempt += 1) {
      const action = findNextCloseAction(getRootElements());
      if (!action) {
        break;
      }

      const performed = safe(() => {
        action.perform();
        return true;
      }, false);
      if (performed) {
        closedCount += 1;
      }
      safe(() => delay(0.05), null);
    }

    log(`closed ${closedCount} notification action(s)`);
    return logs.join('\n');
  } catch (error) {
    log(`ERROR ${String(error)}`);
    throw error;
  }
}
