package tv.turbodrive.away3d.elements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.IAsset;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	
	import tv.turbodrive.Preloader;
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.away3d.elements.entities.PerspScaleMesh;
	import tv.turbodrive.away3d.elements.entities.PlaneMesh;
	import tv.turbodrive.away3d.elements.entities.TriParticleContainer;
	import tv.turbodrive.away3d.elements.meshes.GlowGenGrid;
	import tv.turbodrive.away3d.elements.subElements.AboutTimeline;
	import tv.turbodrive.away3d.elements.subElements.ButtonMesh;
	import tv.turbodrive.away3d.elements.subElements.ButtonMeshLight;
	import tv.turbodrive.away3d.elements.subElements.SkillsContent;
	import tv.turbodrive.away3d.elements.subElements.SkillsMenu;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.transitions.TransitionsName;
	import tv.turbodrive.away3d.transitions.timeline.vo.Gp3DVO;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.events.TransitionEvent;
	import tv.turbodrive.puremvc.proxy.SWFAddressReceiverProxy;
	import tv.turbodrive.puremvc.proxy.data.ContactShareVO;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.puremvc.proxy.data.SubTransitionNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	
	public class PageAbout extends GroupPlane3D
	{
		//private var whatParticles:Array = [{index:0,startTime:0.08,reverted:true,position:new Vector3D(48.35,-40.7, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:1,startTime:0.16,reverted:true,position:new Vector3D(110.9,40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:2,startTime:0.24,reverted:true,position:new Vector3D(206.45,40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:3,startTime:0.32,reverted:true,position:new Vector3D(302.15,40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:4,startTime:0.52,reverted:true,position:new Vector3D(397.85,40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:5,startTime:0.56,reverted:true,position:new Vector3D(493.65,40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:6,startTime:0.2,reverted:true,position:new Vector3D(81.75,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:7,startTime:0.28,reverted:true,position:new Vector3D(177.55,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:8,startTime:0.6,reverted:true,position:new Vector3D(273.25,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:9,startTime:0.68,reverted:true,position:new Vector3D(368.95,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:10,startTime:0.52,reverted:true,position:new Vector3D(464.75,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:11,startTime:0.36,reverted:true,position:new Vector3D(144.05,-40.7, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:12,startTime:0.44,reverted:true,position:new Vector3D(239.75,-40.7, 0),colorTransform:new ColorTransform(0.7109375,0.69921875,0.48046875,1,0,0,0,0)},{index:13,startTime:0.52,reverted:true,position:new Vector3D(335.45,-40.7, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:14,startTime:0.6,reverted:true,position:new Vector3D(431.25,-40.7, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:15,startTime:0.68,reverted:true,position:new Vector3D(526.95,-40.7, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:16,startTime:0,reverted:false,position:new Vector3D(48.5,40.6, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:17,startTime:0.4,reverted:false,position:new Vector3D(144.1,40.6, 0),colorTransform:new ColorTransform(1,1,0.80078125,1,0,0,0,0)},{index:18,startTime:0.16,reverted:false,position:new Vector3D(239.8,40.6, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:19,startTime:0.24,reverted:false,position:new Vector3D(335.5,40.6, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:20,startTime:0.32,reverted:false,position:new Vector3D(431.3,40.6, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:21,startTime:0.4,reverted:false,position:new Vector3D(527,40.6, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:22,startTime:0.12,reverted:false,position:new Vector3D(81.8,-40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:23,startTime:0.2,reverted:false,position:new Vector3D(177.5,-40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:24,startTime:0.44,reverted:false,position:new Vector3D(273.1,-40.75, 0),colorTransform:new ColorTransform(0.73046875,0.75,0.9609375,1,0,0,0,0)},{index:25,startTime:0.48,reverted:false,position:new Vector3D(368.9,-40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:26,startTime:0.36,reverted:false,position:new Vector3D(464.6,-40.75, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:27,startTime:0.24,reverted:false,position:new Vector3D(115.2,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:28,startTime:0.32,reverted:false,position:new Vector3D(211,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:29,startTime:0.4,reverted:false,position:new Vector3D(306.6,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:30,startTime:0.48,reverted:false,position:new Vector3D(402.4,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)},{index:31,startTime:0.56,reverted:false,position:new Vector3D(498.2,-122.2, 0),colorTransform:new ColorTransform(1,1,1,1,0,0,0,0)}];		
		//private var contactParticles:Array = [{index:0,startTime:1.24,reverted:true,position:new Vector3D(266.9,120.3, 0)},{index:1,startTime:1.04,reverted:false,position:new Vector3D(267.1,201.75, 0)},{index:2,startTime:1.08,reverted:true,position:new Vector3D(233.5,201.55, 0)},{index:3,startTime:0.96,reverted:false,position:new Vector3D(233.8,283.05, 0)},{index:4,startTime:0.88,reverted:true,position:new Vector3D(200.2,283, 0)},{index:5,startTime:1.16,reverted:false,position:new Vector3D(200.55,364.55, 0)},{index:6,startTime:0.68,reverted:true,position:new Vector3D(166.95,364.5, 0)},{index:7,startTime:0.8,reverted:false,position:new Vector3D(167.3,445.8, 0)},{index:8,startTime:0.48,reverted:true,position:new Vector3D(133.7,445.75, 0)},{index:9,startTime:0.36,reverted:false,position:new Vector3D(134.05,527.05, 0)},{index:10,startTime:0.2,reverted:true,position:new Vector3D(100.45,527, 0)},{index:11,startTime:1.44,reverted:true,position:new Vector3D(204.7,39, 0)},{index:12,startTime:1.08,reverted:false,position:new Vector3D(204.55,120.3, 0)},{index:13,startTime:1.2,reverted:true,position:new Vector3D(171.2,120.3, 0)},{index:14,startTime:1.12,reverted:false,position:new Vector3D(171.3,201.75, 0)},{index:15,startTime:1.04,reverted:true,position:new Vector3D(137.8,201.55, 0)},{index:16,startTime:0.92,reverted:false,position:new Vector3D(138,283.05, 0)},{index:17,startTime:1.2,reverted:true,position:new Vector3D(104.3,283, 0)},{index:18,startTime:0.72,reverted:false,position:new Vector3D(104.75,364.55, 0)},{index:19,startTime:0.6,reverted:true,position:new Vector3D(71.05,364.5, 0)},{index:20,startTime:0.48,reverted:false,position:new Vector3D(71.5,445.8, 0)},{index:21,startTime:0.4,reverted:true,position:new Vector3D(37.8,445.75, 0)},{index:22,startTime:0.68,reverted:false,position:new Vector3D(38.25,527.05, 0)},{index:23,startTime:0.08,reverted:true,position:new Vector3D(4.55,527, 0)},{index:24,startTime:1.68,reverted:false,position:new Vector3D(142.35,39.1, 0)},{index:25,startTime:1.6,reverted:true,position:new Vector3D(108.9,39, 0)},{index:26,startTime:1.52,reverted:false,position:new Vector3D(108.75,120.3, 0)},{index:27,startTime:1.4,reverted:true,position:new Vector3D(75.3,120.3, 0)},{index:28,startTime:1.28,reverted:true,position:new Vector3D(41.8,201.55, 0)},{index:29,startTime:1.44,reverted:false,position:new Vector3D(75.5,201.75, 0)},{index:30,startTime:1.04,reverted:false,position:new Vector3D(41.95,283.05, 0)},{index:31,startTime:0.96,reverted:true,position:new Vector3D(8.25,283, 0)},{index:32,startTime:0.84,reverted:false,position:new Vector3D(8.7,364.55, 0)},{index:33,startTime:0.72,reverted:true,position:new Vector3D(-25,364.5, 0)},{index:34,startTime:1,reverted:false,position:new Vector3D(-24.55,445.8, 0)},{index:35,startTime:0.56,reverted:true,position:new Vector3D(-58.25,445.75, 0)},{index:36,startTime:0.44,reverted:false,position:new Vector3D(-57.8,527.05, 0)},{index:37,startTime:0.36,reverted:true,position:new Vector3D(-91.5,527, 0)},{index:38,startTime:1.12,reverted:false,position:new Vector3D(46.5,39.1, 0)},{index:39,startTime:1.04,reverted:true,position:new Vector3D(12.8,39, 0)},{index:40,startTime:0.96,reverted:false,position:new Vector3D(12.7,120.3, 0)},{index:41,startTime:0.88,reverted:true,position:new Vector3D(-20.75,120.3, 0)},{index:42,startTime:0.76,reverted:false,position:new Vector3D(-20.45,201.75, 0)},{index:43,startTime:0.68,reverted:true,position:new Vector3D(-54.15,201.55, 0)},{index:44,startTime:0.88,reverted:false,position:new Vector3D(-54.1,283.05, 0)},{index:45,startTime:0.52,reverted:true,position:new Vector3D(-87.7,283, 0)},{index:46,startTime:0.44,reverted:false,position:new Vector3D(-87.35,364.55, 0)},{index:47,startTime:0.36,reverted:true,position:new Vector3D(-120.95,364.5, 0)},{index:48,startTime:0.68,reverted:false,position:new Vector3D(-120.6,445.8, 0)},{index:49,startTime:0.2,reverted:true,position:new Vector3D(-154.2,445.75, 0)},{index:50,startTime:0.12,reverted:false,position:new Vector3D(-153.85,527.05, 0)},{index:51,startTime:0,reverted:true,position:new Vector3D(-187.45,527, 0)}];

		private var _profiPictureBackground:PlaneMesh;
		private var groupLines:ObjectContainer3D;

		private var _whatContainer:TriParticleContainer;
		private var _contactContainer:TriParticleContainer;
		
		private var increment:int = 0
		private static var _waitBuilding:Boolean = true
		private static var _waitFrameSSheet:Boolean = false
				
		private var _skills:PerspScaleMesh;
		private var _hireBg:PerspScaleMesh;
		
		private var _targetOut:Mesh	
		private var _commonZRotation:Number = 22.5	

		private var _findoutBtnMaterial:ATMaterial;
		private var _expandBtnMaterial:ATMaterial;
		private var _skillsBgMat:ColorMaterial;
		private var _hireBgMat:ColorMaterial;
		private var _guiMaterial:ATMaterial;
		private var _skillsPageZRotation:Number = -50

		private var _findoutButton:ButtonMeshLight;
		private var _expandButton:ButtonMeshLight;
		private var _aboutTimeline:AboutTimeline;

		private static var _mainMaterialADD:ATMaterial;
		private var _skillsContent:SkillsContent;

		private var _grid:GlowGenGrid;
		private var _mainMenuSkills:SkillsMenu;

		private var _menu2:SkillsMenu;

		private var _ctaMat:TextureMaterial;
		private var _menu1Mat:TextureMaterial;
		private var _menu2Mat:TextureMaterial;
		private static var _hire2Mat:ATMaterial;
		private static var _hireBg2Mat:ColorMaterial;
		private static var _staticMainMat:ATMaterial;
		private var hireMe:PlaneMesh;

		private var _hireBg2:Mesh;

		private var hireMe2:PlaneMesh;
		
		public function PageAbout(page:Page)
		{			
			super(MaterialName.TEXTURE_ABOUT);
			
			generateSubPagePosition()
		}
		
		override public function generateSubPagePosition(update:Boolean = false):void
		{	
			if(_internalSubPosGenerated && !update) return
			
			var skillsSubPage:Gp3DVO = new Gp3DVO({x:0,y:0,z:-1910, rotationX:0, rotationY:0, rotationZ:_skillsPageZRotation, rigDistance:Tools3d.DISTANCE_Z_1280})	
			_internalSubTransition[SubTransitionNames.ABOUTSKILLS] = skillsSubPage
			
			var backFromSkills:Gp3DVO = worldTargetCamCoordinates.clone()
			backFromSkills.delay = 0
			backFromSkills.duration = 1
			//backFromSkills.ease = Quad.easeInOut
			backFromSkills.z = 0
			_internalSubTransition[SubTransitionNames.BACKFROMSKILLS] = backFromSkills
			
			var backFromTimeline:Gp3DVO = worldTargetCamCoordinates.clone()
			backFromTimeline.delay = 0
			backFromTimeline.duration = 1.5
			//backFromTimeline.ease = Quart.easeInOut
			backFromTimeline.z = 0			
			backFromTimeline.rotationY = 0
			_internalSubTransition[SubTransitionNames.BACKFROMTIMELINE] = backFromTimeline
			
			super.generateSubPagePosition(update);
		}	
		
		override public function get worldTargetCamCoordinates():Gp3DVO
		{
			var newPos:Gp3DVO = worldCoordinates
			newPos.target = null
			newPos.rotationZ = -_commonZRotation		
			
			return newPos
		}
		
		override public function getSubTransition(subPageName:String):String
		{			
			_targetSubPage = subPageName
			if(_currentSubPage == SubPageNames.MAIN && subPageName == SubPageNames.TIMELINE){
				//throw new Error("Transition vers timeline bien spécifique")
				return SubTransitionNames.ABOUTTIMELINE
			}else if(_currentSubPage == SubPageNames.MAIN && subPageName == SubPageNames.SKILLS){
				return SubTransitionNames.ABOUTSKILLS
			}else if(_currentSubPage == SubPageNames.TIMELINE && subPageName == SubPageNames.MAIN){
				return SubTransitionNames.BACKFROMTIMELINE
			}else if(_currentSubPage == SubPageNames.SKILLS && subPageName == SubPageNames.MAIN){
				return SubTransitionNames.BACKFROMSKILLS
			}			
			return null
		}
		
		override public function needToWaitWhenBuilt():Boolean
		{
			return _waitBuilding
		}
		
		/*private function createTriParticlePanels():void
		{
			//trace("CREATE TRIPARTICLE")
			
			// What
			var whatTriPrtcle:TriParticle = new TriParticle(whatParticles);		
			whatTriPrtcle.scale(1.15);
			whatTriPrtcle.rotationZ = -90
			//whatTriPrtcle.z = 5
				
			var whatPanel:Mesh = Mesh(AssetLibrary.getAsset("what")); 
			whatPanel.material = new ColorMaterial(0xCECEC4)
			_materials.push(whatPanel.material)
			
			_whatContainer = new TriParticleContainer(whatPanel,whatTriPrtcle);
			_whatContainer.position = new Vector3D(-380,20,250)
			//addChild(_whatContainer);
			_listElementsToAdd.push(_whatContainer);
			
			// Contact
			var contactTriPrtcle:TriParticle = new TriParticle(contactParticles)
			contactTriPrtcle.scale(.8)
			contactTriPrtcle.rotationZ = -90
			
			var contactPanel:Mesh = Mesh(AssetLibrary.getAsset("contact"))
			contactPanel.material = new ColorMaterial(0xCECEC4)
			_materials.push(contactPanel.material)
			
			_contactContainer = new TriParticleContainer(contactPanel,contactTriPrtcle);
			_contactContainer.position = new Vector3D(385,248,250)
			//addChild(_contactContainer);
			_listElementsToAdd.push(_contactContainer);
		}*/
		
		override protected function initMaterial():void
		{
			
			_menu1Mat = AssetLibrary.getAsset("CommonMenuMat") as TextureMaterial
			_menu2Mat = AssetLibrary.getAsset("CommonMenuMat2") as TextureMaterial			
			_ctaMat = AssetLibrary.getAsset("CtaMat") as TextureMaterial
			
			if(!_staticMainMat) _staticMainMat = MaterialLibrary.getMaterial(_mainAtlas) as ATMaterial			
			if(!_hire2Mat) _hire2Mat = MaterialHelper.cloneATMaterial(_staticMainMat)
			if(!_hireBg2Mat){
				var vintageRed:ColorMaterial = AssetLibrary.getAsset("VintageRed") as ColorMaterial
				_hireBg2Mat = MaterialHelper.cloneColorMaterial(vintageRed)
			}
				
			if(!_mainMaterialADD){
				_mainMaterialADD = MaterialHelper.cloneATMaterial(_staticMainMat);
				_mainMaterialADD.blendMode = BlendMode.ADD
			}
			
			_guiMaterial = MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI) as ATMaterial
			_guiMaterial.alpha = 1
			_guiMaterial.blendMode = BlendMode.ADD
			_fadeAlphaElements.push(_staticMainMat, _guiMaterial)
		}
		
		override protected function createLocalScene():void
		{	
					
			
			_listElementsToAdd = []
				
			/****** GRID ******/
			_grid = new GlowGenGrid(4096,2048, GlowGenGrid.GRADIENT);			
			_grid.scale(3);
			_grid.position = new Vector3D(380,-340,-1200-512)
			_grid.rotationZ = _commonZRotation	
			_listElementsToAdd.push(_grid)
			
			_targetOut = AssetLibrary.getAsset("TargetOut") as Mesh
			this.addChild(_targetOut)			
				
			_skills = PerspScaleMesh.createFromMesh(Mesh(AssetLibrary.getAsset("SkillsBg")))
			_skillsBgMat = _skills.material as ColorMaterial
			_skillsBgMat.alphaPremultiplied = false
			_skillsBgMat.alpha = 0
			_fadeAlphaElements.push(_skillsBgMat)				
			_listElementsToAdd.push(_skills)
			_skills.position = new Vector3D(-75,-90,500)
				
			var containerLines:ObjectContainer3D = new ObjectContainer3D()
			groupLines = new ObjectContainer3D()
			var line1:PlaneMesh = new PlaneMesh(_guiMaterial, "blueLine", {scaleTexY:-1});
			groupLines.addChild(line1)	
			var line2:PlaneMesh = new PlaneMesh(_guiMaterial, "redLine");
			line2.y = line1.y - line2.height + 3
			groupLines.addChild(line2)	
			var line3:PlaneMesh = new PlaneMesh(_guiMaterial, "yellowLine");
			line3.y = line2.y - line3.height + 3
			groupLines.addChild(line3)	
			var line4:PlaneMesh = new PlaneMesh(_guiMaterial, "blueLine");
			line4.y = line3.y - line4.height + 5
			line1.x = -1000
			line2.x = line1.x - 380
			line3.x = line1.x - 200
			line4.x = line1.x - 1000
			containerLines.scaleX = containerLines.scaleY = 2
			//line1.extraScale = line2.extraScale = line3.extraScale = line4.extraScale = 2
				
			groupLines.addChild(line4)
			groupLines.x = -2000
			containerLines.x = 500
			containerLines.z = _skills.z
			containerLines.y = -50
			containerLines.rotationZ = _commonZRotation+180
			containerLines.scale(1.2)
			containerLines.addChild(groupLines)			
			containerLines.rotationY = 180
			_listElementsToAdd.push(containerLines)
			
			var posInit:Vector3D = new Vector3D(0,150,100)
			var imdIntro:PlaneMesh = new PlaneMesh(_staticMainMat,"imdIntro")
			imdIntro.position = posInit
			_listElementsToAdd.push(imdIntro)
			var nameIntro:PlaneMesh = new PlaneMesh(_staticMainMat,"nameIntro")
			nameIntro.position = new Vector3D(posInit.x - (imdIntro.width>>1) + (nameIntro.width >>1),posInit.y + ( imdIntro.height >>1) + (nameIntro.height>>1), 150)
			_listElementsToAdd.push(nameIntro)
			var textIntro:PlaneMesh = new PlaneMesh(_staticMainMat,"textIntro")
			textIntro.position = new Vector3D(posInit.x - (imdIntro.width>>1) + (textIntro.width >>1),posInit.y - ( imdIntro.height >>1) - (textIntro.height>>1)-15, 100 )
			_listElementsToAdd.push(textIntro)
			
			_hireBg = PerspScaleMesh.createFromMesh(Mesh(AssetLibrary.getAsset("HirePanel")))
			_hireBgMat = _hireBg.material as ColorMaterial
			_hireBgMat.alphaPremultiplied = false
			_listElementsToAdd.push(_hireBg)
			
			_fadeAlphaElements.push(_hireBg.material)				
			hireMe = new PlaneMesh(_staticMainMat,"hireMe")			
			hireMe.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler)
			hireMe.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler)
			hireMe.addEventListener(MouseEvent3D.CLICK, hireClickHandler)
			hireMe.mouseEnabled = true		
			_listElementsToAdd.push(hireMe)		
				
			var skillsTitle:PlaneMesh = new PlaneMesh(_staticMainMat,"SkillsTitle1")
			skillsTitle.position = new Vector3D(-390,-85, _skills.z - 25)
			_listElementsToAdd.push(skillsTitle)
			var xpTitle:PlaneMesh = new PlaneMesh(_staticMainMat,"XpTitle1")
			xpTitle.position = new Vector3D(397,-100,2500)
			_listElementsToAdd.push(xpTitle)
				
			_profiPictureBackground = new PlaneMesh(_mainMaterialADD,"background",{width:666,height:628})
			
			_listElementsToAdd.push(_profiPictureBackground)
							
			/*** SKILLS **/			
				
			_mainMenuSkills = new SkillsMenu(1, new Vector3D(-320,-100,-250), _menu1Mat);
			_mainMenuSkills.addEventListener(SkillsMenu.CLICK_BUTTON_SKILLS, clickSkillsHandler)
			_globalContainer.addChild(_mainMenuSkills)
			_mainMenuSkills.alpha = 0
				
			//**BUTTONS*//				
			var findoutMore:PerspScaleMesh = PerspScaleMesh.createFromMesh(AssetLibrary.getAsset("findoutCta") as Mesh)
			findoutMore.extraScale = 1.1
			findoutMore.position = new Vector3D(-130,-240,-50) // 50
			findoutMore.material = _ctaMat
			_findoutButton = new ButtonMeshLight(findoutMore, false)
			_findoutButton.addEventListener(MouseEvent3D.CLICK, clickSkillsHandler)
			_findoutButton.alpha = 0
			
			var expandTimeline:PerspScaleMesh = PerspScaleMesh.createFromMesh(AssetLibrary.getAsset("expandCta") as Mesh);
			expandTimeline.extraScale = 1.1
			expandTimeline.position = new Vector3D(450,-230,100) // 500	
			expandTimeline.material = _ctaMat
			_expandButton = new ButtonMeshLight(expandTimeline, false)
			_expandButton.addEventListener(MouseEvent3D.CLICK, clickTimelineHandler)
			_expandButton.alpha = 0
				
			_listElementsToAdd.push(findoutMore, expandTimeline)
				
			/**** TIMELINE EXPERIENCE *****/
			_aboutTimeline = new AboutTimeline(_commonZRotation, _globalContainer, _staticMainMat);
				
			/***** SKILLS Subpage *****/
			var skillsSubContainer:ObjectContainer3D = new ObjectContainer3D();
			var skillsGp3dVo:Gp3DVO = Gp3DVO(_internalSubTransition[SubTransitionNames.ABOUTSKILLS])
			skillsSubContainer.position = skillsGp3dVo.position
			skillsSubContainer.rotationZ = skillsGp3dVo.rotationZ
			_skillsContent = new SkillsContent(skillsSubContainer, _staticMainMat);							
		
			var skillsSubPlane:Mesh = new Mesh(new PlaneGeometry(4000,660,1,1,false));
			skillsSubPlane.material = new ColorMaterial(0x221026,0.65)
			skillsSubPlane.material.alphaPremultiplied = false
			skillsSubPlane.position = new Vector3D(0,-10,320)
			skillsSubPlane.rotationZ = 7.5
			skillsSubContainer.addChild(skillsSubPlane)
				
			_menu2 = new SkillsMenu(2, new Vector3D(-60,-230,-100), _menu2Mat);
			skillsSubContainer.addChild(_menu2)
			_menu2.addEventListener(SkillsMenu.CLICK_BUTTON_SKILLS, clickSkillsHandler)	
			_menu2.alpha = 0
				
			_hireBg2 = Mesh(AssetLibrary.getAsset("HirePanel2"))
			_hireBg2.material = _hireBg2Mat
			_globalContainer.addChild(_hireBg2)
			hireMe2 = new PlaneMesh(_staticMainMat,"hireMe")
			hireMe2.material = _hire2Mat
			hireMe2.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler)
			hireMe2.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler)
			hireMe2.addEventListener(MouseEvent3D.CLICK, hireClickHandler)
			hireMe2.mouseEnabled = true
			skillsSubContainer.addChild(hireMe2)
				
			_globalContainer.parent.addChild(skillsSubContainer)
			_fadeAlphaElements.push(_mainMenuSkills, _menu2, _findoutButton, _expandButton, _hire2Mat, _hireBg2Mat, _aboutTimeline._constantDateGridMat)
				
			/**** BUILD *****/
			increment = 0				
			if(!PageAbout._waitBuilding){
				while(_listElementsToAdd.length > 0){
					var el:ObjectContainer3D = _listElementsToAdd.pop()
					if(el is PlaneMesh){
						addPlane(el as PlaneMesh)
					}else{
						_globalContainer.addChild(el)
					}
				}
			}
			
			_globalContainer.rotationZ = -_commonZRotation			
		}
		
		protected function hireClickHandler(event:Event):void
		{
			Preloader.track(SWFAddressReceiverProxy.current+"/"+_currentSubPage+"/hireMeClick" );
			dispatchEvent(new StringEvent(ContactShareEvent.OPEN_CONTACT_PANEL, this, ContactShareVO.CONTACT));
		}	
		
		private function regulateCameraYAxis():void
		{		
			if(_viewRenderer.navCamera.rotationY < -180) _viewRenderer.navCamera.rotationY += 360
		}
		
		protected function clickTimelineHandler(event:MouseEvent3D):void
		{
			
			Preloader.track(SWFAddressReceiverProxy.current+"/"+_currentSubPage+"/timelineClick");
			navigateToSubPage(SubPageNames.TIMELINE, TransitionsName.INTERNAL_ABOUT_TIMELINE)
			groupLines.visible = false;	
			TweenMax.to(_mainMaterialADD, 1, {alpha:0})
			TweenMax.to(_staticMainMat, 1, {alpha:0})
			TweenMax.to(_skillsBgMat, 0.3, {alpha:0, delay:0.5})
			TweenMax.to(_hireBgMat, 0.3, {alpha:0, delay:0.4})
			TweenMax.to(_findoutButton, 0.6, {alpha:0})
			TweenMax.to(_expandButton, 0.6, {alpha:0})
			TweenMax.to(_aboutTimeline._constantDateGridMat, 0.8, {alpha:0.4, delay:0.5})
			
			_aboutTimeline.show();
			
			TweenMax.to(_mainMenuSkills , 0.3, {delay:0.4, alpha:0})
			_mainMenuSkills.playRotateX(90,0.1);
		}
		
		/******/
		
		protected function clickSkillsHandler(event:Event):void
		{
			if(_currentSubPage != SubPageNames.SKILLS){
				regulateCameraYAxis()			
				navigateToSubPage(SubPageNames.SKILLS)
				
				TweenMax.to(_staticMainMat, 1, {alpha:0, ease:Quad.easeInOut})
				TweenMax.to(_mainMaterialADD, 1, {alpha:0, ease:Quad.easeInOut})
				TweenMax.to(_findoutButton, 1, {alpha:0, ease:Quad.easeInOut})
				TweenMax.to(_expandButton, 1, {alpha:0, ease:Quad.easeInOut})
				TweenMax.to(_mainMenuSkills, 0.5, {alpha:0, ease:Quad.easeInOut})			
				TweenMax.to(_skillsBgMat, 1, {alpha:0, ease:Quad.easeInOut})
				TweenMax.to(_hireBgMat, 1, {alpha:0, ease:Quad.easeInOut})
				//TweenMax.to(_grid, 0.5, {alpha:0, delay:0.5})
				TweenMax.to(_aboutTimeline._constantDateGridMat, 1, {alpha:0, delay:0.2})
				_aboutTimeline.hide();
				_menu2.alpha = 0
				TweenMax.to(_menu2, 0.3, {delay:0.7, alpha:1, ease:Quad.easeInOut})
				_menu2.playRotateX(0,0.65)
				_mainMenuSkills.playRotateX(-100,0.1);
			}		
			
			var targetContent:String
			if(event is StringEvent){
				targetContent = StringEvent(event).getString();
			}
			Preloader.track(SWFAddressReceiverProxy.current+"/"+_currentSubPage+"/"+targetContent);
			_skillsContent.show(targetContent)
		}
		
		override protected function transitionCompleteHandler(event:TransitionEvent):void
		{
			if(event.transition.internalSubTransition && _targetSubPage){
				_currentSubPage = _targetSubPage
			}

			super.transitionCompleteHandler(event);
		}
		
		override public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{
			
			if(transitionInfo.internalSubTransition){
				if(_targetSubPage == SubPageNames.MAIN && _currentSubPage == SubPageNames.TIMELINE){
					regulateCameraYAxis()							
					TweenMax.to(_staticMainMat, 1, {alpha:1})
					TweenMax.to(_mainMaterialADD, 1, {alpha:1})
					TweenMax.to(_skillsBgMat, 0.3, {alpha:0.65, delay:0.5})
					TweenMax.to(_hireBgMat, 0.3, {alpha:1, delay:0.4})
					TweenMax.to(_findoutButton, 1, {alpha:1})				
					TweenMax.to(_expandButton, 1, {alpha:1})				
					TweenMax.to(_aboutTimeline._constantDateGridMat, 0.8, {alpha:1, delay:0.5})
					_aboutTimeline.hide();					
					TweenMax.to(_mainMenuSkills, 0.3, {delay:0.9, alpha:1})
					_mainMenuSkills.playRotateX(0,0.9);
				}
				if(_targetSubPage == SubPageNames.MAIN && _currentSubPage == SubPageNames.SKILLS){
					TweenMax.to(_staticMainMat, 1, {delay:0.2, alpha:1})
					TweenMax.to(_mainMaterialADD, 1, {delay:0.2, alpha:1})
					TweenMax.to(_findoutButton, 1, {delay:0.5, alpha:1})
					TweenMax.to(_expandButton, 1, {delay:0.5, alpha:1})
					TweenMax.to(_skillsBgMat, 1, {delay:0.5, alpha:0.65})
					TweenMax.to(_hireBgMat, 1, {delay:0.5, alpha:1})
					TweenMax.to(_grid, 1, {alpha:1})
					TweenMax.to(_aboutTimeline._constantDateGridMat, 0.5, {alpha:1, delay:0.1})
					_skillsContent.remove();
					_menu2.playRotateX(-90,0);
					
					TweenMax.to(_mainMenuSkills, 1, {delay:0.3, alpha:1})
					_mainMenuSkills.playRotateX(0,0.5);
				}
				
				super.startTransition()
			}else{
				
				_mainMenuSkills.alpha = 0
				_menu2.alpha = 0
				_findoutButton.alpha = 0
				_expandButton.alpha = 0
				
				// come from another category
				if(transitionInfo.previousPage){
					if(groupLines){
						_mainMaterialADD.alpha = 1
						groupLines.x = -2000
						TweenMax.to(groupLines,1, {delay:0.8, x:1000, ease:Linear.easeNone})
					}
					
					if(_skillsBgMat){
						_skillsBgMat.alpha = 0.65
					}
					
					if(_targetSubPage == SubPageNames.MAIN){
						_mainMenuSkills.playRotateX(0,3.2*0.8);
						TweenMax.to(_mainMenuSkills,0.5, {delay:3.5*0.8, alpha:1})
						TweenMax.to(_findoutButton,0.5, {delay:3.8*0.8, alpha:1})
						TweenMax.to(_expandButton,0.5, {delay:3.7*0.8, alpha:1})
						TweenMax.to(_aboutTimeline._constantDateGridMat,0.5, {delay:2.5*0.8, alpha:1})
					}
				}else{
					
					if(_skillsBgMat){
						TweenMax.to(_skillsBgMat,0.8, {alpha:0.65})
					}
					
					_mainMenuSkills.playRotateX(0,0);
					TweenMax.to(_mainMenuSkills,0.5, {alpha:1})
					TweenMax.to(_findoutButton,0.5, {alpha:1})
					TweenMax.to(_expandButton,0.5, {alpha:1})
					TweenMax.to(_aboutTimeline._constantDateGridMat,0.5, {delay:0.5, alpha:1})
				}
			}
			
			
		}
		
		override protected function onRender(e:Event):void
		{
			if(_waitBuilding && !_builtContent){
				if(_listElementsToAdd){
					if(_listElementsToAdd.length > 0){
						//if(increment/3 == Math.round(increment/3)){
							var el:ObjectContainer3D = _listElementsToAdd.pop()
							if(el is PlaneMesh){
								addPlane(el as PlaneMesh)
							}else{
								_globalContainer.addChild(el)
							}
						/*}
						increment ++*/
					}else{
						increment = 0
						PageAbout._waitBuilding = false
					}
				}
			}
			if(!_builtContent && !PageAbout._waitBuilding && !_waitFrameSSheet){
				_builtContent = true
				dispatchEvent(new Event(GroupPlane3D.BUILD_COMPLETE));
			}
		}
		override public function dispose():void
		{	
			super.dispose();
			if(_skillsContent){
				_skillsContent.dispose();
				_skillsContent = null
			}
			if(_aboutTimeline){
				_aboutTimeline.dispose();
				_aboutTimeline = null
			}
			
		}
		override public function introTransition():void
		{
	
		}
		
		/** LAYOUT X/Y **/		
		override protected function replaceContent():void
		{	
			_profiPictureBackground.position = new Vector3D(-365*_rX,165*_rY,10000)
			_profiPictureBackground.extraScale = _scaleVisuel*0.9
				
			_hireBg.position = new Vector3D(510*_rX,160*_rY,380)
			hireMe.position = new Vector3D(510*_rX,257*_rY,_hireBg.z-50)
			hireMe.extraScale = _scaleVisuel > 1.11 ? _scaleVisuel*0.9 : _scaleVisuel
			_hireBg2.x = 360*_rX

			hireMe2.position = new Vector3D(550*_rX-_layoutRatioX*60-_layoutRatioY*60,250*_rY,-400)
			if(_ratioPan){
				hireMe2.extraScale = _scaleVisuel > 1.11 ? _scaleVisuel*0.9 : _scaleVisuel
			}else{
				hireMe2.extraScale = _rX 
			}
			
				
			super.replaceContent();
		}		
	}
}