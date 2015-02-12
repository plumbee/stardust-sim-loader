package com.plumbee.stardustplayer.emitter
{
import com.plumbee.stardustplayer.FlexUnitStarlingIntegration;
import com.plumbee.stardustplayer.FlexUnitStarlingIntegrationEvent;

import flash.display.BitmapData;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertStrictlyEquals;
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


	[Test]
	public function whenUpdatesFromModel_rotationIsConvertedToRadians() : void
	{
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(1);
		var rotationDegs : Number = 180;
		p.updateFromModel(0, 0, rotationDegs, 0, 0);
		assertEquals(Math.PI, p.rotation);
	}


	[Test]
	public function whenUpdatesFromModel_scaleXandYAreSetWithSameValue() : void
	{
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(1);
		var scale : Number = 100;
		p.updateFromModel(0, 0, 0, scale, 0);
		assertEquals(scale, p.scaleY, p.scaleX);
	}


	[Test(description="when not a spritesheet then step to next texture doesn't change the texture")]
	public function whenStepSpriteSheet_butIsNotSpritesheet_textureDoesNotChange() : void
	{
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(1);
		var prevTexture : Texture = p.texture;
		p.stepSpriteSheet(1);
		assertStrictlyEquals(prevTexture, p.texture);
	}


	[Test]
	public function whenStepSpriteSheetBy0_textureDoesntChange() : void
	{
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(2);
		var prevTexture : Texture = p.texture;
		p.stepSpriteSheet(0);
		assertStrictlyEquals(prevTexture, p.texture);
	}


	[Test(description="when is a spritesheet then step to next texture updates the texture")]
	public function whenStepSpriteSheet_toNextFrame_textureIsUpdated() : void
	{
		var stepsAmount : uint = 1;
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(2);
		p.stepSpriteSheet(stepsAmount);
		assertStrictlyEquals(p.getTextures()[stepsAmount], p.texture);
	}


	[Test(description="when amount of steps is greater than amount of textures, destination frame is wrapped around")]
	public function whenStepSpriteSheet_MoreStepsThanFrames_wrapsValue() : void
	{
		var stepsAmount : uint = 2;
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(2);
		p.stepSpriteSheet(stepsAmount);
		assertStrictlyEquals(p.getTextures()[0], p.texture);
	}


	[Test(description="when stepping sprite twice, texture index advances")]
	public function whenStepSpriteSheetTwice_textureIndexAdvances() : void
	{
		var stepsAmount : uint = 1;
		var p : StarlingBitmapParticleSpy = createWithTexturesAmount(3);
		p.stepSpriteSheet(stepsAmount);
		p.stepSpriteSheet(stepsAmount);
		assertStrictlyEquals(p.getTextures()[2 * stepsAmount], p.texture);
	}


	[Test(description="when creating particle, size is texture size")]
	public function whenCreatingParticle_particleSizeChangesAccordingly() : void
	{
		var texture : Texture = createTexture(2, 3);
		var p : StarlingBitmapParticleSpy = new StarlingBitmapParticleSpy(Vector.<Texture>([texture]));
		assertEquals(texture.width, p.width);
		assertEquals(texture.height, p.height);
	}

	[Test(description="when creating particle, pivot is texture center")]
	public function whenCreatingParticle_pivotUpdates() : void
	{
		var texture : Texture = createTexture(2, 3);
		var p : StarlingBitmapParticleSpy = new StarlingBitmapParticleSpy(Vector.<Texture>([texture]));
		assertEquals(texture.width/2, p.pivotX);
		assertEquals(texture.height/2, p.pivotY);
	}

	[Test(description="when changing texture, pivot is texture center")]
	public function whenStepSpriteSheet_pivotUpdates() : void
	{
		var texture1 : Texture = createTexture(2, 3);
		var texture2 : Texture = createTexture(4, 5);
		var p : StarlingBitmapParticleSpy = new StarlingBitmapParticleSpy(Vector.<Texture>([texture1, texture2]));
		p.stepSpriteSheet(1);
		assertEquals(texture2.width/2, p.pivotX);
		assertEquals(texture2.height/2, p.pivotY);
	}

	[Test(description="when changing texture (bigger), size is texture size")]
	public function whenStepSpriteSheet_particleSizeChangesAccordingly1() : void
	{
		var texture1 : Texture = createTexture(2, 3);
		var texture2 : Texture = createTexture(4, 5);
		var p : StarlingBitmapParticleSpy = new StarlingBitmapParticleSpy(Vector.<Texture>([texture1, texture2]));
		p.stepSpriteSheet(1);
		assertEquals(texture2.width, p.width);
		assertEquals(texture2.height, p.height);
	}

	[Test(description="when changing texture (smaller), size is texture size")]
	public function whenStepSpriteSheet_particleSizeChangesAccordingly2() : void
	{
		var texture1 : Texture = createTexture(4, 5);
		var texture2 : Texture = createTexture(2, 3);
		var p : StarlingBitmapParticleSpy = new StarlingBitmapParticleSpy(Vector.<Texture>([texture1, texture2]));
		p.stepSpriteSheet(1);
		assertEquals(texture2.width, p.width);
		assertEquals(texture2.height, p.height);
	}

	private function createTexture(width : uint, height : uint) : Texture
	{
		var bd : BitmapData = new BitmapData(width, height);
		var texture : Texture = Texture.fromBitmapData(bd);
		return texture;
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

	public function getTextures() : Vector.<Texture>
	{
		return _textures;
	}

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