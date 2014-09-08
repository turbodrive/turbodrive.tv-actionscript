package tv.turbodrive.away3d.elements
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.away3d.elements.subElements.FromReelTitle;
	import tv.turbodrive.away3d.textures.VideoStreamTexture;
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.loader.ReelVideoPlayer;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	import tv.turbodrive.puremvc.mediator.view.awayComponents.TextureBufferBridge;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class FromReelGp3D extends GroupPlane3D
	{
		protected var _videoTexture:VideoStreamTexture;
		protected var _videoMat:TextureMaterial;
		protected var _videoPlane:Mesh;
		private var _titleAnimation:FromReelTitle;		
		private var _page:Page;
		protected var _preInitialized:Boolean = false;
		 
		public function FromReelGp3D(page:Page = null)
		{
			if(page) setPage(page)
			super(null, null);
		}
		
		public function setPage(newPage:Page):void
		{
			if((_page && _page.id != newPage.id) || !_page){
				_builtContent = false
				_page = newPage
			}
		}
		
		public function preInit():void
		{			
			_videoTexture = new VideoStreamTexture();
			_videoMat = new TextureMaterial(_videoTexture,false,false,false);
			_videoMat.smooth = true
			_videoMat.mipmap = false
			_videoPlane = new Mesh(new PlaneGeometry(_sW, _sH,1,1,false),_videoMat);
		
			addChild(_videoPlane);
			if(_titleAnimation && contains(_titleAnimation)){
				_titleAnimation.destroy()
				removeChild(_titleAnimation)
			}
			_titleAnimation = new FromReelTitle()
			addChild(_titleAnimation);
			
		 	_preInitialized = true
		}
		
		override public function build():void
		{
			if(!_preInitialized){
				preInit()
			}
			
			if(!_page){
				throw new Error("No Page")
			}
			
			// update size
			PlaneGeometry(_videoPlane.geometry).width = _sW
			PlaneGeometry(_videoPlane.geometry).height = _sH
			_videoPlane.geometry.scaleUV( _sW/2048, _sH/1024);			

			_titleAnimation.setPage(_page)	
			
			viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender)				
			_builtContent = true
		}
		
		override public function resetPosition():void
		{
			this.transform = new Matrix3D();
		}
		
		override protected function createLocalScene():void {
			
		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
			// Empty - no startTransition Here			
		}
		
		override public function hideTransition(subPageName:String = null):void
		{				
			TextureBufferBridge.instance.dispatchHidePlayer2D();
			_titleAnimation.autoPosition();
			_titleAnimation.play(2.2-1.4)
		}
		
		private function removeFromScene():void
		{
			parent.removeChild(this)
			dispatchEvent(new Event(Stage3DView.VIDEO_PLANE_HIDDEN,true))
			dispose();
		}
		
		override protected function onRender(e:Event):void
		{			
			if(_videoMat && _videoMat.alpha > 0 && visible) {
				_videoTexture.update()
			}
		}
		
		override public function dispose():void			
		{	
			/*if(parent) parent.removeChild(this)
			return*/
			//_preInitialized = false
			super.dispose();
			
			if(_videoPlane){
				_videoPlane.dispose()
				_videoPlane = null	
			}
			if(_videoMat){		
				_videoMat.dispose();
				_videoMat = null
			}
			if(_videoTexture){	
				_videoTexture.dispose()
				_videoTexture = null
			}			
			if(_titleAnimation){	
				_titleAnimation.destroy()
				_videoTexture = null
			}			
		}	
		
		
	}
}