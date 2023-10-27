//
//  Notifications.swift
//
//  Created by HomeMac on 7/26/22.
//

import SwiftUI
import UserNotifications
import Foundation
import ScreenTime
import ConfettiSwiftUI

class Notifications{
    static let instance = Notifications() // Singleton
    var complete = 0
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print ("ERROR: \(error)")
            } else {
                print ("SUCCESS \(success)")
            }
        }
    }
    
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Time to take a break!"
        content.sound = .default
        content.badge = 1
        // time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1.0, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func changePrompt() -> String {
        let randomInt = Int.random(in: 0..<6)
        if randomInt == 0 {
            return "Break time! Why not try yoga."
        }
        if randomInt == 1 {
            return "Chop Chop! Take a rest with a power nap."
        }
        if randomInt == 2 {
            return "Hmmm... Having some thoughts write it in a journal."
        }
        if randomInt == 3 {
            return "Nature is just so beautiful! Why not take a walk?"
        }
        if randomInt == 4 {
            return "You can put down your phone. Play some board games!"
        }
        if randomInt == 5 {
            return "Workout time & chill. Listen to your favorite music"
        }
        return "Time for Eye exercises."
    }
    
}

struct LocalNotification: View {
    
    @State var isFaceup: Bool = true
    @State var isButtonReady: Bool = false
    @State var prompt = "Hey! You can continue to work. Though I am excited if you do want to take a break as then you could maybe write on a journal, do yoga , take a walk, or just take a power nap."
    @State var time = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @State var count = 0
    @State var imageCount = 0
    @State private var counter = 0
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius:20)
            shape.fill().foregroundColor(.white)
            RadialGradient(gradient: Gradient(colors: [.orange, .yellow]), center: .center, startRadius: 2, endRadius: 650)
            ScrollView {
                VStack {
                    HStack{
                        Text("Vigilant Eye").font(.system(size: 100)).fontWeight(.semibold).foregroundColor(.black)
                        Spacer()
                        Image("eye").clipped().cornerRadius(12.0).shadow(radius: 50).animation(.spring())
                    }.padding()
                    
                    HStack {
                        if imageCount == 0 {
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                        }
                        if imageCount == 1 {
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                        }
                        if imageCount == 2 {
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                        }
                        if imageCount == 3 {
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("blackp").resizable().aspectRatio(contentMode: .fit)
                        }
                        if imageCount == 4 {
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                            Image("party").resizable().aspectRatio(contentMode: .fit)
                        }
                    }.padding().shadow(radius: 50).animation(.spring()).confettiCannon(counter: $counter, num: 400, confettiSize: 30.0, rainHeight: 1400.0, radius: 1500.0)
                    
                    Spacer()
                    
                    ZStack {
                        if isFaceup {
                            RoundedRectangle(cornerRadius: 20).foregroundColor(.black).frame(width: 500, height: 320)
                            Text("Introducing our product, the Vigilant Eye. This is a revolutionary approach to managing time and health in a new virtual age. As Too much screen time can lead to sleep problems, chronic neck and back problems, depression, anxiety, obesity and lower long term productivity. Past studies recommend a maximum of two hours more than what’s needed in a working day, however, employees now spend up to 10 hours on screens, a number too large to be healthy. So, we have set a timer of 2 hours that runs the moment the device is turned on and after the two hours you will get a notification that tell you to take a break.").frame(width: 400, height: 260)
                        } else {
                            RoundedRectangle(cornerRadius: 20).foregroundColor(.yellow).frame(width: 500, height: 320).border(.black, width: 12.0)
                            Text("\(prompt)").frame(width: 400, height: 260).foregroundColor(.black)
                        }
                    }.padding()
                        .onTapGesture {
                            isFaceup = !isFaceup
                        }
                    
                    if isButtonReady && imageCount < 4{
                        Button (action: {
                            count = 0
                            imageCount += 1
                            isButtonReady = false
                        }, label:{
                            Text("Done")
                        }).padding().frame(width: 100, height: 60).controlSize(.large).foregroundColor(.black)
                    }
                    if !isButtonReady{
                        Button (action: {
                        }, label:{
                            Text("Done")
                        }).padding().colorInvert().frame(width: 100, height: 60).controlSize(.large)
                    }
                    if isButtonReady && imageCount == 4{
                        Button(action: {
                            count = 0
                            isButtonReady = false
                            counter += 1
                        }) {
                            Text("🎉")
                                .padding().frame(width: 100, height: 60).controlSize(.large).foregroundColor(.black)
                        }
                        
                    }
                    
                    Spacer()
                
                }
                
            }
            .onAppear(perform: {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
                }
            })
            .onReceive(self.time) { (_) in
                count += 1
                
                if count == 1 {
                    prompt = "Hey! You can continue to work. Though I am excited if you do want to take a break as then you could maybe write on a journal, do yoga, take a walk, or just take a power nap."
                    if imageCount == 4 && counter == 1{
                        imageCount = 0
                        counter = 0
                        imageCount = 0
                    }
                }
                
                if count == 2 {
                    prompt = Notifications.instance.changePrompt()
                    Notifications.instance.scheduleNotification()
                    isButtonReady = true
                }
                
                if count == 3 {
                    count = 2
                    Notifications.instance.scheduleNotification()
                }
    
            }
        }
    }
}

struct LocalNotification_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotification()
    }
}
