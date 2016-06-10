package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;
import flixel.FlxG;


class LevelLoader {
	private static inline var TILE_SIZE:Int = 32;
	public static function load(state:PlayState, level:String) {
		var tiledMap = new TiledMap("assets/data/" + level + ".tmx");
		var mainLayer:TiledTileLayer = cast tiledMap.getLayer("foreground");

		state.map = new FlxTilemap();
		state.map.loadMapFromArray(mainLayer.tileArray,
			tiledMap.width,
			tiledMap.height,
			AssetPaths.tinytiles__png,
			TILE_SIZE, TILE_SIZE, 1);

		var backLayer:TiledTileLayer = cast tiledMap.getLayer("background");

		var backMap = new FlxTilemap();
		backMap.loadMapFromArray(backLayer.tileArray,
			tiledMap.width,
			tiledMap.height,
			AssetPaths.tinytiles__png,
			TILE_SIZE, TILE_SIZE, 1);
		backMap.solid = false;

		state.add(backMap);
		state.add(state.map);

		var playerPos:TiledObject = getLevelObjects(tiledMap, "player")[0];
		state.player.setPosition(playerPos.x, playerPos.y - TILE_SIZE);
	}

	public static function getLevelObjects(map:TiledMap, layer:String):Array<TiledObject> {
		if ((map != null) && (map.getLayer(layer) != null)) {
			var objLayer:TiledObjectLayer = cast map.getLayer(layer);
			return objLayer.objects;
		} else {
			trace("Object layer " + layer + " not found!");
			return [];
		}
	}
}