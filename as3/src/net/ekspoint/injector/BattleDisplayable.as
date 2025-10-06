package net.ekspoint.injector
{
   import net.wg.gui.battle.components.BattleUIDisplayable;
   import net.wg.gui.battle.views.BaseBattlePage;
   
   public class BattleDisplayable extends BattleUIDisplayable
   {
      public var battlePage:BaseBattlePage;
      public var componentName:String;
      
      private var _isInitialized:Boolean = false;
      
      public function BattleDisplayable()
      {
         super();
      }
      
      public function initBattle() : void
      {
         try
         {
            if (!this.battlePage)
            {
               trace("[BattleDisplayable] initBattle: battlePage is null");
               return;
            }
            
            if (!this.battlePage.contains(this))
            {
               this.battlePage.addChildAt(this, 1);
            }
            
            if (!this.battlePage.isFlashComponentRegisteredS(this.componentName))
            {
               this.battlePage.registerFlashComponent(this, this.componentName);
               this._isInitialized = true;
            }
         }
         catch (e:Error)
         {
            trace("[BattleDisplayable] initBattle error: " + e.message);
         }
      }
      
      public function finiBattle() : void
      {
         try
         {
            if (!this.battlePage)
            {
               return;
            }
            
            if (this._isInitialized && 
                this.battlePage.isFlashComponentRegisteredS(this.componentName))
            {
               this.battlePage.unregisterFlashComponentS(this.componentName);
               this._isInitialized = false;
            }
            
            if (this.battlePage.contains(this))
            {
               this.battlePage.removeChild(this);
            }
         }
         catch (e:Error)
         {
            trace("[BattleDisplayable] finiBattle error: " + e.message);
         }
      }
      
      override protected function onPopulate() : void
      {
         try
         {
            super.onPopulate();
         }
         catch (e:Error)
         {
            trace("[BattleDisplayable] onPopulate error: " + e.message);
         }
      }
      
      override protected function onDispose() : void
      {
         try
         {
            this.finiBattle();
            this.battlePage = null;
            this.componentName = null;
            
            super.onDispose();
         }
         catch (e:Error)
         {
            trace("[BattleDisplayable] onDispose error: " + e.message);
         }
      }
   }
}