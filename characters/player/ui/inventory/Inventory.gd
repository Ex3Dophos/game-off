extends GridContainer;
const ItemClass = preload("Item.gd");
const ItemSlotClass = preload("res://characters/player/ui/inventory/ItemSlot.gd");

const slotTexture = preload("res://characters/player/ui/inventory/sprites/skil.png");
const itemImages = [
	preload("res://characters/player/ui/inventory/sprites/Ac_Ring05.png"),
	preload("res://characters/player/ui/inventory/sprites/A_Armor05.png"),
	preload("res://characters/player/ui/inventory/sprites/A_Armour02.png"),
	preload("res://characters/player/ui/inventory/sprites/A_Shoes03.png"),
	preload("res://characters/player/ui/inventory/sprites/C_Elm03.png"),
	preload("res://characters/player/ui/inventory/sprites/E_Wood02.png"),
	preload("res://characters/player/ui/inventory/sprites/P_Red02.png"),
	preload("res://characters/player/ui/inventory/sprites/W_Sword001.png")
];

const itemDictionary = {
	0: {
		"itemName": "Ring",
		"itemValue": 100,
		"itemIcon": itemImages[0]
	},
	1: {
		"itemName": "Sword",
		"itemValue": 350,
		"itemIcon": itemImages[7]
	},
	2: {
		"itemName": "Orange Armor",
		"itemValue": 1300,
		"itemIcon": itemImages[1]
	},
	3: {
		"itemName": "Shoes",
		"itemValue": 250,
		"itemIcon": itemImages[3]
	},
	4: {
		"itemName": "White Armor",
		"itemValue": 1500,
		"itemIcon": itemImages[2]
	},
	5: {
		"itemName": "White Helm",
		"itemValue": 1000,
		"itemIcon": itemImages[4]
	},
	6: {
		"itemName": "Wooden Shield",
		"itemValue": 500,
		"itemIcon": itemImages[5]
	},
	7: {
		"itemName": "Health Potion",
		"itemValue": 450,
		"itemIcon": itemImages[6]
	},
};

var slotList = Array();
var itemList = Array();

var holdingItem = null;

func _ready():
	for item in itemDictionary:
		var itemName = itemDictionary[item].itemName;
		var itemIcon = itemDictionary[item].itemIcon;
		var itemValue = itemDictionary[item].itemValue;
		itemList.append(ItemClass.new(itemName, itemIcon, null, itemValue));
	
	for i in range(20):
		var slot = ItemSlotClass.new(i);
		slotList.append(slot);
		add_child(slot);
	
	# Default items
	slotList[0].setItem(itemList[0]);
	slotList[1].setItem(itemList[1]);
	slotList[2].setItem(itemList[2]);
	slotList[3].setItem(itemList[3]);
	
	pass

func _input(event):
	if holdingItem != null && holdingItem.picked:
		holdingItem.rect_global_position = Vector2(event.position.x, event.position.y);

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		var clickedSlot;
		for slot in slotList:
			var slotMousePos = slot.get_local_mouse_position();
			var slotTexture = slot.texture;
			var isClicked = slotMousePos.x >= 0 && slotMousePos.x <= slotTexture.get_width() && slotMousePos.y >= 0 && slotMousePos.y <= slotTexture.get_height();
			if isClicked:
				clickedSlot = slot;
		
		if holdingItem != null:
			if clickedSlot.item != null:
				var tempItem = clickedSlot.item;
				var oldSlot = slotList[slotList.find(holdingItem.itemSlot)];
				clickedSlot.pickItem();
				clickedSlot.putItem(holdingItem);
				holdingItem = null;
				oldSlot.putItem(tempItem);
			else:
				clickedSlot.putItem(holdingItem);
				holdingItem = null;
		elif clickedSlot.item != null:
			holdingItem = clickedSlot.item;
			clickedSlot.pickItem();
			holdingItem.rect_global_position = Vector2(event.position.x, event.position.y);
	pass
