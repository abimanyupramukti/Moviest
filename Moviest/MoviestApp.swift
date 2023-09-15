//
//  MoviestApp.swift
//  Moviest
//
//  Created by Abimanyu Pramukti on 12/09/23.
//

import SwiftUI

@main
struct MoviestApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                start()
            }
        }
    }
    
    func start() -> some View {
        let interactor = GenreListInteractor()
        let presenter = GenreListPresenter(interactor: interactor)
        return GenreListView(presenter: presenter)
    }
}
