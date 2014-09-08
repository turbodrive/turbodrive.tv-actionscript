package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.MathUtils;
	import tv.turbodrive.utils.geom.RectangleRotation;
	
	public class SpriteDrivenBy3D extends Sprite
	{
		protected var _xOffset:Number = 0;
		protected var _overlay:Overlay2DView
		protected var _destroyed:Boolean = false		
		private var _tmpDestroy:Boolean = false;
		
		public function SpriteDrivenBy3D(overlay:Overlay2DView)
		{			
			_overlay = overlay
			super();
		}
		
		public function getSkewShape(h:Number, yStart:Number):Sprite
		{
			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(0xFF0000,0);
			var xStart:int = MathUtils.getSkewXPos(yStart)-30
			var yEnd:int = h-yStart
			var xEnd:int = MathUtils.getSkewXPos(yEnd)-30
			shape.graphics.moveTo(xStart,yStart);
			shape.graphics.lineTo(xStart+450, yStart);
			shape.graphics.lineTo(xEnd+450, yEnd);
			shape.graphics.lineTo(xEnd, yEnd);
			shape.graphics.endFill();
			
			return shape
		}
		
		public function buildContent(page:Page):void {
			
		}
		
		protected function placeElement(displayObject:DisplayObject, y:Number, internalElement:Boolean = false):void
		{
			if(MathUtils.ANGLE_SKEW_DEGREES == 0){
				displayObject.x = 0				
			}else{
				displayObject.x = MathUtils.getSkewXPos(y)
			}
			if(!internalElement) displayObject.x += _xOffset
			displayObject.y = y
		}
		
		public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number = 0):void
		{			
			if(_destroyed) return
			/*if(gtps3d.subPageName == SubPageNames.MAIN){
				var rect:RectangleRotation = gtps3d.rectangles[0]
				//_yOffset =  10 + rect.height
				*/
				this.x = rect.x-25
				this.y = rect.y /*+ 10 + rect.height*/
				this.rotation = rect.rotation // -3
			//}
		}
		
		public function destroy():void
		{
			_destroyed = true
			while(numChildren > 0) removeChildAt(0);
			if(parent) parent.removeChild(this)
		}
		
		public function hideAndRemove():Boolean
		{
			TweenMax.to(this, 0.25, {alpha:0, onComplete:destroy})
			return true
		}
		
		public function haveToDestroy():Boolean
		{
			return _tmpDestroy
		}
		
		public function toTmpDestroy():void
		{
			_tmpDestroy = true
		}
		
		public function rehab():void
		{
			_tmpDestroy = false
		}
		
		public function resume():void
		{
		}
		
		public function pause():void
		{
		}
	}
}