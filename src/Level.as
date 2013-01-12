package  
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Maikeroppi
	 */
	public class Level extends Entity
	{
		private var Tiles_:Tilemap;
		private var Grid_:Grid;
		public var LevelData:XML;
		public var LevelWidth_:Number;
		public var LevelHeight_:Number;
		public var LevelWidthInTiles_:Number;
		public var LevelHeightInTiles_:Number;
		
		
		public function Level(xml:Class)
		{

			type = "level";
			
			loadLevel(xml);
		}
		
		private function loadLevel(xml:Class):void
		{
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			LevelData = new XML(dataString);
			var dataList:XMLList = LevelData.Objects.*;
			var dataElement:XML;
			
			// Set our grid and tilemap size based on Ogmo file we're loading
			LevelHeight_ = LevelData.@height;
			LevelWidth_ = LevelData.@width;
			LevelHeightInTiles_ = LevelHeight_ / Assets.kTileHeight;
			LevelWidthInTiles_ = LevelWidth_ / Assets.kTileWidth;
			
			Tiles_ = new Tilemap(Assets.Tiles, 
			LevelWidth_, 
			LevelHeight_, 
			Assets.kTileWidth,
			Assets.kTileHeight);
			
			graphic = Tiles_;
			layer = 1;
							
			Grid_ = new Grid(LevelWidth_, LevelHeight_, Assets.kTileWidth, Assets.kTileHeight, 0, 0);
			mask = Grid_;
			
			// Load tiles
			Tiles_.loadFromString(LevelData.Tiles[0]);
						
			// Setup grid
			Grid_.loadFromString(LevelData.Solids[0], "", "\n");
		}
		
		/*
		 * Sets tile index the pixel is on. 
		 * @param Xpixel X coordinate in pixel space.
		 * @param Ypixel Y coordinate in pixel space.
		 * @param tile The tile index to change the tile to.
		 */
		public function SetTileColor(Xpixel:int, YPixel:int, tile:int):void
		{
			var TileX:uint = Xpixel / Assets.kTileWidth;
			var TileY:uint = YPixel / Assets.kTileHeight;
			
			if(Grid_.getTile(TileX, TileY) ) {
				Tiles_.setTile(
					TileX,
					TileY,
					tile
					);
			}
		}
		
		public function clearGrid():void
		{
			Grid_.clearRect(0, 0, LevelWidthInTiles_, LevelHeightInTiles_);
		}
		
		override public function update():void
		{
			
			super.update();
		}
		}

}