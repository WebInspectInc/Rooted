package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera.FlxCameraFollowStyle;

class PlayState extends FlxState
{
	public var map:FlxTilemap;
	public var player:Player;
	override public function create():Void
	{
		super.create();

		player = new Player();

		LevelLoader.load(this, 'main');

		add(player);

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(map, player);
	}
}
