package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import states.HUD;
import objects.Player;
import objects.Enemy;
import objects.Door;
import utils.LevelLoader;

class PlayState extends FlxState
{
	private var _hud:HUD;

	public var map:FlxTilemap;
	public var player:Player;
	public var enemies(default, null):FlxTypedGroup<Enemy>;
	public var doors(default, null):FlxTypedGroup<Door>;
	override public function create():Void
	{
		super.create();
		playLevel('main');
	}

	public function playLevel(levelName:String):Void {
		_hud = new HUD();

		player = new Player();
		enemies = new FlxTypedGroup<Enemy>();
		doors = new FlxTypedGroup<Door>();

		LevelLoader.load(this, levelName);

		add(enemies);
		add(player);
		add(doors);

		add(_hud);

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(map, player);
		FlxG.overlap(enemies, player, collideEnemies);
		FlxG.overlap(doors, player, collideDoors);

		FlxG.collide(map, enemies);

		super.update(elapsed);
	}

	function collideEnemies(enemy:Enemy, player:Player):Void {
		enemy.interact(player);
	}

	function collideDoors(door:Door, player:Player):Void {
		door.interact(player, this);
	}
}
