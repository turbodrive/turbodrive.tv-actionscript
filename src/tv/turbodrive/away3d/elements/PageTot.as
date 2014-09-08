package tv.turbodrive.away3d.elements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import away3d.core.base.Object3D;
	import away3d.core.base.SubMesh;
	import away3d.core.math.MathConsts;
	
	import tv.turbodrive.away3d.elements.subElements.FromReelTitle;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.tools.RiggedCameraBehaviour;
	import tv.turbodrive.away3d.transitions.timeline.vo.Gp3DVO;
	import tv.turbodrive.puremvc.proxy.StructureProxy;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubTransitionNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	import tv.turbodrive.utils.MathUtils;

	public class PageTot extends RightContentGp3D
	{	
		private static var _firstLaunch:Boolean = true
		private var titleFromReel:FromReelTitle;
		
		public function PageTot(page:Page)
		{
			super(page);
		}			
		
		/*override protected function onRender(e:Event):void
		{
			//titleFromReel.rotationY += 2
			super.onRender(e)
		}
		
		/*override protected function createLocalScene():void
		{	
			titleFromReel = new FromReelTitle()
			titleFromReel.setPage(StructureProxy.getPage("tl"))
			addChild(titleFromReel)
			
			titleFromReel.rotationY = 45//60
			//titleFromReel.rotationZ = 60
			//titleFromReel.rotationX = 75
			titleFromReel.z = 16000
			titleFromReel.x = -360
			//TweenMax.to(titleFromReel, 2, {delay:1.5, rotationY:130})
			titleFromReel.play(0.5);
		}*/
		
		override public function generateSubPagePosition(update:Boolean = false):void
		{	
			return
		}
		
		override protected function initMaterial():void
		{	
			if(_materialInitialized) return
			_normalMainMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TOT_ALPHA_TEXTURE_ALPHA) as ATMaterial)		
			_addMainMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TOTGSTLBORGIA_ADD_TEXTURE) as ATMaterial)		
			super.initMaterial();		
		}
		
		override protected function createLocalScene():void
		{	
			super.createLocalScene();
			
			_extraContainer.x = _extraContentX+1000
			_extraContainer.y = _extraContentY
				
			_awardsBlock.extraScale = 1.2
			_workBlock.extraScale = 1.03				
			_gs3dWork.setSource(_workBlock,600,720);
			_gs3dAwards.setSource(_awardsBlock,530,375);			
			_gs3dExtra.setSource(_extraBlock,1000,500);	
			_extraContainer.addChild(_gs3dAwards);
			_extraContainer.addChild(_gs3dWork);
			_extraContainer.addChild(_gs3dExtra);		

			//var offsetTitleExtra:Point = new Point(1300,105);
			var offsetTitleExtra:Point = new Point(632,85);
			titleName2.position = redLine.position.clone();
			titleName2.x += offsetTitleExtra.x
			titleName2.y += offsetTitleExtra.y
			clientName2.position = titleName2.position.clone();
			clientName2.y = titleName2.y + ((clientName2.height + titleName2.height) / 2) - 10
			clientName2.x = titleName2.x - (titleName2.width /2) + (clientName2.width/2)

		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
			if(titleFromReel) return
			
			super.startTransition(timelineDuration, transitionInfo);
			if(_firstLaunch){
				_firstLaunch = false
				_autoPlayTimer = new Timer(TIME_AUTOPLAY_VIDEO,1);
				_autoPlayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoPlayVideo);
				_autoPlayTimer.start();
			}
		}
		
		override public function hideTransition(subTransitionName:String = null):void
		{
			if(_autoPlayTimer) _autoPlayTimer.stop()
			super.hideTransition(subTransitionName);
		}
		
		private function autoPlayVideo(e:TimerEvent):void
		{
			_autoPlayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, autoPlayVideo);
			_autoPlayTimer.stop()
			_autoPlayTimer = null
			playVideoClickHandler();
		}
		
		override public function dispose():void{
			if(_autoPlayTimer){
				_autoPlayTimer.stop()
				_autoPlayTimer = null
			}
			super.dispose();
		}
		override public function resume():void{
			if(_autoPlayTimer) _autoPlayTimer.start()
			super.pause();
		}
		
		override public function pause():void{
			if(_autoPlayTimer) _autoPlayTimer.stop()
			super.pause();
		}
		
		/** LAYOUT X/Y **/		
		
		override protected function replaceContent():void
		{	

			if(titleFromReel) return
			
			if(_ratioPan){
				_visuelContainer.scaleX = _visuelContainer.scaleY = _scaleVisuel 
				_visuelContainer.x = (_layoutRatioX*100)
				planText.z = 100
				clientName.z = -125
			}else{
				_visuelContainer.scaleX = _visuelContainer.scaleY = _rX*1.3
				_visuelContainer.x = (_layoutRatioY*150)
				_visuelContainer.y = -(_layoutRatioY*60)
				planText.z = -150
				clientName.z = -200
			}
			
			
			redLine.z = 40
			redLine.y = 130
			
			_workBlock.x = _rX*120
			_workBlock.y = 180+(_sH/4)
			_gs3dWork.update()
			
			_extraBlock.x = _rX*-100
			_extraBlock.y = 0
			_gs3dExtra.update()
			
			_awardsBlock.x = _rX*-360
			_awardsBlock.y = -(_sH/4)-190
			_gs3dAwards.update()
			
			planPlayer.x =  (_rX * -640) - 220 + (_layoutRatioX*120)
			planText.x = _rX * 380 + (_layoutRatioX*20)
			
			var oX:Number = (380*_rX) + (_layoutRatioX*20) - 60
			var oY:Number = 40 +( Math.sin(3*MathConsts.DEGREES_TO_RADIANS)*oX) ;
			var titlePosition:Vector3D = new Vector3D(redLine.x+oX,redLine.y+oY,-250);				
			
			titleName.position = titlePosition
			clientName.y = titlePosition .y + ((clientName.height + titleName.height) / 2) - 10
			var df:Number = titlePosition .y - clientName.y
			var xdecal:Number = MathUtils.getSkewXPos(df)
			clientName.x = titlePosition .x - (titleName.width /2) + (clientName.width/2) + xdecal
			
			super.replaceContent();
		}	
		
	}
}