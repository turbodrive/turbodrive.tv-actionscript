package tv.turbodrive.away3d.elements.entities
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.tools.RiggedCameraBehaviour;
	import tv.turbodrive.away3d.transitions.timeline.vo.Gp3DVO;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.events.GroupSprite3DEvent;
	import tv.turbodrive.events.TransitionEvent;
	import tv.turbodrive.loader.AssetsManager;
	import tv.turbodrive.puremvc.proxy.data.Asset;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.puremvc.proxy.data.SubTransitionNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;

	public class AbstractProjectGp3D extends GroupPlane3D
	{	
		protected var _rPosition:Vector3D
		protected var _rRotation:Vector3D
		
		public static const UPDATE_3DPOSITION:String = "updateTitlePosition"
		public static const CLOSE_SUBPAGE:String = "closeProject";
		public static const OPEN_SUBPAGE:String = "openProject";		
		
		protected var _normalMainMaterial:TextureMaterial;
		protected var _addMainMaterial:TextureMaterial;
		protected var _guiMaterial:ATMaterial;
		protected var _buttonPlayMaterial:ATMaterial
		protected var _contentMaterial:ATMaterial;
		protected var alphaGuiMat:TextureMaterial;
		protected var alphaContentMat1:ATMaterial;
		protected var _matRedLine:ColorMaterial;
		protected var _matPurpleAlpha:ColorMaterial;
		protected var _videoScreenMaterial:ColorMaterial;
		
		protected var titleName:PlaneMesh;
		protected var clientName:PlaneMesh;
		protected var clientName2:PlaneMesh;
		protected var titleName2:PlaneMesh;
		protected var _videoScreen:Mesh;
		protected var redLine:PerspScaleMesh;
		protected var _extraContentX:Number = 1600;		
		protected var _extraContentY:Number = 20;		
		public static const TIME_AUTOPLAY_VIDEO:int = 15000;		
		
		protected var _extraContainer:PerspScaleContainer;
		protected var _extraPointlight:PointLight;
		protected var _extraBlock:PerspScaleMesh;
		protected var _awardsBlock:PerspScaleMesh;
		protected var _workBlock:PerspScaleMesh;
	//protected var _grid:GlowSquareGrid
		protected var playVideoPicto:PlaneMesh;
		protected var shadePlay:PlaneMesh;
		protected var planText:PerspScaleMesh;
		protected var planPlayer:PerspScaleMesh;
		
		protected var _page:Page
		protected var _idAsset:String;
		private var _transitionComplete:Boolean = false;
		protected var _waitBuilding:Boolean = true
		
		protected var _gs3dMain:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.MAIN);
		protected var _gs3dWork:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.WORK);
		protected var _gs3dAwards:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.AWARDS);
		protected var _gs3dExtra:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.EXTRA);
		protected var _gs3dPlayer:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.PLAYER);
		protected var _gs3dTitleExtra:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.TITLE_EXTRA);
		protected var _gs3dOverlayGrid:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.OVERLAY_GRID);
		
		private var _currentTps3D:GroupTps3D;		
		protected var _videoContainer:ObjectContainer3D;		
		
		private var increment:int;
		private var loopBuilderInterval:int;
		
		protected static var _planTextX:Dictionary = new Dictionary()
		protected static var _redlinePositionZ:Dictionary = new Dictionary()

		protected var _visuelContainer:ObjectContainer3D;
		protected var _autoPlayTimer:Timer;

		protected var startAlphaZero:Boolean;
		protected var _hasAwardBlock:Boolean = true
		
		public function AbstractProjectGp3D(page:Page)
		{
			super(null);
			_page = page;
			_idAsset = _page.id;
			_listElementsToAdd = [];
			_portalOut = new Gp3DVO({x:-500,y:-7000,z:-6500, rotationX:90, rotationY:90, rotationZ:30, rigDistance:Tools3d.DISTANCE_Z_1280});
			_portalIn = new Gp3DVO({x:0,y:0,z:-30000, rotationX:0, rotationY:0, rotationZ:0, rigDistance:Tools3d.DISTANCE_Z_1280});
				
			if(_page.project && _page.project.transformClone){
				var model:Object3D = _page.project.transformClone
				_rPosition = new Vector3D(model.x, model.y, model.z);
				_rRotation = new Vector3D(model.rotationX,model.rotationY,model.rotationZ);
				_worldCoordinates = new Gp3DVO({x:_rPosition.x,y:_rPosition.y,z:_rPosition.z, rotationX:_rRotation.x, rotationY:_rRotation.y, rotationZ:_rRotation.z, rigDistance:Tools3d.DISTANCE_Z_1280})
				
				var _rgcHelper:RiggedCameraBehaviour = getNeutralRGC();
				//_rgcHelper.rotationZ += 10
				var tmp:Object3D = new Object3D();
				tmp.transform = _rgcHelper.globalTransform.clone()
			
					
				tmp.moveDown(3000*randUnit)
				tmp.moveBackward(1250);
				tmp.moveRight(650*randUnit);
				//tmp.pitch(25);
				
				_internalLoader = new Gp3DVO({position:new Vector3D(tmp.x, tmp.y, tmp.z), rotationX:tmp.rotationX, rotationY:tmp.rotationY, rotationZ:_rRotation.z-(80*randUnit)})
				_internalLoader.duration = 1
				_internalLoader.delay = 0
				_internalLoader.ease = Quad.easeInOut
			}
		}
		
		public function get randUnit():Number
		{
			return Math.random() < 0.5 ? -1 : 1
		}
		
		public static function getMatrixFromCam(positionCamera:Vector3D, rotationCamera:Vector3D = null):Matrix3D
		{
			var _rgcHelper:RiggedCameraBehaviour = new RiggedCameraBehaviour();
			_rgcHelper.position = positionCamera
			_rgcHelper.rotationX = rotationCamera.x
			_rgcHelper.rotationY = rotationCamera.y
			_rgcHelper.rotationZ = rotationCamera.z
			return _rgcHelper.globalTransform
		}
		
		protected function getNeutralRGC():RiggedCameraBehaviour
		{
			var _rgcHelper:RiggedCameraBehaviour = new RiggedCameraBehaviour();
			_rgcHelper.position = _rPosition
			_rgcHelper.rotationX = _rRotation.x
			_rgcHelper.rotationY = _rRotation.y
			_rgcHelper.rotationZ = _rRotation.z
			return _rgcHelper
		}
		
		override public function getSubTransition(subPageName:String):String
		{
			_targetSubPage = subPageName				
			if(_currentSubPage == SubPageNames.MAIN && subPageName == SubPageNames.EXTRACONTENT){
				return SubTransitionNames.EXTRACONTENT
			}else if(_currentSubPage == SubPageNames.MAIN && subPageName == SubPageNames.VIDEOPLAYER){
				return SubTransitionNames.VIDEOPLAYER
			}else if(_currentSubPage == SubPageNames.VIDEOPLAYER && subPageName == SubPageNames.MAIN){
				return SubTransitionNames.HOMEFROMVIDEO
			}else if(_currentSubPage == SubPageNames.EXTRACONTENT && subPageName == SubPageNames.MAIN){
				return SubTransitionNames.HOMEFROMEXTRA	
			}else if(_currentSubPage == SubPageNames.VIDEOPLAYER && subPageName == SubPageNames.EXTRACONTENT){
				return SubTransitionNames.EXTRACONTENT	
			}			
			return null
		}
		
		override public function resetPosition():void
		{				
			this.transform = getMatrixFromCam(_rPosition, _rRotation)
		}
		
		override public function needToWaitWhenBuilt():Boolean
		{
			return _waitBuilding
		}
		
		override protected function initMaterial():void
		{	
			if(_materialInitialized) return			
			_materialInitialized = true
			super.initMaterial();
				
			var awdAsset:Asset = AssetsManager.instance.getAssets(_idAsset+"Awd")
			//_normalMainMaterial = MaterialLibrary.getMaterial(_idAsset)
			//_addMainMaterial = MaterialHelper.cloneTextureMaterial(_normalMainMaterial)			
			_matRedLine = MaterialHelper.cloneColorMaterial(MaterialLibrary.GLOBAL_RED);
			_matPurpleAlpha = MaterialHelper.cloneColorMaterial(MaterialLibrary.GLOBAL_TRANSPARENT_PURPLE);			
			_guiMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI) as ATMaterial);
			_guiMaterial.blendMode = BlendMode.NORMAL
			_buttonPlayMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI) as ATMaterial);
			_buttonPlayMaterial.colorTransform = new ColorTransform();
			_buttonPlayMaterial.blendMode = BlendMode.NORMAL
			_contentMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI) as ATMaterial);
			_contentMaterial.blendMode = BlendMode.NORMAL
			alphaContentMat1 = MaterialHelper.cloneATMaterial(_contentMaterial);
			alphaContentMat1.repeat = false
			alphaGuiMat = MaterialHelper.cloneATMaterial(_guiMaterial);
			
			//_videoScreenMaterial = new ColorMaterial(0x000000);
			
			_fadeAlphaElements.push(_buttonPlayMaterial, _matRedLine, _matPurpleAlpha, _guiMaterial, _contentMaterial, alphaContentMat1, alphaGuiMat);
			
			if(_normalMainMaterial){
				_normalMainMaterial.smooth = true
				_normalMainMaterial.alpha = 0
				_normalMainMaterial.alphaBlending = true
				_normalMainMaterial.alphaPremultiplied = true				
				_fadeAlphaElements.push(_normalMainMaterial)
			}
			
			if(_addMainMaterial){
				_addMainMaterial.blendMode = BlendMode.ADD
				_addMainMaterial.smooth = true
				_addMainMaterial.alpha = 0
				_addMainMaterial.alphaBlending = true
				_addMainMaterial.alphaPremultiplied = true						
				_fadeAlphaElements.push(_addMainMaterial)
			}
		}
		
		override protected function createLocalScene():void
		{	
			super.createLocalScene()
			
			_matRedLine.alpha = 0
			_matPurpleAlpha.alpha = 0 
				
				redLine = PerspScaleMesh.createFromMesh(AssetLibrary.getAsset(_idAsset+"Redline") as Mesh)
				redLine.material = _matRedLine
				MeshHelper.recenter(redLine)
				if(isNaN(_redlinePositionZ[_idAsset])) _redlinePositionZ[_idAsset] = redLine.z -20
				redLine.z = _redlinePositionZ[_idAsset]
				redLine.material = alphaContentMat1
				_listElementsToAdd.push(redLine)
				
			// visuelNormal
			var i:int = 1
			var visuelPart:Mesh
			_visuelContainer = new ObjectContainer3D();
			while(AssetLibrary.getAsset(_idAsset+"VNormal_"+i)){
				visuelPart = AssetLibrary.getAsset(_idAsset+"VNormal_"+i) as Mesh
				visuelPart.material = _normalMainMaterial
				_visuelContainer.addChild(Mesh(AssetLibrary.getAsset(_idAsset+"VNormal_"+i)))	
				i ++
			}
			
			// visuelAdd
			i = 1
			while(AssetLibrary.getAsset(_idAsset+"VAdd_"+i)){
				visuelPart = AssetLibrary.getAsset(_idAsset+"VAdd_"+i) as Mesh
				visuelPart.material = _addMainMaterial
				_visuelContainer.addChild(visuelPart)
				i ++
			}
			
			_listElementsToAdd.push(_visuelContainer)		
			
				
			planPlayer = PerspScaleMesh.createFromMesh(AssetLibrary.getAsset(_idAsset+"PlanPlayer") as Mesh);
			if(planPlayer){
				planPlayer.material = _matPurpleAlpha			
				planPlayer.z = -450
				_listElementsToAdd.push(planPlayer)
			}
			
			//// MAIN			
			clientName = new PlaneMesh(_guiMaterial,_idAsset+"Client")
			titleName = new PlaneMesh(_guiMaterial,_idAsset+"Title")
			_gs3dMain.setSource(titleName)
			_gs3dMain.visible = false
			_listElementsToAdd.push(clientName, titleName, _gs3dMain)
				
			planText = PerspScaleMesh.createFromMesh((AssetLibrary.getAsset(_idAsset+"PlanText") as Mesh))
			planText.material = _matPurpleAlpha
			_listElementsToAdd.push(planText)
			
			// videoPicto
			playVideoPicto = new PlaneMesh(_buttonPlayMaterial,"playShow")
			playVideoPicto.addEventListener(MouseEvent3D.MOUSE_OVER, playVideoPictoOverHandler)
			playVideoPicto.addEventListener(MouseEvent3D.MOUSE_OUT, playVideoPictoOutHandler)
			playVideoPicto.z = -800
			playVideoPicto.rotationZ = 3
			
			shadePlay = new PlaneMesh(_guiMaterial, "playShowShade")
			shadePlay.z = -750
			shadePlay.rotationZ = 3			
				
			playVideoPicto.addEventListener(MouseEvent3D.MOUSE_DOWN,playVideoClickHandler)
			playVideoPicto.addEventListener(MouseEvent3D.MOUSE_OUT,mouseOutHandler)
			playVideoPicto.addEventListener(MouseEvent3D.MOUSE_OVER,mouseOverHandler)
			playVideoPicto.mouseEnabled = true
			_listElementsToAdd.push(shadePlay, playVideoPicto)
				
			// PLAYER
			_videoContainer = new ObjectContainer3D()
			var scale:Number = 0.55
			var widthPlaneScreen:Number = 1280*scale
			var heightPlaneScreen:Number = 720*scale
			_videoScreen = new Mesh(new PlaneGeometry(widthPlaneScreen,heightPlaneScreen, 1,1, false), _videoScreenMaterial)
			_gs3dPlayer.setSource(_videoScreen);
			_videoContainer.addChild(_gs3dPlayer)
			
			//_videoContainer.position = new Vector3D(120,-390,-2000)
			//_videoContainer.position = new Vector3D(120,-390,-100)
			_videoContainer.position = new Vector3D(200,-50,-0.001)
			_videoContainer.visible = false
			//_videoContainer.rotationZ = -63.5
			
			_videoContainer.addChild(_videoScreen)
				
			_gs3dOverlayGrid.setSource(null,100,100);
			_globalContainer.addChild(_gs3dOverlayGrid)
			_gs3dOverlayGrid.z = -500
			
			//// EXTRA
			titleName2 = new PlaneMesh(_contentMaterial,_idAsset+"Title")
			clientName2 = new PlaneMesh(_contentMaterial,_idAsset+"Client")
			_gs3dTitleExtra.setSource(titleName2)
			
			_extraContainer = new PerspScaleContainer(viewRenderer)
			trace(_idAsset + " has awardsBloc >> " + _hasAwardBlock)
			if(_hasAwardBlock){
				
				_awardsBlock = PerspScaleMesh.createFromMesh(AssetLibrary.getAsset("commonAwardsBlock") as Mesh)
			}
			_workBlock = PerspScaleMesh.createFromMesh(AssetLibrary.getAsset("commonWorkBlock") as Mesh)
			_extraBlock = PerspScaleMesh.createFromMesh(AssetLibrary.getAsset("commonMainBlock") as Mesh)
			_extraPointlight = AssetLibrary.getAsset("commonExtraLight") as PointLight
			ColorMaterial(_extraBlock.material).specular = 0			
			ColorMaterial(_workBlock.material).specular = 0
			_extraContainer.addChild(_workBlock);
			if(_awardsBlock){
				ColorMaterial(_awardsBlock.material).specular = 0
				_extraContainer.addChild(_awardsBlock);				
			}
			_extraContainer.addChild(_extraBlock);
			_extraContainer.addChild(_extraPointlight)
			_extraPointlight.x = 0
			_extraPointlight.specular = 0		
				
			_listElementsToAdd.push(titleName2, clientName2, _gs3dTitleExtra)
		}		
		
		protected function playVideoPictoOutHandler(event:MouseEvent3D):void
		{
			TweenMax.to(_buttonPlayMaterial.colorTransform, 0.5, {redMultiplier:1, greenMultiplier:1, blueMultiplier:1, redOffset:0, greenOffset:0, blueOffset:0, ease:Quart.easeOut})
			mouseOverHandler(event)
		}
		
		protected function playVideoPictoOverHandler(event:MouseEvent3D):void
		{
			TweenMax.to(_buttonPlayMaterial.colorTransform, 0.15, {redMultiplier:1, greenMultiplier:1, blueMultiplier:1, redOffset:96, greenOffset:96, blueOffset:96, ease:Quart.easeOut})
			mouseOutHandler(event)
		}
		
		/*** LOOP BUILDER **/
		
		override protected function startLoopBuilder():void
		{
			if(!_waitBuilding){
				while(_listElementsToAdd.length > 0){
					var el:ObjectContainer3D = _listElementsToAdd.pop()
					if(el is PlaneMesh){
						addPlane(el as PlaneMesh)
						//trace("addPlane >> " + el)
					}else{
						_globalContainer.addChild(el)
						/*trace("add EL >> " + el)
						var globalTransform:Matrix3D = el.sceneTransform.clone()
						this.parent.addChild(el)
						el.transform = globalTransform*/
					}
				}
			}else{
				loopBuilderInterval = setInterval(loopBuilder,10)
			}
		}
		
		private function loopBuilder():void
		{
			if(!_builtContent){
				if(_waitBuilding){
					if(_listElementsToAdd){
						if(_listElementsToAdd.length > 0){
							//if(increment/3 == Math.round(increment/3)){
							var el:ObjectContainer3D = _listElementsToAdd.pop()
							if(el is PlaneMesh){
								addPlane(el as PlaneMesh)
							}else{
								_globalContainer.addChild(el)
							}
						}else{
							_waitBuilding = false
						}
					}
				}else{
					_builtContent = true
					dispatchEvent(new Event(GroupPlane3D.BUILD_COMPLETE));
					clearInterval(loopBuilderInterval)
				}
			}
		}
		
		override protected function transitionCompleteHandler(event:TransitionEvent):void
		{
			if(event.transition.internalSubTransition && _targetSubPage){
				_currentSubPage = _targetSubPage
			}
			
			_transitionComplete = true
			super.transitionCompleteHandler(event);
		}
		
		protected function getTriPosSprite3DList(subPageName:String):Vector.<TriPosSprite3D>
		{
			var tpss3d:Vector.<TriPosSprite3D>
			if(subPageName == SubPageNames.MAIN){
				tpss3d  = new <TriPosSprite3D>[_gs3dMain];					
			}else if(subPageName == SubPageNames.EXTRACONTENT){
				tpss3d= new <TriPosSprite3D>[_gs3dTitleExtra, _gs3dAwards, _gs3dWork, _gs3dExtra];
			}else if(subPageName == SubPageNames.VIDEOPLAYER){
				tpss3d = new <TriPosSprite3D>[_gs3dMain, _gs3dPlayer];
			}
			
			if(!tpss3d) return null
			return tpss3d
		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
			if(!transitionInfo.internalSubTransition == null) _targetSubPage = SubPageNames.MAIN
			trace("_currentSubPage >> " + _currentSubPage + "_target >>" + _targetSubPage)
			startAlphaZero = (_currentSubPage == SubPageNames.MAIN && _targetSubPage == SubPageNames.MAIN)
				
			if(startAlphaZero){
				if(_normalMainMaterial) _normalMainMaterial.alpha = 0
				if(_addMainMaterial) _addMainMaterial.alpha = 0
				_matRedLine.alpha = 0
				_matPurpleAlpha.alpha = 0
				
				if(redLine){
					SubMesh(redLine.subMeshes[0]).offsetU = -1
					TweenMax.to(SubMesh(redLine.subMeshes[0]),1.6, {delay:0.8, offsetU:0, ease:Linear.easeNone})
				}
			}
				
				
			if(_targetSubPage == SubPageNames.MAIN){
				var delay:Number = timelineDuration-0.6 < 0 ? 0 : timelineDuration-0.6
				if(_normalMainMaterial){					
					TweenMax.to(_normalMainMaterial, 0.8, {delay:delay, alpha:1})
				}
				if(_addMainMaterial){
					TweenMax.to(_addMainMaterial, 0.8, {delay:delay, alpha:1})
				}
				TweenMax.to(_matRedLine, 0.8, {delay:delay, alpha:1})
				TweenMax.to(_matPurpleAlpha, 0.8, {delay:delay, alpha:0.65})
			}else if(_targetSubPage == SubPageNames.VIDEOPLAYER){
				if(_normalMainMaterial){
					TweenMax.to(_normalMainMaterial, 2, {delay:0.3, alpha:0.2})
				}
				if(_addMainMaterial){
					TweenMax.to(_addMainMaterial, 2, {delay:0.3, alpha:0.2})
				}
			}else if(_targetSubPage == SubPageNames.EXTRACONTENT){
				if(_normalMainMaterial){
					TweenMax.to(_normalMainMaterial, 2, {delay:0.3, alpha:1})
				}
				if(_addMainMaterial){
					TweenMax.to(_addMainMaterial, 2, {delay:0.3, alpha:1})
				}
			}
			
			if(_targetSubPage == SubPageNames.MAIN || _targetSubPage == SubPageNames.EXTRACONTENT || _targetSubPage == SubPageNames.VIDEOPLAYER){
				var tpss3d:Vector.<TriPosSprite3D> = getTriPosSprite3DList(_targetSubPage);
				var time:int = (timelineDuration-0.3)*1000
				if(time <= 0){
					dispatchOpenSubPage(tpss3d);
				}else{		
					setTimeout(dispatchOpenSubPage, time, tpss3d)
				}
			}
			
			TweenMax.to(_guiMaterial, 0.3, {delay:0.5, alpha:1})
			
			super.startTransition()
		}
		
		override public function hideTransition(subTransitionName:String = null):void
		{
			/*if(!subPageName && _currentSubPage) subPageName = _currentSubPage
			if(subPageName){				
				if(subPageName == SubPageNames.MAIN){
					//if(_normalMainMaterial) TweenMax.to(_normalMainMaterial, 0.5, {alpha:0})
					//if(_addMainMaterial) TweenMax.to(_addMainMaterial, 0.5, {alpha:0})
				}
			}else{*/
			if(subTransitionName == SubTransitionNames.VIDEOPLAYER){
			
			}

			if(!subTransitionName) fadeAlpha(0,0.15);
			//}
		}
		
		protected function dispatchOpenSubPage(gs3d:Vector.<TriPosSprite3D> = null):void {
			_currentTps3D = new GroupTps3D(_targetSubPage, gs3d)
			trace("@@@@ dispatchOpenSubPage >> - " + _targetSubPage + " - " + gs3d.length + " - " + _page.id)
			dispatchEvent(new GroupSprite3DEvent(AbstractProjectGp3D.OPEN_SUBPAGE, _currentTps3D))
		}		
		
		public function dispatchUpdatePosition():void
		{	
			//if(!_currentTps3D) return
			dispatchEvent(new GroupSprite3DEvent(UPDATE_3DPOSITION, _currentTps3D))	
		}
		
		override protected function onRender(e:Event):void
		{
			//dispatchUpdatePosition();
			super.onRender(e)
		}
		
		/*protected function dispatchCloseProject():void
		{
			dispatchEvent(new Event(CLOSE_PROJECT))
		}*/
		
		override protected function replaceContent():void
		{
			super.replaceContent()
			dispatchUpdatePosition();
		}
		
		override public function dispose():void{
			super.dispose();
		}
		
		override public function get worldTargetCamCoordinates():Gp3DVO
		{
			var newPos:Gp3DVO = worldCoordinates
			//newPos.target = null
			//newPos.rotationZ = 0//-_commonZRotation		
			
			return newPos
		}
		
		protected function watchCaseHandler(event:MouseEvent3D):void
		{
			navigateToURL(new URLRequest(_page.project.caseVimeo), "_blank")
		}
		
		override public function prepareSubPageTransition(transition:TransitionPageData):void
		{	
			if(transition.internalSubTransition == SubTransitionNames.EXTRACONTENT){
				TweenMax.to(_extraContainer, 1, {x:_extraContentX, ease:Quart.easeInOut}) 
			}
			
			if(transition.internalSubTransition == SubTransitionNames.HOMEFROMEXTRA){
				TweenMax.to(_extraContainer, 1, {x:_extraContentX+1000, ease:Quart.easeInOut})
			}
			
			if(transition.internalSubTransition == SubTransitionNames.EXTRACONTENT){
				_globalContainer.addChild(_extraContainer)
			}
			
			if(transition.internalSubTransition == SubTransitionNames.VIDEOPLAYER){
				_globalContainer.addChild(_videoContainer)
				shadePlay.visible = false
				playVideoPicto.visible = false
			}else{
				shadePlay.visible = true
				playVideoPicto.visible = true
			}
			
			super.prepareSubPageTransition(transition);
		}
		
		
		protected function playVideoClickHandler(event:MouseEvent3D = null):void
		{	
			navigateToSubPage(SubPageNames.VIDEOPLAYER)
		}	
	}
}