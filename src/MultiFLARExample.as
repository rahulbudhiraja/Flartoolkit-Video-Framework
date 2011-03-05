
package {
	import flash.events.Event;
	
	import flash.media.Video;

import flash.net.NetConnection;

import flash.net.NetStream;
import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
import org.papervision3d.materials.VideoStreamMaterial;
import org.papervision3d.materials.BitmapFileMaterial;
import org.papervision3d.materials.MovieMaterial;	
import org.papervision3d.materials.WireframeMaterial;
	
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	
	import org.papervision3d.objects.parsers.DAE;
	import com.squidder.flar.FLARMarkerObj;
	import com.squidder.flar.PVFLARBaseApplication;
	import com.squidder.flar.events.FLARDetectorEvent;		
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	

import flash.events.NetStatusEvent;

	public class MultiFLARExample extends PVFLARBaseApplication {
		
		private var _cubes : Array;
		private var video_status:Array=new Array(20);
		private var current_marker:int=100; //garbage value to begin with..
		
		
		private var _lightPoint : PointLight3D;
        static public var count:int;
		static public var _earth:DAE;
		public var temp:int=0;
		public var flag:int=0;
		private var plane:Plane;
		private var plane2:Plane;
 		private var bufferbit:int=0;
        private var netConnection:NetConnection;
        private var video:Video;
        private var netStream:NetStream;
		  private var netConnection2:NetConnection;
        private var video2:Video;
        private var netStream2:NetStream;
		  private var netConnection3:NetConnection;
        private var video3:Video;
        private var netStream3:NetStream;
		private var bm:BitmapFileMaterial=new BitmapFileMaterial("buffer.gif");
		private var mv:MovieMaterial;
		
		private var current_video:int=0;
		
        private var vm:VideoStreamMaterial;
        public var myTimer:Timer=new Timer(22500,100000);
		public var bufferTimer:Timer=new Timer(2000,10000);
		private var recent:int=109; //garbage value to begin with..
		
		public function MultiFLARExample() {
		    this.stage.align = StageAlign.TOP_LEFT;
			_cubes = new Array();
			
			_markers = new Array();
			for(var i:int=0;i<3;i++)
			{
				video_status[i]=0;
			}
			
			_markers.push( new FLARMarkerObj( "assets/flar/crash.pat" , 16 , 50 , 80 ) );
			_markers.push (new FLARMarkerObj("papervision.pat",16,50,80));
			_markers.push( new FLARMarkerObj( "assets/flar/kickdrum.pat" , 16 , 50 , 80 ) );
			/*_markers.push( new FLARMarkerObj( "assets/flar/ride.pat" , 16 , 50 , 80 ) );
			_markers.push( new FLARMarkerObj( "assets/flar/snare.pat" , 16 , 50 , 80 ) );
			*/
			super( );
			
		}
		
		override protected function _init( event : Event ) : void {

			super._init( event );	
			count=1;
			
			
			
			_lightPoint = new PointLight3D( );
			_lightPoint.y = 1000;
			_lightPoint.z = -1000;
			
			
			netConnection = new NetConnection();

            netConnection.connect(null);

            netStream = new NetStream(netConnection);
			netStream.bufferTime=2;
			netStream.client = new Object();
            video = new Video(320,240);
 			video.smoothing = true;
			video.attachNetStream(netStream);
			
			
			
			
			netConnection3 = new NetConnection();

            netConnection3.connect(null);

            netStream3 = new NetStream(netConnection3);
			netStream3.bufferTime=2;
			netStream3.client = new Object();
            video3 = new Video(320,240);
 			video3.smoothing = true;
			video3.attachNetStream(netStream3);
			
			
			netConnection2 = new NetConnection();

            netConnection2.connect(null);

            netStream2 = new NetStream(netConnection2);
			netStream2.bufferTime=2;
			netStream2.client = new Object();
            video2 = new Video(320,240);
 			video2.smoothing = true;
			video2.attachNetStream(netStream2);
			
			
			
			
		}
		
		override protected function _detectMarkers() : void {
			
			_resultsArray = _flarDetector.updateMarkerPosition( _flarRaster , 80 , .5 );
			
			for ( var i : int = 0 ; i < _resultsArray.length ; i ++ ) {
				
				var subResults : Array = _resultsArray[ i ];
				
				for ( var j : * in subResults ) {
					
					_flarDetector.getTransmationMatrix( subResults[ j ], _resultMat );
					if ( _cubes[ i ][ j ] != null ) transformMatrix( _cubes[ i ][ j ] , _resultMat );
				}
				
			}
				
			
		}		
		
		override protected function _handleMarkerAdded( event : FLARDetectorEvent ) : void {
			_addCube( event.codeId , event.codeIndex );
			
			
		}

		override protected function _handleMarkerRemove( event : FLARDetectorEvent ) : void {
	
			_removeCube( event.codeId , event.codeIndex );
	
		}
		
		private function _addCube( id:int , index:int ) : void {
			
			// If the marker has already been displayed then pause it..

current_marker=id;
if(video_status[id]==1)
{
	if(id==0&&recent!=0)
	netStream.togglePause();
	 else if (id==1&&recent!=1)
	 netStream2.togglePause();
	 else if (id==2&&recent!=2)
	 netStream3.togglePause();
}

else if (video_status[id]==0)
{
	if(id==0)
	{
				
			
			netStream.play("http://adobe.edgeboss.net/download/adobe/adobetv/gotoandlearn/native1.mp4");  
			
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
		  
			vm = new VideoStreamMaterial(video, netStream);		  
	}
			
	if(id==1)
	{
				
			netStream2.play("http://adobe.edgeboss.net/download/adobe/adobetv/gotoandlearn/aa2.mp4");  
			
			netStream2.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
		  
			vm = new VideoStreamMaterial(video2, netStream2);		  
			}
			
	if(id==2)
	{
				
			
			netStream3.play("http://adobe.edgeboss.net/download/adobe/adobetv/gotoandlearn/aa1.mp4");  
			
			netStream3.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
		  
			vm = new VideoStreamMaterial(video3, netStream3);		  
			}
			
}
video_status[id]=1;
//Pause the rest of the videos...
			if(id==0)
			{
				netStream2.togglePause();
				netStream3.togglePause();
			}
			
			if(id==1)
			{
				netStream.togglePause();
				netStream3.togglePause();
			}
			if(id==2)
			{
				netStream.togglePause();
				netStream2.togglePause();
			}			
			
			if ( _cubes[ id ] == null ) _cubes[ id ] = new Array();
			
			if ( _cubes[ id ][ index ] == null ) {
                
				
				var fmat : FlatShadeMaterial = _getFlatMaterial( id );
				var dispObj : DisplayObject3D = new DisplayObject3D();
				
				
				if(bufferbit==0)
				plane=new Plane(bm,200,200,1,1);
			
				plane.rotationX=180;
				plane.rotationZ=180;
				dispObj.addChild(plane);
				
				_baseNode.addChild( dispObj );
				
				_cubes[ id ][ index ] = dispObj;
				
			} 
			
				temp++;
			    _baseNode.addChild( _cubes[ id ][ index ] );
			
		}
		
		private function _removeCube( id:int , index:int ) : void {

			if ( _cubes[ id ] == null ) _cubes[ id ] = new Array();

			if ( _cubes[ id ][ index ] != null ) {
				recent=id;
			
				
					
				_baseNode.removeChild( _cubes[ id ][ index ] );
			}
			
			
		}		

		private function _getFlatMaterial( id:int ) : FlatShadeMaterial {
			
			if ( id == 0 ) {
				return new FlatShadeMaterial( _lightPoint , 0xff22aa , 0x75104e ); 					
			} else if ( id == 1 ){
				return new FlatShadeMaterial( _lightPoint , 0x00ff00 , 0x113311 ); 					
			} else if ( id == 2 ) {
				return new FlatShadeMaterial( _lightPoint , 0x0000ff , 0x111133 ); 					
			} else {
				return new FlatShadeMaterial( _lightPoint , 0x777777 , 0x111111 ); 					
			}			
		}
		
		
		private function runOnce(event:TimerEvent):void 
		{
		   temp=0;
		}
		private function onStatusEvent(stat:Object):void
{
	
if(current_marker==0)
     {


trace((netStream.bytesLoaded/netStream.bytesTotal)*100);


		if((netStream.bytesLoaded/netStream.bytesTotal) <=0.04)
			{
				trace((netStream.bytesLoaded/netStream.bytesTotal)*100);
				netStream.seek(0);
				trace("Buffering Please wait ...!");
				bufferbit=0;
			}
		else
		{
	     
		 bufferbit=1;
		 
		 trace("buffering over");
		 plane.material = new WireframeMaterial();
		 plane.material=vm;
		}
   }
   
  if(current_marker==1)
     {


trace((netStream2.bytesLoaded/netStream2.bytesTotal)*100);


		if((netStream2.bytesLoaded/netStream2.bytesTotal) <=0.04)
			{
				trace((netStream2.bytesLoaded/netStream2.bytesTotal)*100);
				netStream2.seek(0);
				trace("Buffering Please wait ...!");
				bufferbit=0;
			}
		else
		{
	     
		 bufferbit=1;
		 
		 trace("buffering over");
		 plane.material = new WireframeMaterial();
		 plane.material=vm;
		}
   }
   
   if(current_marker==2)
     {


trace((netStream3.bytesLoaded/netStream3.bytesTotal)*100);


		if((netStream3.bytesLoaded/netStream3.bytesTotal) <=0.04)
			{
				trace((netStream3.bytesLoaded/netStream3.bytesTotal)*100);
				netStream3.seek(0);
				trace("Buffering Please wait ...!");
				bufferbit=0;
			}
		else
		{
	     
		 bufferbit=1;
		 
		 trace("buffering over");
		 plane.material = new WireframeMaterial();
		 plane.material=vm;
		}
   }
   
   
   
   
   
			trace(bufferbit);
			
	
		   
  }


}









}
