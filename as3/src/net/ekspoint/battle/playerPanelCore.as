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
      
      public var flashLogS:Function;
      
      private var configs:Object = new Object();
      
      private var textFields:Object = new Object();
      
      public function playerPanelCore()
      {
         super();
         name = this.componentName;
      }
      
      public function as_create(param1:String, param2:Object) : void
      {
         this.createComponent(param1,param2);
      }
      
      public function as_update(param1:String, param2:Object) : void
      {
         this.updateComponent(param1,param2);
      }
      
      public function as_hasOwnProperty(param1:String) : Boolean
      {
         return this.hasOwnPropertyComponent(param1);
      }
      
      public function as_delete(param1:String) : void
      {
         this.deleteComponent(param1);
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
         delete this.configs[param1];
         delete this.textFields[param1];
      }
      
      private function getListItem(param1:*, param2:Number) : *
      {
         var _loc3_:int = int(param1._items.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1._items[_loc4_].vehicleID == param2)
            {
               return param1._items[_loc4_]._listItem;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function as_getPPListItem(param1:int) : *
      {
         var _loc2_:* = (this.battlePage as BattlePage).playersPanel.listRight;
         if(!_loc2_.getHolderByVehicleID(int(param1)))
         {
            _loc2_ = (this.battlePage as BattlePage).playersPanel.listLeft;
            return this.getListItem(_loc2_,param1);
         }
         return this.getListItem(_loc2_,param1);
      }
      
      private function isRightP(param1:int) : Boolean
      {
         var _loc2_:* = (this.battlePage as BattlePage).playersPanel.listRight;
         if(!_loc2_.getHolderByVehicleID(int(param1)))
         {
            return false;
         }
         return true;
      }
      
      public function as_updatePosition(param1:String, param2:int) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:Boolean = this.isRightP(param2);
         if(!this.textFields[param1].hasOwnProperty(int(param2)))
         {
            this.createPpanelTF(param1,int(param2));
         }
         _loc3_ = this.as_getPPListItem(int(param2));
         _loc4_ = this.configs[param1][_loc5_ ? "right" : "left"];
         this.textFields[param1][param2].x = _loc3_[this.configs[param1]["holder"]].x + _loc4_.x;
         this.textFields[param1][param2].y = _loc3_[this.configs[param1]["holder"]].y + _loc4_.y;
      }
      
      public function as_shadowListItem(param1:Object) : *
      {
         return Utils.getDropShadowFilter(param1.distance,param1.angle,param1.color,param1.alpha,param1.size,param1.strength);
      }
      
      public function extendedSetting(param1:String, param2:int) : *
      {
         if(!this.textFields[param1].hasOwnProperty(int(param2)))
         {
            this.createPpanelTF(param1,int(param2));
         }
         return this.textFields[param1][param2];
      }
      
      public function as_vehicleIconColor(param1:int, param2:String) : void
      {
         var _loc4_:BattleAtlasSprite = null;
         var _loc3_:* = undefined;
         _loc3_ = this.as_getPPListItem(int(param1));
         if(_loc3_)
         {
            _loc4_ = _loc3_.vehicleIcon;
            _loc4_["playerPanelCoreUI"] = {"color":Utils.colorConvert(param2)};
            if(!_loc4_.hasEventListener(Event.RENDER))
            {
               _loc4_.addEventListener(Event.RENDER,this.onRenderHendle);
            }
         }
      }
      
      private function onRenderHendle(param1:Event) : void
      {
         var _loc2_:BattleAtlasSprite = param1.target as BattleAtlasSprite;
         var _loc3_:ColorTransform = _loc2_.transform.colorTransform;
         _loc3_.color = _loc2_["playerPanelCoreUI"]["color"];
         _loc2_.transform.colorTransform = _loc3_;
      }
      
      private function updateComponent(param1:String, param2:Object) : void
      {
         if(!this.textFields[param1].hasOwnProperty(int(param2.vehicleID)))
         {
            this.createPpanelTF(param1,int(param2.vehicleID));
         }
         this.textFields[param1][param2.vehicleID].htmlText = param2.text;
      }
      
      private function createPpanelTF(param1:String, param2:int) : void
      {
         var _loc3_:Number = 0;
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Boolean = this.isRightP(param2);
         var _loc8_:TextField = null;
         var _loc9_:DropShadowFilter = null;
         _loc4_ = this.as_getPPListItem(int(param2));
         _loc5_ = this.configs[param1][_loc7_ ? "right" : "left"];
         _loc6_ = this.configs[param1]["shadow"];
         _loc8_ = new TextField();
         TextFieldEx.setNoTranslate(_loc8_,true);
         _loc3_ = Number(_loc4_.getChildIndex(_loc4_[this.configs[param1]["child"]]));
         _loc4_.addChildAt(_loc8_,_loc3_ + 1);
         _loc8_.defaultTextFormat = new TextFormat("$UniversCondC",16,Utils.colorConvert("#ffffff"),false,false,false,"","","left",0,0,0,0);
         _loc8_.mouseEnabled = false;
         _loc8_.background = false;
         _loc8_.backgroundColor = 0;
         _loc8_.embedFonts = true;
         _loc8_.multiline = true;
         _loc8_.selectable = false;
         _loc8_.tabEnabled = false;
         _loc8_.antiAliasType = AntiAliasType.ADVANCED;
         _loc8_.width = _loc5_.width;
         _loc8_.height = _loc5_.height;
         _loc8_.autoSize = _loc5_.align;
         _loc9_ = Utils.getDropShadowFilter(_loc6_.distance,_loc6_.angle,_loc6_.color,_loc6_.alpha,_loc6_.size,_loc6_.strength);
         _loc8_.filters = [_loc9_];
         _loc8_.x = _loc4_[this.configs[param1]["holder"]].x + _loc5_.x;
         _loc8_.y = _loc4_[this.configs[param1]["holder"]].y + _loc5_.y;
         this.textFields[param1][param2] = _loc8_;
      }
   }
}

