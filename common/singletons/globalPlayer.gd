extends Node

var simpleFieldToSaveList=["gems","xp","life","maxLife","nickname","equipment","itemsList","side"]
var stringFieldList=["nickname"]
var arrayFieldList=["itemsList"]
var nullFieldList=["equipment"]

var position=null
var itemsList=[]

var gems=0
var xp=0
var life=100
var maxLife=100
var nickname=null
var equipment=null

var side="DOWN"

func setSide(side_):
	side=side_

func getSide():
	return side
	
	

#---nickname
func setNickname(nickname_):
	nickname=nickname_

func getNickname():
	return nickname

#---equipment
func setEquipment(item_):
	equipment=item_
	
func getEquipment():
	return equipment
	
func hasEquipment():
	if equipment==null:
		return false
	else:
		return true

#--life
func setLife(life_):
	life=life_

func getLife():
	return life

func getMaxLife():
	return maxLife
	
func damage(damage_):
	life-=damage_
	
#--xp
func setXp(xp_):
	xp=xp_

func getXp():
	return xp

func addXp(xp_):
	xp+=xp_

#--position
func savePosition(newPosition_):
	position=newPosition_

func loadPosition():
	var savedPosition=position
	resetPosition()
	return savedPosition
	
func getPosition():
	return position

func resetPosition():
	position=null

func shouldLoadPosition():
	if(position!=null):
		return true
	else:
		return false

#--gems
func addGems(value_):
	putGems(value_)
	
func putGems(value_):
	gems+=value_
	
func spendGems(value_):
	if(value_<=gems):
		gems-=value_
		
func getGemsBalance():
	return gems
	
func canSpendGems(price_):
	if(price_<=gems):
		return true
	return false

#--items
func useItem(itemId_):
	var realItem=GlobalItems.getItem(itemId_)
	if realItem.type==item_class.TYPE.MAGICPOTION:
		var potionAction=realItem.actionList[0]
		if potionAction.action=="increaseLife":
			var newLife=getLife()+potionAction.value
			if newLife > getMaxLife():
				newLife=getMaxLife()
			setLife( newLife )
			removeItem(itemId_)


func hasItem(itemId_):
	return itemsList.has(itemId_)

func addItem(itemId_):
	addItemIfNotExist(itemId_)
	
func addItemIfNotExist(itemId_):
	if !hasItem(itemId_):
		_addItem(itemId_)
		
func addItemEvenIfExist(itemId_):
	itemsList.append(itemId_)
	
func _addItem(itemId_):
	itemsList.append(itemId_)

func getItemsList():
	return itemsList

func countItem(itemId_):
	return itemsList.count(itemId_)

func removeItem(itemId_):
	itemsList.erase(itemId_)


func getAttackList():
	var attackFilteredList=[]
	for itemId in getItemsList():
		var realItem=GlobalItems.getItem(itemId)
		if realItem.type==item_class.TYPE.WEAPON:
			print("type:"+str(realItem.type))
			for attack in realItem.actionList:
				if xp >= attack.xpMin:
					print("xp > attaxMin:  attack.xpMin:"+str(attack.xpMin))
					attackFilteredList.append(attack)
			
	return attackFilteredList
	
func loadFromSave(data_):
	for field in simpleFieldToSaveList:
		if data_.has(field):
			var valueMixed=data_[field]
			if arrayFieldList.has(field):
				var intArray=[]
				for valueMixedLoop in valueMixed:
					intArray.append(int(valueMixedLoop))
					
				set(field,intArray)
			
			elif stringFieldList.has(field):
				set(field,str(valueMixed))
			elif nullFieldList.has(field):
				set(field,valueMixed)
			else:
				set(field,int(valueMixed))
			
	position=Vector2(data_.position[0],data_.position[1])
	pass

func convertToSave():
	var saveData=GlobalGame.convertObjectToSave(self,simpleFieldToSaveList)
	
	saveData.position=[position.x,position.y]	

	return saveData
