import 'package:aspects/aspects.dart';

void main(List<String> arguments) {

	AEngine aEngine = AEngine();


	aEngine.prepareAspects();
	print(aEngine.aspects);
	aEngine.engineRun();


}






@Log()
void hello(){print("Ciao bello");}








@Aspect()
class Log extends Aspect{

	const Log();



	static void before(){
		print("hello zi");
	}

}


