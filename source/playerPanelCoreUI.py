# -*- coding: utf-8 -*-
import copy
import Event
import BigWorld
import logging
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

logger = logging.getLogger(__name__)

class PlayerPanelCoreUIMeta(BaseDAAPIComponent):

    def _populate(self):
        try:
            super(PlayerPanelCoreUIMeta, self)._populate()
            g_events._populate(self)
        except Exception:
            logger.error('[PlayerPanelCore] Error during populate', exc_info=True)

    def _dispose(self):
        try:
            super(PlayerPanelCoreUIMeta, self)._dispose()
            g_events._dispose(self)
        except Exception:
            logger.error('[PlayerPanelCore] Error during dispose', exc_info=True)

    def flashLogS(self, *data):
        logger.debug('[PlayerPanelCore] Flash: %s', data)

    def as_createS(self, container, config):
        try:
            return self.flashObject.as_create(container, config) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_createS for container: %s', container, exc_info=True)
            return None

    def as_updateS(self, container, data):
        try:
            return self.flashObject.as_update(container, data) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_updateS for container: %s', container, exc_info=True)
            return None

    def as_deleteS(self, container):
        try:
            return self.flashObject.as_delete(container) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_deleteS for container: %s', container, exc_info=True)
            return None

    def as_updatePositionS(self, container, vehicleID):
        try:
            return self.flashObject.as_updatePosition(container, vehicleID) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_updatePositionS', exc_info=True)
            return None

    def as_shadowListItemS(self, shadow):
        try:
            return self.flashObject.as_shadowListItem(shadow) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_shadowListItemS', exc_info=True)
            return None

    def as_extendedSettingS(self, container, vehicleID):
        try:
            return self.flashObject.extendedSetting(container, vehicleID) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_extendedSettingS', exc_info=True)
            return None

    def as_getPPListItemS(self, vehicleID):
        try:
            return self.flashObject.as_getPPListItem(vehicleID) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_getPPListItemS for vehicleID: %s', vehicleID, exc_info=True)
            return None

    def as_hasOwnPropertyS(self, container):
        try:
            return self.flashObject.as_hasOwnProperty(container) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_hasOwnPropertyS', exc_info=True)
            return False

    def as_vehicleIconColorS(self, vehicleID, color):
        try:
            return self.flashObject.as_vehicleIconColor(vehicleID, color) if self._isDAAPIInited() else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in as_vehicleIconColorS', exc_info=True)
            return None


