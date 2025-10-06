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
         var result:uint = 0xFFFFFF;
         try
         {
            if (!param1 || param1.length == 0)
            {
               trace("[Utils] colorConvert: empty color string, using default white");
               return 0xFFFFFF;
            }
            
            var cleanColor:String = param1.split("#").join("0x");
            var parsedColor:uint = uint(parseInt(cleanColor, 16));
            
            if (isNaN(parsedColor))
            {
               trace("[Utils] colorConvert: invalid color '" + param1 + "', using default white");
               result = 0xFFFFFF;
            }
            else
            {
                result = parsedColor;
            }
         }
         catch (e:Error)
         {
            trace("[Utils] colorConvert error: " + e.message + ", using default white");
            result = 0xFFFFFF;
         }
         return result;
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
         var filter:DropShadowFilter;
         try
         {
            filter = new DropShadowFilter();
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
         }
         catch (e:Error)
         {
            trace("[Utils] getDropShadowFilter error: " + e.message + ", returning default filter");
            filter = new DropShadowFilter(0, 90, 0x000000, 1.0, 2, 2, 1.0, BitmapFilterQuality.MEDIUM);
         }
         return filter;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         var result:Number;
         try
         {
            if (isNaN(param1))
            {
               trace("[Utils] clamp: value is NaN, using min value");
               result = param2;
            }
            else if (isNaN(param2))
            {
               trace("[Utils] clamp: min is NaN, using 0");
               result = Math.max(0, Math.min(param3, param1));
            }
            else if (isNaN(param3))
            {
               trace("[Utils] clamp: max is NaN, using value");
               result = param1;
            }
            else
            {
                result = Math.max(param2, Math.min(param3, param1));
            }
         }
         catch (e:Error)
         {
            trace("[Utils] clamp error: " + e.message + ", returning value as-is");
            result = param1;
         }
         return result;
      }
   }
}