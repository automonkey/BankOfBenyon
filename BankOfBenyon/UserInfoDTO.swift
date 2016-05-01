import Foundation

struct UserInfoDTO {

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

    init(accountData:AccountData) {
        self.accountData = accountData
    }

    init?(fromDictionary dictionary:[String:AnyObject]?) {

        guard let accountData = AccountData(fromDictionary: dictionary?["bankOfWillData"]?["accountData"] as? [String:AnyObject]) else {
            return nil
        }

        self.accountData = accountData
    }

    func toDictionary() -> [String:AnyObject]? {

        guard let accountData = accountData else {
            return nil
        }

        return [
            "bankOfWillData": [
                "accountData": accountData.toDictionary()
            ]
        ]
    }
}
