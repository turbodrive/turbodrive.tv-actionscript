package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.tools.utils.Bounds;

	public class AnimatedTimelineBlock
	{
		private var _xInit:Number = 0
		private var _block:Mesh
		private var _width:Number
		public var id:int
		
		private var _time:Number;
		private var _delay:Number;
		private var _initAlpha:Number = 0
		
		public function AnimatedTimelineBlock(block:Mesh)
		{
			_xInit = block.x
			_block = block
			//_block.scaleY = 10
			//_block.scaleZ = 4
			Bounds.getObjectContainerBounds(block)
			ColorMaterial(_block.material).alphaPremultiplied = false
			_width = Bounds.width
			id = int(block.name.slice(4))
			_initAlpha = ColorMaterial(_block.material).alpha
		}
		
		public function get x():Number
		{
			return _block.x
		}
		
		public function setTimeAndDelay(time:Number, delay:Number):void
		{
			_time = time
			_delay = delay
		}
		
		public function get width():Number
		{
			return _width
		}
		
		public function set animatedScale(value:Number):void
		{
			_block.scaleX = value
			_block.x = _xInit-(_width*0.5)+(_width*0.5*value)
			if(value <= 0){
				_block.visible = false
			}else if(!_block.visible){
				_block.visible = true
			}
		}
		
		public function get animatedScale():Number
		{
			return _block.scaleX
		}
		
		public function play():void
		{
			ColorMaterial(_block.material).alpha = _initAlpha
			animatedScale = 0				
			TweenMax.to(this, _time, {animatedScale:1, delay:_delay, ease:Linear.easeNone})
		}
		
		public function hide(d:Number):void
		{
			TweenMax.to(_block.material, 0.3, {delay:d, alpha:0})
		}
	}
}