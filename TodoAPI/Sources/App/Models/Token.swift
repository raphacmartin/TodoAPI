import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "Token"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    init() { }

    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}

extension User {
    func generateToken() throws -> UserToken {
        try .init(value: [UInt8].random(count: 16).base64, userID: self.requireID())
    }
}
