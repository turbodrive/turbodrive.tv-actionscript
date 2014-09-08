package tv.turbodrive.away3d.elements
{
	import com.greensock.easing.Quad;
	
	import flash.geom.Vector3D;
	
	import away3d.core.base.Object3D;
	
	import tv.turbodrive.away3d.elements.entities.AbstractProjectGp3D;
	import tv.turbodrive.away3d.tools.RiggedCameraBehaviour;
	import tv.turbodrive.away3d.transitions.timeline.vo.Gp3DVO;
	import tv.turbodrive.puremvc.mediator.view.Overlay2DView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubTransitionNames;
	import tv.turbodrive.utils.MathUtils;
	
	public class RightContentGp3D extends AbstractProjectGp3D
	{		
		protected var angleSkewContent:Number = 24.5	
		
		public function RightContentGp3D(page:Page)
		{
			MathUtils.ANGLE_SKEW_DEGREES = angleSkewContent
			super(page);	
		}		
				
		override protected function createLocalScene():void
		{
			MathUtils.ANGLE_SKEW_DEGREES = Overlay2DView.ANGLE_RIGHT

			super.createLocalScene()				
		}	
		
		override public function generateSubPagePosition(update:Boolean = false):void
		{	
			if(_internalSubPosGenerated && ! update) return
			
			_videoContainer.position = new Vector3D(-180,-70,-0.001)
			var rotationVideo:Number = 0//-10 // -67.7
			_videoContainer.rotationZ = rotationVideo
			
			var _rgcHelper:RiggedCameraBehaviour = getNeutralRGC();
			//_rgcHelper.rotationZ -= _videoContainer.rotationZ
			var tmp:Object3D = new Object3D();
			tmp.transform = _rgcHelper.globalTransform.clone()
			
			//tmp.moveUp(_videoContainer.y)
			//tmp.moveRight(_videoContainer.x)
			tmp.moveForward(_videoContainer.z);
				
			var positionPlayer:Gp3DVO = new Gp3DVO({position:new Vector3D(tmp.x, tmp.y, tmp.z), rotationX:_rRotation.x, rotationY:_rRotation.y, rotationZ:_rRotation.z+rotationVideo}) 
			positionPlayer.duration = 0.05
			positionPlayer.delay = 0
			positionPlayer.ease = Quad.easeInOut
			_internalSubTransition[SubTransitionNames.VIDEOPLAYER] = positionPlayer
			
			/*** EXTRA ***/
				
			_rgcHelper = getNeutralRGC();	
			tmp.transform = _rgcHelper.globalTransform.clone()
			tmp.moveRight(_extraContentX)
			tmp.moveUp(_extraContentY)
			
			var positionExtra:Gp3DVO = new Gp3DVO({position:new Vector3D(tmp.x, tmp.y, tmp.z), rotationX:_rRotation.x, rotationY:_rRotation.y, rotationZ:_rRotation.z})
			positionExtra.duration = 1
			positionExtra.delay = 0
			positionExtra.ease = Quad.easeInOut		
			_internalSubTransition[SubTransitionNames.EXTRACONTENT] = positionExtra			
				
			/*******/
			
			var backFromExtra:Gp3DVO = worldTargetCamCoordinates.clone()
			backFromExtra.duration = 1
			backFromExtra.delay = 0
			backFromExtra.ease = Quad.easeInOut				
			_internalSubTransition[SubTransitionNames.HOMEFROMEXTRA] = backFromExtra
				
			var backFromVideo:Gp3DVO = worldTargetCamCoordinates.clone()
			backFromVideo.rotationZ = _rRotation.z
			backFromVideo.duration = 0.01
			backFromVideo.delay = 0
			backFromVideo.ease = Quad.easeInOut
			_internalSubTransition[SubTransitionNames.HOMEFROMVIDEO] = backFromVideo
				
			super.generateSubPagePosition();
		}
		
		override protected function replaceContent():void
		{
			playVideoPicto.x = shadePlay.x = -_sW/3
			playVideoPicto.y = shadePlay.y = -_sH/3
				
			if(_ratioPan){
				_videoContainer.scaleX = _videoContainer.scaleY = _scaleVisuel*0.92
				_videoContainer.x = -_sW*0.15
			}else{
				_videoContainer.scaleX = _videoContainer.scaleY = _rX
				_videoContainer.x = -_sW*0.18
			}
			
			_videoContainer.y = -65
			
			super.replaceContent();
		}	
	}
}