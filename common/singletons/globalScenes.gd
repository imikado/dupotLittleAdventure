extends Node

var simpleFieldToSaveList=["scenesData"]

var scenesData={}

func getKey(scene_,param_):
	return scene_+'___'+param_

func saveParamForScene(scene_,param_,value_):
	scenesData[ getKey(scene_,param_) ]=value_

func getParamForSceneOr(scene_,param_,default_):
	if hasParamForScene(scene_,param_):
		return scenesData[ getKey(scene_,param_) ]
	return default_

func hasParamForScene(scene_,param_):
	if scenesData.has( getKey(scene_,param_) ):
		return true
	return false


func loadFromSave(data_):
	for field in simpleFieldToSaveList:
		if data_.has(field):
			set(field,data_[field])
	

func convertToSave():
	var saveData=GlobalGame.convertObjectToSave(self,simpleFieldToSaveList)
	
	return saveData
