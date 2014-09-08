package tv.turbodrive.away3d.transitions.timeline
{
	import com.greensock.easing.Quad;
	
	import tv.turbodrive.away3d.transitions.timeline.vo.RiggedCamVO;
	
	public class TimelineData
	{
		public static const PORTAL_IN_ONTHEFLY:String = "PortalInOnTheFly"
		public static const PORTAL_OUT_ONTHEFLY:String = "PortalOutOnTheFly"
		public static const GP3D_AS_TARGET_ONTHEFLY:String = "Gp3dCoordinatesAsTargetOnThefly"
		public static const GP3D_INTERNAL:String = "Gp3dInternalSubPage"
		public static const LOADER_ON_THE_FLY:String = "Gp3dInternalLoaderOnTheFly";
	
		public static const X:String = "x"
		public static const Y:String = "y"
		public static const Z:String = "z"	
		
		protected var _x:TimelineParams
		protected var _y:TimelineParams
		protected var _z:TimelineParams	
				
		protected var _name:String;
		protected var _reverseAexCoord:Boolean;
		protected var _useFrameDurations:Boolean;
		
		public var startValues:RiggedCamVO
		public var endValues:RiggedCamVO
		public var startValuesType:String
		public var endValuesType:String
		
		public var commonEase:*
		public var commonDuration:Number = 1
		public var commonDelay:Number = 0	
		
		public var autoPlay:Boolean = true
		//public var onTheFly:Boolean = false	
		
		
		public function TimelineData(name:String = "empty", useFrameDurations:Boolean = false, reverseAexCoord:Boolean = true)
		{
			_reverseAexCoord = reverseAexCoord;
			_name = name
			_useFrameDurations = useFrameDurations
			commonEase = Quad.easeInOut	
			
			_x = new TimelineParams(X,useFrameDurations)
			_y = new TimelineParams(Y,useFrameDurations, reverseAexCoord)
			_z = new TimelineParams(Z,useFrameDurations)			
			
			if(name == "empty"){				
				_x.setParams([0],[0])
				_y.setParams([0],[0])
				_z.setParams([0],[0])
			}
		}
		
		public function get onTheFly():Boolean
		{
			return (startValuesType || endValuesType)
		}
		
		public function get name():String
		{
			return _name
		}		
		
		public function get propsList():Array
		{
			return [X,Y,Z]
		}
		
		public function getLastValue(propName:String):Number
		{
			var values:Array = TimelineParams(this[propName]).values
			if(!values) return 0
			return values[values.length-1]
		}		
		
		public function get x():TimelineParams
		{
			return _x
		}
		
		public function get y():TimelineParams
		{
			return _y
		}
		
		public function get z():TimelineParams
		{
			return _z
		}
		
		public function get useFrameDurations():Boolean
		{
			return _useFrameDurations
		}
		
		
	}
}