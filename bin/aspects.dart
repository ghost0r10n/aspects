import 'package:aspects/aspects.dart';



void main()async{
	AspectEventEngine aspectEventEngine = AspectEventEngine();
	
	 aspectEventEngine.aspectsStream.listen((event) {
		print("method => $event WAS CALLED");
	});


	aspectEventEngine.emit("function");
}






