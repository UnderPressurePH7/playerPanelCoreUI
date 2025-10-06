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
         try
         {
            if (!param1 || param1.length == 0)
            {
               trace("[Utils] colorConvert: empty color string, using default white");
               return 0xFFFFFF;
            }
            
            var cleanColor:String = param1.split("#").join("0x");
            var result:uint = uint(parseInt(cleanColor, 16));
            
            if (isNaN(result))
            {
               trace("[Utils] colorConvert: invalid color '" + param1 + "', using default white");
               return 0xFFFFFF;
            }
            
            return result;
         }
         catch (e:Error)
         {
            trace("[Utils] colorConvert error: " + e.message + ", using default white");
            return 0xFFFFFF;
         }
      }
      
      public static function getDropShadowFilter(
         param1:Number,
         param2:Number,
         param3:String,
         param4:Number,
         param5:Number,
         param6:Number   
      ) : DropShadowFilter
      {
         try
         {
            var filter:DropShadowFilter = new DropShadowFilter();
            
            filter.distance = isNaN(param1) ? 0 : param1;
            filter.angle = Utils.clamp(param2, 0, 360);
            filter.color = Utils.colorConvert(param3);
            filter.alpha = Utils.clamp(0.01 * param4, 0, 1);
            filter.blurX = Utils.clamp(param5, 0, 255);
            filter.blurY = Utils.clamp(param5, 0, 255);
            filter.strength = Utils.clamp(0.01 * param6, 0, 255);
            filter.quality = BitmapFilterQuality.MEDIUM;
            filter.inner = false;
            filter.knockout = false;
            filter.hideObject = false;
            
            return filter;
         }
         catch (e:Error)
         {
            trace("[Utils] getDropShadowFilter error: " + e.message + ", returning default filter");
            return new DropShadowFilter(0, 90, 0x000000, 1.0, 2, 2, 1.0, BitmapFilterQuality.MEDIUM);
         }
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         try
         {
            if (isNaN(param1))
            {
               trace("[Utils] clamp: value is NaN, using min value");
               return param2;
            }
            if (isNaN(param2))
            {
               trace("[Utils] clamp: min is NaN, using 0");
               param2 = 0;
            }
            if (isNaN(param3))
            {
               trace("[Utils] clamp: max is NaN, using value");
               return param1;
            }
            
            return Math.max(param2, Math.min(param3, param1));
         }
         catch (e:Error)
         {
            trace("[Utils] clamp error: " + e.message + ", returning value as-is");
            return param1;
         }
      }
   }
}