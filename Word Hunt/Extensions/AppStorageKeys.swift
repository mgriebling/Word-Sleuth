//
//  AppStorage-keys.swift
//  WordBreaker
//
//  Created by Michael Griebling on 18.05.2026.
//

import SwiftUI

public struct AppStorageKey<Value> {
	let key: String
	let defaultValue: Value
	
	public init(_ key: StringLiteralType, defaultValue: Value) {
		self.key = key
		self.defaultValue = defaultValue
	}
}

public extension AppStorage {
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Bool {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
	
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Int {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
	
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == SettingsType {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
	
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Color {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
	
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Double {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
	
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == String {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
	
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == URL {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
	
//	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Date {
//		self.init(wrappedValue: key.defaultValue, key.key, store: store)
//	}
	
	init(_ key: AppStorageKey<Value>, store: UserDefaults? = nil) where Value == Data {
		self.init(wrappedValue: key.defaultValue, key.key, store: store)
	}
}
