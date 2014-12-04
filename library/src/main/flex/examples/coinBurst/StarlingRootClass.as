package examples.coinBurst
{
import com.plumbee.stardustplayer.SimLoader;
import com.plumbee.stardustplayer.SimPlayer;

import flash.events.Event;
import flash.utils.ByteArray;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;

public class StarlingRootClass extends Sprite
{
	[Embed(source="coins_particles.sde", mimeType = 'application/octet-stream')]
//	[Embed(source="stardustProject.sde", mimeType = 'application/octet-stream')]
	private static var Asset:Class;
	private static var assetInstance:ByteArray = new Asset();

	public static var canvas : DisplayObjectContainer;
	private var loader : SimLoader;
	private var player : SimPlayer;

	public function StarlingRootClass()
	{
		x = 190;
		y = 120;

		canvas = this;

		player = new SimPlayer();
		loader = new SimLoader();
		loader.addEventListener(Event.COMPLETE, onSimLoaded);
		// this function parses the simulation
		loader.loadSim(assetInstance);
	}

	private function onSimLoaded(event : Event) : void
	{
		player.setSimulation(loader.project, this);
		// step the simulation on every frame
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(event : EnterFrameEvent) : void
	{
		player.stepSimulation();
	}
}
}
