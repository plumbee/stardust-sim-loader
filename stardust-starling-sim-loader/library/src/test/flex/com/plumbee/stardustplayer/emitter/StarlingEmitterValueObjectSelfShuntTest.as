package com.plumbee.stardustplayer.emitter
{
import com.plumbee.stardustplayer.FlexUnitStarlingIntegration;
import com.plumbee.stardustplayer.FlexUnitStarlingIntegrationEvent;

import idv.cjcat.stardustextended.common.initializers.Initializer;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;

import org.flexunit.asserts.assertEquals;

import org.flexunit.async.Async;

import org.flexunit.rules.IMethodRule;
import org.mockito.integrations.any;
import org.mockito.integrations.flexunit4.MockitoRule;
import org.mockito.integrations.given;
import org.mockito.integrations.verify;

import starling.textures.Texture;

public class StarlingEmitterValueObjectSelfShuntTest extends StarlingEmitterValueObject
{
	[Rule]
	public var rule:IMethodRule = new MockitoRule();

	[Mock]
	public var helper:BitmapToTextureHelper;

	private const helperReturn:Vector.<Texture> = new <Texture>[];

	private var starlingInit:PooledStarlingDisplayObjectClass;

	public function StarlingEmitterValueObjectSelfShuntTest()
	{
		super(0, null);
	}

	[Before(async, timeout=1000)]
	public function setUp() : void
	{
		Async.proceedOnEvent(this, FlexUnitStarlingIntegration.nativeStage, FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED, 15500);
		FlexUnitStarlingIntegration.createStarlingContext();

		_emitter = new Emitter2D();
		given(helper.getTexturesFromBitmapParticleInit(any())).willReturn(helperReturn);

		starlingInit = new PooledStarlingDisplayObjectClass(Object,[]);
	}

	[After]
	public function tearDown() : void
	{
		FlexUnitStarlingIntegration.destroyStarlingContext();
		helperReturn.length = 0;
	}

	[Test(expects="Error")]
	public function addStarlingInitializers_failsWithMultipleBitmapParticleInit() : void
	{
		emitter.addInitializer(new BitmapParticleInit());
		emitter.addInitializer(new BitmapParticleInit());
		addStarlingInitializers();
	}

	[Test]
	public function addStarlingInitializers_getsTexturesFromHelper() : void
	{
		helperReturn.push(Texture.fromColor(1,1));

		var initializer:BitmapParticleInit = new BitmapParticleInit();
		emitter.addInitializer(initializer);
		addStarlingInitializers();
		verify().that(helper.getTexturesFromBitmapParticleInit(initializer));
	}

	[Test]
	public function addStarlingInitializers_addsInitializerToEmitter() : void
	{
		helperReturn.push(Texture.fromColor(1,1));

		var initializer:BitmapParticleInit = new BitmapParticleInit();
		emitter.addInitializer(initializer);
		addStarlingInitializers();
		assertEquals(1,emitter.getInitializersByClass(PooledStarlingDisplayObjectClass).length);
	}

	[Test]
	public function prepareForStarling_addsInitializerToEmitter() : void
	{
		prepareForStarling(createTextures());
		assertEquals(1,emitter.getInitializersByClass(PooledStarlingDisplayObjectClass).length);
	}

	private function createTextures() : Vector.<Texture>
	{
		return Vector.<Texture>([Texture.fromColor(1,1,0xFF00FF)]);
	}

	override protected function getBitmapToTextureHelper() : BitmapToTextureHelper
	{
		return helper;
	}

	override protected function createStarlingInitializerWithTextures(textures : Vector.<Texture>) : Initializer
	{
		return starlingInit;
	}
}
}
