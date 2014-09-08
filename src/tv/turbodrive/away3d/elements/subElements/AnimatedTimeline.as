package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import away3d.bounds.BoundingSphere;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.tools.helpers.MeshHelper;
	import away3d.tools.utils.Bounds;

	public class AnimatedTimeline
	{
		private var _blocks:Array = []
		private var _arrow:Mesh
		private var _arrowWidth:Number
		private var totalWidth:int = 0
		public static const totalDuration:Number = 1.6
		public static const globalDelay:Number = 1.2
		private var targetXArrow:Number = 0			
		private var startXArrow:Number = 0;
		private var speedXArrow:Number = 0
		
		public function AnimatedTimeline()
		{
			var cubeGroup:ObjectContainer3D = AssetLibrary.getAsset("cubeGroup") as ObjectContainer3D;
			
			for(var i:int = 0; i< cubeGroup.numChildren; i++){
				var c:Mesh = cubeGroup.getChildAt(i) as Mesh
				MeshHelper.recenter(c)
				c.scaleY = 0.01
				if(c.name.search("arrow") > -1){
					_arrow = c
				}else if(c.name.search("cube") > -1){
					var animatedBlock:AnimatedTimelineBlock = new AnimatedTimelineBlock(c)
					_blocks.push(animatedBlock)
				
					totalWidth += animatedBlock.width
				}
			}
			
			_blocks.sortOn("id");
			
			ColorMaterial(_arrow.material).alpha = 0
			Bounds.getObjectContainerBounds(_arrow)
			_arrowWidth = Bounds.width
			targetXArrow = _arrow.x	
			startXArrow = AnimatedTimelineBlock(_blocks[0]).x - (AnimatedTimelineBlock(_blocks[0]).width*0.5)+ _arrowWidth*0.5
			speedXArrow = (targetXArrow-startXArrow)/totalDuration
			var distanceDelay:Number = globalDelay*speedXArrow
			startXArrow -= distanceDelay
				
			var time:Number = 0
			var delay:Number = globalDelay
			for(i = 0; i<_blocks.length ;i++){
				var b:AnimatedTimelineBlock = _blocks[i]
				b.animatedScale = 0
				delay += time
				time = (b.width/totalWidth)*totalDuration
				b.setTimeAndDelay(time, delay)
			}			
		}
		
		public function play():void
		{
			for(var i:int = 0; i<_blocks.length ;i++){
				var b:AnimatedTimelineBlock = _blocks[i]
				b.play()
			}
			ColorMaterial(_arrow.material).alpha = 1
			TweenMax.to(ColorMaterial(_arrow.material),0.3, {alpha:1})	
			_arrow.x = startXArrow
			TweenMax.to(_arrow, totalDuration+globalDelay, {delay:0, x:targetXArrow, ease:Linear.easeNone})
		}
		
		public function hide():void
		{
			for(var i:int = 0; i<_blocks.length ;i++){
				var b:AnimatedTimelineBlock = _blocks[i]
				b.hide(i*0.10)
			}
			TweenMax.to(_arrow.material, 0.5, {alpha:0})
		}
	}
}