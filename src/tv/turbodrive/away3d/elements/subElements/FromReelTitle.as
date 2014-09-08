package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	import away3d.bounds.BoundingSphere;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.MeshHelper;
	import away3d.tools.utils.Bounds;
	
	import tv.turbodrive.away3d.elements.entities.PlaneMesh;
	import tv.turbodrive.away3d.elements.meshes.GlowGenGrid;
	import tv.turbodrive.away3d.elements.meshes.PlaneGlowTitle;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	
	public class FromReelTitle extends ObjectContainer3D
	{
		private static const FROM_REEL_TX:String = "FromReel"
		private var _idMesh:String
		private var _recenteredMeshes:Boolean = false
		
		private var extrudeMat:ColorMaterial;
		private var capMatWhite:ColorMaterial;
		private var capMatDark:ColorMaterial;
		private var glowTitle100:PlaneGlowTitle;
		private var darkCapColorTransform:ColorTransform;

		private var redCircleLineMat:TextureMaterial;
		private var twAlphaRedLine:TweenMax;
		private var delayInit:Number;
		private var h:Number;
		private var w:Number;
		private var subMeshesCircle:Array
		private var glowTitle40:PlaneGlowTitle;
		private var glowTitle20:PlaneGlowTitle;
		private var glowTitle10:PlaneGlowTitle;
		private var glowTitle05:PlaneGlowTitle;

		private var groupLines:ObjectContainer3D;
		private var grid:GlowGenGrid;
		private static const CAPDARK_X:int = 450;
		private var meshesCircle:Object;
		
		public function FromReelTitle()
		{		
			if(!grid) {
				grid = new GlowGenGrid(4096,4096)
				grid.alpha = 0
				addChild(grid)
				grid.scale(40)
			}			
			
			prepareRedCircles();
			
			extrudeMat =  ColorMaterial(AssetLibrary.getAsset("extrudeMat"))
			capMatWhite =  ColorMaterial(AssetLibrary.getAsset("capMatWhite"))
			capMatDark =  ColorMaterial(AssetLibrary.getAsset("capMatDark"))
			darkCapColorTransform = new ColorTransform(0,0,0,1,239,236,225,0)
			capMatDark.colorTransform = darkCapColorTransform
				
			extrudeMat.alpha = capMatWhite.alpha = capMatDark.alpha = 0
			extrudeMat.alphaPremultiplied = capMatWhite.alphaPremultiplied = capMatDark.alphaPremultiplied = false			
			
			var pointLight:PointLight = PointLight(AssetLibrary.getAsset("PointLightProject"))
			addChild(pointLight)
			pointLight.y = h/2
			
			var mat100:ATMaterial = MaterialLibrary.getMaterial(MaterialName.TEXTURE_FROMREELTITLES) as ATMaterial
			var mat40:ATMaterial = new ATMaterial(mat100.texture);
			mat40.alpha = 0.6
			var mat20:ATMaterial = new ATMaterial(mat100.texture);
			mat20.alpha = 0.4
			var mat10:ATMaterial = new ATMaterial(mat100.texture);
			mat10.alpha = 0.2
			var mat05:ATMaterial = new ATMaterial(mat100.texture);
			mat05.alpha = 0.1
			mat40.coordinates = mat20.coordinates = mat10.coordinates = mat05.coordinates = mat100.coordinates			
			
			var targetX:Number = CAPDARK_X + 30
			glowTitle100 = new PlaneGlowTitle(mat100)
			glowTitle100.addEventListener(Event.COMPLETE, completeGlowStep1Handler)
			addChild(glowTitle100)			
			glowTitle40 = new PlaneGlowTitle(mat40)
			addChild(glowTitle40)			
			glowTitle20 = new PlaneGlowTitle(mat20)
			addChild(glowTitle20)			
			glowTitle10 = new PlaneGlowTitle(mat10)
			addChild(glowTitle10)			
			glowTitle05 = new PlaneGlowTitle(mat05)
			addChild(glowTitle05)			
			glowTitle100.targetX = glowTitle40.targetX = glowTitle20.targetX = glowTitle10.targetX = glowTitle05.targetX = targetX
				
			
			prepareIntroLines()
		}
		
		public function setPage(page:Page):void
		{
			
			if(page.project && page.project.isSecondaryProject){
				_idMesh = PagesName.MORE_PROJECTS
			}else{
				_idMesh = page.id
			}		
			if(!_recenteredMeshes){
				MeshHelper.recenter((AssetLibrary.getAsset(_idMesh+"Extrude"+FROM_REEL_TX)) as Mesh)
				MeshHelper.recenter((AssetLibrary.getAsset(_idMesh+"Cap"+FROM_REEL_TX)) as Mesh)
				_recenteredMeshes = true
			}
			
			var _textExtrude:Mesh = new Mesh(Mesh(AssetLibrary.getAsset(_idMesh+"Extrude"+FROM_REEL_TX)).geometry,extrudeMat)
			_textExtrude.position = new Vector3D(0,0,0)
			var _capWhite:Mesh = new Mesh(Mesh(AssetLibrary.getAsset(_idMesh+"Cap"+FROM_REEL_TX)).geometry, capMatWhite)
			var _capDark:Mesh = new Mesh(_capWhite.geometry, capMatDark);
			Bounds.getMeshBounds(_textExtrude)
			h = Bounds.height
			w = Bounds.depth
			_capWhite.x = 300
			_capDark.x = CAPDARK_X
			_textExtrude.y = _capDark.y = _capWhite.y = (h/2)			
			
				
			glowTitle100.setAtlasName(_idMesh)
			glowTitle40.setAtlasName(_idMesh)
			glowTitle20.setAtlasName(_idMesh)
			glowTitle10.setAtlasName(_idMesh)
			glowTitle05.setAtlasName(_idMesh)
			glowTitle100.y = glowTitle40.y = glowTitle20.y = glowTitle10.y = glowTitle05.y = h/2 + 50
				
			addChild(_textExtrude);
			addChild(_capWhite);
			addChild(_capDark);
			this.y = -h/2
				
			groupLines.x = -1000
			groupLines.z = (-w/2) - 300

			var ySpace:int = 800
			var yOffset:int = (h/2)-2500
			for(var i:int = 0; i< meshesCircle.length; i++){
				Mesh(meshesCircle[i]).y = yOffset+(ySpace*i)
			}
			
			grid.y = yOffset
			
		}
		
		private function prepareIntroLines():void
		{
			groupLines = new ObjectContainer3D()
			var matAbout:ATMaterial = ATMaterial(MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI));
			matAbout.blendMode = BlendMode.ADD
			matAbout.alphaPremultiplied = false
			var line1:PlaneMesh = new PlaneMesh(matAbout, "blueLine", {scaleTexY:-1});
			groupLines.addChild(line1)
			var line2:PlaneMesh = new PlaneMesh(matAbout, "redLine");			
			line2.y = line1.y - line2.height - 60
			groupLines.addChild(line2)	
			var line3:PlaneMesh = new PlaneMesh(matAbout, "yellowLine");
			line3.y = line2.y - line3.height - 60
			groupLines.addChild(line3)	
			line1.x = -1000-2004
			line2.x = line1.x - 380
			line3.x = line1.x - 200		
			line2.scaleX = line3.scaleX = line1.scaleX = 4
			line2.scaleY = line3.scaleY = line1.scaleY = 2
			
			groupLines.y = 1100
			
			groupLines.scale(3);				
			addChild(groupLines)			
		}
		
		public function autoPosition():void{
			z = (w/2) + 50
			y = -720
		}
		
		public function play(globalDelay:Number):void
		{
			TweenMax.to(grid, 0.5, {delay:globalDelay-0.1, alpha:1})			
			TweenMax.to(groupLines, 4.0, {delay:globalDelay-0.3, ease:Linear, x:22000})
			
			delayInit = globalDelay+0.5
			var delayFact:Number = 0.08
			glowTitle100.play(delayInit,false);
			glowTitle40.play(delayInit+delayFact);
			glowTitle20.play(delayInit+delayFact*2);
			glowTitle10.play(delayInit+delayFact*3);
			glowTitle05.play(delayInit+delayFact*4);
			
			for(var i:int = 0; i< subMeshesCircle.length; i++){
				var subMesh:SubMesh = subMeshesCircle[i] as SubMesh
				TweenMax.to(subMesh,3, {delay:delayInit+1.2+(Math.random()*0.4), ease:Quart.easeOut, offsetU:0/*, onComplete:alphaRedLine*/});
			}
			alphaRedLine(delayInit);
		}
		
		public function prepareRedCircles():void
		{
			if(!redCircleLineMat){
				redCircleLineMat = TextureMaterial(Mesh(AssetLibrary.getAsset("redCircle")).material)
			}
			redCircleLineMat.alpha = 1
			
			var i:int		
			if(!subMeshesCircle){
				subMeshesCircle = []
				meshesCircle = []
				for(i = 0; i< 6; i++){
					var redCircle:Mesh = new Mesh(Mesh(AssetLibrary.getAsset("redCircle")).geometry, redCircleLineMat);
					addChild(redCircle)				
					var redCircleMat:TextureMaterial = redCircle.material as TextureMaterial
					redCircleMat.animateUVs = true
					redCircleMat.repeat = false
					var subMeshUvOffset:SubMesh = redCircle.subMeshes[0]
					subMeshUvOffset.offsetU = -1					
					subMeshesCircle.push(subMeshUvOffset)				
					meshesCircle.push(redCircle)		
				}
					
			}else{
				for(i = 0; i< subMeshesCircle.length; i++){
					SubMesh(subMeshesCircle[i]).offsetU = -1
				}
			}			
		}
		
		public function alphaRedLine(d):void
		{
			if(twAlphaRedLine) return
			twAlphaRedLine = TweenMax.to(redCircleLineMat, 0.5, {delay:d+2.5, alpha:0})
			TweenMax.to(grid, 0.5, {delay:d+3, alpha:0})
		}
		
		
		protected function completeGlowStep1Handler(event:Event):void
		{
			glowTitle100.removeEventListener(Event.COMPLETE, completeGlowStep1Handler)
			TweenMax.to(extrudeMat,0.2, {delay:0.4, alpha:1, ease:Linear.easeNone})
			TweenMax.to(capMatWhite,0.2, {delay:0.2, alpha:1, ease:Linear.easeNone})
			TweenMax.to(capMatDark,0.2, {alpha:1, ease:Linear.easeNone})
			TweenMax.to(darkCapColorTransform,0.9, {delay:0.5, redMultiplier:1, greenMultiplier:1, blueMultiplier:1, redOffset:0, greenOffset:0, blueOffset:0, ease:Quad.easeInOut})
		}
		
		public function destroy():void
		{
			// TODO Destroy
			
		}	
	}
}