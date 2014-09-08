package tv.turbodrive.puremvc.mediator.view.component.overlay2d
{

	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.utils.geom.RectangleRotation;
	
	public class OverlayGridView extends SpriteDrivenBy3D
	{

		private var _grid:gridBR;
		public function OverlayGridView(overlay:Overlay2DView)
		{
			super(overlay);
			this.mouseChildren = this.mouseEnabled = false
		}
		
		override public function buildContent(page:Page):void
		{	
			_grid = new gridBR();
			_grid.grid_mc.light_mc.mask = _grid.grid_mc.mask_mc
			//_grid.grid_mc.light_mc.cacheAsBitmap = _grid.grid_mc.mask_mc.cacheAsBitmap = true
			//var gridMask:Bitmap = new Bitmap(new MaskGridOverlay());
			//_grid.grid_mc.addChild(gridMask);
			//_grid.grid_mc.light_mc.mask = gridMask
			_grid.grid_mc.light_mc.x = 0
			//_grid.grid_mc.removeChild(_grid.grid_mc.mask_mc)
			_grid.grid_mc.light_mc.y = 0
			_grid.grid_mc.light_mc.alpha = 0.6
			_grid.darkness_mc.x = 0
			_grid.darkness_mc.y = 0
			//_grid.removeChild(_grid.darkness_mc)
			this.addChild(_grid);
			/*graphics.beginFill(0xFF0000);
			graphics.drawRect(0,0,100,100);
			graphics.endFill();*/
			
			//randMov()
			
			_grid.darkness_mc.alpha = 0
			TweenMax.to(_grid.darkness_mc, 2, {alpha:1})
		}
		
		private function randMov():void
		{
			TweenMax.to(_grid.grid_mc.light_mc, 2, {x:-300+Math.random()*600, y:-300+Math.random()*600, onComplete:randMov})
		}
		
		override public function updatePosition(rect:RectangleRotation, gps3d:Vector.<TriPosSprite3D> = null, extraRotation:Number = 0):void
		{	
			if(_destroyed) return
			this.x = rect.x //+ 50
			this.y = rect.y //+ 100
			this.rotation = -3//extraRotation
			
			if(parent && _grid){
				_grid.grid_mc.light_mc.x = /*- (stage.stageWidth >> 1) +*/ stage.mouseX - rect.x
				_grid.grid_mc.light_mc.y = /*- (stage.stageHeight >> 1) +*/ stage.mouseY - rect.y
			}
		}
		
		override public function destroy():void
		{
			_destroyed = true
			super.destroy()
			_grid = null
		}
	}
}