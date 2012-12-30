package  
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Assets 
	{
		// Load up OGMO stuff
		
		
		[Embed(source = "../Sockr.oep", mimeType = "application/octet-stream")]
		public static const SockrOgmoFile:Class;
		
		[Embed(source = "../Field.oel", mimeType = "application/octet-stream")]
		public static const SockrField:Class;
		
		// Images
		[Embed(source = "../Tiles.png")]
		public static const Tiles:Class;
		
		
		[Embed(source = "../Player1.png")]
		public static const Player1Image:Class;
		
		[Embed(source = "../Player2.png")]
		public static const Player2Image:Class;
		
		[Embed(source = "../Ball.png")]
		public static const BallImage:Class;
		
		public static var ImageDictionary:Object = {
			"Player1.png":Assets.Player1Image
			, "Player2.png":Assets.Player2Image
			, "Tiles.png":Assets.Tiles
			, "Ball.png":Assets.BallImage
		};
			
		// Set screen size
		public static const kScreenWidth:int = 640;
		public static const kScreenHeight:int = 480;
		public static const kBackgroundcolor:uint = 0xFF008040;
		
		// Set tile parameters
		public static const kTileWidth:int = 16;
		public static const kTileHeight:int = 16;
		public static const kScreenWidthInTiles:int = kScreenWidth / kTileWidth;
		public static const kScreenHeightInTiles:int = kScreenHeight / kTileHeight;
		
		
				
		public function Assets() 
		{
			
		}
		
	}

}