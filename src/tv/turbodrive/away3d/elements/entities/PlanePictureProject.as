package tv.turbodrive.away3d.elements.entities
{
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	
	public class PlanePictureProject extends PlaneMesh
	{
		public function PlanePictureProject(name:String, id:String)
		{
			// récupération du material
			var material:ATMaterial = MaterialLibrary.getJpegProjectMaterial(name,id);
			super(material, id);
		}		
		
	}
}