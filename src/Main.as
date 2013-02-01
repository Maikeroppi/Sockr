package 
{
import net.flashpunk.Engine;
import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(640, 480, 60, false);
			FP.screen.scale = 1;
		//	FP.console.enable();
		}
		
		override public function init():void 
		{
			trace("FlashPunk has started successfully!");

			FP.world = new ScreenWorld(Assets.StartScreen, ScreenWorld.StartScreen);
			FP.screen.color = Assets.kBackgroundcolor;
			
			super.init();
		}
		
	}
	
}