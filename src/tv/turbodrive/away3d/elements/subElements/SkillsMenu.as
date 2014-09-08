package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.tools.helpers.MeshHelper;
	
	import tv.turbodrive.away3d.elements.entities.PerspScaleMesh;
	import tv.turbodrive.events.StringEvent;
	
	public class SkillsMenu extends ObjectContainer3D
	{
		static public const CLICK_BUTTON_SKILLS:String = "clickButtonSkills";		
			
		private var _offset:Vector3D
		private var _localCopySkillsMat:TextureMaterial;

		private var _buttonsML:Dictionary = new Dictionary();
		private var _meshes:Vector.<PerspScaleMesh>
		private var _buttons:Vector.<ButtonMeshLight>
		
		private var _alpha:Number = 0
		private var _enabled:Boolean = true
		
		public function SkillsMenu(id:int, offset:Vector3D, mat:TextureMaterial)
		{	
			_offset = offset
			//var nameMat:String = id > 1 ? "CommonMenuMat2" : "CommonMenuMat"
			_localCopySkillsMat = mat // 
			//AssetLibrary.getAsset(nameMat) as TextureMaterial_localCopySkillsMat.name = "newMenu"+id+"mat";
			_meshes = new Vector.<PerspScaleMesh>();
			_buttons = new Vector.<ButtonMeshLight>();
			
			for(var i:int = 0; i < SkillsContent.SKILLS_NAMES.length ; i++){
				var buttonName:String = SkillsContent.SKILLS_NAMES[i];
				if(id>1) buttonName += String(id)
				var sourceMesh:Mesh = Mesh(AssetLibrary.getAsset(buttonName))
				MeshHelper.recenter(sourceMesh)
				var perspMesh:PerspScaleMesh = PerspScaleMesh.createFromMesh(sourceMesh, true)
				perspMesh.addEventListener(PerspScaleMesh.UPDATE_PERSP_SCALE, updatePerspScaleHandler);
				perspMesh.material = _localCopySkillsMat
				var newPos:Vector3D = sourceMesh.position.clone().add(_offset)
				perspMesh.position = newPos
				perspMesh.name = buttonName
				perspMesh.rotationX = 180//50

				var button:ButtonMeshLight = new ButtonMeshLight(perspMesh, false)
				button.name = id == 2 ? buttonName.slice(0,-1) : buttonName
				button.addEventListener(MouseEvent3D.CLICK, clickSkillsHandler)
					
				_buttonsML[perspMesh] = button
				_meshes.push(perspMesh)
				_buttons.push(button)
					
				addChild(perspMesh)
				button.updateLightPosition()
			}
			scale(1.1);
			if(id == 1){
				_meshes[4].y -= 1 
				_meshes[0].y -= 1 
			}else{
				_meshes[3].y += 0.3
				_meshes[5].y += 0.2
			}
			//enabled = true
			//alpha = 1
		}
		
		/*public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			//if(value == _enabled) return
			_enabled = value;
			for(var i:int = 0; i<_buttons.length ;i++){
				ButtonMeshLight(_buttons[i]).enabled = value
			}
		}*/

		public function playRotateX(target:Number, delay:Number):void
		{
			for(var i:int = 0; i<_meshes.length ;i++){
				var mesh:PerspScaleMesh = _meshes[i] as PerspScaleMesh
				TweenMax.to(mesh, 0.8, {rotationX:target, delay:delay+i*0.05, ease:Quart.easeOut})
			}
		}
		
		protected function updatePerspScaleHandler(event:Event):void
		{
			var btn:ButtonMeshLight = _buttonsML[event.target]
			btn.updateLightPosition();
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value
			for(var i:int = 0; i<_buttons.length ;i++){
				ButtonMeshLight(_buttons[i]).alpha = _alpha
			}		
		}
		
		public function get alpha():Number
		{
			return _alpha
		}
		
		protected function clickSkillsHandler(event:MouseEvent3D):void
		{						
			dispatchEvent(new StringEvent(CLICK_BUTTON_SKILLS, event.target, ButtonMeshLight(event.target).name))
		}
	}
}