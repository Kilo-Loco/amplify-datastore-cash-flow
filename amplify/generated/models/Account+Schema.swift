// swiftlint:disable all
import Amplify
import Foundation

extension Account {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case balance
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let account = Account.keys
    
    model.pluralName = "Accounts"
    
    model.fields(
      .id(),
      .field(account.balance, is: .required, ofType: .double)
    )
    }
}