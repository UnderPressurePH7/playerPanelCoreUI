package
{
   import net.under_pressure.battle.playerPanelCore;
   import net.under_pressure.injector.AbstractViewInjector;
   import net.under_pressure.injector.IAbstractInjector;
   
   public class PlayerPanelCoreUI extends AbstractViewInjector implements IAbstractInjector
   {
      public function PlayerPanelCoreUI()
      {
         super();
      }
      
      override public function get componentUI() : Class
      {
         return playerPanelCore;
      }
      
      override public function get componentName() : String
      {
         return "playerPanelCore";
      }
   }
}

