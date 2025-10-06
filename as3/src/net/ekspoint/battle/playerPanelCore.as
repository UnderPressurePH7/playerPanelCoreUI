package net.ekspoint.battle
{
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.ekspoint.injector.BattleDisplayable;
   import net.ekspoint.utils.Utils;
   import net.wg.gui.battle.components.*;
   import net.wg.gui.battle.random.views.BattlePage;
   import scaleform.gfx.TextFieldEx;
   
   public class playerPanelCore extends BattleDisplayable
   {
      private static const POOL_SIZE:int = 30;
      private var textFieldPool:Vector.<TextField> = new Vector.<TextField>();
      
      public var flashLogS:Function;
      
      private var configs:Object = new Object();
      private var textFields:Object = new Object();
      private var eventListeners:Vector.<BattleAtlasSprite> = new Vector.<BattleAtlasSprite>();
      
      public function playerPanelCore()
      {
         super();
         name = this.componentName;
         this.initializeTextFieldPool();
      }
      
      private function initializeTextFieldPool() : void
      {
         for (var i:int = 0; i < POOL_SIZE; i++)
         {
            this.textFieldPool.push(this.createPooledTextField());
         }
      }
      
      private function createPooledTextField() : TextField
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
      
      private function getTextFieldFromPool() : TextField
      {
         if (this.textFieldPool.length > 0)
         {
            return this.textFieldPool.pop();
         }
         return this.createPooledTextField();
      }
      
      private function returnTextFieldToPool(tf:TextField) : void
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
      
      public function as_create(param1:String, param2:Object) : void
      {
         if (!param1 || param1.length == 0)
         {
            this.logError("as_create: invalid container name");
            return;
         }
         if (!param2)
         {
            this.logError("as_create: config is null");
            return;
         }
         
         try
         {
            this.createComponent(param1, param2);
         }
         catch (e:Error)
         {
            this.logError("as_create error: " + e.message);
         }
      }
      
      public function as_update(param1:String, param2:Object) : void
      {
         if (!param1 || !param2)
         {
            this.logError("as_update: invalid parameters");
            return;
         }
         
         try
         {
            this.updateComponent(param1, param2);
         }
         catch (e:Error)
         {
            this.logError("as_update error: " + e.message);
         }
      }
      
      public function as_hasOwnProperty(param1:String) : Boolean
      {
         if (!param1) return false;
         
         var result:Boolean = false;
         try
         {
            result = this.hasOwnPropertyComponent(param1);
         }
         catch (e:Error)
         {
            this.logError("as_hasOwnProperty error: " + e.message);
            result = false;
         }
         return result;
      }
      
      public function as_delete(param1:String) : void
      {
         if (!param1)
         {
            this.logError("as_delete: invalid container name");
            return;
         }
         
         try
         {
            this.deleteComponent(param1);
         }
         catch (e:Error)
         {
            this.logError("as_delete error: " + e.message);
         }
      }
      
      private function hasOwnPropertyComponent(param1:String) : Boolean
      {
         return this.configs.hasOwnProperty(param1);
      }
      
      private function createComponent(param1:String, param2:Object) : void
      {
         this.configs[param1] = param2;
         this.textFields[param1] = {};
      }
      
      public function deleteComponent(param1:String) : void
      {
         try
         {
            if (this.textFields.hasOwnProperty(param1))
            {
               var fields:Object = this.textFields[param1];
               for (var vehicleId:String in fields)
               {
                  this.returnTextFieldToPool(fields[vehicleId]);
               }
            }
            
            delete this.configs[param1];
            delete this.textFields[param1];
         }
         catch (e:Error)
         {
            this.logError("deleteComponent error: " + e.message);
         }
      }
      
      private function getListItem(param1:*, param2:Number) : *
      {
         if (!param1 || !param1._items) return null;
         
         var result:* = null;
         try
         {
            var _loc3_:int = int(param1._items.length);
            for (var _loc4_:int = 0; _loc4_ < _loc3_; _loc4_++)
            {
               if (param1._items[_loc4_].vehicleID == param2)
               {
                  result = param1._items[_loc4_]._listItem;
                  break;
               }
            }
         }
         catch (e:Error)
         {
            this.logError("getListItem error: " + e.message);
            result = null;
         }
         return result;
      }
      
      public function as_getPPListItem(param1:int) : *
      {
         var result:* = null;
         try
         {
            var panel:* = (this.battlePage as BattlePage).playersPanel.listRight;
            if (!panel || !panel.getHolderByVehicleID(int(param1)))
            {
               panel = (this.battlePage as BattlePage).playersPanel.listLeft;
            }
            result = this.getListItem(panel, param1);
         }
         catch (e:Error)
         {
            this.logError("as_getPPListItem error: " + e.message);
            result = null;
         }
         return result;
      }
      
      private function isRightP(param1:int) : Boolean
      {
         var result:Boolean = false;
         try
         {
            var panel:* = (this.battlePage as BattlePage).playersPanel.listRight;
            if (panel && panel.getHolderByVehicleID(int(param1)))
            {
               result = true;
            }
         }
         catch (e:Error)
         {
            this.logError("isRightP error: " + e.message);
            result = false;
         }
         return result;
      }
      
      public function as_updatePosition(param1:String, param2:int) : void
      {
         if (!param1) return;
         
         try
         {
            var listItem:* = undefined;
            var config:Object = null;
            var isRight:Boolean = this.isRightP(param2);
            
            if (!this.textFields[param1].hasOwnProperty(int(param2)))
            {
               this.createPpanelTF(param1, int(param2));
            }
            
            listItem = this.as_getPPListItem(int(param2));
            if (!listItem) return;
            
            config = this.configs[param1][isRight ? "right" : "left"];
            
            var tf:TextField = this.textFields[param1][param2];
            if (tf)
            {
               tf.x = listItem[this.configs[param1]["holder"]].x + config.x;
               tf.y = listItem[this.configs[param1]["holder"]].y + config.y;
            }
         }
         catch (e:Error)
         {
            this.logError("as_updatePosition error: " + e.message);
         }
      }
      
      public function as_shadowListItem(param1:Object) : *
      {
         var result:* = null;
         try
         {
            if (param1)
            {
               result = Utils.getDropShadowFilter(
                  param1.distance, param1.angle, param1.color, 
                  param1.alpha, param1.size, param1.strength
               );
            }
         }
         catch (e:Error)
         {
            this.logError("as_shadowListItem error: " + e.message);
            result = null;
         }
         return result;
      }
      
      public function extendedSetting(param1:String, param2:int) : *
      {
         var result:* = null;
         try
         {
            if (!this.textFields[param1].hasOwnProperty(int(param2)))
            {
               this.createPpanelTF(param1, int(param2));
            }
            result = this.textFields[param1][param2];
         }
         catch (e:Error)
         {
            this.logError("extendedSetting error: " + e.message);
            result = null;
         }
         return result;
      }
      
      public function as_vehicleIconColor(param1:int, param2:String) : void
      {
         try
         {
            var vehicleIcon:BattleAtlasSprite = null;
            var listItem:* = this.as_getPPListItem(int(param1));
            
            if (listItem)
            {
               vehicleIcon = listItem.vehicleIcon;
               if (vehicleIcon)
               {
                  vehicleIcon["playerPanelCoreUI"] = {"color": Utils.colorConvert(param2)};
                  if (!vehicleIcon.hasEventListener(Event.RENDER))
                  {
                     vehicleIcon.addEventListener(Event.RENDER, this.onRenderHendle);
                     this.eventListeners.push(vehicleIcon);
                  }
               }
            }
         }
         catch (e:Error)
         {
            this.logError("as_vehicleIconColor error: " + e.message);
         }
      }
      
      private function onRenderHendle(param1:Event) : void
      {
         try
         {
            var sprite:BattleAtlasSprite = param1.target as BattleAtlasSprite;
            if (!sprite || !sprite["playerPanelCoreUI"]) return;
            
            var cTransform:ColorTransform = sprite.transform.colorTransform;
            cTransform.color = sprite["playerPanelCoreUI"]["color"];
            sprite.transform.colorTransform = cTransform;
         }
         catch (e:Error)
         {
            this.logError("onRenderHendle error: " + e.message);
         }
      }
      
      private function updateComponent(param1:String, param2:Object) : void
      {
         if (!param2 || !param2.hasOwnProperty("vehicleID")) return;
         
         try
         {
            var vehicleId:int = int(param2.vehicleID);
            if (!this.textFields[param1].hasOwnProperty(vehicleId))
            {
               this.createPpanelTF(param1, vehicleId);
            }
            
            var tf:TextField = this.textFields[param1][vehicleId];
            if (tf && param2.hasOwnProperty("text"))
            {
               tf.htmlText = param2.text;
            }
         }
         catch (e:Error)
         {
            this.logError("updateComponent error: " + e.message);
         }
      }
      
      private function createPpanelTF(param1:String, param2:int) : void
      {
         try
         {
            var childIndex:Number = 0;
            var listItem:* = undefined;
            var posConfig:Object = null;
            var shadowConfig:Object = null;
            var isRight:Boolean = this.isRightP(param2);
            var tf:TextField = null;
            var shadow:DropShadowFilter = null;
            
            listItem = this.as_getPPListItem(int(param2));
            if (!listItem) return;
            
            posConfig = this.configs[param1][isRight ? "right" : "left"];
            shadowConfig = this.configs[param1]["shadow"];
            
            tf = this.getTextFieldFromPool();
            
            childIndex = Number(listItem.getChildIndex(listItem[this.configs[param1]["child"]]));
            listItem.addChildAt(tf, childIndex + 1);

            tf.width = posConfig.width;
            tf.height = posConfig.height;
            tf.autoSize = posConfig.align;
            
            shadow = Utils.getDropShadowFilter(
               shadowConfig.distance, shadowConfig.angle, shadowConfig.color,
               shadowConfig.alpha, shadowConfig.size, shadowConfig.strength
            );
            tf.filters = [shadow];
            
            tf.x = listItem[this.configs[param1]["holder"]].x + posConfig.x;
            tf.y = listItem[this.configs[param1]["holder"]].y + posConfig.y;
            
            this.textFields[param1][param2] = tf;
         }
         catch (e:Error)
         {
            this.logError("createPpanelTF error: " + e.message);
         }
      }
      
      override protected function onDispose() : void
      {
         try
         {
            this.cleanupEventListeners();
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

      private function cleanupEventListeners() : void
      {
         try
         {
            for each (var sprite:BattleAtlasSprite in this.eventListeners)
            {
               if (sprite && sprite.hasEventListener(Event.RENDER))
               {
                  sprite.removeEventListener(Event.RENDER, this.onRenderHendle);
               }
            }
            this.eventListeners.length = 0;
         }
         catch (e:Error)
         {
            this.logError("cleanupEventListeners error: " + e.message);
         }
      }
      
      private function cleanupTextFields() : void
      {
         try
         {
            for (var container:String in this.textFields)
            {
               var fields:Object = this.textFields[container];
               for (var vehicleId:String in fields)
               {
                  var tf:TextField = fields[vehicleId] as TextField;
                  this.returnTextFieldToPool(tf);
               }
            }
         }
         catch (e:Error)
         {
            this.logError("cleanupTextFields error: " + e.message);
         }
      }
      
      private function cleanupPool() : void
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
      
      private function logError(message:String) : void
      {
         if (this.flashLogS != null)
         {
            this.flashLogS("[ERROR]", message);
         }
         trace("[PlayerPanelCore ERROR]", message);
      }
   }
}