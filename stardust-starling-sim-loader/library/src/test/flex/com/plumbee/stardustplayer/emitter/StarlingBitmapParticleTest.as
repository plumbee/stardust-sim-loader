package com.plumbee.stardustplayer.emitter
{
import com.plumbee.stardustplayer.FlexUnitStarlingIntegration;
import com.plumbee.stardustplayer.FlexUnitStarlingIntegrationEvent;

import flash.display.BitmapData;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.flexunit.async.Async;
import org.hamcrest.object.strictlyEqualTo;

import starling.textures.Texture;

public class StarlingBitmapParticleTest
{
	[Before(async, timeout=1000)]
	public function setUp() : void
	{
		Async.proceedOnEvent(this, FlexUnitStarlingIntegration.nativeStage, FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED, 15500);
		FlexUnitStarlingIntegration.createStarlingContext();
	}

	[Test(expects="Error")]
	public function cantCreateWithNoTexture() : void
	{
		new StarlingBitmapParticle(Vector.<Texture>([]));
	}

	[Test]
	public function whenCreated_particleTextureIsSet() : void
	{
		var p : StarlingBitmapParticle = createWithTexturesAmount(1);
		assertNotNull(p.texture);
	}

	[Test]
	public function whenCreated_particleTextureIsFirstInVector() : void
	{
		var bd : BitmapData = new BitmapData(1, 1);
		var textures : Vector.<Texture> = Vector.<Texture>([
			Texture.fromBitmapData(bd),
			Texture.fromBitmapData(bd)
		]);
		var p : StarlingBitmapParticle = new StarlingBitmapParticle(textures);
		assertThat(p.texture, strictlyEqualTo(textures[0]));
	}

	[Test]
	public function whenCreatedWithMultipleTextures_isAnimatedSpriteSheet() : void
	{
		var p : StarlingBitmapParticle = createWithTexturesAmount(2);
		assertTrue(p.isAnimatedSpriteSheet());
	}

	[Test]
	public function whenCreatedWithSingleTexture_isNotAnimatedSpriteSheet() : void
	{
		var p : StarlingBitmapParticle = createWithTexturesAmount(1);
		assertFalse(p.isAnimatedSpriteSheet());
	}

	[Test]
	public function whenUpdatesFromModel_setsAllProperties() : void
	{
		var propertiesToUpdate : Array = ["x", "y", "scaleX", "scaleY", "rotation"];
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(1);
		p.updateFromModel(0, 0, 0, 0, 0);
		assertPropertiesWereSet(p, propertiesToUpdate);
	}

	[Test]
	public function whenUpdatesFromModel_alphaIsNotUpdatedIfSameValue() : void
	{
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(1);
		var alphaValue : Number = p.alpha;
		p.updateFromModel(0, 0, 0, 0, alphaValue);
		assertFalse(p.setterWasCalled("alpha"));
	}


	[Test]
	public function whenUpdatesFromModel_alphaIsUpdatedIfDifferentValue() : void
	{
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(1);
		var alphaValue : Number = p.alpha + .1;
		p.updateFromModel(0, 0, 0, 0, alphaValue);
		assertTrue(p.setterWasCalled("alpha"));
	}

	[After]
	public function tearDown() : void
	{
		FlexUnitStarlingIntegration.destroyStarlingContext();
	}

	private function assertPropertiesWereSet(particleSpy : StarlingBitmapParticleSpy, propertiesToUpdate : Array) : void
	{
		for each(var propName : String in propertiesToUpdate)
		{
			assertTrue(particleSpy.setterWasCalled(propName));
		}
	}

	private function createWithTexturesAmount(texturesAmount : uint) : StarlingBitmapParticleSpy
	{
		if (texturesAmount == 0)
		{
			throw(new Error("can't be 0"));
		}
		var bd : BitmapData = new BitmapData(1, 1);
		var textures : Vector.<Texture> = new Vector.<Texture>();
		for (var i : uint = 0; i < texturesAmount; i++)
		{
			textures.push(Texture.fromBitmapData(bd));
		}
		return new StarlingBitmapParticleSpy(textures);
	}
}
}

import com.plumbee.stardustplayer.emitter.StarlingBitmapParticle;

import flash.utils.Dictionary;

import starling.textures.Texture;

class StarlingBitmapParticleSpy extends StarlingBitmapParticle
{

	public function StarlingBitmapParticleSpy(textures : Vector.<Texture>)
	{
		super(textures);
		calledSetters = new Dictionary();
	}

	private var calledSetters : Dictionary;

	public function setterWasCalled(propname : String) : int
	{
		return calledSetters[propname];
	}

	private function callSetter(propname : String) : void
	{
		if (!calledSetters[propname])
		{
			calledSetters[propname] = 1;
		}
		else
		{
			calledSetters[propname]++;
		}
	}

	override public function set x(value : Number) : void
	{
		super.x = value;
		callSetter("x");
	}

	override public function set y(value : Number) : void
	{
		super.y = value;
		callSetter("y");
	}

	override public function set scaleX(value : Number) : void
	{
		super.scaleX = value;
		callSetter("scaleX");
	}

	override public function set scaleY(value : Number) : void
	{
		super.scaleY = value;
		callSetter("scaleY");
	}

	override public function set rotation(value : Number) : void
	{
		super.rotation = value;
		callSetter("rotation");
	}

	override public function set alpha(value : Number) : void
	{
		super.alpha = value;
		callSetter("alpha");
	}
}