//
//  main.swift
//  L7_GVEN_SHEL
//
//  Created by Admin on 09.03.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum RentalShopError: Error {
    case notAvailable
    case outOfStock
    case notEnoughMoney(moneyNeeded: Int)
    case notEnoughChange
}

enum Genres {
    case action
    case horror
    case comedy
    case thriler
    case animation
    case drama
}

enum Currency: Int {
    case fifty = 50
    case twenty = 20
    case ten = 10
    case fiver = 5
}

struct Movie {
    var count: Int
    var price: Int
    var genre: Genres
    var name: DVD
}

struct DVD {
    var diskOf: String
}

struct Customer {
    var moneyAvailable: Currency
    var favoriteGenres = [Genres]()
    var change: Int
}


class VideoRentalShop {
    
    init(cashRegister: Int, customerMoney: Int) {
        self.cashRegister = cashRegister
        self.moneyFromTheCustomer = customerMoney
    }
    
    var libraryOfMovies = [
        "Jay and Silent Bob Strike Back" : Movie(count: 3, price: 10, genre: Genres.comedy, name: DVD(diskOf: "Jay and Silent Bob Strike Back")),
        "Avengers: Endgame" : Movie(count: 6, price: 5, genre: Genres.action, name: DVD(diskOf: "Avengers: Endgame")),
        "The Silence of the Lambs" : Movie(count: 1, price: 8, genre: Genres.horror, name: DVD(diskOf: "The Silence of the Lambs"))
    ]
    
    var cashRegister: Int
    
    var moneyFromTheCustomer: Int
    
    func rent(movieName: String, customer: inout Customer) throws -> DVD {
        
        moneyFromTheCustomer += customer.moneyAvailable.rawValue
                
        guard let movie = libraryOfMovies[movieName] else {
            throw RentalShopError.notAvailable
        }
        
        guard movie.count > 0 else {
            throw RentalShopError.outOfStock
        }
        
        guard moneyFromTheCustomer >= movie.price else {
            throw RentalShopError.notEnoughMoney(moneyNeeded: movie.price - moneyFromTheCustomer)
        }
        
        guard moneyFromTheCustomer-movie.price <= cashRegister else {
            throw RentalShopError.notEnoughChange
        }
        
        var newMovie = movie
        newMovie.count -= 1
        let change = cashRegister - newMovie.price
        customer.change = change
        libraryOfMovies[movieName] = newMovie
        
        return newMovie.name
        
    }
}

var RSTVideo: VideoRentalShop = VideoRentalShop(cashRegister: 12, customerMoney: 0)

var Jay: Customer = Customer(moneyAvailable: Currency.twenty, favoriteGenres: [.comedy, .action, .thriler], change: 0)


do {
    let rent = try RSTVideo.rent(movieName: "The Silence of the Lambs", customer: &Jay)
} catch RentalShopError.notAvailable {
    print("We don't have this movie")
} catch RentalShopError.outOfStock {
    print("Unfortunatelly, we rented all of this movies")
} catch RentalShopError.notEnoughMoney(let moneyNeeded) {
    print("You don't have enough money. You need another \(moneyNeeded) dollars")
} catch RentalShopError.notEnoughChange {
    print("Sorry, we don't have enough change. Is it alright if we keep it?")
} catch let error {
    print(error.localizedDescription)
}
