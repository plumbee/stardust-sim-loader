package com.plumbee.stardustplayer.emitter
{
import com.plumbee.stardustplayer.FlexUnitStarlingIntegration;
import com.plumbee.stardustplayer.FlexUnitStarlingIntegrationEvent;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;

import org.flexunit.asserts.assertEquals;
import org.flexunit.async.Async;

public class BitmapToTextureHelperTest
{
	private var helper : BitmapToTextureHelper;
	private var initializer : BitmapParticleInit;

	[Before(async, timeout=1000)]
	public function setUp() : void
	{
		Async.proceedOnEvent(this, FlexUnitStarlingIntegration.nativeStage, FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED, 15500);
		FlexUnitStarlingIntegration.createStarlingContext();
		helper = new BitmapToTextureHelper();
		initializer = new BitmapParticleInit();
	}

	[Test]
	public function typeSingleImage_texturesSize1() : void
	{
		initializer.bitmapData = new BitmapData(1, 1);
		initializer.bitmapType = BitmapParticleInit.SINGLE_IMAGE;
		assertEquals(1, helper.getTexturesFromBitmapParticleInit(initializer).length);
	}

	[Test(expects="Error")]
	public function typeSingleImage_nullBitmap_throwsError() : void
	{
		initializer.bitmapData = null;
		initializer.bitmapType = BitmapParticleInit.SINGLE_IMAGE;
		helper.getTexturesFromBitmapParticleInit(initializer);
	}

	[Test]
	public function typeSpriteSheet_singleFrame_texturesSize1() : void
	{
		var width : uint = 1;
		initializer.bitmapData = new BitmapData(width, 1);
		initializer.spriteSheetSliceWidth = width;
		initializer.bitmapType = BitmapParticleInit.SINGLE_IMAGE;
		assertEquals(1, helper.getTexturesFromBitmapParticleInit(initializer).length);
	}

	[Test]
	public function typeSpriteSheet_multipleFrames_texturesSizeNFrames() : void
	{
		var frameWidth : uint = 2;
		var frames : uint = 2;
		var spritesheetWidth : uint = frameWidth * frames;
		initializer.bitmapData = new BitmapData(spritesheetWidth, 1);
		initializer.spriteSheetSliceWidth = frames;
		initializer.bitmapType = BitmapParticleInit.SINGLE_IMAGE;
		assertEquals(1, helper.getTexturesFromBitmapParticleInit(initializer).length);
	}


	[Test(expects="Error")]
	public function invalidType_throwsError() : void
	{
		initializer.bitmapData = new BitmapData(1,1);
		initializer.bitmapType = "invalid";
		helper.getTexturesFromBitmapParticleInit(initializer);
	}

	[After]
	public function tearDown() : void
	{
		FlexUnitStarlingIntegration.destroyStarlingContext();
	}
}
}
