package tv.turbodrive.away3d.elements
{
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	
	import tv.turbodrive.away3d.textures.VideoStreamTexture;
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.loader.ReelVideoPlayer;
	import tv.turbodrive.puremvc.mediator.view.awayComponents.TextureBufferBridge;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;

	public class ToReelGp3D extends FromReelGp3D
	{
		
		private var _numScreen:int = 6
		
		public function ToReelGp3D(page:Page)
		{
			trace("TO REEEL - ToReelGp3D")
			super(page)
		}
		
		override public function build():void
		{
			trace("build - ToReelGp3D")
			_videoTexture = new VideoStreamTexture();
			_videoMat = new TextureMaterial(_videoTexture,false,false,false);	
			_videoMat.smooth = true
			_videoMat.mipmap = false
			_videoPlane = new Mesh(new PlaneGeometry(_sW, _sH,1,1,false),_videoMat);
			_videoPlane.geometry.scaleUV( _sW/2048, _sH/1024);
			addChild(_videoPlane);
			
			var screenMat:TextureMaterial = AssetLibrary.getAsset("ScreenShapeMaterial") as TextureMaterial
			
			for(var i:int = 0; i<_numScreen; i++){
				var mesh:Mesh = new Mesh(new PlaneGeometry(1280,1280,1,1,false), screenMat);
				mesh.z = i*-4000
				addChild(mesh);
			}
			
			
			_builtContent = true
			//trace("build content but wait to start...")
		}
		
		override public function resetPosition():void
		{
			this.transform = new Matrix3D();
			z = 30000
		}
		
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
			
			ReelVideoPlayer.instance.resume(true)			
			TextureBufferBridge.instance.dispatchShowPlayer2D(timelineDuration)	
			_viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender)
		}
		
		override public function hideTransition(subPageName:String = null):void
		{				
			//TextureBufferBridge.instance.dispatchHidePlayer2D();
		}
	}
}