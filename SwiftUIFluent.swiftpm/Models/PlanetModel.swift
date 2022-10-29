import FluentSQLiteDriver

final class Planet: Model {
	static let schema = "planets"
	
	@ID(key: .id)
	var id: UUID?
	@Field(key: "name")
	var name: String
	
	init() {}
	
	init(id: UUID? = nil, name: String) {
		self.id = id
		self.name = name
	}
}

struct CreatePlanetMigration: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema(Planet.schema)
			.id()
			.field("name", .string, .required)
			.create()
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema(Planet.schema)
			.delete()
	}
}
