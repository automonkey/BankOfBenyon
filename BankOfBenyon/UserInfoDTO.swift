import Foundation

struct UserInfoDTO {

    var name:String
    var accountData:AccountData?

    struct AccountData {
        let sortCode:String
        let accountNumber:String

        init(sortCode:String, accountNumber:String) {
            self.sortCode = sortCode
            self.accountNumber = accountNumber
        }

        init?(fromDictionary dictionary:[String:AnyObject]?) {
            guard let sortCode = dictionary?["sortCode"] as? String, accountNumber = dictionary?["accountNumber"] as? String else {
                return nil
            }

            self.sortCode = sortCode
            self.accountNumber = accountNumber
        }

        func toDictionary() -> [String:AnyObject] {
            return [
                "sortCode": sortCode,
                "accountNumber": accountNumber
            ]
        }
    }

    init(name:String, accountData:AccountData) {
        self.name = name
        self.accountData = accountData
    }

    init?(fromDictionary dictionary:[String:AnyObject]?) {

        guard let name = dictionary?["bankOfBenyonData"]?["name"] as? String else {
            return nil
        }

        guard let accountData = AccountData(fromDictionary: dictionary?["bankOfBenyonData"]?["accountData"] as? [String:AnyObject]) else {
            return nil
        }

        self.name = name
        self.accountData = accountData
    }

    func toDictionary() -> [String:AnyObject]? {

        guard let accountData = accountData else {
            return nil
        }

        return [
            "bankOfBenyonData": [
                "name": name,
                "accountData": accountData.toDictionary()
            ]
        ]
    }
}
