package com.plumbee.stardustplayer
{
import flash.display.Stage;

import mx.core.FlexGlobals;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

public class FlexUnitStarlingIntegration extends Sprite
{
	private static var _starling : Starling;

	public function FlexUnitStarlingIntegration()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	public static function createStarlingContext() : void
	{
		_starling = new Starling(FlexUnitStarlingIntegration, FlexGlobals.topLevelApplication.stage);
		_starling.start();
	}

	public static function destroyStarlingContext() : void
	{
		if (_starling)
		{
			_starling.stop();
			_starling.dispose();
			_starling = null;
		}
	}

	public static function get nativeStage() : Stage
	{
		return FlexGlobals.topLevelApplication.stage;
	}

	private function onAddedToStage(event : Event) : void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		nativeStage.dispatchEvent(new FlexUnitStarlingIntegrationEvent(FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED));
	}
}
}
