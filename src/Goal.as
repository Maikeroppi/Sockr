package  
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Goal extends Entity 
	{
		private var GoalCount:Number;
		
		public function Goal(inX:Number, inY:Number) 
		{
			x = inX;
			y = inY;			
		}
		
		override public function update():void
		{
			var balls:Array = new Array();
			var ball:Ball;
			
			// Check for goal collision
			collideInto("ball", x, y, balls);
			for each(ball in balls) {			
				trace("Goal 1 GOOOOOOOOOOOOOOOOOOOOOOOOOOOOAAAAAAAAAAAALLLLL!!!!!!!!");
			}
		}
		
	}

}