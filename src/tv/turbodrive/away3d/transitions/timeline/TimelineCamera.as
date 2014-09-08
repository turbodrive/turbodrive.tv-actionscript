package tv.turbodrive.away3d.transitions.timeline
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease;
	import com.greensock.events.TweenEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import away3d.core.base.Object3D;
	
	import tv.turbodrive.away3d.core.NavCamera;
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.away3d.tools.RiggedCameraBehaviour;
	import tv.turbodrive.away3d.transitions.TransitionsLibrary;
	import tv.turbodrive.away3d.transitions.timeline.vo.ITweenable;
	import tv.turbodrive.away3d.transitions.timeline.vo.RiggedCamVO;
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;

	public class TimelineCamera extends EventDispatcher
	{				

		private var timelines:Dictionary
		private var _currentTimeline:TimelineMax;
		private static var timelinesCamData:Dictionary;
		private static var _rgcHelper:RiggedCameraBehaviour;

		private var _camera:NavCamera;

		private var _enableHyperDrive:Boolean;
		private var _gp3dLoop:GroupPlane3D;
		
		// RollVars
		private var _autoRollCamera:Boolean = false;
		private var _prevX:Number = 0
		private var _rotX:Number = 0
		private var _prevY:Number = 0
		private var _prevZ:Number = 0
		private var _rotZ:Number = 0
		
		private var smoothingFactor:Number = 1-(1/4)
		private var smoothX:Number = 0
		private var smoothZ:Number = 0
		
		public function TimelineCamera(camera:NavCamera, rgcHelper:RiggedCameraBehaviour)
		{
			timelines = new Dictionary();
			timelinesCamData = new Dictionary();
			_rgcHelper = rgcHelper
			_camera = camera
			
			var _library:TransitionsLibrary = new TransitionsLibrary()
			for(var i:int = 0; i<_library.timelinesCamera.length ; i++){
				registerTimeline(camera, _library.timelinesCamera[i])
			}			
		}
		
		private function registerTimeline(camera:NavCamera, data:TimelineData):void
		{
			if(!data.onTheFly){			
				timelines[data.name] = getTimeline(camera,data);
			}
			timelinesCamData[data.name] = data;
		}		
		
		/** CONTROLS **/		
		public static function getEndTransform(timelineName:String, departure:GroupPlane3D = null, traceHelp:Boolean = false):Matrix3D
		{			
			var timeline:TimelineCameraData = timelinesCamData[timelineName];
			_rgcHelper.transform = new Matrix3D();
			if(timeline.onTheFly){
				if(timeline.endValuesType == TimelineData.PORTAL_OUT_ONTHEFLY){
					_rgcHelper.position = departure.portalOut.position
					_rgcHelper.rotationX = departure.portalOut.rotationX
					_rgcHelper.rotationY = departure.portalOut.rotationY
					_rgcHelper.rotationZ = departure.portalOut.rotationZ
					//_rgcHelper.moveBackward(Tools3d.DISTANCE_Z_1280)
				}
				if(timeline.endValuesType == TimelineData.LOADER_ON_THE_FLY){
					_rgcHelper.position = departure.internalLoader.position
					_rgcHelper.rotationX = departure.internalLoader.rotationX
					_rgcHelper.rotationY = departure.internalLoader.rotationY
					_rgcHelper.rotationZ = departure.internalLoader.rotationZ
				}
			}else{
				_rgcHelper.x = timeline.getLastValue(TimelineData.X);
				_rgcHelper.y = timeline.getLastValue(TimelineData.Y);
				_rgcHelper.z = timeline.getLastValue(TimelineData.Z);
				
				//if(!timeline.isTargetCamera){
					_rgcHelper.rotationX = timeline.getLastValue(TimelineCameraData.ROTATION_X);
					_rgcHelper.rotationY = timeline.getLastValue(TimelineCameraData.ROTATION_Y);
					_rgcHelper.rotationZ = timeline.getLastValue(TimelineCameraData.ROTATION_Z);
				//}
			}
			if(traceHelp){
				trace("________ EndPosition >> " + _rgcHelper.position + " - rX: " +_rgcHelper.rotationX + " - rY: " +_rgcHelper.rotationX + " - rZ: "+ _rgcHelper.rotationZ )
			}
			
			return _rgcHelper.globalTransform
		}				
		
		public function hasInitState(timelineName:String):Boolean
		{	
			return TimelineCameraData(timelinesCamData[timelineName]).startValues
		}		
		
		public function getDuration(timelineName:String):Number
		{	
			if(timelines[timelineName]) return TimelineMax(timelines[timelineName]).duration();			
			return TimelineData(timelinesCamData[timelineName]).commonDuration	
		}
		
		public function play(timelineName:String, gp3dLoop:GroupPlane3D = null, destination:GroupPlane3D = null, departure:GroupPlane3D = null, internalSubPage:String = null):TimelineCameraData
		{	
			if(_currentTimeline){
				_currentTimeline.stop();
				_currentTimeline.removeEventListener(TweenEvent.COMPLETE, completeTimelineHandler)
				_currentTimeline.removeEventListener(TweenEvent.START, startTimelineHandler)
			}else{
				Stage3DView.instance.addEventListener(ViewRender3DEvent.ON_RENDER, onRenderHandler);
			}
			
			var timelineData:TimelineCameraData = TimelineCameraData(timelinesCamData[timelineName])
			_autoRollCamera = timelineData.rollCamera
			var isTargetCam:Boolean = false
			
			//var targetX:Number
			//var targetY:Number
			//var targetZ:Number
			
			if(!timelines[timelineName]){
				if(timelineData.onTheFly){
					if(!destination){
						throw new Error("On the fly set to true and no GP3D (destination) for calculations !")
					}else{
						// type of on the fly.
						// START VALUE
						if(timelineData.startValuesType){
							/*if(timelineData.startValuesType == TimelineData.GP3D_AS_TARGET_ONTHEFLY) {
								// Convert positions if targetCamera (Do nothing if it's riggedCamera)
								if(timelineData.isTargetCamera) timelineData.startValues = destination.worldTargetCamCoordinates
							}*/
							if(timelineData.startValuesType == TimelineData.PORTAL_IN_ONTHEFLY) {
								// get current GP3D portal IN
								timelineData.startValues = destination.portalIn
							}
							if(timelineData.startValuesType == TimelineData.PORTAL_OUT_ONTHEFLY){
								throw new Error("Portal OUT on the fly can't be used as startValues")
							}							
						}
						
						// END VALUE
						if(timelineData.endValuesType){
							var endValues:ITweenable
							// CAMERA
							var duration:Number
							var delay:Number
							var ease:Ease
							
							//if(!isTargetCam){
								if(timelineData.endValuesType != TimelineData.LOADER_ON_THE_FLY && timelineData.endValuesType != TimelineData.GP3D_AS_TARGET_ONTHEFLY && timelineData.endValuesType != TimelineData.GP3D_INTERNAL && timelineData.endValuesType != TimelineData.PORTAL_OUT_ONTHEFLY) {
									throw new Error("dynamicEndValues for RiggedCamera only on GP3D_AS_TARGET_ONTHEFLY, PORTAL_OUT_ONTHEFLY, LOADER_ON_THE_FLY or GP3D_INTERNAL")
								}
								if(timelineData.endValuesType == TimelineData.PORTAL_OUT_ONTHEFLY){
									timelineData.endValues = departure.portalOut
								}else if(timelineData.endValuesType == TimelineData.LOADER_ON_THE_FLY){
									timelineData.endValues = departure.internalLoader
								}else{
									timelineData.endValues = internalSubPage ? destination.getInternalSubPosition(internalSubPage) : destination.worldTargetCamCoordinates
								}							
								// ON THE FLY camera transition
								endValues = timelineData.endValues as ITweenable
								// CAMERA
								if(endValues.duration){
									duration = timelineData.useFrameDurations ? endValues.frameDuration : endValues.duration
								}else{
									duration = timelineData.commonDuration
								}								
								if(endValues.delay){
									delay = timelineData.useFrameDurations ? endValues.frameDelay : endValues.delay
								}else{
									delay = timelineData.commonDelay
								}
								ease = endValues.ease ? endValues.ease : timelineData.commonEase					
								if(!isNaN(endValues.x)){
									//targetX = endValues.x
									timelineData.x.setParams([endValues.x],[duration],[ease],[delay]);
								}
								if(!isNaN(endValues.y)){
									//targetY = endValues.y
									timelineData.y.setParams([endValues.y],[duration],[ease],[delay]);
								}
								if(!isNaN(endValues.z)){
									//targetZ = endValues.z
									timelineData.z.setParams([endValues.z],[duration],[ease],[delay]);
								}
								if(!isNaN(endValues.rotationX)) timelineData.rotationX.setParams([endValues.rotationX],[duration],[ease],[delay]);
								if(!isNaN(endValues.rotationY)){
									timelineData.rotationY.setParams([endValues.rotationY],[duration],[ease],[delay]);
									//trace("ADD RotationY > " + endValues.rotationY)
								}
								if(!isNaN(endValues.rotationZ)) timelineData.rotationZ.setParams([endValues.rotationZ],[duration],[ease],[delay]);
								if(!isNaN(endValues.rigDistance)) timelineData.rigDistance.setParams([endValues.rigDistance],[duration],[ease],[delay]);
								
								if(endValues.rollCamera) timelineData.rollCamera = endValues.rollCamera // Overwrite timelineData only if envalues.rollcamera is TRUE
								//trace("endValues >> " + endValues)
								_currentTimeline = getTimeline(_camera,timelineData);
								
								
								
							/*}else{
								throw new Error("Not Allowed to use a targetCam in this version of Turbodrive")
							}*/
						}
					}					
				}else{
					// allready prepared
					_currentTimeline = getTimeline(_camera,timelineData);
				}
			}else{
				_currentTimeline = timelines[timelineName] as TimelineMax		
			}
			
			_currentTimeline.addEventListener(TweenEvent.COMPLETE, completeTimelineHandler)
			_currentTimeline.addEventListener(TweenEvent.START, startTimelineHandler)
			_currentTimeline.progress(0)
			_camera.isTargetCamera = false		
								
			if(timelineData.startValues){
				if(timelineData.startValues is String) throw new Error("Set startvalues as TweenableObject3D instead of constant")
				var props:RiggedCamVO = timelineData.startValues as RiggedCamVO
				if(!isNaN(props.x)) _camera.x = props.x
				if(!isNaN(props.y)) _camera.y = props.y
				if(!isNaN(props.z)) _camera.z = props.z
				
				/*if(props is Gp3DVO){
					var propsT:Gp3DVO = Gp3DVO(props)
				}else if(props is RiggedCamVO){*/
					//var propsR:RiggedCamVO = RiggedCamVO(props)
					if(!isNaN(props.rotationX)) _camera.rotationX = props.rotationX
					if(!isNaN(props.rotationY)) _camera.rotationY = props.rotationY
					if(!isNaN(props.rotationZ)) _camera.rotationZ = props.rotationZ					
					if(!isNaN(props.rigDistance)) _camera.rigDistance = props.rigDistance
				//}
				
			}
			
			if(gp3dLoop){
				_gp3dLoop = gp3dLoop
				_gp3dLoop.transform = _camera.transform.clone()
				_gp3dLoop.rotationX = _camera.rotationX
				_gp3dLoop.rotationY = _camera.rotationY
				_gp3dLoop.rotationZ = _camera.rotationZ
			}else{
				_gp3dLoop = null
			}
			
			if(timelineData.autoPlay){
				_prevX = _localCamPosition.x
				_prevY = _localCamPosition.y
				_prevZ = _localCamPosition.z
				
				//getEndTransform(timelineName, departure, true);
				//for()
				_currentTimeline.play()
				//setTimeout(reelPlay,1000)
			}			
			timelineData.globalDuration = _currentTimeline.duration();
			
			return timelineData
		}
		
		private function get _localCamPosition():Vector3D
		{
			return _camera.coreInverseSceneTransform.transformVector(Stage3DView._gridContainer.position)
		}	
		
		private function rollCamera():void
		{
			var localCamPosition:Vector3D = _localCamPosition
			
			// RollZ (left/right)
			var speedX:Number = _prevX - localCamPosition.x
			_rotZ = speedX*.015
			smoothZ = (_rotZ*smoothingFactor) + ( smoothZ * ( 1.0 - smoothingFactor))
			//_camera.rollZ = smoothZ
			_camera.rollZ += (smoothZ-_camera.rollZ)*0.2
			_prevX = localCamPosition.x
			
			// RollX (up/down)
			var speedY:Number = _prevY - localCamPosition.y
			var rotX:Number = speedY*.015
			_prevY = localCamPosition.y
			
			// RollX (backward/forward)
			var speedZ:Number = _prevZ - localCamPosition.z
			var rotX2:Number = -speedZ*.015
			_prevZ = localCamPosition.z
				
			_rotX = rotX2 + rotX				
			smoothX = (_rotX*smoothingFactor) + ( smoothX * ( 1.0 - smoothingFactor))
			//_camera.rollX = smoothX
			_camera.rollX += (smoothX-_camera.rollX)*0.2
			
			
						
			/*if(speedX != 0 || speedZ != 0){
				trace("0 x = " + localCamPosition.x + "- z =" + localCamPosition.z)
				trace("1 x = " + speedX + "- z =" + speedZ)
			}*/
			
		}
		
		protected function onRenderHandler(event:Event):void
		{
			if(_autoRollCamera) rollCamera();
			if(_gp3dLoop){
				_gp3dLoop.transform = _camera.transform.clone()
				_gp3dLoop.moveForward(995.6)
				_gp3dLoop.roll(_camera.rotationZ)
			}
		}
		
		/** LISTENERS **/
		
		protected function startTimelineHandler(event:TweenEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function completeTimelineHandler(event:TweenEvent):void
		{				
			//Stage3DView.instance.removeEventListener(ViewRender3DEvent.ON_RENDER, onRenderHandler);
			//setTimeout(stopRender,1500)
			_currentTimeline.removeEventListener(TweenEvent.COMPLETE, completeTimelineHandler)
			_currentTimeline.removeEventListener(TweenEvent.START, startTimelineHandler)
			dispatchEvent(event.clone());			
		}
		
		private function stopRender():void
		{
			// TODO Auto Generated method stub
			Stage3DView.instance.removeEventListener(ViewRender3DEvent.ON_RENDER, onRenderHandler);
		}
		
		/** FROM CAMERA DATA (AE) TO TIMELINE (TWEENS) **/
		
		public static function getTimeline(tweenTarget:Object3D, tcData:TimelineData):TimelineMax
		{
			// create tweens for each propriety			
			var listProps:Array = tcData.propsList;
			var propTimelineList:Array = [];
			//trace("tx" + tcData.name)
			for(var i:int = 0; i<listProps.length; i++)
			{	
				var params:TimelineParams = tcData[listProps[i]] as TimelineParams;
				if(params.isAnimated()) propTimelineList.push(getPropTimeline(tweenTarget, params, tcData.commonEase, tcData.commonDuration));
			}
			
			var mainTL:TimelineMax = new TimelineMax();
			mainTL.appendMultiple(propTimelineList);
			mainTL.pause();
			return mainTL						
		}
		
		public static function getPropTimeline(tweenTarget:Object3D,params:TimelineParams, defaultEase:*, commonDuration:Number = -1):TimelineLite
		{
				var tl:TimelineLite = new TimelineLite();
				var len:int = params.values.length
				var prop:String = params.propName;
				tl.data = prop
					
				if(params.times.length != len){
					throw new Error("Error TimelineParams - [" + prop + "] - different number of durations and values")
				}
				
				for(var i:int = 0; i< len ; i++){					
					var ease:*
					if(params.eases && params.eases[i]){
						ease = params.eases[i]						
					}else {
						ease = defaultEase
					}
					
					var times:Number
					if(params.times && params.times[i]){
						times = params.times[i]						
					}else {
						times = commonDuration
					}
					
					var delay:Number
					if(params.delays && params.delays[i]){
						delay = params.delays[i]						
					}else {
						delay = 0
					}
					/*if(prop == "z"){
						trace("times " , times,  "-", params.values[i], " d ", delay, " ease:", ease)
					}*/
					
					var tw:TweenMax = getTween(tweenTarget, times, prop, params.values[i], ease, delay)
					tl.append(tw);
				}				
				return tl				
		}
				
		public static function getTween(tweenTarget:Object3D, time:Number, prop:String, targetValue:*, ease:* = null, delay:Number = 0):TweenMax
		{		
			var vars:Object = {};
			vars[prop] = targetValue;
			vars.ease = ease;
			if(delay > 0) vars.delay = delay;
			var tw:TweenMax = new TweenMax(tweenTarget, time, vars)
				
			return tw;
		}	
	}
}