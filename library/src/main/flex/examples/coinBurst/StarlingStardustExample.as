package examples.coinBurst
{
import com.plumbee.stardustplayer.SimLoader;
import com.plumbee.stardustplayer.SimPlayer;
import com.plumbee.stardustplayer.StarlingSimBuilder;
import com.plumbee.stardustplayer.StarlingSimZipLoader;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.display.Bitmap;
import flash.events.Event;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class StarlingStardustExample extends Sprite
{
	[Embed(source="coins_particles.sde", mimeType='application/octet-stream')]
//	[Embed(source="stardustProject.sde", mimeType = 'application/octet-stream')]
	private static var Asset : Class;
	private static var assetInstance : ByteArray = new Asset();

	public static var canvas : DisplayObjectContainer;
	private var loader : SimLoader;
	private var player : SimPlayer;

	[Embed(source="../../examples/coinBurst/emitterImage_0.png")]
	public static const Texture0 : Class;

	[Embed(source="../../examples/coinBurst/emitterImage_1.png")]
	public static const Texture1 : Class;

	[Embed(source="../../examples/coinBurst/emitterImage_2.png")]
	public static const Texture2 : Class;

	[Embed(source="../../examples/coinBurst/emitterImage_0.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture0 : Class;

	[Embed(source="../../examples/coinBurst/emitterImage_1.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture1 : Class;

	[Embed(source="../../examples/coinBurst/emitterImage_2.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture2 : Class;
	private var _project : ProjectValueObject;

	/*public function StarlingRootClass()
	 {
	 x = 190;
	 y = 120;

	 canvas = this;

	 player = new SimPlayer();
	 loader = new SimLoader();
	 loader.addEventListener(Event.COMPLETE, onSimLoaded);

	 var arrayOfTextures:Array = [];
	 for(var i:int = 0; i < 3; i++) {
	 var texture : Texture = getTexture(i);
	 var xml:XML;
	 if(i == 0) {
	 xml = new XML(new AtlasTexture0());
	 } else if (i == 1) {
	 xml = new XML(new AtlasTexture1());
	 } else if (i == 2) {
	 xml = new XML(new AtlasTexture2());
	 }
	 var atlas:TextureAtlas = new TextureAtlas(texture, xml);
	 arrayOfTextures[i] = atlas.getTextures("coin");
	 }

	 loader.loadStarlingSim(assetInstance, arrayOfTextures);
	 }*/

	public function StarlingStardustExample()
	{
		x = 190;
		y = 120;

		canvas = this;

		player = new SimPlayer();

		var emitters : Dictionary = new StarlingSimZipLoader().extractEmittersFromZip(assetInstance);

		var project : ProjectValueObject = createProject(emitters);

		player.setSimulation(project, this);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function createAtlas(atlasTexture : Class, atlasXML : Class)
	{
		var bitmap : Bitmap = new atlasTexture();
		return new TextureAtlas(Texture.fromBitmap(bitmap), new XML(new atlasXML()));
	}

	private function createProject(emitters : Dictionary) : ProjectValueObject
	{
		var emitters : Dictionary = new StarlingSimZipLoader().extractEmittersFromZip(assetInstance);

		var simBuilder : StarlingSimBuilder = new StarlingSimBuilder();
		var i : int = 0;
		for each (var emitter2D : ByteArray in emitters)
		{
			simBuilder.withEmitter(i, emitter2D);
			i ++;
		}
		simBuilder.withTextures(0, "coin", createAtlas(Texture0,AtlasTexture0));
		simBuilder.withTextures(1, "coin", createAtlas(Texture1,AtlasTexture1));
		simBuilder.withTextures(2, "coin", createAtlas(Texture2,AtlasTexture2));

		return simBuilder.build();

	}

	private function onSimLoaded(event : Event) : void
	{
		player.setSimulation(loader.project, this);
		// step the simulation on every frame

	}

	private function onEnterFrame(event : EnterFrameEvent) : void
	{
		player.stepSimulation();
	}

	public static function getTexture(emitterId : uint) : Texture
	{
		var c : Class;
		c = Texture0;

		if (emitterId == 1)
		{
			c = Texture1;
		}
		else if (emitterId == 2)
		{
			c = Texture2;
		}
		var bitmap : Bitmap = new c();
		return Texture.fromBitmap(bitmap);
	}
}
}
