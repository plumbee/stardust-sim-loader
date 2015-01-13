package examples.coinBurst
{
import com.plumbee.stardustplayer.SimPlayer;
import com.plumbee.stardustplayer.SimTimeModel;
import com.plumbee.stardustplayer.StarlingSimBuilder;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.display.Bitmap;
import flash.events.Event;
import flash.utils.ByteArray;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class StarlingStardustExample extends Sprite
{
	[Embed(source="coins_particles.sde", mimeType='application/octet-stream')]
	private static var Asset : Class;
	private static var assetInstance : ByteArray = new Asset();

	public static var canvas : DisplayObjectContainer;
	private var player : SimPlayer;
	private var simTimeModel : SimTimeModel;

	[Embed(source="emitterImage_0.png")]
	public static const Texture0 : Class;

	[Embed(source="emitterImage_1.png")]
	public static const Texture1 : Class;

	[Embed(source="emitterImage_2.png")]
	public static const Texture2 : Class;

	[Embed(source="emitterImage_0.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture0 : Class;

	[Embed(source="emitterImage_1.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture1 : Class;

	[Embed(source="emitterImage_2.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture2 : Class;

	public function StarlingStardustExample()
	{
		x = 190;
		y = 120;

		canvas = this;

		player = new SimPlayer();
		simTimeModel = new SimTimeModel();


		var project : ProjectValueObject = createProject();

		player.setSimulation(project, this);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function createAtlas(atlasTexture : Class, atlasXML : Class) : TextureAtlas
	{
		var bitmap : Bitmap = new atlasTexture();
		return new TextureAtlas(Texture.fromBitmap(bitmap), new XML(new atlasXML()));
	}

	private function createProject() : ProjectValueObject
	{
		var simBuilder : StarlingSimBuilder = new StarlingSimBuilder();

		return simBuilder.withSDE(assetInstance)
				.withTextures("coin", createAtlas(Texture0, AtlasTexture0))
				.withTextures("coin", createAtlas(Texture1, AtlasTexture1))
				.withTextures("coin", createAtlas(Texture2, AtlasTexture2))
				.build();

	}

	private function onEnterFrame(event : EnterFrameEvent) : void
	{
		simTimeModel.update();

		////////////////////////////////////////////////////////////////
		// Example ways to run simulation updates
		// (Uncomment one of below steps (1 - 3) to run simulation differently

		// 1) updates simulation with constant time step equal to 1 stardust time unit
		// This runs frame rate dependant simulation, the more fps the quicker the simulation happens
//		player.stepSimulation(1);

		// 2) updates simulation with varying time step in milliseconds normalized to stardust time domain
		// This runs frame rate independent simulation
		// (but significantly varying time step or very low frame rate will influence simulation behaviour)
//		player.stepSimulation(simTimeModel.timeStepNormalizedTo60fps);

		// 3) updates simulation with varying time step splitting big steps into number of smaller steps when needed.
		// This runs truly frame rate independent simulation
		// (assures that the particles behaviour looks the same no matter what the frame rate is)
		player.stepSimulationWithSubsteps(simTimeModel.timeStep, SimTimeModel.msFor60FPS);
	}
}
}