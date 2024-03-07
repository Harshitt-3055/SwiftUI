//
//  ContentView.swift
//  BetterRest
//
//  Created by Harshit Agarwal on 23/02/24.
//

import CoreML
import SwiftUI


struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
   static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading, spacing: 0){
                VStack(alignment:.leading,spacing: 0){
                    Text("BetterRest").font(.largeTitle.bold()).padding([.leading], 10)
                    Text("Powered by the Core ML Model").font(.caption)
                        .padding([.leading], 10)
                
                }
                Form{
                    VStack(alignment: .leading, spacing: 0){
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text("Desired amount of sleep?")
                            .font(.headline)
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text("Daily coffee intake")
                        Stepper("^[\(coffeeAmount) Cup](inflect: true)", value: $coffeeAmount, in: 0...20)
                    }
                }
                
                
            }
            
            .toolbar{
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert){
                Button("Ok"){}
            }message: {
                Text(alertMessage)
            }
        }
    }
    func calculateBedTime(){
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is...."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        }catch{
            alertTitle = "ERROR!"
            alertMessage = "Sorry, there was a problem in calculating your Bedtime."
        }
        
        showingAlert = true
        
    }
}

#Preview {
    ContentView()
}
