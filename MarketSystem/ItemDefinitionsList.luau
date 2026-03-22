
return {
	-- ?? School Supplies (10 second updates)
	Pencil = {
		DisplayName = "Pencil",
		MinPrice = 1,
		MaxPrice = 2,
		Size = "small";
		Strategy = "default",
		TimerGroup = "School",
		ModelName = "TradeStand",
		Position = Vector3.new(-31.375, 6.5, 75),
		Orientation = Vector3.new(0, -90, 30),
	},

	Highlighter = {
		DisplayName = "Highlighter",
		MinPrice = 2,
		MaxPrice = 4,
		Size = "small";
		Strategy = "default",
		TimerGroup = "School",
		ModelName = "TradeStand",
		Position = Vector3.new(-31.375, 6.5, 87),
		Orientation = Vector3.new(0, -90, 30),
	},
	Eraser = {
		DisplayName = "Eraser",
		MinPrice = 3,
		MaxPrice = 6,
		Size = "small";
		Strategy = "bipolar",
		TimerGroup = "School",
		ModelName = "TradeStand",
		Position = Vector3.new(-31.375, 6.5, 99),
		Orientation = Vector3.new(0, -90, 30),
	},
	Notepad = {
		DisplayName = "Notepad",
		MinPrice = 4,
		MaxPrice = 7,
		Size = "small";
		Strategy = "default",
		TimerGroup = "School",
		ModelName = "TradeStand",
		Position = Vector3.new(-31.375, 6.5, 111),
		Orientation = Vector3.new(60, 0, 90),
	},
	Scissors = {
		DisplayName = "Scissors",
		MinPrice = 5,
		MaxPrice = 9,
		Size = "small";
		Strategy = "default",
		TimerGroup = "School",
		ModelName = "TradeStand",
		Position = Vector3.new(-31.375, 6.5, 123),
		Orientation = Vector3.new(50, 20, 90),
	},

	--  Food (15 second updates) -----
	Apple = {
		DisplayName = "Apple",
		MinPrice = 10,
		MaxPrice = 20,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Food",
		ModelName = "TradeStand",
		Position = Vector3.new(-21.375, 6.5, 75),
		Orientation = Vector3.new(30, 0, 0),
	},
	Cereal = {
		DisplayName = "Cereal",
		MinPrice = 15,
		MaxPrice = 37,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Food",
		ModelName = "TradeStand",
		Position = Vector3.new(-21.375, 6.5, 87),
		Orientation = Vector3.new(30, 0, 0),
	},
	CandyBar = {
		DisplayName = "Candy Bar",
		MinPrice = 25,
		MaxPrice = 50,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Food",
		ModelName = "TradeStand",
		Position = Vector3.new(-21.375, 6.5, 99),
		Orientation = Vector3.new(0, -90, 30),
	},
	PotatoChips = {
		DisplayName = "Potato Chips",
		MinPrice = 35,
		MaxPrice = 70,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Food",
		ModelName = "TradeStand",
		Position = Vector3.new(-21.375, 6.5, 111),
		Orientation = Vector3.new(30, 0, 0),
	},
	Cookies = {
		DisplayName = "Cookies",
		MinPrice = 45,
		MaxPrice = 99,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Food",
		ModelName = "TradeStand",
		Position = Vector3.new(-21.375, 6.5, 123),
		Orientation = Vector3.new(30, 0, 0),
	},
	
	--  Toys (20 second updates) -----
	ToyCar = {
		DisplayName = "Toy Car",
		MinPrice = 100,
		MaxPrice = 200,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Toys",
		ModelName = "TradeStand",
		Position = Vector3.new(-11.375, 6.5, 75),
		Orientation = Vector3.new(0, -90, 30),
	},

	Doll = {
		DisplayName = "Doll",
		MinPrice = 200,
		MaxPrice = 470,
		Size = "small";
		Strategy = "a",
		TimerGroup = "Toys",
		ModelName = "TradeStand",
		Position = Vector3.new(-11.375, 6.5, 87),
		Orientation = Vector3.new(0, -90, 30),
	},

	ColoringBook = {
		DisplayName = "Coloring Book",
		MinPrice = 220,
		MaxPrice = 610,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Toys",
		ModelName = "TradeStand",
		Position = Vector3.new(-11.375, 6.5, 99),
		Orientation = Vector3.new(0, -90, 30),
	},

	PuzzleCube = {
		DisplayName = "Puzzle Cube",
		MinPrice = 250,
		MaxPrice = 600,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Toys",
		ModelName = "TradeStand",
		Position = Vector3.new(-11.375, 6.5, 111),
		Orientation = Vector3.new(0, -90, 30),
	},

	PlushAnimal = {
		DisplayName = "Plush Animal",
		MinPrice = 300,
		MaxPrice = 1000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "Toys",
		ModelName = "TradeStand",
		Position = Vector3.new(-11.375, 6.5, 123),
		Orientation = Vector3.new(0, -90, 30),
	},

	--  Fast Food (30 second updates) -----
	BubbleTea = {
		DisplayName = "Bubble Tea",
		MinPrice = 1000,
		MaxPrice = 3000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "FastFood",
		ModelName = "TradeStand",
		Position = Vector3.new(-1.375, 6.5, 75),
		Orientation = Vector3.new(30, 0, 0),
	},

	Pizza = {
		DisplayName = "Pizza Slice",
		MinPrice = 1500,
		MaxPrice = 4000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "FastFood",
		ModelName = "TradeStand",
		Position = Vector3.new(-1.375, 6.5, 87),
		Orientation = Vector3.new(30, 0, 0),
	},

	Fries = {
		DisplayName = "Fries",
		MinPrice = 2000,
		MaxPrice = 5000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "FastFood",
		ModelName = "TradeStand",
		Position = Vector3.new(-1.375, 6.5, 99),
		Orientation = Vector3.new(30, 0, 0),
	},

	Milkshake = {
		DisplayName = "Milkshake",
		MinPrice = 2500,
		MaxPrice = 6000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "FastFood",
		ModelName = "TradeStand",
		Position = Vector3.new(-1.375, 6.5, 111),
		Orientation = Vector3.new(30, 0, 0),
	},

	Tendies = {
		DisplayName = "Tendies",
		MinPrice = 3000,
		MaxPrice = 10000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "FastFood",
		ModelName = "TradeStand",
		Position = Vector3.new(-1.375, 6.5, 123),
		Orientation = Vector3.new(30, 0, 0),
	},
	
	--  Small Electronics (60 second updates) -----
	Phonoid = {
		DisplayName = "Phonoid",
		MinPrice = 10000,
		MaxPrice = 30000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "SmallElectronics",
		ModelName = "TradeStand",
		Orientation = Vector3.new(0, -90, 30),
	},

	rPhone = {
		DisplayName = "rPhone",
		MinPrice = 15000,
		MaxPrice = 40000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "SmallElectronics",
		ModelName = "TradeStand",
		Orientation = Vector3.new(0, -90, 30),
	},

	Tablet = {
		DisplayName = "Tablet",
		MinPrice = 20000,
		MaxPrice = 50000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "SmallElectronics",
		ModelName = "TradeStand",
		Orientation = Vector3.new(0, -90, 30),
	},

	SmartWatch = {
		DisplayName = "Smartwatch",
		MinPrice = 25000,
		MaxPrice = 60000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "SmallElectronics",
		ModelName = "TradeStand",
		Orientation = Vector3.new(0, -90, 30),
	},

	Headphones = {
		DisplayName = "Headphones",
		MinPrice = 3000000,
		MaxPrice = 10000000,
		Size = "small";
		Strategy = "default",
		TimerGroup = "SmallElectronics",
		ModelName = "TradeStand",
		Orientation = Vector3.new(0, -90, 30),
	},
}