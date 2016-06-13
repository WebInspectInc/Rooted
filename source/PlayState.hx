package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	public var map:FlxTilemap;
	public var player:Player;
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	override public function create():Void
	{
		super.create();

		player = new Player();
		enemies = new FlxTypedGroup<Enemy>();

		LevelLoader.load(this, 'main');

		add(enemies);
		add(player);

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(map, player);
		FlxG.overlap(enemies, player, collideEnemies);

		FlxG.collide(map, enemies);

		super.update(elapsed);
	}

	function collideEnemies(enemy:Enemy, player:Player):Void {
		enemy.interact(player);
	}
}
