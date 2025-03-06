import Foundation

struct User: Identifiable {
    var id: String
    var name: String
    var email: String
    var birthdate: Date

    init(id: String, name: String, email: String, birthdate: Date) {
        self.id = id
        self.name = name
        self.email = email
        self.birthdate = birthdate
    }
}