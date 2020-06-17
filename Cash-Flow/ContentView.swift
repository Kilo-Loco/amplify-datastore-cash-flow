//
//  ContentView.swift
//  Cash-Flow
//
//  Created by Kyle Lee on 6/17/20.
//  Copyright © 2020 Kilo Loco. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var amount: Double = 0.00
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.isLenient = false
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
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
        VStack(spacing: 30) {
            TextField("$0.00", text: amountFormatterBinding)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                
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
    }
    
    func add() {
        print("add \(amount)")
        amount = 0
    }
    
    func subtract() {
        print("subtract \(amount)")
        amount = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
