package tv.turbodrive.away3d.transitions
{
	import com.greensock.events.TweenEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import away3d.tools.utils.Grid;
	
	import tv.turbodrive.away3d.core.NavCamera;
	import tv.turbodrive.away3d.elements.FromReelGp3D;
	import tv.turbodrive.away3d.elements.GridLoadGp3D;
	import tv.turbodrive.away3d.elements.HyperDriveGp3D;
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.away3d.tools.RiggedCameraBehaviour;
	import tv.turbodrive.away3d.transitions.timeline.TimelineCamera;
	import tv.turbodrive.away3d.transitions.timeline.TimelineCameraData;
	import tv.turbodrive.events.TransitionEvent;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class TransitionsEngine extends EventDispatcher
	{
		private var _camera:NavCamera;
		private var _timelineCamera:TimelineCamera;
		private var _currentTransition:String;
		private var _currentTimeline:String;

		private var _delay:Number;
		private var _destination:GroupPlane3D
		private var _departure:GroupPlane3D;
		
		private var _firstOfMultipleTimeline:Boolean;
		private var _secondOfMultipleTimeline:Boolean;
		private var _hyperDriveGp3d:GroupPlane3D;
		private var _gridLoadGp3d:GroupPlane3D;
		private var _readyToResume:Boolean = false
		private var _currentLoop:String
		
		private var _transitionsInfo:TransitionPageData;
		private var _autoResume:Boolean = false;
		private var _tmpTransitionsInfo:TransitionPageData;

		private var _currentTcData:TimelineCameraData;
		private var _delayWait:Number = 0
		private var _debugTrace:Boolean = false
		
		public function TransitionsEngine(camera:NavCamera, rgcHelper:RiggedCameraBehaviour, hyperDriveGp3d:GroupPlane3D, gridLoadGp3d:GroupPlane3D)
		{
			_camera = camera
			_timelineCamera = new TimelineCamera(_camera, rgcHelper);
			_timelineCamera.addEventListener(TweenEvent.COMPLETE, timelineCameraCompleteHandler)
			_hyperDriveGp3d = hyperDriveGp3d
			_gridLoadGp3d = gridLoadGp3d
		}		
		
		public function play(destination:GroupPlane3D, departure:GroupPlane3D = null, transitionsInfo:TransitionPageData = null):void
		{			
			_destination = destination
			//_destination.visible = false			
			if(_debugTrace) trace("[TE] play " + transitionsInfo.transitionName + " waitLoading : " + transitionsInfo.waitLoading);
			_transitionsInfo = transitionsInfo;
			_currentTransition = _transitionsInfo.transitionName;
			//if(_debugTrace) trace('_currentTransition >> ' + _currentTransition)
			_currentTimeline = TransitionsLibrary.lib[_currentTransition][0];
			if(departure){
				_departure = departure;
				if(!_departure.isBuilt()) _departure.build();
				_departure.visible = true;
			}
			_firstOfMultipleTimeline = (TransitionsLibrary.lib[_currentTransition].length > 1);
			_secondOfMultipleTimeline = false;
				
			prepareGp3DAndProcess()
		}	
		
		public function resumeMultiPartTransition(transitionsInfo:TransitionPageData):void
		{	
			if(_debugTrace) trace("[TE] resumeMultiPartTransition : " + transitionsInfo.transitionName)
			if(_transitionsInfo.nextPage != transitionsInfo.nextPage){
				if(_debugTrace) trace("[TE] " + _transitionsInfo.nextPage + " / " + transitionsInfo.nextPage )				
				throw new Error("You can't resume a transition with different page(s) than expected")
			}
			_tmpTransitionsInfo = transitionsInfo;
			_autoResume = true			
			checkResumeMultiPartTransition()
		}
		
		private function checkResumeMultiPartTransition():void
		{
			if(_debugTrace) trace("[TE] checkResumeMultiPartTransition " + _readyToResume + " - " + _autoResume + " - " + _destination.isBuilt())	
			if(_firstOfMultipleTimeline && _readyToResume){
				if(_autoResume){
					_autoResume = _readyToResume = false;		
					_transitionsInfo = _tmpTransitionsInfo;
					_firstOfMultipleTimeline = false;
					_secondOfMultipleTimeline = true;
					_currentTransition = _transitionsInfo.transitionName;
					var transitionArray:Array = TransitionsLibrary.lib[_currentTransition]
					if(transitionArray.length == 1){
						_currentTimeline = transitionArray[0];
					}else{
						_currentTimeline = transitionArray[1];
					}
						
					if(_destination.needToWaitWhenBuilt()) _destination.addEventListener(GroupPlane3D.BUILD_COMPLETE, buildDestinationComplete);
					_destination.build();
					if(_destination.isBuilt()) buildDestinationComplete(null);
				}else{
					dispatchEvent(new TransitionEvent(TransitionEvent.FIRSTOFMULTI_COMPLETE, _transitionsInfo))
				}
			}
		}
		
		protected function buildDestinationComplete(event:Event):void
		{
			_destination.removeEventListener(GroupPlane3D.BUILD_COMPLETE, buildDestinationComplete)
			prepareGp3DAndProcess()		
		}
		
		
		private function prepareGp3DAndProcess():void
		{	
			startSingleTransition();
			//_delay = setTimeout(startSingleTransition,_delayWait);
		}
		
		private function prepare():void
		{
			if(_firstOfMultipleTimeline){
				//_destination.position = new Vector3D(5000000,5000000);
				_currentLoop = TransitionsSelector.getLoop(_currentTransition)
				if(_currentLoop == TransitionsName.LOOP_HYPERDRIVE){
					_destination.position = new Vector3D(0,0,0)
					HyperDriveGp3D(_hyperDriveGp3d).preStart()
					_hyperDriveGp3d.transform = TimelineCamera.getEndTransform(_currentTimeline, _departure);
				}else {
					_gridLoadGp3d.transform = TimelineCamera.getEndTransform(_currentTimeline, _departure);
				}
			}else{
				//if(_currentLoop == TransitionsName.LOOP_HYPERDRIVE){
					_destination.visible = true;
					_destination.resetPosition();
				//}
				if(!_destination.isBuilt() && !_secondOfMultipleTimeline) _destination.build();
				if(!_destination.subPositionAreGenerated) _destination.generateSubPagePosition();
			}
		}			
		
		private function startSingleTransition():void
		{
			prepare();
			if(_secondOfMultipleTimeline) dispatchEvent(new TransitionEvent(TransitionEvent.MULTIPART_RESUME, _transitionsInfo))
			_readyToResume = false;
			clearTimeout(_delay);
			
			var hyperDriveInstance:GroupPlane3D = _firstOfMultipleTimeline ? null : GroupPlane3D(_hyperDriveGp3d);
			if(_debugTrace) trace("Start1")
			_currentTcData = _timelineCamera.play(_currentTimeline, hyperDriveInstance, _destination, _departure, _transitionsInfo.internalSubTransition);
			if(_debugTrace) trace("Start2")
			if(_firstOfMultipleTimeline){
				if(_currentLoop == TransitionsName.LOOP_HYPERDRIVE){
					_hyperDriveGp3d.startTransition(_currentTcData.globalDuration, _transitionsInfo);
				} else {
					_gridLoadGp3d.startTransition(_currentTcData.globalDuration, _transitionsInfo);
				}
				
			}else{
				if(_currentLoop == TransitionsName.LOOP_HYPERDRIVE){
					if(_hyperDriveGp3d.visible) HyperDriveGp3D(_hyperDriveGp3d).hide();
				} else {
					if(_gridLoadGp3d.visible) GridLoadGp3D(_gridLoadGp3d).hide();
				}
				
				_destination.startTransition(_currentTcData.globalDuration, _transitionsInfo);
			}
			if(!_secondOfMultipleTimeline && _departure){				
				//if(_currentLoop != TransitionsName.LOOP_GRID){
					_departure.hideTransition(_transitionsInfo.internalSubTransition);
					if(_departure is FromReelGp3D){
						_camera.fadeBgFromBlack()
					}
				//}else{
					//_departure.fadeAlpha(0);
				//}
			}
			if(_debugTrace) trace("[TE] transitions starts");
			dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_STARTS, _transitionsInfo))
		}
				
		protected function timelineCameraCompleteHandler(event:Event):void
		{	
			//// CHECK
			if(_firstOfMultipleTimeline){			
				if(_departure && _currentLoop != TransitionsName.LOOP_GRID) _departure.dispose();
				//if(_hyperDriveGp3d.visible) _hyperDriveGp3d.transform = new Matrix3D();
				if(_debugTrace) trace("[TE] transition 1st part Complete");
				_readyToResume = true				
				if(_transitionsInfo.waitLoading){
					// 1st timeline
					if(_debugTrace) trace("[TE] wait assets...")
					checkResumeMultiPartTransition()
				}else{
					if(_debugTrace) trace("[TE] auto resume")
					resumeMultiPartTransition(_transitionsInfo)
				}
			}else{
				if(!_transitionsInfo.internalSubTransition){
					_camera.reset(_destination.worldTargetCamCoordinates);
				}
				dispatchEvent(new TransitionEvent(TransitionEvent.TRANSITION_COMPLETE, _transitionsInfo))
				//_destination.transform = new Matrix3D();		
				
				if(_debugTrace) trace("------------------")
				if(_debugTrace) trace("_destination : " + _destination.position + " - " + _destination.rotationX+ " - " + _destination.rotationY+ " - " + _destination.rotationZ)
				if(_debugTrace) trace("------------------")
			}
		}		
	}
}