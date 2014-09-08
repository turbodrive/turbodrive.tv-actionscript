package tv.turbodrive.away3d.elements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.away3d.elements.meshes.GlowGenGrid;
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.mediator.view.IViewRender3D;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class GridLoadGp3D extends GroupPlane3D
	{
		private var _glowGrid:GlowGenGrid
		private var incScroll:int = 0
			
		public function GridLoadGp3D(mainAtlas:String=null, view:IViewRender3D=null)
		{
			super(null);
			visible = false
		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{	
			var d:Number = timelineDuration-0.25
			if(d < 0) return
			_glowGrid.alpha = 0
			incScroll = 0
			visible = true
			TweenMax.to(_glowGrid, 0.5, {alpha:1, delay:d})
		}
		
		public function hide():void
		{
			TweenMax.to(_glowGrid, 0.5, {alpha:0, onComplete:completeHide})
		}
		
		public function completeHide():void
		{
			visible = false
		}
		
		override protected function onRender(e:Event):void
		{
			if(visible){
				incScroll++
				if(incScroll >= 25){
					_glowGrid.position = new Vector3D();
					_glowGrid.moveForward(100)
					incScroll = 0
				}else{
					_glowGrid.moveBackward(4)
				}
			}
		}
		
		public function init():void
		{
			_glowGrid = new GlowGenGrid(4096, 4096, GlowGenGrid.NORMAL)
			_glowGrid.scale(2);
			_glowGrid.rotationX = -8
			_glowGrid.rotationZ = 15
			_glowGrid.moveForward(100)
			_globalContainer.addChild(_glowGrid)
				
			_viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender)
		}
	}
}