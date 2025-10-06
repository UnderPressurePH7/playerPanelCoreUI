# Python bytecode 2.7 (decompiled from Python 2.7)
# Embedded file name: playerPanelCoreUI
# Compiled at: 2022-06-01 20:37:14
import copy
import Event
import BigWorld
from Avatar import PlayerAvatar
from helpers import getShortClientVersion
from gui.shared.personality import ServicesLocator
from gui.shared import events, g_eventBus, EVENT_BUS_SCOPE
from gui.Scaleform.framework.entities.View import View
from gui.Scaleform.framework import g_entitiesFactories, ScopeTemplates, ViewSettings, ComponentSettings
from frameworks.wulf import WindowLayer
from gui.Scaleform.daapi.view.battle.classic.players_panel import PlayersPanel
from gui.Scaleform.framework.managers.loaders import SFViewLoadParams
from gui.Scaleform.genConsts.BATTLE_VIEW_ALIASES import BATTLE_VIEW_ALIASES
from gui.Scaleform.framework.entities.BaseDAAPIComponent import BaseDAAPIComponent
from gui.Scaleform.daapi.view.meta.PlayersPanelMeta import PlayersPanelMeta
from gui.Scaleform.daapi.view.battle.shared.stats_exchange.stats_ctrl import BattleStatisticsDataController

class PlayerPanelCoreUIMeta(BaseDAAPIComponent):

    def _populate(self):
        super(PlayerPanelCoreUIMeta, self)._populate()
        g_events._populate(self)

    def _dispose(self):
        super(PlayerPanelCoreUIMeta, self)._dispose()
        g_events._dispose(self)

    def flashLogS(self, *data):
        print 'PlayerPanelCoreMeta', data

    def as_createS(self, container, config):
        return self.flashObject.as_create(container, config) if self._isDAAPIInited() else None

    def as_updateS(self, container, data):
        return self.flashObject.as_update(container, data) if self._isDAAPIInited() else None

    def as_deleteS(self, container):
        return self.flashObject.as_delete(container) if self._isDAAPIInited() else None

    def as_updatePositionS(self, container, vehicleID):
        return self.flashObject.as_updatePosition(container, vehicleID) if self._isDAAPIInited() else None

    def as_shadowListItemS(self, shadow):
        return self.flashObject.as_shadowListItem(shadow) if self._isDAAPIInited() else None

    def as_extendedSettingS(self, container, vehicleID):
        return self.flashObject.extendedSetting(container, vehicleID) if self._isDAAPIInited() else None

    def as_getPPListItemS(self, vehicleID):
        return self.flashObject.as_getPPListItem(vehicleID) if self._isDAAPIInited() else None

    def as_hasOwnPropertyS(self, container):
        return self.flashObject.as_hasOwnProperty(container) if self._isDAAPIInited() else None

    def as_vehicleIconColorS(self, vehicleID, color):
        return self.flashObject.as_vehicleIconColor(vehicleID, color) if self._isDAAPIInited() else None


