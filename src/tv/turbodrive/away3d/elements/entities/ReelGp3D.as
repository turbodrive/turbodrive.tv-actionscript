package tv.turbodrive.away3d.elements.entities
{
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.MeshHelper;
	
	import flash.events.Event;
	
	import tv.turbodrive.away3d.textures.VideoStreamTexture;
	import tv.turbodrive.loader.ReelVideoPlayer;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	import tv.turbodrive.puremvc.mediator.view.awayComponents.TextureBufferBridge;
	import tv.turbodrive.puremvc.proxy.data.PagesName;

	public class ReelGp3D extends GroupPlane3D
	{
		private var _videoTexture:VideoStreamTexture;
		private var _videoMat:TextureMaterial;
		private var _videoPlane:Mesh;
		
		public function ReelGp3D()
		{
			super(PagesName.REEL);			
		}
		
		override public function build():void
		{
			if(_builtContent) return
			
			_videoTexture = new VideoStreamTexture();
			_videoMat = new TextureMaterial(_videoTexture,false,false,false);
			_videoMat.smooth = true
			_videoMat.mipmap = false
			_videoPlane = new Mesh(new PlaneGeometry(_sW, _sH,1,1,false),_videoMat);
			_videoPlane.geometry.scaleUV( _sW/2048, _sH/1024);
			//_videoPlane.rotationX = -90
			addChild(_videoPlane);
			
			var copy1:Mesh = MeshHelper.clone(_videoPlane)
			copy1.x = - (_sW) -20
			var copy2:Mesh = MeshHelper.clone(_videoPlane)
			copy2.x = (_sW )+ 20
			var copy3:Mesh = MeshHelper.clone(_videoPlane)
			copy3.x = - (_sW *2) - 40
			var copy4:Mesh = MeshHelper.clone(_videoPlane)
			copy4.x = - copy3.x
			addChild(copy1);
			addChild(copy2);
			addChild(copy3);
			addChild(copy4);
			
			var copy0:Mesh = MeshHelper.clone(_videoPlane)
			copy0.y = _sH +20
			var copy10:Mesh = MeshHelper.clone(_videoPlane)
			copy10.x = copy1.x
			var copy20:Mesh = MeshHelper.clone(_videoPlane)
			copy20.x = copy2.x
			var copy30:Mesh = MeshHelper.clone(_videoPlane)
			copy30.x = copy3.x
			var copy40:Mesh = MeshHelper.clone(_videoPlane)
			copy40.x = copy4.x
			copy10.y = copy20.y = copy30.y = copy40.y = copy0.y
			addChild(copy0);
			addChild(copy10);
			addChild(copy20);
			addChild(copy30);
			addChild(copy40);
			
			var copy100:Mesh = MeshHelper.clone(_videoPlane)
			copy100.y = - _sH -20
			var copy110:Mesh = MeshHelper.clone(_videoPlane)
			copy110.x = copy1.x
			var copy120:Mesh = MeshHelper.clone(_videoPlane)
			copy120.x = copy2.x
			var copy130:Mesh = MeshHelper.clone(_videoPlane)
			copy130.x = copy3.x
			var copy140:Mesh = MeshHelper.clone(_videoPlane)
			copy140.x = copy4.x
			copy110.y = copy120.y = copy130.y = copy140.y = copy100.y
			addChild(copy100);
			addChild(copy110);
			addChild(copy120);
			addChild(copy130);
			addChild(copy140);
			
			
			_builtContent = true		
		}	
		
		override protected function createLocalScene():void	{}
		
		override public function startTransition(timelineDuration:Number = 0):void
		{				
			ReelVideoPlayer.instance.resume(true)			
			TextureBufferBridge.instance.dispatchShowPlayer2D(timelineDuration)
		}
		
		override public function hideTransition():void
		{				
			TextureBufferBridge.instance.dispatchHidePlayer2D();
		}
		
		private function removeFromScene():void
		{
			parent.removeChild(this)
			dispatchEvent(new Event(Stage3DView.VIDEO_PLANE_HIDDEN,true))
			dispose();
		}
		
		override protected function onRender(e:Event):void
		{	
			if(_videoTexture && _videoMat && _videoMat.alpha > 0 && visible) {
				_videoTexture.update()
			}
		}
		
		override public function dispose():void			
		{			
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
		}		
	}
}