package
{
   import net.ekspoint.battle.playerPanelCore;
   import net.ekspoint.injector.AbstractViewInjector;
   import net.ekspoint.injector.IAbstractInjector;
   
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

