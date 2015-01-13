package examples
{

import com.plumbee.stardustplayer.SimLoader;
import com.plumbee.stardustplayer.SimPlayer;
import com.plumbee.stardustplayer.SimTimeModel;

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.ByteArray;

public class ExampleSimPlayer extends Sprite
{

	private var loader : SimLoader;
	private var player : SimPlayer;
	private var timeModel : SimTimeModel;

	public function ExampleSimPlayer()
	{
		timeModel = new SimTimeModel();
		player = new SimPlayer();
		loader = new SimLoader();
	}

	public function loadSim(sim : ByteArray) : void
	{
		loader.addEventListener(Event.COMPLETE, onSimLoaded);
		// this function parses the simulation
		loader.loadSim(sim);
	}

	private function onSimLoaded(event : Event) : void
	{
		timeModel.resetTime();
		player.setSimulation(loader.project, this);
		// step the simulation on every frame
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(event : Event) : void
	{
		timeModel.update();
		player.stepSimulation(timeModel.timeStepNormalizedTo60fps);
	}

}
}
