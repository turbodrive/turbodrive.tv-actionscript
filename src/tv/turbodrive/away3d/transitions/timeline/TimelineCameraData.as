package tv.turbodrive.away3d.transitions.timeline
{
	import tv.turbodrive.away3d.utils.Tools3d;

	public class TimelineCameraData extends TimelineData
	{
		public static const RIGGED_CAM:String = "riggedCamera"
		public static const TARGET_CAM:String = "targetCamera"
		public static const AUTO:String = "cameraSetByGp3D"
		
		public static const ROTATION_X:String = "rotationX" // RiggedCam
		public static const ROTATION_Y:String = "rotationY" // RiggedCam
		public static const ROTATION_Z:String = "rotationZ" // RiggedCam
		public static const RIG_DISTANCE:String = "rigDistance" // RiggedCam
			
		public static const LOCAL_ROTATION_Z:String = "localRz" // TargetCam
			
		public static const DYNAMIC_RD_VALUE:String = "dynamicRigDistanceValue"
			
		private var _rX:TimelineParams
		private var _rY:TimelineParams
		private var _rZ:TimelineParams
		private var _localRz:TimelineParams
		private var _rigDistance:TimelineParams
		
		private var _isTargetCamera:Boolean = false;
		public var timelineTargetData:TimelineData;
		private var _type:String;
		public var globalDuration:Number
		
		public var rollCamera:Boolean = false
		
		public function TimelineCameraData(name:String="empty", type:String = "riggedCamera", useFrameDurations:Boolean=false, reverseAexCoord:Boolean=true)
		{
			super(name, useFrameDurations, reverseAexCoord);			
			this.typeCamera = type			
		}
		
		public function set typeCamera(value:String):void
		{
			_type = value
			if(_type != AUTO) {
				_isTargetCamera = (_type == TARGET_CAM)
			}			
			init();
		}
		
		private function init():void
		{
			if(_type != RIGGED_CAM){
				_localRz = new TimelineParams(LOCAL_ROTATION_Z, _useFrameDurations)
				timelineTargetData = new TimelineData("target", _useFrameDurations, _reverseAexCoord);
			}
			
			if(_type != TARGET_CAM){
				_rX = new TimelineParams(ROTATION_X,_useFrameDurations, _reverseAexCoord)
				_rY = new TimelineParams(ROTATION_Y,_useFrameDurations)
				_rZ = new TimelineParams(ROTATION_Z,_useFrameDurations, _reverseAexCoord)				
				_rigDistance = new TimelineParams(RIG_DISTANCE,_useFrameDurations)
			}			
			
			if(_name == "empty"){			
				if(_type != RIGGED_CAM){
					_localRz.setParams([0],[0])
				}
				
				if(_type != TARGET_CAM){
					_rX.setParams([0],[0])			
					_rY.setParams([0],[0])
					_rZ.setParams([0],[0])					
					_rigDistance.setParams([Tools3d.DISTANCE_Z_1280],[0])
				}			
			}
		}	
		
		public function get typeCamera():String
		{
			return _type
		}
		
		public function get isTargetCamera():Boolean
		{
			return _isTargetCamera
		}
		
		override public function get propsList():Array
		{
			var list:Array = super.propsList
			if(_type != RIGGED_CAM){
				list.push(LOCAL_ROTATION_Z);
			}
			if(_type != TARGET_CAM){
				list.push(ROTATION_X, ROTATION_Y, ROTATION_Z, RIG_DISTANCE);
			}
			
			return list
		}
		
		public function get rotationX():TimelineParams
		{
			if(_type == TARGET_CAM) throw new Error("This timeline camera is set for " +  _type)
			return _rX
		}
		
		public function get rotationY():TimelineParams
		{
			if(_type == TARGET_CAM) throw new Error("This timeline camera is set for " +  _type)
			return _rY
		}
		
		public function get rotationZ():TimelineParams
		{
			if(_type == TARGET_CAM) throw new Error("This timeline camera is set for " +  _type)
			return _rZ
		}
		
		public function get localRz():TimelineParams
		{
			if(_type == RIGGED_CAM) throw new Error("This timeline camera is set for " +  _type)
			return _localRz
		}
		
		public function get rigDistance():TimelineParams
		{
			if(_type == TARGET_CAM) throw new Error("This timeline camera is set for " +  _type)
			return _rigDistance
		}
	}
}