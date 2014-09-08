package tv.turbodrive.away3d.elements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import away3d.core.base.SubMesh;
	
	import tv.turbodrive.away3d.elements.entities.TriPosSprite3D;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	import tv.turbodrive.utils.MathUtils;
	
	public class PageGreetings extends RightContentGp3D
	{
		
		private static var _firstLaunch:Boolean = true
		private static var _offsetApplied:Boolean = false
			
		public function PageGreetings(page:Page)
		{
			super(page);
			_hasAwardBlock = false
		}		
		
		override protected function initMaterial():void
		{	
			if(_materialInitialized) return
			_addMainMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.GREETINGSIKAF2_ADD_TEXTURE) as ATMaterial)		
			super.initMaterial();		
		}
		
		override protected function createLocalScene():void
		{			
			super.createLocalScene();
			
			_extraContentY = 80
			//_extraContentX = 1550
			
			_extraContainer.x = _extraContentX+1000
			_extraContainer.y = _extraContentY

			_workBlock.extraScale = 1.03
			_extraBlock.extraScale = 0.75
			_gs3dWork.setSource(_workBlock,600,720);				
			_gs3dExtra.setSource(_extraBlock,1000,10);		
			_extraContainer.addChild(_gs3dWork);
			_extraContainer.addChild(_gs3dExtra);					

		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
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
		
		override protected function getTriPosSprite3DList(subPageName:String):Vector.<TriPosSprite3D>
		{
			var tpss3d:Vector.<TriPosSprite3D>
			if(subPageName == SubPageNames.MAIN){
				tpss3d  = new <TriPosSprite3D>[_gs3dMain];					
			}else if(subPageName == SubPageNames.EXTRACONTENT){
				tpss3d= new <TriPosSprite3D>[_gs3dTitleExtra, _gs3dWork, _gs3dExtra];
			}else if(subPageName == SubPageNames.VIDEOPLAYER){
				tpss3d = new <TriPosSprite3D>[_gs3dMain, _gs3dPlayer];
			}
			
			if(!tpss3d) return null
			return tpss3d
		}
		
		
		/** LAYOUT X/Y **/		
		override protected function replaceContent():void
		{
			
			if(_ratioPan){
				_visuelContainer.scaleX = _visuelContainer.scaleY = _scaleVisuel 
				_visuelContainer.x = (_layoutRatioX*150)
			}else{
				_visuelContainer.scaleX = _visuelContainer.scaleY = _rX*1.1
				_visuelContainer.x = 0
				_visuelContainer.y = -(_layoutRatioY*80)
				clientName.z = -250
			}
			

			_workBlock.x = _rX*120
			_workBlock.y = 80+(_sH/4)
			_gs3dWork.update()
			
			_extraBlock.x = _rX*-100 -40
			_extraBlock.y = 0
			_gs3dMain.update()			
				
			planPlayer.x =  (_rX * -640) - 220 + (_layoutRatioX*120)
			planText.x = _rX * 300 + (_layoutRatioX*60)
			planText.y = _rY*180
			redLine.x = planText.x
			redLine.y = planText.y-10
				
			//var offsetTitleExtra:Point = new Point(1000,95);
			var offsetTitleExtra:Point = new Point(632,85);
			titleName2.position = redLine.position.clone();
			titleName2.x += offsetTitleExtra.x
			titleName2.y += offsetTitleExtra.y
			clientName2.position = titleName2.position.clone();
			clientName2.y = titleName2.y + ((clientName2.height + titleName2.height) / 2)-10
			clientName2.x = titleName2.x - (titleName2.width /2) + (clientName2.width/2);
			
			var titlePosition:Vector3D = new Vector3D(planText.x-20,planText.y+30,-250);	
			titleName.position = titlePosition
			clientName.y = titlePosition .y + ((clientName.height + titleName.height) / 2) - 10
			var df:Number = titlePosition .y - clientName.y
			var xdecal:Number = MathUtils.getSkewXPos(df)
			clientName.x = titlePosition .x - (titleName.width /2) + (clientName.width/2) + xdecal
			clientName.z = -125
			
			super.replaceContent();
		}
	}
}