package net.ekspoint.utils
{
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   
   public class Utils
   {
      
      public function Utils()
      {
         super();
      }
      
      public static function colorConvert(param1:String) : uint
      {
         return uint(parseInt(param1.split("#").join("0x"),16));
      }
      
      public static function getDropShadowFilter(param1:Number, param2:Number, param3:String, param4:Number, param5:Number, param6:Number) : DropShadowFilter
      {
         var _loc7_:DropShadowFilter = null;
         _loc7_ = new DropShadowFilter();
         _loc7_.distance = param1;
         _loc7_.angle = Utils.clamp(param2,0,360);
         _loc7_.color = Utils.colorConvert(param3);
         _loc7_.alpha = Utils.clamp(0.01 * param4,0,1);
         _loc7_.blurX = Utils.clamp(param5,0,255);
         _loc7_.blurY = Utils.clamp(param5,0,255);
         _loc7_.strength = Utils.clamp(0.01 * param6,0,255);
         _loc7_.quality = BitmapFilterQuality.MEDIUM;
         _loc7_.inner = false;
         _loc7_.knockout = false;
         _loc7_.hideObject = false;
         return _loc7_;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.max(param2,Math.min(param3,param1));
      }
   }
}

