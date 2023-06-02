part of test;






@Route()
void function(String name) async{
	print("START 1");	
	await Future.delayed(Duration(seconds: 1));
	print("Finish 1");
}


@Route() 
void function2() async{
	print("Start 2");
	await Future.delayed(Duration(milliseconds: 500));
	print("Finish 2");
}
