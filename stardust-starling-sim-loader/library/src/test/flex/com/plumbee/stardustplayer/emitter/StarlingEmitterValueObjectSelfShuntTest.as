package com.plumbee.stardustplayer.emitter
{
import com.plumbee.stardustplayer.FlexUnitStarlingIntegration;
import com.plumbee.stardustplayer.FlexUnitStarlingIntegrationEvent;

import idv.cjcat.stardustextended.common.initializers.Initializer;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;

import org.flexunit.assertThat;

import org.flexunit.asserts.assertEquals;

import org.flexunit.async.Async;

import org.flexunit.rules.IMethodRule;
import org.mockito.integrations.any;
import org.mockito.integrations.flexunit4.MockitoRule;
import org.mockito.integrations.given;
import org.mockito.integrations.verify;

import starling.textures.Texture;

public class StarlingEmitterValueObjectSelfShuntTest
{
	[Rule]
	public var rule:IMethodRule = new MockitoRule();

	[Mock]
	public var helper:BitmapToTextureHelper;

	[Mock]
	public var texture: Texture;

	private const helperReturn:Vector.<Texture> = new <Texture>[];
	private const testId: uint = 1;

	private var emitter: Emitter2D;


	private var vo: StarlingEmitterValueObject;

	[Before(async, timeout=1000)]
	public function setUp() : void
	{
		Async.proceedOnEvent(this, FlexUnitStarlingIntegration.nativeStage, FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED, 15500);
		FlexUnitStarlingIntegration.createStarlingContext();
		emitter = new Emitter2D();
		setupTexture(100,100);
		vo = new StarlingEmitterValueObjectShunt(testId, emitter, helper);
	}

	[After]
	public function tearDown() : void
	{
		FlexUnitStarlingIntegration.destroyStarlingContext();
		helperReturn.length = 0;
	}

	[Test(expects="Error")]
	public function prepareForStarlingWithSingleTexture_failsWithMultipleBitmapParticleInit() : void
	{
		setupMultipleBitmapParticleInit();
		vo.prepareForStarlingWithSingleTexture(texture);
	}

	[Test(expects="Error")]
	public function prepareForStarlingWithTextureList_failsWithMultipleBitmapParticleInit() : void
	{
		setupMultipleBitmapParticleInit();
		vo.prepareForStarlingWithTextureList(Vector.<Texture>([texture, texture]));
	}

	[Test(expects="Error")]
	public function prepareForStarlingWithTextureAtlas_failsWithMultipleBitmapParticleInit() : void
	{
		setupMultipleBitmapParticleInit();
		vo.prepareForStarlingWithAtlas(texture);
	}

	[Test(expects="Error")]
	public function prepareForStarlingWithSingleTexture_AlreadyExistingDisplayObjectInitializer_throwsError() : void
	{
		setupBitmapParticleInit();
		setupAlreadyEmitterThatAlreadyHasDisplayObjectInitializerRegistered();
		vo.prepareForStarlingWithSingleTexture(texture);
	}

	[Test(expects="Error")]
	public function prepareForStarlingWithTextureList_AlreadyExistingDisplayObjectInitializer_throwsError() : void
	{
		setupBitmapParticleInit();
		setupAlreadyEmitterThatAlreadyHasDisplayObjectInitializerRegistered();
		vo.prepareForStarlingWithTextureList(Vector.<Texture>([texture,texture]));
	}

	[Test(expects="Error")]
	public function prepareForStarlingWithAtlas_AlreadyExistingDisplayObjectInitializer_throwsError() : void
	{
		setupBitmapParticleInit();
		setupAlreadyEmitterThatAlreadyHasDisplayObjectInitializerRegistered();
		vo.prepareForStarlingWithAtlas(texture);
	}

	[Test]
	public function prepareForStarlingWithAtlas_getsTexturesFromHelper() : void
	{
		setupHelper(3);
		var initializer:BitmapParticleInit = new BitmapParticleInit();
		emitter.addInitializer(initializer);
		vo.prepareForStarlingWithAtlas(texture);
		verify().that(helper.getTexturesFromSpriteSheetAndBitmapParticleInit(initializer, texture));
	}

	[Test]
	public function prepareForStarlingWithAtlas_addsPooledStarlingDisplayObjectInitializerToEmitter() : void
	{
		setupHelper(3);
		var initializer:BitmapParticleInit = new BitmapParticleInit();
		emitter.addInitializer(initializer);
		vo.prepareForStarlingWithAtlas(texture);
		assertEquals(1,emitter.getInitializersByClass(PooledStarlingDisplayObjectClass).length);
	}

	[Test]
	public function prepareForStarlingWithTextureList_addsPooledStarlingDisplayObjectInitializerToEmitter_doesNotGetTexturesFromHelper() : void
	{
		setupHelperToFailTestIfUsed();
		var initializer:BitmapParticleInit = new BitmapParticleInit();
		emitter.addInitializer(initializer);
		vo.prepareForStarlingWithTextureList(Vector.<Texture>([texture, texture]));
		assertEquals(1,emitter.getInitializersByClass(PooledStarlingDisplayObjectClass).length);
	}

	[Test]
	public function prepareForStarlingWithSingleTexture_addsPooledStarlingDisplayObjectInitializerToEmitter_doesNotGetTexturesFromHelper() : void
	{
		setupHelperToFailTestIfUsed();
		var initializer:BitmapParticleInit = new BitmapParticleInit();
		emitter.addInitializer(initializer);
		vo.prepareForStarlingWithSingleTexture(texture);
		assertEquals(1,emitter.getInitializersByClass(PooledStarlingDisplayObjectClass).length);
	}

	private function setupTexture(width: int, height: int): void
	{
		given(texture.width).willReturn(width);
		given(texture.height).willReturn(height);
	}

	private function setupHelper(numFrames: uint = 1): void
	{
		given(helper.getTexturesFromBitmapParticleInit(any())).willReturn(helperReturn);
		given(helper.getTexturesFromSpriteSheetAndBitmapParticleInit(any(),any())).willReturn(helperReturn);


		for(var i: int = 0; i<numFrames; i++)
		{
			helperReturn.push(texture);
		}
	}

	private function setupHelperToFailTestIfUsed(): void
	{
		given(helper.getTexturesFromBitmapParticleInit(any())).willThrow(new Error("this method is not to use the helper"));
		given(helper.getTexturesFromSpriteSheetAndBitmapParticleInit(any(),any())).willThrow(new Error("this method is not to use the helper"));
	}

	private function setupBitmapParticleInit(): void
	{
		var initializer:BitmapParticleInit = new BitmapParticleInit();
		emitter.addInitializer(initializer);
	}

	private function setupAlreadyEmitterThatAlreadyHasDisplayObjectInitializerRegistered(): void
	{
		emitter.addInitializer(new PooledStarlingDisplayObjectClass());
	}

	private function setupMultipleBitmapParticleInit(): void
	{
		emitter.addInitializer(new BitmapParticleInit());
		emitter.addInitializer(new BitmapParticleInit());
	}

}
}

import com.plumbee.stardustplayer.emitter.BitmapToTextureHelper;
import com.plumbee.stardustplayer.emitter.StarlingEmitterValueObject;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;

internal class StarlingEmitterValueObjectShunt extends StarlingEmitterValueObject
{
	private var _mockedHelper: BitmapToTextureHelper;

	public function StarlingEmitterValueObjectShunt(emitterId : uint, emitter : Emitter2D, mockedHelper: BitmapToTextureHelper)
	{
		_mockedHelper = mockedHelper;
		super(emitterId, emitter);
	}

	override protected function getBitmapToTextureHelper() : BitmapToTextureHelper
	{
		return _mockedHelper;
	}
}
