package com.plumbee.stardustplayer
{

import com.plumbee.stardustplayer.emitter.EmitterBuilder;
import com.plumbee.stardustplayer.emitter.EmitterValueObject;
import com.plumbee.stardustplayer.project.ProjectValueObject;
import com.plumbee.stardustplayer.sequenceLoader.ISequenceLoader;
import com.plumbee.stardustplayer.sequenceLoader.LoadByteArrayJob;
import com.plumbee.stardustplayer.sequenceLoader.SequenceLoader;

import flash.display.Bitmap;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.display.bitmapParticle.BitmapParticle;

import org.as3commons.zip.Zip;

use namespace sd;

public class SimLoader extends EventDispatcher implements ISimLoader
{
    private static const bitmapParticle : BitmapParticle = null; // this is needed here, so it can be instantiated
    public static const DESCRIPTOR_FILENAME : String = "descriptor.json";
    private static const BACKGROUND_JOB_ID : String = "backgroundID";
    private const sequenceLoader : ISequenceLoader = new SequenceLoader();
    private var _project : ProjectValueObject;
    private var projectLoaded : Boolean = false;

    /* Loads an .sde file (thats in a byteArray). */
    public function loadSim(data : ByteArray) : void
    {
        projectLoaded = false;
        sequenceLoader.clearAllJobs();

        const loadedZip : Zip = new Zip();
        loadedZip.loadBytes( data );
        const descriptorJSON : Object = JSON.parse( loadedZip.getFileByName( DESCRIPTOR_FILENAME ).getContentAsString() );
        _project = new ProjectValueObject( descriptorJSON );

        if ( loadedZip.getFileByName(_project.backgroundFileName) != null )
        {
            const backgroundJob : LoadByteArrayJob = new LoadByteArrayJob( BACKGROUND_JOB_ID,
                                                         _project.backgroundFileName,
                                                         loadedZip.getFileByName(_project.backgroundFileName).content );
            sequenceLoader.addJob( backgroundJob );
        }
        for each (var emitterVO : EmitterValueObject in _project.emitters)
        {
            const job : LoadByteArrayJob = new LoadByteArrayJob(
                                                    emitterVO.id.toString(),
                                                    emitterVO.imageName,
                                                    loadedZip.getFileByName(emitterVO.imageName).content );
            sequenceLoader.addJob( job );

            const stardustBA : ByteArray = loadedZip.getFileByName( emitterVO.xmlName ).content;
            const xml : XML = new XML( stardustBA.readUTFBytes( stardustBA.length ) );
            emitterVO.emitter = EmitterBuilder.buildEmitter( xml );
        }

        sequenceLoader.addEventListener( Event.COMPLETE, onProjectAssetsLoaded );
        sequenceLoader.loadSequence();
    }

    private function onProjectAssetsLoaded( event : Event ) : void
    {
        sequenceLoader.removeEventListener( Event.COMPLETE, onProjectAssetsLoaded );

        for each (var emitterVO : EmitterValueObject in _project.emitters)
        {
            const job : LoadByteArrayJob = sequenceLoader.getJobByName( emitterVO.id.toString() );
            emitterVO.image = Bitmap(job.content).bitmapData;
        }
        if ( sequenceLoader.getJobByName(BACKGROUND_JOB_ID) )
        {
            _project.backgroundImage = sequenceLoader.getJobByName(BACKGROUND_JOB_ID).content;
            _project.backgroundRawData = sequenceLoader.getJobByName(BACKGROUND_JOB_ID).byteArray;
        }
        sequenceLoader.clearAllJobs();
        projectLoaded = true;
        dispatchEvent( new Event(Event.COMPLETE) );
    }

    public function get project() : ProjectValueObject
    {
        if (projectLoaded)
        {
            return _project;
        }
        return null;
    }
}
}
