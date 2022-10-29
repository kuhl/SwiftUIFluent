import SwiftUI
import FluentSQLiteDriver

final class AppModel: ObservableObject {
	let databases: Databases
	
	var logger: Logger = {
		var logger = Logger(label: "database.logger")
		logger.logLevel = .trace
		return logger
	}()
	
	var database: Database {
		return self.databases.database(
			logger: logger,
			on: self.databases.eventLoopGroup.next()
		)!
	}
	
	var planets: [Planet] {
		try! database.query(Planet.self).all().wait()
	}
	
	init() {
		let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
		let threadPool = NIOThreadPool(numberOfThreads: 1)
		threadPool.start()
		
		databases = Databases(threadPool: threadPool, on: eventLoopGroup)
		databases.use(.sqlite(.memory), as: .sqlite)
		databases.default(to: .sqlite)
		
		do {
			try CreatePlanetMigration().prepare(on: database).wait()
			try ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"].forEach{
				let item = Planet(name: $0)
				try item.save(on: database).wait()
			}
		}
		catch {
			print("error \(error)")
		}
	}
}
