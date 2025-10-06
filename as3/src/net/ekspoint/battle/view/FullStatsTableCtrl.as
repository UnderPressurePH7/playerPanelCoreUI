package mx.wotlab.gui.battle.views.stats.fullStats
{
   import net.wg.gui.battle.ranked.stats.components.fullStats.FullStatsTable;
   import net.wg.gui.battle.ranked.stats.components.fullStats.FullStatsTableCtrl;
   import net.wg.infrastructure.events.ListDataProviderEvent;
   
   public dynamic class FullStatsTableCtrl extends net.wg.gui.battle.ranked.stats.components.fullStats.FullStatsTableCtrl
   {
      
      public function FullStatsTableCtrl(param1:FullStatsTable)
      {
         super(param1);
      }
      
      override protected function onEnemyDataProviderUpdateItemHandler(param1:ListDataProviderEvent) : void
      {
         super.onEnemyDataProviderUpdateItemHandler(param1);
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:uint = this._enemyRenderers.length - 1;
         var _loc5_:Vector.<int> = Vector.<int>(param1.data);
         for each(_loc2_ in _loc5_)
         {
            if(_loc2_ <= _loc4_)
            {
               _loc3_ = this._enemyRenderers[_loc2_];
               _loc3_.statsItem.vehicleID = _loc3_.data.vehicleID;
            }
         }
      }
      
      override protected function onAllyDataProviderUpdateItemHandler(param1:ListDataProviderEvent) : void
      {
         super.onAllyDataProviderUpdateItemHandler(param1);
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:uint = this._allyRenderers.length - 1;
         var _loc5_:Vector.<int> = Vector.<int>(param1.data);
         for each(_loc2_ in _loc5_)
         {
            if(_loc2_ <= _loc4_)
            {
               _loc3_ = this._allyRenderers[_loc2_];
               _loc3_.statsItem.vehicleID = _loc3_.data.vehicleID;
            }
         }
      }
      
      private function createPlayerStatsItem(param1:int, param2:int) : *
      {
         return new FullStatsTableItem(this._table,param1,param2);
      }
   }
}

