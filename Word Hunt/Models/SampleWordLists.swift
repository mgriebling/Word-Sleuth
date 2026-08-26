//
//  SampleWordLists.swift
//  Word Hunt
//
//  Created by Michael Griebling on 26.06.2026.
//

import Foundation

struct SampleWordLists {
	
	static var all: [WordList] { [
		WordList(name: "Academic Subjects",
				 words: [
					"Algebra", "Anatomy", "Anthropology", "Archaeology", "Architecture", "Arithmetic", "Art", "Astronomy", "Biology", "Calculus", "Chemistry", "Economics", "Engineering", "English", "Geography", "Geology", "Geometry", "History", "Languages", "Law", "Literature", "Logic", "Management", "Marketing", "Mathematics", "Medicine", "Meteorology", "Music", "Philosophy", "Physics", "Poetry", "Politics", "Psychology", "Reading", "Science", "Sociology", "Statistics", "Theology", "Trigonometry", "Writing", "Zoology", "Ethics", "Genetics", "Linguistics", "Microbiology", "Neuroscience", "Oceanography", "Paleontology", "Robotics", "Thermodynamics"]),
		
		WordList(name: "Anatomy",
				 words: [
					"Appendix", "Artery", "Bladder", "Blood", "Bone", "Brain", "Cartilage", "Cell", "Cortex", "Diaphragm", "Ear", "Esophagus", "Eye", "Femur", "Gallbladder", "Gland", "Gum", "Hair", "Heart", "Intestine", "Joint", "Kidney", "Larynx", "Ligament", "Liver", "Lungs", "Marrow", "Muscle", "Nail", "Nerve", "Neuron", "Nose", "Pancreas", "Pharynx", "Plasma", "Platelet", "Rib", "Skin", "Skull", "Spine", "Spleen", "Stomach", "Tendon", "Throat", "Thyroid", "Tissue", "Tongue", "Tooth", "Trachea", "Vein"]),
		
		WordList(name: "Animals",
				 words: ["Albatross", "Alligator", "Antelope", "Baboon", "Badger", "Barracuda", "Bear", "Beaver",
						 "Buffalo", "Camel", "Cardinal", "Cheetah", "Chimpanzee",
						 "Cougar", "Coyote", "Crocodile", "Crow", "Deer", "Dolphin",
						 "Donkey", "Eagle", "Elephant", "Falcon", "Ferret", "Flamingo", "Fox", "Frog",
						 "Giraffe", "Gorilla", "Hawk", "Hedgehog", "Hippopotamus",
						 "Hyena", "Iguana", "Jaguar", "Kangaroo", "Koala", "Leopard",
						 "Lion", "Lizard", "Llama", "Manatee", "Meerkat", "Moose", "Ocelot", "Octopus", "Ostrich",
						 "Otter", "Owl", "Panda", "Panther", "Parrot", "Pelican", "Penguin",
						 "Platypus", "Porcupine", "Rabbit", "Raccoon", "Raven", "Rhinoceros",
						 "Shark", "Sloth", "Snake", "Squirrel", "Tiger", "Turtle",
						 "Walrus", "Whale", "Wolf", "Zebra"]),
		
		WordList(name: "Architecture",
				 words: [
					"Alcove", "Arch", "Atrium", "Attic", "Balcony", "Basement", "Beam", "Blueprint", "Buttress", "Canopy", "Ceiling", "Colonnade", "Column", "Cornice", "Corridor", "Courtyard", "Dome", "Door", "Eaves", "Facade", "Floor", "Foundation", "Foyer", "Gable", "Gargoyle", "Hallway", "Joist", "Lintel", "Lobby", "Monolith", "Mortar", "Parapet", "Patio", "Pillar", "Plinth", "Porch", "Portico", "Roof", "Rotunda", "Scaffolding", "Spire", "Staircase", "Terrace", "Tower", "Truss", "Vault", "Veranda", "Vestibule", "Wall", "Window"]),
		
		WordList(name: "Astronomy",
				 words: [
					"Aphelion", "Asteroid", "Aurora", "Azimuth", "Barycenter", "Chromosphere", "Cluster", "Comet", "Constellation", "Corona", "Cosmos", "Declination", "Eclipse", "Equinox", "Exoplanet", "Firmament", "Galaxy", "Gravity", "Lightyear", "Magnetosphere", "Magnitude", "Meteor", "Meteorite", "Moon", "Nadir", "Nebula", "Occultation", "Orbit", "Parallax", "Parsec", "Perihelion", "Photosphere", "Planet", "Pulsar", "Quasar", "Radiation", "Satellite", "Singularity", "Solstice", "Star", "Sun", "Supercluster", "Supernova", "Syzygy", "Telemetry", "Telescope", "Universe", "Void", "Zenith"]),
		
		WordList(name: "Birds",
				 words: ["Albatross", "Bluebird", "Bluejay", "Buzzard", "Canary", "Cardinal",
						 "Cassowary", "Chickadee", "Condor", "Cormorant", "Crane", "Crow", "Dove", "Duck", "Eagle",
						 "Egret", "Emu", "Falcon", "Finch", "Flamingo", "Goose",
						 "Gull", "Harrier", "Hawk", "Heron", "Hummingbird", "Ibis",
						 "Jay", "Kestrel", "Kingfisher", "Kite", "Lark", "Loon", "Macaw", "Magpie",
						 "Mallard", "Merlin", "Mockingbird", "Nightingale", "Nuthatch", "Osprey",
						 "Ostrich", "Owl", "Parrot", "Peacock", "Pelican", "Penguin",
						 "Pheasant", "Pigeon", "Puffin", "Quail", "Raven", "Roadrunner",
						 "Robin", "Rooster", "Sandpiper", "Seagull", "Sparrow",
						 "Starling", "Stork", "Swallow", "Swan", "Thrush", "Toucan",
						 "Turkey", "Vulture", "Warbler", "Woodpecker", "Wren"]),
		
		WordList(name: "Body Parts",
				 words: [
					"Ankle", "Arm", "Back", "Belly", "Bone", "Brain", "Cheek", "Chest", "Chin", "Ear", "Elbow", "Eye", "Face", "Finger", "Foot", "Hair", "Hand", "Head", "Heart", "Hip", "Jaw", "Knee", "Leg", "Lip", "Lung", "Mouth", "Muscle", "Nail", "Neck", "Nose", "Palm", "Rib", "Shoulder", "Skin", "Skull", "Spine", "Stomach", "Teeth", "Thigh", "Throat", "Thumb", "Toe", "Tongue", "Tooth", "Torso", "Vein", "Waist", "Wrist", "Heel", "Brow"]),
		
		WordList(name: "Car Parts",
				 words: [
					"Alternator", "Axle", "Battery", "Bearing", "Bumper", "Caliper", "Camshaft", "Carburetor", "Clutch", "Compressor", "Crankshaft", "Cylinder", "Dashboard", "Differential", "Engine", "Exhaust", "Filter", "Flywheel", "Fender", "Gasket", "Grille", "Headlight", "Hood", "Ignition", "Injector", "Manifold", "Muffler", "Odometer", "Piston", "Radiator", "Rotor", "Sensor", "Sparkplug", "Speedometer", "Spoiler", "Starter", "Suspension", "Taillight", "Thermostat", "Transmission", "Trunk", "Turbocharger", "Valve", "Wheel", "Windshield", "Wiper", "Chassis", "Hubcap", "Carburetor", "Dipstick"]),
		
		WordList(name: "Cat Breeds",
				 words: ["Abyssinian", "Aegean", "American", "Anatolian", "Asian",
						 "Australian", "Balinese", "Bambino", "Bengal", "Birman",
						 "Bobtail", "Bombay", "Burmilla", "Ceylon", "Chausie",
						 "Cheetoh", "Colorpoint", "Cornish", "Cymric", "Devon",
						 "Donskoy", "Dragon", "Egyptian", "European", "Exotic",
						 "Fold", "German", "Havana", "Highlander", "Himalayan",
						 "Japanese", "Javanese", "Korat", "LaPerm", "Lykoi",
						 "Maine", "Manx", "Minuet", "Munchkin", "Nebelung",
						 "Ocicat", "Oriental", "Owyhee", "Persian", "Peterbald",
						 "Pixie", "Ragamuffin", "Ragdoll", "Savannah", "Serengeti",
						 "Siamese", "Siberian", "Singapura", "Snowshoe", "Sokoke",
						 "Somali", "Sphynx", "Tonkinese", "Toyger", "York"]),
		
		WordList(name: "Chemistry",
				 words: [
					"Acid", "Alkane", "Alkene", "Alkyne", "Allotrope", "Atom", "Base", "Bond", "Buffer", "Catalyst", "Compound", "Distillation", "Electron", "Element", "Enthalpy", "Entropy", "Enzyme", "Equilibrium", "Ester", "Ether", "Gas", "Halogen", "Hydrocarbon", "Ion", "Isotope", "Kinetic", "Liquid", "Metal", "Mixture", "Molecule", "Monomer", "Neutron", "Nucleus", "Oxidation", "Plasma", "Polymer", "Precipitate", "Proton", "Radical", "Reaction", "Reduction", "Salt", "Solid", "Solute", "Solution", "Solvent", "Thermodynamics", "Titration", "Valence", "Xenon"]),
		
		WordList(name: "Cities",
				 words: [
					"Amsterdam", "Athens", "Bangkok", "Barcelona", "Beijing", "Berlin", "Bogota", "Boston", "Brussels", "Cairo", "Chicago", "Dallas", "Delhi", "Dublin", "Hanoi", "Houston", "Istanbul", "Jakarta", "Jerusalem", "Lima", "Lisbon", "London", "Madrid", "Manila", "Melbourne", "Mexicocity", "Miami", "Milan", "Moscow", "Mumbai", "Nairobi", "Newyork", "Paris", "Prague", "Rio", "Rome", "Santiago", "Seoul", "Shanghai", "Singapore", "Stockholm", "Sydney", "Taipei", "Tehran", "Tokyo", "Toronto", "Vienna", "Warsaw", "Washington", "Zurich"]),
		
		WordList(name: "Clothing",
				 words: [
					"Apron", "Beanie", "Belt", "Bikini", "Blazer", "Blouse", "Boots", "Bowtie", "Cap", "Cardigan", "Cloak", "Coat", "Corset", "Costume", "Dress", "Gloves", "Gown", "Hat", "Hoodie", "Jacket", "Jeans", "Jumpsuit", "Lingerie", "Mittens", "Overalls", "Pajamas", "Pants", "Poncho", "Raincoat", "Robe", "Sandals", "Scarf", "Shawl", "Shirt", "Shoes", "Shorts", "Skirt", "Slippers", "Sneakers", "Socks", "Stockings", "Suit", "Suspenders", "Sweater", "Swimsuit", "Tie", "Tunic", "Underwear", "Uniform", "Vest"]),
		
		WordList(name: "Colors",
				 words: ["Alabaster", "Amber", "Amethyst", "Apricot", "Aquamarine",
						 "Azure", "Beige", "Black", "Bronze", "Brown", "Burgundy", "Canary", "Celadon",
						 "Cerulean", "Charcoal", "Chartreuse", "Chestnut", "Cobalt", "Copper",
						 "Coral", "Cream", "Crimson", "Cyan", "Ebony", "Emerald",
						 "Espresso", "Fern", "Forest", "Fuchsia", "Gold", "Gray", "Green", "Indigo",
						 "Ivory", "Jade", "Khaki", "Lavender", "Lemon", "Lilac", "Lime",
						 "Magenta", "Maroon", "Mauve", "Mint", "Mustard", "Navy",
						 "Ochre", "Olive", "Onyx", "Orange", "Orchid", "Peach", "Periwinkle",
						 "Pink", "Plum", "Purple", "Red", "Rose", "Ruby", "Rust", "Saffron", "Sage", "Salmon",
						 "Sapphire", "Scarlet", "Silver", "Tangerine", "Tan", "Teal",
						 "Terracotta", "Turquoise", "Vermilion", "Violet", "White", "Yellow"]),
		
		WordList(name: "Computer Science",
				 words: [
					"Algorithm", "Array", "Binary", "Bit", "Boolean", "Byte", "Cache", "Class", "Cloud", "Code", "Compiler", "Database", "Debugging", "Encryption", "File", "Firewall", "Folder", "Function", "Gateway", "Hardware", "Index", "Interface", "Internet", "Kernel", "Link", "Loop", "Memory", "Modem", "Network", "Node", "Object", "Package", "Password", "Processor", "Protocol", "Queue", "Router", "Script", "Server", "Software", "Stack", "String", "Syntax", "Terminal", "Thread", "Token", "Variable", "Vector", "Virus", "Web"]),
		
		WordList(name: "Container Types",
				 words: [
					"Bag", "Barrel", "Basin", "Basket", "Bin", "Bottle", "Bowl", "Box", "Briefcase", "Bucket", "Cabinet", "Can", "Carton", "Case", "Cask", "Chest", "Cistern", "Crate", "Cup", "Dish", "Drawer", "Drum", "Glass", "Holster", "Jar", "Jug", "Kettle", "Mug", "Pail", "Pan", "Plate", "Pot", "Pouch", "Purse", "Quiver", "Reservoir", "Sack", "Scabbard", "Sheath", "Shelf", "Silo", "Sink", "Suitcase", "Tank", "Tray", "Trunk", "Tub", "Vessel", "Wallet"]),
		
		WordList(name: "Cooking Terms",
				 words: [
					"Bake", "Baste", "Beat", "Blend", "Boil", "Braise", "Broil", "Carve", "Char", "Chill", "Chop", "Core", "Dice", "Drain", "Fold", "Freeze", "Fry", "Garnish", "Glaze", "Grate", "Grill", "Knead", "Marinate", "Measure", "Melt", "Mince", "Mix", "Pare", "Peel", "Plate", "Poach", "Pour", "Roast", "Saute", "Sear", "Season", "Serve", "Shred", "Sift", "Simmer", "Slice", "Steam", "Stew", "Stir", "Strain", "Thaw", "Toast", "Weigh", "Whip", "Whisk"]),
		
		WordList(name: "Countries",
				 words: [
					"Algeria", "Argentina", "Australia", "Austria", "Bangladesh", "Belgium", "Brazil", "Canada", "Chile", "China", "Colombia", "Denmark", "Egypt", "Ethiopia", "Finland", "France", "Germany", "Greece", "India", "Indonesia", "Iran", "Ireland", "Italy", "Japan", "Kenya", "Malaysia", "Mexico", "Morocco", "Netherlands", "Nigeria", "Norway", "Pakistan", "Peru", "Philippines", "Poland", "Portugal", "Russia", "Saudiarabia", "Singapore", "Southafrica", "Spain", "Sweden", "Switzerland", "Thailand", "Turkey", "Ukraine", "Unitedstates", "Unitedkingdom", "Vietnam", "Zambia"]),
		
		WordList(name: "Crimes",
				 words: [
					"Abduction", "Arson", "Assault", "Battery", "Bigamy", "Blackmail", "Bribery", "Burglary", "Conspiracy", "Counterfeiting", "Defamation", "Embezzlement", "Espionage", "Extortion", "Forgery", "Fraud", "Harassment", "Hijacking", "Incest", "Jaywalking", "Kidnapping", "Larceny", "Libel", "Looting", "Manslaughter", "Moneylaundering", "Mugging", "Murder", "Perjury", "Pickpocketing", "Piracy", "Poaching", "Polygamy", "Racketeering", "Riot", "Robbery", "Sabotage", "Sedition", "Shoplifting", "Slander", "Smuggling", "Speeding", "Stalking", "Theft", "Treason", "Trespass", "Truancy", "Vagrancy", "Vandalism"]),
		
		WordList(name: "Currencies",
				 words: [
					"Afghani", "Ariary", "Baht", "Balboa", "Birr", "Bolivar", "Boliviano", "Cedi", "Colon", "Cordoba", "Dinar", "Dirham", "Dobra", "Dollar", "Dong", "Dram", "Escudo", "Euro", "Florin", "Forint", "Gourde", "Guarani", "Guilder", "Hryvnia", "Kina", "Kip", "Koruna", "Krona", "Krone", "Kwacha", "Kwanza", "Kyat", "Lari", "Lek", "Lempira", "Leone", "Leu", "Lev", "Lira", "Loti", "Manat", "Metical", "Naira", "Nakfa", "Nakit", "Ngultrum", "Ouguiya", "Pataca", "Peso", "Pound"]),
		
		WordList(name: "Dog Breeds",
				 words: ["Akita", "Alano", "Barbet", "Basenji", "Beagle", "Borzoi",
						 "Boxer", "Briard", "Bulldog", "Chihuahua", "Chin", "Chow",
						 "Cirneco", "Collie", "Corgi", "Dachshund", "Dalmatian",
						 "Dingo", "Doberman", "Dogo", "Elkhound", "Estrela", "Eurasier",
						 "Foxhound", "Greyhound", "Harrier", "Havanese", "Hokkaido",
						 "Husky", "Kai", "Keeshond", "Kelpie", "Komondor", "Kooikerhondje",
						 "Kuvasz", "Labrador", "Leonberger", "Lhasa", "Maltese", "Mastiff",
						 "Mudi", "Otterhound", "Papillon", "Pekingese", "Pharaoh",
						 "Pinscher", "Plott", "Pointer", "Pomeranian", "Poodle",
						 "Pug", "Puli", "Pumi", "Rafeiro", "Rottweiler", "Saluki",
						 "Samoyed", "Schipperke", "Schnauzer", "Whippet"]),
		
		WordList(name: "Earth Sciences",
				 words: [
					"Aquifer", "Atmosphere", "Biosphere", "Canyon", "Climate", "Core", "Crust", "Crystal", "Delta", "Desert", "Erosion", "Fault", "Fossil", "Geology", "Geyser", "Glacier", "Gorge", "Hydrology", "Igneous", "Lava", "Lithosphere", "Magma", "Mantle", "Metamorphic", "Mineral", "Mountain", "Oceanography", "Paleontology", "Plateau", "Quarry", "River", "Sediment", "Seismology", "Stratum", "Tectonics", "Topography", "Trench", "Tsunami", "Tundra", "Valley", "Volcano", "Weather", "Wind", "Xerophyte", "Yazoo", "Zephyr", "Zircon", "Zodiac", "Zone", "Zooplankton"]),
		
		WordList(name: "Emotions",
				 words: [
					"Admiration", "Affection", "Amusement", "Anger", "Anxiety", "Apathy", "Boredom", "Compassion", "Contempt", "Contentment", "Curiosity", "Depression", "Desire", "Despair", "Disgust", "Ecstasy", "Embarrassment", "Empathy", "Envy", "Euphoria", "Fear", "Frustration", "Grief", "Guilt", "Happiness", "Hatred", "Hope", "Horror", "Hostility", "Humiliation", "Interest", "Jealousy", "Joy", "Loneliness", "Love", "Melancholy", "Nostalgia", "Panic", "Pity", "Pride", "Regret", "Remorse", "Resentment", "Sadness", "Shame", "Sorrow", "Surprise", "Sympathy", "Terror", "Triumph"]),
		
		WordList(name: "Fabric & Textiles",
				 words: [
					"Acrylic", "Alpaca", "Angora", "Bouclé", "Brocade", "Calico", "Canvas", "Cashmere", "Chenille", "Chiffon", "Corduroy", "Cotton", "Damask", "Denim", "Felt", "Flannel", "Fleece", "Gabardine", "Gauze", "Gingham", "Hemp", "Jersey", "Jute", "Khaki", "Lace", "Leather", "Linen", "Mohair", "Muslin", "Nylon", "Organza", "Plaid", "Polyester", "Poplin", "Rayon", "Reps", "Satin", "Seersucker", "Silk", "Spandex", "Suede", "Taffeta", "Tartan", "Tweed", "Twill", "Velour", "Velvet", "Viscose", "Wool"]),
		
		WordList(name: "Flowers",
				 words: ["Allium", "Alyssum", "Anemone", "Aster", "Azalea",
						 "Begonia", "Bluebell", "Bluebonnet", "Buttercup",
						 "Calla", "Camellia", "Carnation", "Celosia", "Chrysanthemum",
						 "Clover", "Columbine", "Coneflower",
						 "Cornflower", "Cosmos", "Crocus", "Daffodil",
						 "Dahlia", "Dandelion", "Daisy", "Foxglove", "Freesia", "Fuchsia",
						 "Gardenia", "Geranium", "Gladiolus", "Heather",
						 "Hibiscus", "Hollyhock", "Honeysuckle", "Hyacinth", "Hydrangea",
						 "Impatiens", "Iris", "Juxta", "Jasmine", "Lantana", "Larkspur", "Lavender",
						 "Lilac", "Lily", "Lotus", "Lupine", "Magnolia", "Marigold",
						 "Mimosa", "Narcissus", "Nasturtium", "Oleander", "Orchid", "Pansy", "Peony", "Periwinkle", "Petunia",
						 "Phlox", "Poppy", "Primrose", "Ranunculus", "Rose",
						 "Rosemary", "Snapdragon", "Snowdrop", "Sunflower", "Sweetpea", "Thistle", "Tulip", "Verbena", "Violet", "Wisteria",
						 "Yarrow", "Zinnia"]),
		
		WordList(name: "Furniture",
				 words: [
					"Armchair", "Bed", "Bench", "Blind", "Bookcase", "Buffet", "Bureau", "Cabinet", "Carpet", "Chair", "Chandelier", "Chest", "Closet", "Coatrack", "Couch", "Cradle", "Credenza", "Crib", "Cupboard", "Curtain", "Desk", "Divider", "Drape", "Drawer", "Dresser", "Footboard", "Futon", "Hammock", "Hatrack", "Headboard", "Hutch", "Lamp", "Lantern", "Mattress", "Mirror", "Nightstand", "Ottoman", "Pantry", "Recliner", "Rug", "Sconce", "Screen", "Shelf", "Shutter", "Sideboard", "Sofa", "Stool", "Table", "Vanity", "Wardrobe"]),
		
		WordList(name: "Foods",
				 words: [
					"Apple", "Bacon", "Bread", "Butter", "Cabbage", "Cake", "Cheese", "Chicken", "Chocolate", "Cookie", "Egg", "Fish", "Garlic", "Grape", "Honey", "Icecream", "Jam", "Lemon", "Lettuce", "Meat", "Milk", "Mushroom", "Noodle", "Nut", "Onion", "Orange", "Pasta", "Pastry", "Peach", "Pear", "Pepper", "Pie", "Pizza", "Pork", "Potato", "Rice", "Salad", "Salt", "Sandwich", "Sausage", "Soup", "Spice", "Steak", "Sugar", "Toast", "Tomato", "Turkey", "Vegetable", "Yogurt", "Zucchini"]),
		
		WordList(name: "Geography",
				 words: [
					"Archipelago", "Atoll", "Bay", "Bog", "Canyon", "Cape", "Cave", "Cavern", "Channel", "Cliff", "Continent", "Country", "Creek", "Desert", "Dune", "Fjord", "Forest", "Geyser", "Glacier", "Gulf", "Hill", "Iceberg", "Island", "Isthmus", "Jungle", "Lagoon", "Lake", "Marsh", "Meadow", "Mountain", "Oasis", "Ocean", "Pass", "Peninsula", "Plain", "Plateau", "Prairie", "Reef", "Ridge", "River", "Savanna", "Sea", "Sinkhole", "Steppe", "Strait", "Stream", "Swamp", "Tundra", "Valley", "Waterfall"]),
		
		WordList(name: "Geometry",
				 words: [
					"Angle", "Apex", "Area", "Asymptote", "Chord", "Circle", "Circumference", "Cone", "Cube", "Cylinder", "Decagon", "Diagonal", "Diameter", "Ellipse", "Fractal", "Heptagon", "Hexagon", "Hyperbola", "Line", "Matrix", "Nonagon", "Octagon", "Oval", "Parabola", "Parallelogram", "Pentagon", "Perimeter", "Point", "Polygon", "Polyhedron", "Prism", "Pyramid", "Quadrant", "Radius", "Ray", "Rectangle", "Rhombus", "Secant", "Segment", "Sphere", "Square", "Symmetry", "Tangent", "Torus", "Trapezium", "Trapezoid", "Triangle", "Vector", "Vertex", "Volume"]),
		
		WordList(name: "Hobbies",
				 words: [
					"Acting", "Archery", "Astronomy", "Baking", "Birdwatching", "Bowling", "Camping", "Chess", "Cooking", "Crafting", "Cycling", "Dancing", "Drawing", "Embroidery", "Fishing", "Gaming", "Gardening", "Hiking", "Hunting", "Jogging", "Knitting", "Origami", "Painting", "Photography", "Pottery", "Quilting", "Reading", "Rowing", "Running", "Sailing", "Scuba", "Sewing", "Singing", "Skating", "Skiing", "Surfing", "Swimming", "Taxidermy", "Tennis", "Traveling", "Weaving", "Woodworking", "Writing", "Yoga", "Calligraphy", "Crochet", "Gardening", "Journaling", "Meditation", "Sculpting"]),
		
		WordList(name: "Insects & Bugs",
				 words: [
					"Ant", "Aphid", "Bee", "Beetle", "Butterfly", "Caterpillar", "Centipede", "Cicada", "Cockroach", "Cricket", "Dragonfly", "Earwig", "Flea", "Fly", "Gnat", "Grasshopper", "Hornet", "Ladybug", "Louse", "Mantis", "Mayfly", "Millipede", "Mite", "Mosquito", "Moth", "Scorpion", "Silverfish", "Slug", "Snail", "Spider", "Stinkbug", "Termite", "Tick", "Wasp", "Weevil", "Woodlouse", "Worm", "Xylocopa", "Yellowjacket", "Zoraptera", "Zygentoma", "Chinch", "Katydid", "Lacewing", "Leafhopper", "Maggot", "Mealworm", "Planthopper", "Silkworm", "Walkingstick"]),
		
		WordList(name: "Instruments",
				 words: [
					"Accordion", "Bagpipes", "Banjo", "Bassoon", "Bongo", "Bouzouki", "Castanets", "Cello", "Clarinet", "Claves", "Cymbal", "Didgeridoo", "Drums", "Dulcimer", "Flute", "Glockenspiel", "Gong", "Guitar", "Guitarrón", "Harmonica", "Harp", "Harpsichord", "Kalimba", "Kazoo", "Lute", "Mandolin", "Maracas", "Marimba", "Melodica", "Oboe", "Ocarina", "Organ", "Piano", "Piccolo", "Recorder", "Saxophone", "Sitar", "Snare", "Synthesizer", "Tambourine", "Theremin", "Timpani", "Triangle", "Trombone", "Trumpet", "Tuba", "Ukulele", "Viola", "Violin", "Xylophone"]),
		
		WordList(name: "Kitchenware",
				 words: [
					"Blender", "Bowl", "Cleaver", "Colander", "Crockery", "Cup", "Cutlery", "Dish", "Fork", "Grater", "Griddle", "Juicer", "Kettle", "Knife", "Ladle", "Masher", "Microplane", "Mixer", "Mug", "Pan", "Peeler", "Pitcher", "Plate", "Pot", "Ramekin", "Saucepan", "Scale", "Scissors", "Scoop", "Sieve", "Skillet", "Spatula", "Spoon", "Strainer", "Toaster", "Tongs", "Tray", "Turner", "Whisk", "Wok", "Zester", "Bakeware", "Canopener", "Cuttingboard", "Garlicpress", "Measuringcup", "Rollingpin", "Saladspinner", "Timer", "Tupperware"]),
		
		WordList(name: "Languages",
				 words: [
					"Arabic", "Bengali", "Bulgarian", "Burmese", "Cantonese", "Catalan", "Croatian", "Czech", "Danish", "Dutch", "English", "Estonian", "Farsi", "Finnish", "French", "German", "Greek", "Gujarati", "Hebrew", "Hindi", "Hungarian", "Icelandic", "Indonesian", "Italian", "Japanese", "Javanese", "Korean", "Latvian", "Lithuanian", "Malay", "Mandarin", "Marathi", "Nepali", "Norwegian", "Pashto", "Polish", "Portugal", "Punjabi", "Romanian", "Russian", "Slovak", "Slovenian", "Spanish", "Swahili", "Swedish", "Tagalog", "Tamil", "Telugu", "Thai", "Turkish"]),
		
		WordList(name: "Legal Terms",
				 words: [
					"Action", "Affidavit", "Appeal", "Argument", "Attorney", "Brief", "Case", "Code", "Constitution", "Contract", "Counsel", "Court", "Crime", "Decree", "Defendant", "Deposition", "Doctrine", "Evidence", "Exhibit", "Felony", "Hearing", "Infraction", "Injunction", "Judge", "Judgment", "Jury", "Law", "Lawsuit", "Lawyer", "Misdemeanor", "Motion", "Objection", "Ordinance", "Plaintiff", "Pleading", "Precedent", "Ruling", "Sentence", "Statute", "Subpoena", "Suit", "Summons", "Testimony", "Tort", "Treaty", "Trial", "Verdict", "Warrant", "Witness"]),
		
		WordList(name: "Letter Codes",
				 words:	["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot",
						 "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mike",
						 "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra",
						 "Tango", "Uniform", "Victor", "Whiskey", "Xray", "Yankee",
						 "Zulu"]),
		
		WordList(name: "Linear Measurements",
				 words: [
					"Angstrom", "Barleycorn", "Cable", "Caliber", "Centimeter", "Chain", "Cubit", "Decameter", "Decimeter", "Digit", "Ell", "Fathom", "Finger", "Foot", "Furlong", "Gauge", "Hand", "Hectometer", "Inch", "Kilometer", "League", "Lightyear", "Link", "Meter", "Micrometer", "Micron", "Mil", "Mile", "Millimeter", "Nanometer", "Knot", "Pace", "Palm", "Parsec", "Perch", "Pica", "Point", "Pole", "Rod", "Rope", "Shaftment", "Shaku", "Skein", "Span", "Spindle", "Stride", "Verst", "Yard"]),
		
		WordList(name: "Literary Devices",
				 words: [
					"Allegory", "Alliteration", "Allusion", "Analogy", "Antagonist", "Anthropomorphism", "Antithesis", "Assonance", "Character", "Cliche", "Climax", "Conflict", "Consonance", "Dialogue", "Epilogue", "Euphemism", "Fable", "Flashback", "Foreshadowing", "Hyperbole", "Idiom", "Imagery", "Irony", "Juxtaposition", "Metaphor", "Meter", "Monologue", "Motif", "Narrative", "Onomatopoeia", "Oxymoron", "Parable", "Paradox", "Parody", "Pastiche", "Personification", "Plot", "Prologue", "Protagonist", "Resolution", "Rhyme", "Rhythm", "Sarcasm", "Satire", "Setting", "Simile", "Soliloquy", "Symbolism", "Theme", "Understatement"]),
		
		WordList(name: "Mammals",
				 words: [
					"Aardvark", "Antelope", "Armadillo", "Baboon", "Badger", "Bat", "Bear", "Beaver", "Camel", "Cheetah", "Chimpanzee", "Chipmunk", "Coyote", "Deer", "Dingo", "Dolphin", "Donkey", "Elephant", "Elk", "Ferret", "Fox", "Gerbil", "Gibbon", "Giraffe", "Gopher", "Gorilla", "Hedgehog", "Hippopotamus", "Horse", "Hyena", "Ibex", "Jackal", "Jaguar", "Kangaroo", "Koala", "Lemur", "Leopard", "Lion", "Llama", "Lynx", "Manatee", "Meerkat", "Mink", "Mole", "Mongoose", "Monkey", "Moose", "Mouse", "Ocelot", "Opossum"]),
		
		WordList(name: "Marine Life",
				 words: [
					"Anemone", "Barnacle", "Clam", "Coral", "Crab", "Dolphin", "Eel", "Fish", "Flounder", "Haddock", "Halibut", "Jellyfish", "Kelp", "Krill", "Lobster", "Manatee", "Manta", "Marlin", "Mussel", "Narwhal", "Octopus", "Orca", "Oyster", "Pelican", "Penguin", "Plankton", "Pufferfish", "Ray", "Salmon", "Sardine", "Scallop", "Seahorse", "Seal", "Seaweed", "Shark", "Shrimp", "Sponge", "Squid", "Starfish", "Stingray", "Swordfish", "Trout", "Tuna", "Turtle", "Walrus", "Whale", "Whelk", "Xiphias", "Zooplankton", "Anchovy"]),
		
		WordList(name: "Materials",
				 words: [
					"Aluminum", "Amber", "Asphalt", "Bone", "Brass", "Brick", "Bronze", "Cardboard", "Cement", "Ceramic", "Charcoal", "Clay", "Coal", "Concrete", "Copper", "Cork", "Diamond", "Fabric", "Fiber", "Glass", "Gold", "Graphite", "Gypsum", "Horn", "Iron", "Ivory", "Lead", "Leather", "Marble", "Mercury", "Metal", "Mica", "Nickel", "Paper", "Plastic", "Platinum", "Porcelain", "Quartz", "Resin", "Rubber", "Shell", "Silicon", "Silver", "Steel", "Stone", "Tin", "Titanium", "Wax", "Wood", "Zinc"]),
		
		WordList(name: "Math Concepts",
				 words: [
					"Axiom", "Binomial", "Coefficient", "Combination", "Constant", "Corollary", "Decimal", "Derivative", "Equation", "Exponent", "Factorial", "Formula", "Fraction", "Function", "Graph", "Infinity", "Integer", "Integral", "Lemma", "Limit", "Logarithm", "Logic", "Matrix", "Mean", "Median", "Mode", "Monomial", "Number", "Operator", "Paradox", "Percent", "Permutation", "Polynomial", "Postulate", "Probability", "Proof", "Proportion", "Radical", "Ratio", "Sequence", "Series", "Set", "Statistics", "Subset", "Theorem", "Trinomial", "Variable", "Variance", "Vector"]),
		
		WordList(name: "Musical Genres",
				 words: [
					"Alternative", "Ambient", "Baroque", "Bluegrass", "Blues", "Classical", "Country", "Disco", "Dubstep", "Electronic", "Folk", "Funk", "Gospel", "Grunge", "Heavymetal", "Hiphop", "House", "Indie", "Industrial", "Jazz", "Latin", "Metal", "Minimal", "Motown", "Musical", "Newage", "Opera", "Orchestral", "Pop", "Psychedelic", "Punk", "Rap", "Reggae", "Rock", "Salsa", "Samba", "Ska", "Soul", "Techno", "Trance", "Trap", "Vaporwave", "Western", "World", "Xoomii", "Yodeling", "Zouk", "Zydeco", "Choral", "Gothic"]),
		
		WordList(name: "Mythical Creatures",
				 words: [
					"Banshee", "Basilisk", "Centaur", "Cerberus", "Chimera", "Chupacabra", "Cyclops", "Dragon", "Dryad", "Elf", "Fairy", "Gargoyle", "Ghoul", "Gnome", "Goblin", "Golem", "Griffin", "Harpy", "Hippogriff", "Hydra", "Incubus", "Kelpie", "Kraken", "Leprechaun", "Manticore", "Mermaid", "Minotaur", "Nymph", "Orc", "Pegasus", "Phoenix", "Pixie", "Sasquatch", "Satyr", "Selkie", "Siren", "Sphinx", "Succubus", "Sylph", "Thunderbird", "Troll", "Undine", "Unicorn", "Valkyrie", "Vampire", "Wendigo", "Werewolf", "Wraith", "Wyvern", "Yeti"]),
		
		WordList(name: "Natural Disasters",
				 words: [
					"Aftershock", "Avalanche", "Blight", "Blizzard", "Cloudburst", "Cyclone", "Deluge", "Derecho", "Drought", "Duststorm", "Earthquake", "Epidemic", "Famine", "Firestorm", "Flood", "Freshet", "Gale", "Glaze", "Haboob", "Hailstorm", "Heatwave", "Hurricane", "Icequake", "Infestation", "Lahar", "Landslide", "Lightning", "Limnic", "Maelstrom", "Meteor", "Monsoon", "Mudslide", "Pandemic", "Pyroclast", "Quicksand", "Sandstorm", "Sinkhole", "Solarflare", "Squall", "Superswell", "Thunderstorm", "Tornado", "Tremor", "Tsunami", "Typhoon", "Volcano", "Waterspout", "Whirlpool", "Whirlwind", "Wildfire"]),
		
		WordList(name: "Numbers",
				 words: ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen",
						 "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Hundred",
						 "Thousand", "Million", "Billion", "Trillion", "Quadrillion", "Quintillion", "Sextillion", "Octillion", "Nonillion",
						 "Decillion", "Vigintillion", "Centillion", "Pi", "Imaginary", "Euler", "GoldenRatio", "Planck", "Avogadro",
						 "Gravitational", "Half", "Third", "Quarter", "Logarithm", "Omega", "Infinity", "Fraction", "Real", "Integer", "Negative"]),
		
		WordList(name: "Occupations",
				 words: [
					"Actor", "Architect", "Artist", "Astronaut", "Baker", "Barber", "Biologist", "Carpenter", "Chef", "Chemist", "Dentist", "Doctor", "Electrician", "Engineer", "Farmer", "Firefighter", "Florist", "Geologist", "Historian", "Journalist", "Judge", "Lawyer", "Librarian", "Mechanic", "Musician", "Nurse", "Optometrist", "Painter", "Pharmacist", "Photographer", "Pilot", "Plumber", "Policeman", "Politician", "Professor", "Psychologist", "Reporter", "Scientist", "Secretary", "Soldier", "Surgeon", "Tailor", "Teacher", "Therapist", "Translator", "Trucker", "Veterinarian", "Waiter", "Welder", "Writer"]),
		
		WordList(name: "Reptiles & Amphibians",
				 words: [
					"Alligator", "Anole", "Axolotl", "Basilisk", "Bullfrog", "Caiman", "Chameleon", "Cobra", "Copperhead", "Crocodile", "Gecko", "Iguana", "Mamba", "Monitor", "Newt", "Python", "Rattlesnake", "Salamander", "Skink", "Snake", "Tadpole", "Terrapin", "Toad", "Tortoise", "Treefrog", "Turtle", "Viper", "Adder", "Boa", "Garter", "Krait", "Moccasin", "Sidewinder", "Taipan", "Tuatara", "Gator", "Gharial", "Leatherback", "Loggerhead", "Mudpuppy", "Hellbender", "Siren", "Caecilian", "Skink", "Chuckwalla", "Komodo", "Anaconda", "Sidewinder", "Cooter", "Slider"]),
		
		WordList(name: "Sports",
				 words: [
					"Archery", "Athletics", "Badminton", "Baseball", "Basketball", "Bobsleigh", "Bowling", "Boxing", "Cricket", "Curling", "Cycling", "Diving", "Equestrian", "Fencing", "Football", "Golf", "Gymnastics", "Handball", "Hockey", "Judo", "Karate", "Lacrosse", "Lugers", "Marathon", "Motocross", "Netball", "Paddleboarding", "Polo", "Racquetball", "Rowing", "Rugby", "Sailing", "Skateboarding", "Skeleton", "Skiing", "Snowboarding", "Soccer", "Softball", "Squash", "Surfing", "Swimming", "Taekwondo", "Tennis", "Triathlon", "Volleyball", "Waterpolo", "Weightlifting", "Windsurfing", "Wrestling", "Yachting"]),
		
		WordList(name: "Time & Calendar",
				 words: [
					"Afternoon", "Age", "Autumn", "Calendar", "Century", "Chronometer", "Clock", "Dawn", "Day", "Decade", "Duration", "Dusk", "Eon", "Epoch", "Equinox", "Era", "Evening", "Fortnight", "Hour", "Interval", "Midnight", "Millennium", "Minute", "Month", "Morning", "Night", "Noon", "Period", "Schedule", "Season", "Second", "Solstice", "Span", "Spring", "Stopwatch", "Summer", "Sunrise", "Sunset", "Timer", "Today", "Tomorrow", "Twilight", "Watch", "Week", "Weekday", "Weekend", "Winter", "Year", "Yesterday"]),
		
		WordList(name: "Tools",
				 words: [
					"Anvil", "Axe", "Bellows", "Caliper", "Chisel", "Clamp", "Compass", "Crowbar", "Cutter", "Drill", "File", "Forge", "Funnel", "Gauge", "Grinder", "Hammer", "Hatchet", "Hoe", "Knife", "Lathe", "Level", "Mallet", "Micrometer", "Pickaxe", "Pitchfork", "Plane", "Pliers", "Protractor", "Rake", "Ratchet", "Router", "Ruler", "Sander", "Saw", "Scissors", "Scraper", "Screwdriver", "Shears", "Shovel", "Socket", "Soldering", "Spade", "Square", "Tape", "Torch", "Trowel", "Vise", "Welder", "Wrench"]),
		
		WordList(name: "Trees & Plants",
				 words: [
					"Algae", "Bamboo", "Bark", "Birch", "Blossom", "Branch", "Brier", "Cactus", "Cedar", "Clover", "Conifer", "Cypress", "Elm", "Fern", "Flora", "Flower", "Forest", "Fungus", "Grass", "Ivory", "Ivy", "Leaf", "Lichen", "Lily", "Maple", "Moss", "Oak", "Palm", "Petal", "Pine", "Plant", "Pollen", "Root", "Rose", "Sapling", "Seed", "Shrub", "Spore", "Sprout", "Stem", "Thorn", "Tree", "Vine", "Weed", "Willow", "Wood", "Xylem", "Yew", "Yucca", "Zinnia"]),
		
		WordList(name: "Vehicles",
				 words: [
					"Airplane", "Ambulance", "Bicycle", "Blimp", "Boat", "Bulldozer", "Bus", "Canoe", "Car", "Carriage", "Chariot", "Convertible", "Crane", "Cruiser", "Excavator", "Ferry", "Firetruck", "Forklift", "Freighter", "Glider", "Gondola", "Helicopter", "Hovercraft", "Kayak", "Limousine", "Monorail", "Moped", "Motorcycle", "Raft", "Roadster", "Rocket", "Rover", "Scooter", "Segway", "Ship", "Sleigh", "Snowmobile", "Spacecraft", "Submarine", "Subway", "Taxi", "Tractor", "Train", "Tram", "Trolley", "Truck", "Van", "Wagon", "Yacht", "Zeppelin"]),
		
		WordList(name: "Weapons",
				 words: [
					"Arrow", "Axe", "Ballista", "Bayonet", "Blowgun", "Bomb", "Boomerang", "Bow", "Cannon", "Carbine", "Catapult", "Claymore", "Club", "Crossbow", "Cutlass", "Dagger", "Flail", "Flamethrower", "Foil", "Grenade", "Halberd", "Harpoon", "Javelin", "Katana", "Kunai", "Lance", "Mace", "Mine", "Missile", "Morningstar", "Mortar", "Musket", "Pistol", "Rapier", "Revolver", "Rifle", "Rocket", "Saber", "Scimitar", "Shield", "Shotgun", "Shuriken", "Sling", "Spear", "Staff", "Sword", "Tomahawk", "Torpedo", "Trebuchet", "Trident"]),
		
		WordList(name: "Weather",
				 words: [
					"Blizzard", "Breeze", "Celsius", "Climate", "Cloud", "Cyclone", "Dew", "Drizzle", "Drought", "Fahrenheit", "Flood", "Fog", "Forecast", "Freeze", "Frost", "Gale", "Hail", "Haze", "Humidity", "Hurricane", "Ice", "Lightning", "Meteorology", "Mist", "Monsoon", "Overcast", "Ozone", "Precipitation", "Radar", "Rain", "Rainbow", "Satellite", "Shower", "Sleet", "Smog", "Snow", "Squall", "Storm", "Sun", "Sunshine", "Temperature", "Thunder", "Thunderstorm", "Tornado", "Typhoon", "Vapor", "Weather", "Wind", "Windchill", "Zenith"]),
		
		WordList(name: "Random 3-5", wordRange: 3...5, totalWords: 100),
		WordList(name: "Random 3-6", wordRange: 3...6, totalWords: 100),
		WordList(name: "Random 3-7", wordRange: 3...7, totalWords: 100),
		WordList(name: "Random 4-5", wordRange: 4...5, totalWords: 100),
		WordList(name: "Random 4-6", wordRange: 4...6, totalWords: 100),
		WordList(name: "Random 4-7", wordRange: 4...7, totalWords: 100),
		WordList(name: "Random 4-8", wordRange: 4...8, totalWords: 100),
		WordList(name: "Random 5-6", wordRange: 5...5, totalWords: 100),
		WordList(name: "Random 5-7", wordRange: 5...6, totalWords: 100),
		WordList(name: "Random 5-8", wordRange: 5...7, totalWords: 100),
		WordList(name: "Random 5-9", wordRange: 5...8, totalWords: 100)
	]}
}
