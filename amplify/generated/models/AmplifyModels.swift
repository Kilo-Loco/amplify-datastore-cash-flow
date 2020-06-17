// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "e4e673b0d25ff9a4c367ae91b22e3e35"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Account.self)
  }
}