class Events(object):

    def __init__(self):
        self.impl = False
        self.viewLoad = False
        self.componentUI = None
        self.onUIReady = Event.Event()
        self.updateMode = Event.Event()
        
        self._original_methods = {}
        self._patchMethods()
        
        self.config = {
            'child': 'vehicleTF',
            'holder': 'vehicleIcon',
            'left': {'x': 0, 'y': 0, 'align': 'left', 'height': 24, 'width': 100},
            'right': {'x': 0, 'y': 0, 'align': 'right', 'height': 24, 'width': 100},
            'shadow': {'distance': 0, 'angle': 90, 'color': '#000000', 'alpha': 100, 'size': 2, 'strength': 200}
        }
        
        logger.info('[PlayerPanelCore] Loading mod: playerPanelCoreUI, [v.1.0.3 WOT: %s] by Ekspoint modified by Under', 
                    getShortClientVersion().replace('v.', '').strip())

    def _patchMethods(self):
        try:
            handleNextMode = PlayersPanel._handleNextMode
            as_setPanelModeS = PlayersPanelMeta.as_setPanelModeS
            _as_setPanelModeS = PlayersPanel.as_setPanelModeS
            _tryToSetPanelModeByMouse = PlayersPanel.tryToSetPanelModeByMouse
            tryToSetPanelModeByMouse = PlayersPanelMeta.tryToSetPanelModeByMouse
            updateVehiclesInfo = BattleStatisticsDataController.updateVehiclesInfo
            updateVehiclesStats = BattleStatisticsDataController.updateVehiclesStats
            setInitialMode = PlayersPanel.setInitialMode
            setLargeMode = PlayersPanel.setLargeMode
            
            PlayersPanel.setInitialMode = lambda base_self: self.setInitialMode(setInitialMode, base_self)
            PlayersPanel.setLargeMode = lambda base_self: self.setInitialMode(setLargeMode, base_self)
            PlayersPanel._handleNextMode = lambda base_self, value: self.setPanelMode(handleNextMode, base_self, value)
            
            if hasattr(PlayersPanel, '_PlayersPanel__handleShowExtendedInfo'):
                handleShowExtendedInfo = PlayersPanel._PlayersPanel__handleShowExtendedInfo
                PlayersPanel._PlayersPanel__handleShowExtendedInfo = lambda base_self, value: self.setPanelMode(handleShowExtendedInfo, base_self, value)
                logger.info('[PlayerPanelCore] __handleShowExtendedInfo patched')
            else:
                logger.warning('[PlayerPanelCore] __handleShowExtendedInfo not found, skipping patch')
            
            PlayersPanelMeta.as_setPanelModeS = lambda base_self, value: self.setPanelMode(as_setPanelModeS, base_self, value)
            PlayersPanel.as_setPanelModeS = lambda base_self, value: self.setPanelMode(_as_setPanelModeS, base_self, value)
            PlayersPanel.tryToSetPanelModeByMouse = lambda base_self, value: self.setPanelMode(_tryToSetPanelModeByMouse, base_self, value)
            PlayersPanelMeta.tryToSetPanelModeByMouse = lambda base_self, value: self.setPanelMode(tryToSetPanelModeByMouse, base_self, value)
            BattleStatisticsDataController.updateVehiclesInfo = lambda base_self, updated, arenaDP: self.updateVehicles(updateVehiclesInfo, base_self, updated, arenaDP)
            BattleStatisticsDataController.updateVehiclesStats = lambda base_self, updated, arenaDP: self.updateVehicles(updateVehiclesStats, base_self, updated, arenaDP)
            
            logger.info('[PlayerPanelCore] Methods patched successfully')
        except Exception:
            logger.error('[PlayerPanelCore] Error during method patching', exc_info=True)
            raise

    def updateVehicles(self, base, base_self, updated, arenaDP):
        try:
            base(base_self, updated, arenaDP)
            if self.impl:
                self.updateMode()
        except Exception:
            logger.error('[PlayerPanelCore] Error in updateVehicles', exc_info=True)

    def setInitialMode(self, base, base_self):
        try:
            base(base_self)
            if self.impl:
                self.updateMode()
        except Exception:
            logger.error('[PlayerPanelCore] Error in setInitialMode', exc_info=True)

    def setPanelMode(self, base, base_self, value):
        try:
            base(base_self, value)
            if self.impl:
                self.updateMode()
        except Exception:
            logger.error('[PlayerPanelCore] Error in setPanelMode', exc_info=True)

    def _populate(self, base_self):
        try:
            self.viewLoad = True
            self.componentUI = base_self
            self.onUIReady(self, 'playerPanelCoreUI', base_self)
            logger.debug('[PlayerPanelCore] Populate completed')
        except Exception:
            logger.error('[PlayerPanelCore] Error in _populate', exc_info=True)

    def _dispose(self, base_self):
        try:
            self.impl = False
            self.viewLoad = False
            self.componentUI = None
            logger.debug('[PlayerPanelCore] Dispose completed')
        except Exception:
            logger.error('[PlayerPanelCore] Error in _dispose', exc_info=True)

    def smart_update(self, dict1, dict2):
        try:
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
        except Exception:
            logger.error('[PlayerPanelCore] Error in smart_update', exc_info=True)
            return False

    def create(self, container, config=None):
        try:
            if not container:
                logger.warning('[PlayerPanelCore] create called with empty container')
                return None
            
            if self.componentUI:
                conf = copy.deepcopy(self.config)
                self.smart_update(conf, config if config else self.config)
                return self.componentUI.as_createS(container, conf)
            else:
                logger.warning('[PlayerPanelCore] create called but componentUI is None')
                return None
        except Exception:
            logger.error('[PlayerPanelCore] Error in create for container: %s', container, exc_info=True)
            return None

    def update(self, container, data):
        try:
            if not container or not data:
                logger.warning('[PlayerPanelCore] update called with invalid params')
                return None
            
            if self.componentUI:
                if 'text' in data:
                    data['text'] = data['text'].replace('$IMELanguageBar', '$FieldFont')
                return self.componentUI.as_updateS(container, data)
            else:
                logger.warning('[PlayerPanelCore] update called but componentUI is None')
                return None
        except Exception:
            logger.error('[PlayerPanelCore] Error in update', exc_info=True)
            return None

    def delete(self, container):
        try:
            if not container:
                logger.warning('[PlayerPanelCore] delete called with empty container')
                return None
            return self.componentUI.as_deleteS(container) if self.componentUI else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in delete', exc_info=True)
            return None

    def shadowListItem(self, shadow):
        try:
            return self.componentUI.as_shadowListItemS(shadow) if self.componentUI else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in shadowListItem', exc_info=True)
            return None

    def hasOwnProperty(self, container):
        try:
            return self.componentUI.as_hasOwnPropertyS(container) if self.componentUI else False
        except Exception:
            logger.error('[PlayerPanelCore] Error in hasOwnProperty', exc_info=True)
            return False

    def vehicleIconColor(self, vehicleID, color):
        try:
            if not vehicleID or not color:
                logger.warning('[PlayerPanelCore] vehicleIconColor called with invalid params')
                return None
            return self.componentUI.as_vehicleIconColorS(vehicleID, color) if self.componentUI else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in vehicleIconColor', exc_info=True)
            return None

    def extendedSetting(self, container, vehicleID):
        try:
            return self.componentUI.as_extendedSettingS(container, vehicleID) if self.componentUI else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in extendedSetting', exc_info=True)
            return None

    def getPPListItem(self, vehicleID):
        try:
            return self.componentUI.as_getPPListItemS(vehicleID) if self.componentUI else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in getPPListItem', exc_info=True)
            return None

    def updatePosition(self, container, vehicleID):
        try:
            return self.componentUI.as_updatePositionS(container, vehicleID) if self.componentUI else None
        except Exception:
            logger.error('[PlayerPanelCore] Error in updatePosition', exc_info=True)
            return None

    def onComponentRegistered(self, event):
        try:
            if event.alias == BATTLE_VIEW_ALIASES.PLAYERS_PANEL:
                if BigWorld.player().guiSessionProvider.arenaVisitor.gui.isEpicRandomBattle():
                    logger.debug('[PlayerPanelCore] Skipping Epic Random Battle')
                    return
                if BigWorld.player().guiSessionProvider.arenaVisitor.gui.isBattleRoyale():
                    logger.debug('[PlayerPanelCore] Skipping Battle Royale')
                    return
                
                self.impl = True
                ServicesLocator.appLoader.getDefBattleApp().loadView(
                    SFViewLoadParams('playerPanelCoreUI', 'playerPanelCoreUI'), {}
                )
                logger.info('[PlayerPanelCore] Component registered and view loaded')
        except Exception:
            logger.error('[PlayerPanelCore] Error in onComponentRegistered', exc_info=True)


if not g_entitiesFactories.getSettings('playerPanelCoreUI'):
    try:
        g_events = Events()
        g_entitiesFactories.addSettings(ViewSettings('playerPanelCoreUI', View, 'playerPanelCoreUI.swf', WindowLayer.WINDOW, None, ScopeTemplates.GLOBAL_SCOPE))
        g_entitiesFactories.addSettings(ComponentSettings('playerPanelCore', PlayerPanelCoreUIMeta, ScopeTemplates.DEFAULT_SCOPE))
        g_eventBus.addListener(events.ComponentEvent.COMPONENT_REGISTERED, g_events.onComponentRegistered, scope=EVENT_BUS_SCOPE.GLOBAL)
        logger.info('[PlayerPanelCore] Mod initialized successfully')
    except Exception:
        logger.error('[PlayerPanelCore] Fatal error during mod initialization', exc_info=True)