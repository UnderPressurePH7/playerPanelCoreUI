package net.ekspoint.battle
{
   import flash.text.TextField;
   import net.ekspoint.injector.BattleDisplayable;
   import net.ekspoint.utils.Utils;
   import net.wg.gui.battle.random.views.BattlePage;
   import net.wg.gui.battle.ranked.stats.components.fullStats.FullStatsTable;
   import net.ekspoint.battle.views.FullStatsTableItem;
   import net.ekspoint.battle.views.FullStatsTableCtrl;
   import flash.filters.DropShadowFilter;
   import scaleform.gfx.TextFieldEx;
   import flash.text.TextFormat;
   import flash.text.AntiAliasType;

   public class tabCore extends BattleDisplayable
   {
      private static const POOL_SIZE:int = 30;
      private var textFieldPool:Vector.<TextField> = new Vector.<TextField>();
      
      public var flashLogS:Function;
      
      private var configs:Object = new Object();
      private var textFields:Object = new Object();
      
      public function tabCore()
      {
         super();
         name = this.componentName;
         this.initializeTextFieldPool();
      }
      
      private function initializeTextFieldPool():void
      {
         for (var i:int = 0; i < POOL_SIZE; i++)
         {
            this.textFieldPool.push(this.createPooledTextField());
         }
      }
      
      private function createPooledTextField():TextField
      {
         var tf:TextField = new TextField();
         TextFieldEx.setNoTranslate(tf, true);
         tf.defaultTextFormat = new TextFormat("$UniversCondC", 16, 0xFFFFFF, false, false, false, "", "", "left", 0, 0, 0, 0);
         tf.mouseEnabled = false;
         tf.background = false;
         tf.backgroundColor = 0;
         tf.embedFonts = true;
         tf.multiline = true;
         tf.selectable = false;
         tf.tabEnabled = false;
         tf.antiAliasType = AntiAliasType.ADVANCED;
         return tf;
      }
      
      private function getTextFieldFromPool():TextField
      {
         if (this.textFieldPool.length > 0)
         {
            return this.textFieldPool.pop();
         }
         return this.createPooledTextField();
      }
      
      private function returnTextFieldToPool(tf:TextField):void
      {
         if (!tf) return;

         tf.text = "";
         tf.htmlText = "";
         tf.filters = null;
         if (tf.parent)
         {
            tf.parent.removeChild(tf);
         }
         
         if (this.textFieldPool.length < POOL_SIZE)
         {
            this.textFieldPool.push(tf);
         }
      }
      
      public function as_create(container:String, config:Object):void
      {
         if (!container || container.length == 0)
         {
            this.logError("as_create: invalid container name");
            return;
         }
         if (!config)
         {
            this.logError("as_create: config is null");
            return;
         }
         
         try
         {
            this.createComponent(container, config);
         }
         catch (e:Error)
         {
            this.logError("as_create error: " + e.message);
         }
      }
      
      public function as_update(container:String, data:Object):void
      {
         if (!container || !data)
         {
            this.logError("as_update: invalid parameters");
            return;
         }
         
         try
         {
            this.updateComponent(container, data);
         }
         catch (e:Error)
         {
            this.logError("as_update error: " + e.message);
         }
      }
      
      public function as_delete(container:String):void
      {
         if (!container)
         {
            this.logError("as_delete: invalid container name");
            return;
         }
         
         try
         {
            this.deleteComponent(container);
         }
         catch (e:Error)
         {
            this.logError("as_delete error: " + e.message);
         }
      }

      private function createComponent(container:String, config:Object):void
      {
         this.configs[container] = config;
         this.textFields[container] = {};
      }
      
      public function deleteComponent(container:String):void
      {
         try
         {
            if (this.textFields.hasOwnProperty(container))
            {
               var fields:Object = this.textFields[container];
               for (var vehicleId:String in fields)
               {
                  this.returnTextFieldToPool(fields[vehicleId]);
               }
            }
            
            delete this.configs[container];
            delete this.textFields[container];
         }
         catch (e:Error)
         {
            this.logError("deleteComponent error: " + e.message);
         }
      }

      private function getStatsItem(vehicleID:int):FullStatsTableItem
      {
         var result:FullStatsTableItem = null;
         try
         {
            var statsCtrl:FullStatsTableCtrl = (this.battlePage as BattlePage).fullStats.tableCtrl as FullStatsTableCtrl;
            if (statsCtrl) {
                for each (var renderer:* in statsCtrl._allyRenderers) {
                    if (renderer.data.vehicleID == vehicleID) {
                        result = renderer.statsItem as FullStatsTableItem;
                        break;
                    }
                }
                if (!result) {
                    for each (var renderer:* in statsCtrl._enemyRenderers) {
                        if (renderer.data.vehicleID == vehicleID) {
                            result = renderer.statsItem as FullStatsTableItem;
                            break;
                        }
                    }
                }
            }
         }
         catch (e:Error)
         {
            this.logError("getStatsItem error: " + e.message);
            result = null;
         }
         return result;
      }
      
      private function updateComponent(container:String, data:Object):void
      {
         if (!data || !data.hasOwnProperty("vehicleID")) return;
         
         try
         {
            var vehicleId:int = int(data.vehicleID);
            if (!this.textFields[container].hasOwnProperty(vehicleId))
            {
               this.createTabTF(container, vehicleId);
            }
            
            var tf:TextField = this.textFields[container][vehicleId];
            if (tf && data.hasOwnProperty("text"))
            {
               tf.htmlText = data.text;
            }
         }
         catch (e:Error)
         {
            this.logError("updateComponent error: " + e.message);
         }
      }
      
      private function createTabTF(container:String, vehicleID:int):void
      {
         try
         {
            var statsItem:FullStatsTableItem = this.getStatsItem(vehicleID);
            if (!statsItem) return;

            var isEnemy:Boolean = statsItem._isEnemy;
            var posConfig:Object = this.configs[container][isEnemy ? "right" : "left"];
            var shadowConfig:Object = this.configs[container]["shadow"];
            
            var tf:TextField = this.getTextFieldFromPool();
            
            statsItem.addChild(tf);

            tf.width = posConfig.width;
            tf.height = posConfig.height;
            tf.autoSize = posConfig.align;
            
            var shadow:DropShadowFilter = Utils.getDropShadowFilter(
               shadowConfig.distance, shadowConfig.angle, shadowConfig.color,
               shadowConfig.alpha, shadowConfig.size, shadowConfig.strength
            );
            tf.filters = [shadow];

            var holder:Object = statsItem[this.configs[container]["holder"]];
            if (holder) {
                tf.x = holder.x + posConfig.x;
                tf.y = holder.y + posConfig.y;
            } else {
                tf.x = posConfig.x;
                tf.y = posConfig.y;
            }
            
            this.textFields[container][vehicleID] = tf;
         }
         catch (e:Error)
         {
            this.logError("createTabTF error: " + e.message);
         }
      }
      
      override protected function onDispose():void
      {
         try
         {
            this.cleanupTextFields();
            this.configs = null;
            this.textFields = null;
            this.cleanupPool();
            super.onDispose();
         }
         catch (e:Error)
         {
            this.logError("onDispose error: " + e.message);
         }
      }
      
      private function cleanupTextFields():void
      {
         try
         {
            for (var container:String in this.textFields)
            {
               var fields:Object = this.textFields[container];
               for (var vehicleId:String in fields)
               {
                  this.returnTextFieldToPool(fields[vehicleId] as TextField);
               }
            }
         }
         catch (e:Error)
         {
            this.logError("cleanupTextFields error: " + e.message);
         }
      }
      
      private function cleanupPool():void
      {
         try
         {
            for each (var tf:TextField in this.textFieldPool)
            {
               if (tf)
               {
                  tf.filters = null;
                  if (tf.parent)
                  {
                     tf.parent.removeChild(tf);
                  }
               }
            }
            this.textFieldPool.length = 0;
            this.textFieldPool = null;
         }
         catch (e:Error)
         {
            this.logError("cleanupPool error: " + e.message);
         }
      }
      
      private function logError(message:String):void
      {
         if (this.flashLogS != null)
         {
            this.flashLogS("[ERROR] [tabCore]", message);
         }
         trace("[tabCore ERROR]", message);
      }
   }
}