part of aspects;




class AEngine{
	
	late MirrorSystem mirrorSystem;
	

	Map<Symbol, ClassMirror> aspects = {};

	AEngine(){
		mirrorSystem = currentMirrorSystem();
	}


	void addAspect(Symbol symbol,ClassMirror annotation){
		aspects[symbol] = annotation;
	}




	List<LibraryMirror> filterLibraries(Map<Uri,LibraryMirror> toFilterList){
		List<LibraryMirror> newList = [];
		toFilterList.forEach((key, value) { 
			if(!key.toString().contains("dart:")&&!key.toString().contains("package:")){
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
				/*	
					value.declarations.forEach((key, value) {
						if(!_aspects.keys.contains(key) && value is MethodMirror && value.source!= null){
						
						String simpleNameCleaned = key.toString().replaceAll('Symbol("', "").replaceAll('")', "");
							String code = "";
							code += "class ${simpleNameCleaned} extends Aspect{";
							code+= value.source!;
							code+="";
							addAspect(key,code);
						}
					});	*/
				}
			});	
		}
		

	}





	dynamic engineRun(){

		print(aspects);
		//Get all libraries 
		Map<Uri,LibraryMirror> mirrorLibraries = mirrorSystem.libraries;
		
		//Get all filtered LibraryMirror
		List<LibraryMirror> libraries = filterLibraries(mirrorLibraries);


		for (LibraryMirror mirror in libraries){
			mirror.declarations.forEach((key, value) {
							if(value.metadata.isNotEmpty){
				
				print(value.metadata.first);
				
				ClassMirror? classMirror = isInAnnotations(value.metadata.first.reflectee);
				print(classMirror);
				if(
					value is MethodMirror &&
					value.metadata.isNotEmpty &&
					classMirror!=null&&
					value.source != null){
					print("ao");	
					if(classMirror.staticMembers.containsKey(Symbol("before"))){
						classMirror.invoke(#before, []);			
					}
					run(value.source!, value.simpleName);
					if(classMirror.staticMembers.containsKey(Symbol("after"))) classMirror.invoke(#after,[], []);
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
		final port = ReceivePort();
		Isolate.spawnUri(uri, [], null);
	//	final String response = await port.first;
	//	print(response);
	}
}































