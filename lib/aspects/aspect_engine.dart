part of aspects;




class AspectProcessors{
	
	late MirrorSystem mirrorSystem;
	

	Map<Symbol, ClassMirror> aspects = {};

	AspectProcessors(){
		mirrorSystem = currentMirrorSystem();
	}


	void addAspect(Symbol symbol,ClassMirror annotation){
		aspects[symbol] = annotation;
	}




	List<LibraryMirror> filterLibraries(Map<Uri,LibraryMirror> toFilterList){
		List<LibraryMirror> newList = [];
		toFilterList.forEach((key, value) { 
			if(!key.toString().contains("dart:")){
				newList.add(value);
			}
		});
		return newList;
	}




	ClassMirror? isInAnnotations(Object type){
		
		ClassMirror? result = null;
		aspects.forEach((key, value) { 

			if(key.toString().replaceAll('Symbol("', "").replaceAll('")', "") == type.runtimeType.toString()){
				result = value;
				return;
			}	
		});
		
		
		return result;
	}






	void prepareAspects(){
		Map<Uri,LibraryMirror> mirrorLibraries = mirrorSystem.libraries;
		
		//Get all filtered LibraryMirror
		List<LibraryMirror> libraries = filterLibraries(mirrorLibraries);

		for (LibraryMirror mirror in libraries){
			mirror.declarations.forEach((key, value) {
				if(
					value is ClassMirror &&
					value.metadata.isNotEmpty &&
					value.metadata.first.reflectee is Aspect ){
					
					addAspect(value.simpleName, value);
								}
			});	
		}
		

	}


	String symbolToString(Symbol symbol)=>symbol.toString().replaceAll('Symbol("', "").replaceAll('")', "");


	dynamic engineRun(AspectEvent aspectEvent){

		prepareAspects();
		
		//Get all libraries 
		Map<Uri,LibraryMirror> mirrorLibraries = mirrorSystem.libraries;


		
		//Get all filtered LibraryMirror
		List<LibraryMirror> libraries = filterLibraries(mirrorLibraries);
				

		for (LibraryMirror mirror in libraries){
			mirror.declarations.forEach((key, value) {

				if(value.metadata.isNotEmpty){
				ClassMirror? classMirror = isInAnnotations(value.metadata.first.reflectee);
				if(
						value is MethodMirror &&
					value.metadata.isNotEmpty &&
					classMirror!=null&&
					value.source != null){
					if(symbolToString(value.simpleName) ==  aspectEvent.functionEventName){
	
						if(classMirror.staticMembers.containsKey(Symbol("before")))classMirror.invoke(#before, [], {Symbol("args"): aspectEvent.args});
						mirror.invoke(Symbol(aspectEvent.functionEventName), aspectEvent.args);	
						if(classMirror.staticMembers.containsKey(Symbol("after"))) classMirror.invoke(#after,[],{Symbol("args"): aspectEvent.args});
					}
				}
			}
				
				
			});	
		}
	}
		
	String prepareCodeToExecute(String? baseSource, Symbol simpleName){

		String codeToExecute = "";
		if(baseSource!= null){
	
			String simpleNameToStringRaw = simpleName.toString();
			String simpleNameCleaned = simpleNameToStringRaw.replaceAll('Symbol("', "").replaceAll('")', "");
			
			codeToExecute+=baseSource.replaceAll(simpleNameCleaned, "main");
			
			aspects.forEach((key, value) {
				String clazz = value.simpleName.toString().replaceAll('Symbol("', "").replaceAll('")', "");
				codeToExecute+="class $clazz{const $clazz();}";
			});
			
		}else{
			throw Exception("The source of the function is empty");
		}
		return codeToExecute;
}
	
	dynamic run(String source, Symbol simpleName) async{
		String compiledSource = prepareCodeToExecute(source, simpleName);
		Uri uri = Uri.dataFromString(compiledSource);
		await Isolate.spawnUri(uri, [], null).then((value) => value.kill());
	}
}































