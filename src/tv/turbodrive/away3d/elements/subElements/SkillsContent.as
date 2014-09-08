package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.bounds.NullBounds;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	
	import tv.turbodrive.away3d.elements.entities.PerspScaleMesh;
	import tv.turbodrive.away3d.elements.entities.PlaneMesh;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;

	public class SkillsContent
	{
		static public const SKILLS_NAMES:Array = ["editing","frontEnd", "threeD", "compositing", "motion", "research"]
		private var _skillsContentPositions:Array = [new Vector3D(-100, 12),new Vector3D(-52,-8), new Vector3D(-100, 12), new Vector3D(-46,8,0), new Vector3D(-46,8), new Vector3D(-46,3)]
		private var _contents:Dictionary = new Dictionary();
		private var _titles:Dictionary = new Dictionary();
			
		private var _container:ObjectContainer3D;
		private var _currentContent:PlaneMesh;
		private var _currentContentName:String;
		private static var MATERIALS:Dictionary = new Dictionary();
		
		public function SkillsContent(container:ObjectContainer3D, material:ATMaterial)
		{
			_container = container
			var offsetContent:Vector3D = new Vector3D(0,-30,0)
				
			for(var i:int; i<_skillsContentPositions.length ;i++){
				var id:int = i
				var name:String = String(SKILLS_NAMES[i])
				var copyMaterial:ATMaterial
				if(!MATERIALS[name]){
					copyMaterial = MaterialHelper.cloneATMaterial(material);
					MATERIALS[name] = copyMaterial
				}else{
					copyMaterial = MATERIALS[name]
				}
				var content:PlaneMesh = new PlaneMesh(copyMaterial,name+"Content")
				content.position = Vector3D(_skillsContentPositions[i]).add(offsetContent);
				content.name = name
				var title:PlaneMesh = new PlaneMesh(copyMaterial,"skillfieldsInternal")
				title.position = new Vector3D(content.x-(content.width >> 1) + (title.width >> 1)+2,content.y+(content.height >> 1) + (title.height)-5, -50)
					
				_contents[name] = content
				_titles[content] = title
			}		
		}
		
		public function show(contentName:String = null):void
		{
			if(!contentName) contentName = SKILLS_NAMES[5]
			if(_currentContentName == contentName) return
			if((_currentContentName == SKILLS_NAMES[0] || _currentContentName == SKILLS_NAMES[2]) && (contentName == SKILLS_NAMES[0] || contentName == SKILLS_NAMES[2])) return
				
			if(_currentContent) remove(_currentContent)
			_currentContent = _contents[contentName] as PlaneMesh
			_currentContentName = contentName
			var _currentTitle:PlaneMesh = _titles[_currentContent] as PlaneMesh
			
			_container.addChild(_currentContent)
			_container.addChild(_currentTitle)				
			_currentContent.alpha = 0
			TweenMax.to(_currentContent,0.5, {alpha:1})
		}
		
		public function remove(planeContent:PlaneMesh = null):void
		{
			if(!planeContent){
				if(_currentContent){
					planeContent = _currentContent
					
				}				
			}
			_currentContentName = null
			_currentContent = null
			TweenMax.to(TextureMaterial(planeContent.material),0.3, {alpha:0, onComplete:removeFromScene, onCompleteParams:[planeContent]})
			
		}
		
		public function removeFromScene(planeContent:PlaneMesh):void
		{
			var planeTitle:PlaneMesh = _titles[planeContent]
			if(planeContent.parent) planeContent.parent.removeChild(planeContent)
			if(planeTitle.parent) planeTitle.parent.removeChild(planeTitle)
		}
		
		public function dispose():void
		{	
			_currentContent = null
			for(var i:int = 0; i<SKILLS_NAMES.length; i++){
				ATMaterial(MATERIALS[SKILLS_NAMES[i]]).alpha = 1
			}
				
			for(i = 0; i< _container.numChildren ; i++){
				_container.removeChild(Mesh(_container.getChildAt(i)))
			}
			_contents = null
			_titles = null
		}
	}
}