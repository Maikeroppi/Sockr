package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Paddle extends Entity 
	{
		private var PlayerNumber_:int;
		private var UpKey_:int;
		private var DownKey_:int;
		
		private const MovementScale_:Number = 500;
		private var MovementNumber_:Number;
		
		private var PaddleColor_:uint;
		private var PaddleImage_:Image;
		
		public function Paddle(Player:int = 0) 
		{
			PlayerNumber_ = Player;
			type = "player";
			
			if (PlayerNumber_ == 2) {
				UpKey_ = Key.UP;
				DownKey_ = Key.DOWN;;
			} else {
				UpKey_ = Key.W;
				DownKey_ = Key.S;
			}
			
			PaddleImage_ = new Image(Assets.ImageDictionary["Player1.png"]);
			PaddleColor_ = 0xfffefefe;
			PaddleImage_.color = PaddleColor_;
			
			
			
			MovementNumber_ = 0;
		}
		
		public function GetColor():uint
		{
			return PaddleColor_;
		}
		
		public function SetColor(color:uint):void
		{
			PaddleColor_ = color;
			PaddleImage_.color = PaddleColor_;
			graphic = PaddleImage_;
		}
		
		public function updatePosition():void 
		{
			var MovementDirection:Number = 0;
			
			if (Input.check(UpKey_)) {
				MovementDirection = -1.0;
			}
			
			if (Input.check(DownKey_)) {
				MovementDirection = 1.0;
			}
			
			MovementNumber_ =  MovementDirection * MovementScale_ * FP.elapsed;
			
			moveBy(0, MovementNumber_, ["level", "ball"], false);
		}
		
		override public function update():void
		{
			updatePosition();
			super.update();
		}
	}

}