class Events(object):

    def __init__(self):
        self.impl = False
        self.viewLoad = False
        self.componentUI = None
        self.onUIReady = Event.Event()
        self.updateMode = Event.Event()
        handleNextMode = PlayersPanel._handleNextMode
        as_setPanelModeS = PlayersPanelMeta.as_setPanelModeS
        _as_setPanelModeS = PlayersPanel.as_setPanelModeS
        handleShowExtendedInfo = PlayersPanel._PlayersPanel__handleShowExtendedInfo
        _tryToSetPanelModeByMouse = PlayersPanel.tryToSetPanelModeByMouse
        tryToSetPanelModeByMouse = PlayersPanelMeta.tryToSetPanelModeByMouse
        updateVehiclesInfo = BattleStatisticsDataController.updateVehiclesInfo
        updateVehiclesStats = BattleStatisticsDataController.updateVehiclesStats
        setInitialMode = PlayersPanel.setInitialMode
        setLargeMode = PlayersPanel.setLargeMode
        PlayersPanel.setInitialMode = lambda base_self: self.setInitialMode(setInitialMode, base_self)
        PlayersPanel.setLargeMode = lambda base_self: self.setInitialMode(setLargeMode, base_self)
        PlayersPanel._handleNextMode = lambda base_self, value: self.setPanelMode(handleNextMode, base_self, value)
        PlayersPanel._PlayersPanel__handleShowExtendedInfo = lambda base_self, value: self.setPanelMode(handleShowExtendedInfo, base_self, value)
        PlayersPanelMeta.as_setPanelModeS = lambda base_self, value: self.setPanelMode(as_setPanelModeS, base_self, value)
        PlayersPanel.as_setPanelModeS = lambda base_self, value: self.setPanelMode(_as_setPanelModeS, base_self, value)
        PlayersPanel.tryToSetPanelModeByMouse = lambda base_self, value: self.setPanelMode(_tryToSetPanelModeByMouse, base_self, value)
        PlayersPanelMeta.tryToSetPanelModeByMouse = lambda base_self, value: self.setPanelMode(tryToSetPanelModeByMouse, base_self, value)
        BattleStatisticsDataController.updateVehiclesInfo = lambda base_self, updated, arenaDP: self.updateVehicles(updateVehiclesInfo, base_self, updated, arenaDP)
        BattleStatisticsDataController.updateVehiclesStats = lambda base_self, updated, arenaDP: self.updateVehicles(updateVehiclesStats, base_self, updated, arenaDP)
        self.config = {'child': 'vehicleTF',
         'holder': 'vehicleIcon',
         'left': {'x': 0,
                  'y': 0,
                  'align': 'left',
                  'height': 24,
                  'width': 100},
         'right': {'x': 0,
                   'y': 0,
                   'align': 'right',
                   'height': 24,
                   'width': 100},
         'shadow': {'distance': 0,
                    'angle': 90,
                    'color': '#000000',
                    'alpha': 100,
                    'size': 2,
                    'strength': 200}}
        print '[NOTE] Loading mod: playerPanelCoreUI, [v.1.0.1 WOT: {}] by Ekspoint'.format(getShortClientVersion().replace('v.', '').strip())
        return

    def updateVehicles(self, base, base_self, updated, arenaDP):
        base(base_self, updated, arenaDP)
        if self.impl:
            self.updateMode()

    def setInitialMode(self, base, base_self):
        base(base_self)
        if self.impl:
            self.updateMode()

    def setPanelMode(self, base, base_self, value):
        base(base_self, value)
        if self.impl:
            self.updateMode()

    def _populate(self, base_self):
        self.viewLoad = True
        self.componentUI = base_self
        self.onUIReady(self, 'playerPanelCoreUI', base_self)

    def _dispose(self, base_self):
        self.impl = False
        self.viewLoad = False
        self.componentUI = None
        return

    def smart_update(self, dict1, dict2):
        changed = False
        for k in dict1:
            v = dict2.get(k)
            if isinstance(v, dict):
                changed |= self.smart_update(dict1[k], v)
            if v is not None:
                if isinstance(v, unicode):
                    v = v.encode('utf-8')
                changed |= dict1[k] != v
                dict1[k] = v

        return changed

    def create(self, container, config=None):
        if self.componentUI:
            conf = copy.deepcopy(self.config)
            self.smart_update(conf, config if config else self.config)
            return self.componentUI.as_createS(container, conf)
        else:
            return None

    def update(self, container, data):
        if self.componentUI:
            data['text'] = data['text'].replace('$IMELanguageBar', '$FieldFont')
            return self.componentUI.as_updateS(container, data)
        else:
            return None

    def delete(self, container):
        return self.componentUI.as_deleteS(container) if self.componentUI else None

    def shadowListItem(self, shadow):
        return self.componentUI.as_shadowListItemS(shadow) if self.componentUI else None

    def hasOwnProperty(self, container):
        return self.componentUI.as_hasOwnPropertyS(container) if self.componentUI else None

    def vehicleIconColor(self, vehicleID, color):
        return self.componentUI.as_vehicleIconColorS(vehicleID, color) if self.componentUI else None

    def extendedSetting(self, container, vehicleID):
        return self.componentUI.as_extendedSettingS(container, vehicleID) if self.componentUI else None

    def getPPListItem(self, vehicleID):
        return self.componentUI.as_getPPListItemS(vehicleID) if self.componentUI else None

    def updatePosition(self, container, vehicleID):
        return self.componentUI.as_updatePositionS(container, vehicleID) if self.componentUI else None

    def onComponentRegistered(self, event):
        if event.alias == BATTLE_VIEW_ALIASES.PLAYERS_PANEL:
            if BigWorld.player().guiSessionProvider.arenaVisitor.gui.isEpicRandomBattle():
                return
            if BigWorld.player().guiSessionProvider.arenaVisitor.gui.isBattleRoyale():
                return
            self.impl = True
            ServicesLocator.appLoader.getDefBattleApp().loadView(SFViewLoadParams('playerPanelCoreUI', 'playerPanelCoreUI'), {})


if not g_entitiesFactories.getSettings('playerPanelCoreUI'):
    g_events = Events()
    g_entitiesFactories.addSettings(ViewSettings('playerPanelCoreUI', View, 'playerPanelCoreUI.swf', WindowLayer.WINDOW, None, ScopeTemplates.GLOBAL_SCOPE))
    g_entitiesFactories.addSettings(ComponentSettings('playerPanelCore', PlayerPanelCoreUIMeta, ScopeTemplates.DEFAULT_SCOPE))
    g_eventBus.addListener(events.ComponentEvent.COMPONENT_REGISTERED, g_events.onComponentRegistered, scope=EVENT_BUS_SCOPE.GLOBAL)