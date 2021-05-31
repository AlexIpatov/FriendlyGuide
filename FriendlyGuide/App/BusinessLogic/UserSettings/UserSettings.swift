//
//  UserSettings.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 30.05.2021.
//

import Foundation

class UserSettings {

    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()

    private enum SettingsKey: String {
        case cityName
    }
    // MARK: - City methods
    func saveCurrentCity(city: CityName?) {
        do {
            let data = try encoder.encode(city)
            UserDefaults.standard.setValue(data,
                                           forKey: SettingsKey.cityName.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadCurrentCity() -> CityName? {
        guard let data = UserDefaults.standard.data(forKey: SettingsKey.cityName.rawValue) else {
            return nil
        }
        do {
            return try decoder.decode(CityName.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    //TODO add other user settings
}
