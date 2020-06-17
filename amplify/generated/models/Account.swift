// swiftlint:disable all
import Amplify
import Foundation

public struct Account: Model {
  public let id: String
  public var balance: Double
  
  public init(id: String = UUID().uuidString,
      balance: Double) {
      self.id = id
      self.balance = balance
  }
}