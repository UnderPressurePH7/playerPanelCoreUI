package net.ekspoint.injector
{
   import net.wg.data.constants.generated.LAYER_NAMES;
   import net.wg.gui.battle.views.BaseBattlePage;
   import net.wg.gui.components.containers.MainViewContainer;
   import net.wg.infrastructure.base.AbstractView;
   import net.wg.infrastructure.interfaces.ISimpleManagedContainer;
   
   public class AbstractViewInjector extends AbstractView implements IAbstractInjector
   {
      
      public function AbstractViewInjector()
      {
         super();
      }
      
      private function createComponent() : BattleDisplayable
      {
         var _loc1_:BattleDisplayable = new this.componentUI() as BattleDisplayable;
         this.configureComponent(_loc1_);
         return _loc1_;
      }
      
      protected function configureComponent(param1:BattleDisplayable) : void
      {
      }
      
      override protected function onPopulate() : void
      {
         var _loc4_:BaseBattlePage = null;
         var _loc5_:BattleDisplayable = null;
         super.onPopulate();
         var _loc1_:MainViewContainer = MainViewContainer(App.containerMgr.getContainer(LAYER_NAMES.LAYER_ORDER.indexOf(LAYER_NAMES.VIEWS)));
         var _loc2_:ISimpleManagedContainer = App.containerMgr.getContainer(LAYER_NAMES.LAYER_ORDER.indexOf(LAYER_NAMES.WINDOWS));
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.numChildren)
         {
            _loc4_ = _loc1_.getChildAt(_loc3_) as BaseBattlePage;
            if(_loc4_)
            {
               _loc5_ = this.createComponent();
               _loc5_.componentName = this.componentName;
               _loc5_.battlePage = _loc4_;
               _loc5_.initBattle();
               break;
            }
            _loc3_++;
         }
         _loc1_.setFocusedView(_loc1_.getTopmostView());
         if(_loc2_ != null)
         {
            _loc2_.removeChild(this);
         }
      }
      
      public function get componentUI() : Class
      {
         return null;
      }
      
      public function get componentName() : String
      {
         return null;
      }
   }
}

