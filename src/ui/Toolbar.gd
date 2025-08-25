class_name Toolbar
extends Component


var btnWait: Tool
var btnSearch: Tool
var btnInfo: Tool
var btnInventory: Tool
var btnQuick1: Tool
var btnQuick2: Tool

var pickedUp: PickedUpItem

var lastEnabled: bool = true;

static var instance: Toolbar

func _init() -> void:
	super();

	instance = self

	height = btnInventory.height();


#@Override
func createChildren() -> void:
	btnWait = Tool.new( 0, 7, 20, 25 )
	add( btnWait)

	btnWait.onClick.bind(
		func():
			Dungeon.hero.rest( false );
	)
	btnWait.onLongClick.bind(
		func():
			Dungeon.hero.rest( true );
			return true;
	)

	btnSearch = Tool.new( 20, 7, 20, 25 )
	add( btnSearch)

	btnSearch.onClick.bind(
		func():
			Dungeon.hero.search( true );
	)

	btnInfo = Tool.new( 40, 7, 21, 25 )
	add( btnInfo)

	btnInfo.onClick.bind(
		func():
			GameScene.selectCell( informer );

	)

	btnInventory = GoldTool.new( 60, 7, 23, 25 )

	add( btnInventory)

	btnInventory.onClick.bind(
		func():
			GameScene.show(WndBag.new( Dungeon.hero.belongings.backpack, null, WndBag.Mode.ALL, null ) );
	)

	btnInventory.onLongClick.bind(
		func():
			GameScene.show( WndCatalogus.new() );
			return true;
	)

	btnInventory.createChildren.bind(
		func():
			super.createChildren();
			gold = GoldIndicator.new();
			add( gold );
	)

	btnInventory.layout.bind(
		func():
			super.layout();
			gold.fill( this );
	)

	btnQuick1 = QuickslotTool.new( 83, 7, 22, 25, true )
	add(btnQuick1);
	btnQuick2 = QuickslotTool.new( 83, 7, 22, 25, false )
	add( btnQuick2 );
	btnQuick2.visible = (QuickSlot.secondaryValue != null);

	pickedUp = PickedUpItem.new()
	add( pickedUp );


#@Override
func layout() -> void:
	btnWait.setPos( x, y );
	btnSearch.setPos( btnWait.right(), y );
	btnInfo.setPos( btnSearch.right(), y );
	btnQuick1.setPos( width - btnQuick1.width(), y );
	if (btnQuick2.visible):
		btnQuick2.setPos(btnQuick1.left() - btnQuick2.width(), y );
		btnInventory.setPos( btnQuick2.left() - btnInventory.width(), y );
	else:
		btnInventory.setPos( btnQuick1.left() - btnInventory.width(), y );



#@Override
func update() -> void:
	super.update();

	if (lastEnabled != Dungeon.hero.ready):
		lastEnabled = Dungeon.hero.ready;

		for tool: Gizmo in members:
			if (tool is Tool):
				(tool as Tool).enable( lastEnabled );




	if (!Dungeon.hero.isAlive()):
		btnInventory.enable( true );



func pickup(item: Item) -> void:
	pickedUp.reset( item,
		btnInventory.centerX(),
		btnInventory.centerY() );


static func secondQuickslot() -> bool:
	return instance.btnQuick2.visible;


static func secondQuickslot_v(value: bool) -> void:
	instance.btnQuick2.visible = value
	instance.btnQuick2.active = value

	instance.layout();


static var informer: CellSelector.Listener = CellSelector.Listener.new()

func _init_informer(): #TODO call on start
	informer.onSelect.bind(
		func(cell: int):
			if (cell == null):
				return;

			if (cell < 0 || cell > Level.LENGTH || (!Dungeon.level.visited[cell] && !Dungeon.level.mapped[cell])):
				GameScene.show(WndMessage.new( "You don't know what is there." ) ) ;
				return;


			if (!Dungeon.visible[cell]):
				GameScene.show(WndInfoCell.new( cell ) );
				return;


			if (cell == Dungeon.hero.pos):
				GameScene.show(WndHero.new() );
				return;


			var mob: Mob = Actor.findChar( cell ) as Mob
			if (mob != null):
				GameScene.show(WndInfoMob.new( mob ) );
				return;


			var heap: Heap = Dungeon.level.heaps.get( cell );
			if (heap != null && heap.type != Heap.Type.HIDDEN):
				if (heap.type == Heap.Type.FOR_SALE && heap.size() == 1 && heap.peek().price() > 0):
					GameScene.show(WndTradeItem.new( heap, false ) );
				else:
					GameScene.show(WndInfoItem.new( heap ) );

				return;


			var plant: Plant = Dungeon.level.plants.get( cell );
			if (plant != null):
				GameScene.show(WndInfoPlant.new( plant ) );
				return;


			GameScene.show(WndInfoCell.new( cell ) );
	)

	informer.prompt.bind(
		func():
			return "Select a cell to examine";
	)









class GoldTool extends Tool:
	var gold: GoldIndicator
