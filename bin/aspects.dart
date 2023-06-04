import 'functions/functions.dart';
import 'package:aspects/aspects.dart';



void main(){
	AspectEventEngine aspectEventEngine = AspectEventEngine();
	print( "Start listening for events...");	
	 aspectEventEngine.aspectsStream.listen((event) async{
	 	print("EVENT $event received");
		dynamic result = await aspectEventEngine.listenRun(event);
		if(result!=null){
			print("Result => $result");
		}else{
			print("No Result Found");
		}

	});



	aspectEventEngine.emit(AspectEvent("function",args: ["Fabio"]));
	aspectEventEngine.emit(AspectEvent("function2"));		

}






