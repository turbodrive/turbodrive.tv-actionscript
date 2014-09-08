package tv.turbodrive.away3d.transitions.timeline
{
	public class TimelineParams
	{
		public static const FRAMERATE:int = 25	
		
		private var _values:Array
		private var _times:Array
		private var _eases:Array
		private var _delays:Array
		private var _propName:String
		
		private var _useFrameDurations:Boolean;
		private var _animated:Boolean = false		
		private var _isAdditiveInverse:Boolean;
		
		public function TimelineParams(propName:String, useFrameDurations:Boolean = false, isAdditiveInverse:Boolean = false)
		{
			_useFrameDurations = useFrameDurations
			_isAdditiveInverse = isAdditiveInverse // used to regulate AXIS difference between AfterEffects and Away3d 
			_propName = propName
		}
		
		public function setParams(values:Array, durations:Array = null, eases:Array = null, delays:Array = null):void
		{

			_values = _isAdditiveInverse ? convertAdditiveInv(values) : values		
			_times = _useFrameDurations ? convertFramesInTime(durations) : durations
			_eases = eases
			if(delays) _delays = _useFrameDurations ? convertFramesInTime(delays) : delays
				
			_animated = _values && _times
		}		
		
		public function isAnimated():Boolean
		{
			return _animated
		}
		
		private function convertFramesInTime(framesDurations:Array):Array
		{
			var timeDuration:Array = []
			for(var i:int = 0; i<framesDurations.length ; i++){
				timeDuration.push(framesDurations[i]/FRAMERATE)
			}
				
			return timeDuration
		}
		
		private function convertAdditiveInv(values:Array):Array
		{
			var invValues:Array = []
			for(var i:int = 0; i<values.length ; i++){
				invValues.push(-(values[i]))
			}
			
			return invValues
		}
		
		private function convertRotation(values:Array):Array
		{
			var invValues:Array = []
			for(var i:int = 0; i<values.length ; i++){
				invValues.push((values[i])-180)
			}
			
			return invValues
		}
		
		public function get propName():String
		{
			return _propName
		}
		
		public function get values():Array
		{
			return _values
		}
		
		public function get times():Array
		{
			return _times
		}
		
		public function get eases():Array
		{
			return _eases
		}
		
		public function get delays():Array
		{
			return _delays
		}
	}
}