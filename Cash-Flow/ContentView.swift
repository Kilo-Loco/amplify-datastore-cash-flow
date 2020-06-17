//
//  ContentView.swift
//  Cash-Flow
//
//  Created by Kyle Lee on 6/17/20.
//  Copyright © 2020 Kilo Loco. All rights reserved.
//

import Amplify
import SwiftUI

struct ContentView: View {
    @State var account: Account?
    @State var amount: Double = 0.00
    
    var balance: String {
        let accountBalance = NSNumber(value: self.account?.balance ?? 0)
        let currencyBalance = self.currencyFormatter.string(from: accountBalance)
        return currencyBalance ?? "No Account"
    }
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var amountFormatterBinding: Binding<String> {
        Binding<String>(
            get: {
                self.currencyFormatter
                    .string(from: NSNumber(value: self.amount))
                    ?? ""
            },
            set: { newAmount in
                self.amount = self.currencyFormatter.number(from: newAmount)?
                    .doubleValue
                    ?? 0
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 100) {
            Spacer()
                .frame(height: 20)
            
            VStack {
                Text("Current Balance")
                    .fontWeight(.medium)
                
                Text(balance)
                    .font(.system(size: 60))
            }
            
            VStack(spacing: 20) {
                VStack {
                    Text("Transaction Amount")
                        .fontWeight(.medium)
                    
                    TextField("Amount", text: amountFormatterBinding)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                }
                
                    
                HStack(spacing: 50) {
                    Button(action: add, label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    })
                        
                    Button(action: subtract, label: {
                        Image(systemName: "minus")
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    })
                }
            }
            
            Spacer()
        }
        .onAppear(perform: getAccount)
    }
    
    func createAccount() {
        let account = Account(id: Self.currentUserId, balance: 0)
        
        Amplify.DataStore.save(account) { result in
            switch result {
                
            case .success(let account):
                print("Account created - \(account)")
                self.account = account
                
            case .failure(let error):
                print("Could not create account - \(error)")
            }
        }
    }
    
    func getAccount() {
        Amplify.DataStore.query(Account.self, byId: Self.currentUserId) { (result) in
            switch result {
            case .success(let queriedAccount):
                if let queriedAccount = queriedAccount {
                    print("Found account - \(queriedAccount)")
                    self.account = queriedAccount
                    
                } else {
                    print("No account found")
                    self.createAccount()
                    
                }
                
            case .failure(let error):
                print("Could not perform query for account - \(error)")
            }
        }
    }
    
    func resetAmount() {
        amount = 0
    }
    
    func add() {
        let currentBalance = account?.balance ?? 0
        let newBalance = currentBalance + amount
        
        updateBalance(to: newBalance)
        
        resetAmount()
    }
    
    func subtract() {
        let currentBalance = account?.balance ?? 0
        let newBalance = currentBalance - amount
        
        updateBalance(to: newBalance)
        
        resetAmount()
    }
    
    func updateBalance(to newBalance: Double) {
        account?.balance = newBalance
        
        guard let account = self.account else { return }
        
        Amplify.DataStore.save(account) { result in
            switch result {
            case .success(let updatedAccount):
                print("Updated balance to - \(updatedAccount.balance)")
                self.account = updatedAccount
                
            case .failure(let error):
                print("Could not update account - \(error)")
            }
        }
    }
}

extension ContentView {
    fileprivate static let currentUserId = "currentUserId"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
