package
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Andrew Simeon
	 */
	public class Map extends FlxTilemap
	{
		private var _collision:FlxGroup = new FlxGroup();
		public function get collision():FlxGroup { return _collision; }
		
		public var playerStart:FlxPoint;
		
		public function Map()
		{
			super();
		}
		
		public function loadLevel(map:Class, graphic:Class):void
		{
			var xml:XML = Utilities.getXML(map);			
			var tiles:XML = xml.Tileset[0];
			this.loadMap(tiles, graphic, 16, 16, FlxTilemap.OFF, 0, 0, 1);
			
			loadCollision(xml.Collision[0]);
			
			playerStart = new FlxPoint(xml.MegamanStart[0].MegamanStart[0].@x, xml.MegamanStart[0].MegamanStart[0].@y);
			trace(xml.MegamanStart[0].MegamanStart[0]);
			
			// set camera bounds
			FlxG.camera.setBounds(0, 0, xml.@width, xml.@height);
		}
		
		public function loadCollision(xml:XML):void
		{
			if (xml)
			{
				var rows:Array = xml.toString().split('\n');
				var rowNum:int = 0;
				for each( var row:String in rows )
				{
					var rowLength:int = row.length;
					for (var col:int = 0; col < rowLength; col++)
					{
						if (int(row.charAt(col)) > 0)
						{
							var obj:FlxObject = new FlxObject(col * 16, rowNum * 16, 16, 16);
							obj.immovable = true;
							_collision.add(obj);
						}
					}
					rowNum++;
				}
			}
		}
	}
}