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
         if (!tf)
         {
            return;
         }

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
         if (!param1)
         {
            return false;
         }
         
         try
         {
            return this.hasOwnPropertyComponent(param1);
         }
         catch (e:Error)
         {
            this.logError("as_hasOwnProperty error: " + e.message);
            return false;
         }
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
         if (!param1 || !param1._items)
         {
            return null;
         }
         
         try
         {
            var _loc3_:int = int(param1._items.length);
            var _loc4_:int = 0;
            while(_loc4_ < _loc3_)
            {
               if (param1._items[_loc4_].vehicleID == param2)
               {
                  return param1._items[_loc4_]._listItem;
               }
               _loc4_++;
            }
         }
         catch (e:Error)
         {
            this.logError("getListItem error: " + e.message);
         }
         
         return null;
      }
      
      public function as_getPPListItem(param1:int) : *
      {
         try
         {
            var _loc2_:* = (this.battlePage as BattlePage).playersPanel.listRight;
            if (!_loc2_.getHolderByVehicleID(int(param1)))
            {
               _loc2_ = (this.battlePage as BattlePage).playersPanel.listLeft;
               return this.getListItem(_loc2_, param1);
            }
            return this.getListItem(_loc2_, param1);
         }
         catch (e:Error)
         {
            this.logError("as_getPPListItem error: " + e.message);
            return null;
         }
      }
      
      private function isRightP(param1:int) : Boolean
      {
         try
         {
            var _loc2_:* = (this.battlePage as BattlePage).playersPanel.listRight;
            if (!_loc2_.getHolderByVehicleID(int(param1)))
            {
               return false;
            }
            return true;
         }
         catch (e:Error)
         {
            this.logError("isRightP error: " + e.message);
            return false;
         }
      }
      
      public function as_updatePosition(param1:String, param2:int) : void
      {
         if (!param1)
         {
            return;
         }
         
         try
         {
            var _loc3_:* = undefined;
            var _loc4_:Object = null;
            var _loc5_:Boolean = this.isRightP(param2);
            
            if (!this.textFields[param1].hasOwnProperty(int(param2)))
            {
               this.createPpanelTF(param1, int(param2));
            }
            
            _loc3_ = this.as_getPPListItem(int(param2));
            if (!_loc3_)
            {
               return;
            }
            
            _loc4_ = this.configs[param1][_loc5_ ? "right" : "left"];
            
            var tf:TextField = this.textFields[param1][param2];
            if (tf)
            {
               tf.x = _loc3_[this.configs[param1]["holder"]].x + _loc4_.x;
               tf.y = _loc3_[this.configs[param1]["holder"]].y + _loc4_.y;
            }
         }
         catch (e:Error)
         {
            this.logError("as_updatePosition error: " + e.message);
         }
      }
      
      public function as_shadowListItem(param1:Object) : *
      {
         try
         {
            if (!param1)
            {
               return null;
            }
            return Utils.getDropShadowFilter(
               param1.distance, param1.angle, param1.color, 
               param1.alpha, param1.size, param1.strength
            );
         }
         catch (e:Error)
         {
            this.logError("as_shadowListItem error: " + e.message);
            return null;
         }
      }
      
      public function extendedSetting(param1:String, param2:int) : *
      {
         try
         {
            if (!this.textFields[param1].hasOwnProperty(int(param2)))
            {
               this.createPpanelTF(param1, int(param2));
            }
            return this.textFields[param1][param2];
         }
         catch (e:Error)
         {
            this.logError("extendedSetting error: " + e.message);
            return null;
         }
      }
      
      public function as_vehicleIconColor(param1:int, param2:String) : void
      {
         try
         {
            var _loc4_:BattleAtlasSprite = null;
            var _loc3_:* = undefined;
            
            _loc3_ = this.as_getPPListItem(int(param1));
            if (_loc3_)
            {
               _loc4_ = _loc3_.vehicleIcon;
               if (_loc4_)
               {
                  _loc4_["playerPanelCoreUI"] = {"color": Utils.colorConvert(param2)};
                  
                  if (!_loc4_.hasEventListener(Event.RENDER))
                  {
                     _loc4_.addEventListener(Event.RENDER, this.onRenderHendle);
                     this.eventListeners.push(_loc4_);
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
            var _loc2_:BattleAtlasSprite = param1.target as BattleAtlasSprite;
            if (!_loc2_ || !_loc2_["playerPanelCoreUI"])
            {
               return;
            }
            
            var _loc3_:ColorTransform = _loc2_.transform.colorTransform;
            _loc3_.color = _loc2_["playerPanelCoreUI"]["color"];
            _loc2_.transform.colorTransform = _loc3_;
         }
         catch (e:Error)
         {
            this.logError("onRenderHendle error: " + e.message);
         }
      }
      
      private function updateComponent(param1:String, param2:Object) : void
      {
         if (!param2 || !param2.hasOwnProperty("vehicleID"))
         {
            return;
         }
         
         try
         {
            if (!this.textFields[param1].hasOwnProperty(int(param2.vehicleID)))
            {
               this.createPpanelTF(param1, int(param2.vehicleID));
            }
            
            var tf:TextField = this.textFields[param1][param2.vehicleID];
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
            var _loc3_:Number = 0;
            var _loc4_:* = undefined;
            var _loc5_:Object = null;
            var _loc6_:Object = null;
            var _loc7_:Boolean = this.isRightP(param2);
            var _loc8_:TextField = null;
            var _loc9_:DropShadowFilter = null;
            
            _loc4_ = this.as_getPPListItem(int(param2));
            if (!_loc4_)
            {
               return;
            }
            
            _loc5_ = this.configs[param1][_loc7_ ? "right" : "left"];
            _loc6_ = this.configs[param1]["shadow"];
            
            _loc8_ = this.getTextFieldFromPool();
            
            _loc3_ = Number(_loc4_.getChildIndex(_loc4_[this.configs[param1]["child"]]));
            _loc4_.addChildAt(_loc8_, _loc3_ + 1);

            _loc8_.width = _loc5_.width;
            _loc8_.height = _loc5_.height;
            _loc8_.autoSize = _loc5_.align;
            
            _loc9_ = Utils.getDropShadowFilter(
               _loc6_.distance, _loc6_.angle, _loc6_.color,
               _loc6_.alpha, _loc6_.size, _loc6_.strength
            );
            _loc8_.filters = [_loc9_];
            
            _loc8_.x = _loc4_[this.configs[param1]["holder"]].x + _loc5_.x;
            _loc8_.y = _loc4_[this.configs[param1]["holder"]].y + _loc5_.y;
            
            this.textFields[param1][param2] = _loc8_;
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
            for (var i:int = 0; i < this.eventListeners.length; i++)
            {
               var sprite:BattleAtlasSprite = this.eventListeners[i];
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
            for (var i:int = 0; i < this.textFieldPool.length; i++)
            {
               var tf:TextField = this.textFieldPool[i];
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