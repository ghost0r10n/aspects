part of test;






@Route()
Future<String> function(String name) async{
	return "Hello there $name";
}


@Route() 
void function2() async{
	print("Start 2");
	await Future.delayed(Duration(milliseconds: 500));
	print("Finish 2");
}
