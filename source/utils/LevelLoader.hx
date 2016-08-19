package utils;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTile;
import flixel.FlxObject;
import flixel.FlxG;
import objects.Enemy;
import objects.Player;
import objects.Door;
import states.PlayState;


class LevelLoader {
	public static var levelState:PlayState;
	private static inline var TILE_SIZE:Int = 32;
	public static function load(state:PlayState, level:String) {
		levelState = state;
		var tiledMap = new TiledMap("assets/data/" + level + ".tmx");
		var mainLayer:TiledTileLayer = cast tiledMap.getLayer("foreground");

		state.map = new FlxTilemap();
		state.map.loadMapFromArray(mainLayer.tileArray,
			tiledMap.width,
			tiledMap.height,
			AssetPaths.tinytiles__png,
			TILE_SIZE, TILE_SIZE, 1);

		state.map.setTileProperties(2, FlxObject.ANY, collideStone, Player, 10);

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

		for (enemy in getLevelObjects(tiledMap, "enemies"))
			state.enemies.add(new Enemy(enemy.x, enemy.y - 32));
		
		var playerPos:TiledObject = getLevelObjects(tiledMap, "player")[0];
		state.player.setPosition(playerPos.x, playerPos.y - TILE_SIZE);


		for (door in getLevelObjects(tiledMap, "doors"))
			state.doors.add(new Door(door));
	}

	private static function collideStone(Tile:FlxObject, Player:FlxObject):Void {
		//Player.noRoot = true;
		levelState.player.noRoot = true;
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