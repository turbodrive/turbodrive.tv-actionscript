package tv.turbodrive.away3d.elements.entities
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import away3d.materials.MaterialBase;
	
	import org.puremvc.as3.core.View;
	
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	
	public class AnimatedUVMesh extends PlaneMesh
	{
		public static const VERTICAL:String = "vertical"
		public static const HORIZONTAL:String = "horizontal"		
		public static const COMPLETE:String = "animationComplete";
			
		private var _direction:String = HORIZONTAL
		private var _currentFrame:int = 1		
		private var _totalFrames:int = 1;
		private var _isPlaying:Boolean = false;
		private var _isLooping:Boolean = false;
		private var _listeningRender:Boolean = false
			
		private var _sequence:Array = []
		private var _playHeadPosition :int = 1
		private var _playSequence:Boolean = false;
		
		public function AnimatedUVMesh(material:MaterialBase, idArea:String, options:Object = null)
		{
			super(material, idArea,options);
		}
		
		public function setDirection(direction:String):void
		{
			_direction = direction
		}
		
		public function set sequence(value:Array):void
		{
			_sequence = value
			_playSequence = true
			_totalFrames = _sequence.length
			_playHeadPosition = 1
			updatePlayHead();
		}
		
		private function updateframe():void
		{
			var rect:Rectangle = _atlasArea.clone();		
			if(_direction == HORIZONTAL) rect.x += (rect.width*(_currentFrame-1))
			if(_direction == VERTICAL) rect.y += (rect.height*(_currentFrame-1))
			adjustUVs(rect)
		}		
		
		public function set frame(value:int):void
		{
			_currentFrame = value
			updateframe();
		}
		
		public function get frame():int
		{
			return _currentFrame
		}
		
		public function set totalframes(value:int):void
		{
			_totalFrames = value
		}
		
		public function get totalframes():int
		{
			return _totalFrames
		}
		
		public function set loop(value:Boolean):void
		{
			_isLooping = value	
		}
		
		public function get loop():Boolean
		{
			return _isLooping
		}
		
		public function play():void
		{
			_playHeadPosition = 0
			_isPlaying = true
				
			if(!_listeningRender){
				_viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender);
				_listeningRender = true
			}
		}
		
		public function stop():void
		{
			_isPlaying = false
			if(_listeningRender){
				_viewRenderer.removeEventListener(ViewRender3DEvent.ON_RENDER, onRender);
				_listeningRender = false
			}
		}
		
		private function updatePlayHead():void
		{
			if(_playSequence){
				frame = _sequence[_playHeadPosition-1]
			}else{
				frame = _playHeadPosition
			}
		}
		
		override protected function onRender(e:Event):void
		{
			if(_isPlaying){
				if(_playHeadPosition == _totalFrames){
					if(_isLooping){
						_playHeadPosition = 1
					}else{
						stop();
						dispatchEvent(new Event(COMPLETE))
					}
				}else{
					_playHeadPosition ++						
				}
				updatePlayHead();
			}
			
			super.onRender(e);
		}

	}
}