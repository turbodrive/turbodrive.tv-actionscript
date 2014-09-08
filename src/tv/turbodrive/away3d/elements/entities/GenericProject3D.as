package tv.turbodrive.away3d.elements.entities
{
	import com.greensock.TweenMax;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.transitions.timeline.vo.Gp3DVO;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.puremvc.mediator.view.component.overlay2d.VideoPlayerView;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.puremvc.proxy.data.SubTransitionNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	import tv.turbodrive.utils.MathUtils;

	public class GenericProject3D extends AbstractProjectGp3D
	{	
		private var _idMeshes:int = 1
		
		private var _dictionnaryMesh:Dictionary = new Dictionary();
		private var _localBlackMat:ColorMaterial;
		private var _localPointLight:PointLight;
		private var localLp:StaticLightPicker;
		private var _localRed:ColorMaterial;
		private var _localWhite:ColorMaterial;
		private var _localPurple:ColorMaterial;
		
		protected var _gs3dMpMain:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.MP_MAIN);
		protected var _gs3dMpSkills:TriPosSprite3D = new TriPosSprite3D(TriPosSprite3DName.MP_SKILLS);

		private var redLine2:PerspScaleMesh;

		private var shapeContent2:Mesh;

		private var shapeContent:Mesh;
		
		public function GenericProject3D(page:Page)
		{	
			super(page);
			_portalOut = new Gp3DVO({x:-500,y:-7000,z:3000, rotationX:90, rotationY:90, rotationZ:30, rigDistance:Tools3d.DISTANCE_Z_1280})
			_portalIn = new Gp3DVO({x:0,y:0,z:-30000, rotationX:0, rotationY:0, rotationZ:0, rigDistance:Tools3d.DISTANCE_Z_1280})
			
			if(_page.project && _page.project.transformClone){
				var model:Object3D = _page.project.transformClone
				_rPosition = new Vector3D(model.x, model.y, model.z);
				_rRotation = new Vector3D(model.rotationX,model.rotationY,model.rotationZ);
				_worldCoordinates = new Gp3DVO({x:_rPosition.x,y:_rPosition.y,z:_rPosition.z, rotationX:_rRotation.x, rotationY:_rRotation.y, rotationZ:_rRotation.z, rigDistance:Tools3d.DISTANCE_Z_1280})
			}		
		}
		
		override protected function initMaterial():void
		{
			_contentMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TEXTURE_MOREPROJECTS))	
			
			_localPointLight = new PointLight();
			_localPointLight.position = new Vector3D(0,800,-700)
			_localPointLight.specular = 0
			_localPointLight.ambient = 0.6
			_localPointLight.diffuse = 0.4
			localLp = new StaticLightPicker([_localPointLight])
				
			_localRed = MaterialHelper.cloneColorMaterial(AssetLibrary.getAsset("RedMp") as ColorMaterial)
			_localWhite = MaterialHelper.cloneColorMaterial(AssetLibrary.getAsset("WhiteMp") as ColorMaterial)
			_localWhite.specular = 0
			_localWhite.ambient = 1
			_localWhite.lightPicker = localLp
			_localPurple = MaterialHelper.cloneColorMaterial(AssetLibrary.getAsset("PurpleMp") as ColorMaterial)
			_localPurple.alphaPremultiplied = _localWhite.alphaPremultiplied = _localRed.alphaPremultiplied = false
			_localPurple.lightPicker = localLp
			_localBlackMat = new ColorMaterial(0x000000,1);
			_localBlackMat.bothSides = true
				
			_guiMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI) as ATMaterial);
			
			_fadeAlphaElements.push(_localRed, _localWhite, _localPurple, _localBlackMat, _guiMaterial, _contentMaterial)
		}
		
		protected function addAndCloneAssetsFromAwd(meshName:String, addToScene:Boolean = true):Mesh
		{
			var initMesh:Mesh = AssetLibrary.getAsset(meshName) as Mesh;
			var clone:Mesh = MeshHelper.clone(initMesh);
			var nameClone:String = _idAsset + initMesh.name;
			clone.name = nameClone;
			_dictionnaryMesh[nameClone] = clone;
			MeshHelper.recenter(clone);
			if(addToScene) _listElementsToAdd.push(clone);
			return clone
		}
		
		protected function setMaterialToClone(meshName:String, material:ColorMaterial):void
		{
			var mesh:Mesh = _dictionnaryMesh[_idAsset+meshName] as Mesh;
			mesh.material = material
		}
		
		override protected function createLocalScene():void
		{				
			_videoScreen = new Mesh(new PlaneGeometry(704,396,1,1,false), _localBlackMat);
			_videoScreen.position = _idMeshes == 1 ? new Vector3D(225,-55) : new Vector3D(-175,-63);
			_videoScreen.visible = false
			//_listElementsToAdd.push(_videoScreen)
			
			// PURPLE PANELS
			var i:int = 1
			var meshName:String
			while(AssetLibrary.getAsset("panelP"+i+"MP"+_idMeshes)){
				meshName = "panelP"+i+"MP"+_idMeshes
				addAndCloneAssetsFromAwd(meshName)
				setMaterialToClone(meshName, _localPurple)
				i++
			}
				
			// WHITE PANELS
			i = 1
			while(AssetLibrary.getAsset("panelW"+i+"MP"+_idMeshes)){
				meshName = "panelW"+i+"MP"+_idMeshes
				addAndCloneAssetsFromAwd(meshName)
				setMaterialToClone(meshName, _localWhite)
				i++
			}			
			
			// RED STUFFS
			clientName = new PlaneMesh(_contentMaterial,_idAsset+"_client")
			titleName = new PlaneMesh(_contentMaterial,_idAsset+"_title")
			redLine2 = PerspScaleMesh.createFromMesh(addAndCloneAssetsFromAwd("redlineMP"+_idMeshes, false));
			redLine2.material = _localRed
			redLine2.extraScale = 0.6
			//setMaterialToClone("redlineMP"+_idMeshes, _localRed)
			
			shapeContent2 = _dictionnaryMesh[_idAsset +"panelP1MP1"] as Mesh;
			_gs3dMpSkills.setSource(null,titleName.width,titleName.height)
			shapeContent2.scaleX = 1.05
			shapeContent2.scaleY = 1.05
			_gs3dMpSkills.visible = false

			_gs3dPlayer.setSource(_videoScreen);
			
			shapeContent = _dictionnaryMesh[_idAsset +"panelW1MP1"] as Mesh;
			shapeContent.y -= 180
			shapeContent.x += 180
			_gs3dMpMain.setSource(shapeContent)
			_gs3dMpMain.visible = false
			
			// videoPicto
			playVideoPicto = new PlaneMesh(_guiMaterial,"playShow")		
			playVideoPicto.z = -400
				
			_listElementsToAdd.push(redLine2, _videoScreen, clientName, titleName, _gs3dMpMain ,_gs3dMpSkills, _gs3dPlayer, _localPointLight, playVideoPicto)				
			clientName.z = -50
				
			_globalContainer.rotationZ = 8
		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
			var delay:Number = timelineDuration -1
			if(delay<0) delay = 0
			
			if(_localRed){
				_localRed.alpha = 0
				TweenMax.to(_localRed, 0.3, {delay:delay, alpha:1})
			}
			if(_localWhite){
				_localWhite.alpha = 0
				TweenMax.to(_localWhite, 0.3, {delay:delay+0.3, alpha:1})
			}
			if(_localPurple){
				_localPurple.alpha = 0
				TweenMax.to(_localPurple, 0.3, {delay:delay+0.1, alpha:1})
			}

			var tpss3d:Vector.<TriPosSprite3D> = new <TriPosSprite3D>[_gs3dMpMain, _gs3dPlayer, _gs3dMpSkills ]
			var time:int = (timelineDuration+0.2)*1000

			if(time <= 0){
				dispatchOpenSubPage(tpss3d);
			}else{		
				setTimeout(dispatchOpenSubPage, time, tpss3d)
			}
			
			TweenMax.to(_guiMaterial, 0.3, {delay:timelineDuration-0.1, alpha:1})
				
			setTimeout(hideButtonPlayer, VideoPlayerView.DELAY_MOREPROJECT_SHOW+time)
		}
		
		private function hideButtonPlayer():void
		{
			TweenMax.to(_guiMaterial,0.3, {alpha:0})
		}
		
		override public function hideTransition(subTransitionName:String = null):void
		{
			_guiMaterial.alpha = 1
			fadeAlpha(0,0.3);

		}
		
		override public function prepareSubPageTransition(transition:TransitionPageData):void
		{
			// Override AbstractPage Method
		}
		
		/** LAYOUT X/Y **/		
		override protected function replaceContent():void
		{	
			playVideoPicto.x = _rX*90
			playVideoPicto.y = -_rY*50
			
			if(_ratioPan){
				_videoScreen.scaleX = _videoScreen.scaleY = _scaleVisuel
				_videoScreen.x = _sW* 0.14
			}else{
				_videoScreen.scaleX = _videoScreen.scaleY = _rX
				_videoScreen.x = _sW* 0.14
			}	
			_videoScreen.y = -100
			_gs3dPlayer.update();
			
			var titlePosition:Vector3D = new Vector3D(-520*_rX,210*_rY ,-100);	
			titleName.position = new Vector3D(titlePosition.x + (titleName.width/2), titlePosition.y + (titleName.height/2), titlePosition.z)
			
			clientName.x = titlePosition.x + (clientName.width/2)
			clientName.y = titlePosition.y + titleName.height + (clientName.height/2) + 5
				
			redLine2.x = titlePosition.x
			redLine2.y = titlePosition.y - 10
				
			_gs3dMpSkills.x = titleName.x + 30// - 40*_layoutRatioX
			_gs3dMpSkills.y = titleName.y// - 35 //- 50*_layoutRatioY
			_gs3dMpSkills.z = titleName.z
				
			shapeContent2.x = _rX*-174 - _layoutRatioX*100
			shapeContent.x = _rX*-224 - _layoutRatioX*100
			_gs3dMpMain.update();
			
			super.replaceContent();
		}
	
	}
}