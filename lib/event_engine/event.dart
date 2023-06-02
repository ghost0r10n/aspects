part of aspects;


class AspectEvent{
	
	String functionEventName;
	
	List<dynamic> args = [];

	AspectEvent(this.functionEventName,{this.args = const []});



}
