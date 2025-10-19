package net.ekspoint.battle.views.FullStatsTableItem
{
   import flash.display.MovieClip;
   import mx.wotlab.gui.battle.data.StatisticDataCache;
   import mx.wotlab.gui.battle.events.StatisticDataEvent;
   import net.wg.gui.battle.ranked.stats.components.fullStats.tableItem.StatsTableItem;
   
   public dynamic class FullStatsTableItem extends StatsTableItem
   {
      
      private var vehicleID:int = 0;
      
      private var statsCacheMgr:StatisticDataCache;
      
      public function FullStatsTableItem(param1:MovieClip, param2:int, param3:int)
      {
         super(param1,param2,param3);
         this.statsCacheMgr = StatisticDataCache.getInstance();
         this.statsCacheMgr.addEventListener(StatisticDataEvent.NEW_STATS_RECEIVED,this.onNewStatsReceived,false,0,true);
      }
      
      private function onNewStatsReceived(param1:StatisticDataEvent) : void
      {
         if(param1.vehicleID == this.vehicleID)
         {
            this.updateStatsDataTF();
         }
      }
      
      private function updateStatsDataTF() : void
      {
         var _loc2_:String = null;
         var _loc1_:Object = this.statsCacheMgr.getStatsData(this.vehicleID);
         if(_loc1_)
         {
            _loc2_ = this._isEnemy ? "right" : "left";
            this._playerNameTF.width = _loc1_.FS_playerName_width;
            this._playerNameTF.htmlText = _loc1_["FS_playerName_" + _loc2_];
            this._vehicleNameTF.htmlText = _loc1_["FS_vehicleName_" + _loc2_];
            this._vehicleNameTF.width = _loc1_.FS_vehicleName_width;
            if(!this._isEnemy)
            {
               this._vehicleNameTF.x = this._vehicleTypeIcon.x - this._vehicleNameTF.width - 8;
            }
         }
      }
      
      override protected function draw() : void
      {
         super.draw();
         this.updateStatsDataTF();
         if(this.isDead)
         {
            this._playerNameTF.alpha = 0.8;
            this._vehicleNameTF.alpha = 0.8;
         }
      }
      
      override protected function onDispose() : void
      {
         if(this.statsCacheMgr)
         {
            this.statsCacheMgr.removeEventListener(StatisticDataEvent.NEW_STATS_RECEIVED,this.onNewStatsReceived);
         }
         super.onDispose();
      }
   }
}

