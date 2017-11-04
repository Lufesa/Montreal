//
//  ViewController.swift
//  hackathon
//
//  Created by Yuchen Zhong on 2017-11-04.
//  Copyright © 2017 Yuchen Zhong. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    // Fixed Ion position
    var Ion_position_x0: Double = 100
    var Ion_position_y0: Double = 200
    
    // Initio electron position;
    var x0: Double = 0
    var y0: Double = 0
    
    // force F = k*q1*q2/r^2
    var q1: Double = 1
    var q2: Double = 1
    var k: Double = 1
    
    // electron mass
    var m: Double = 1
    
    // constant delta t
    var t: Double = 1/30
    
    static let V0: Double = 10

    static let Initial_alpha: Double = Double.pi / 4
   
    var V0x = V0 * cos(Initial_alpha)
    var V0y = V0 * sin(Initial_alpha)
    
    // start calculation ---------------------------------------------
    func startCalculation() {
        
        var r0_Vector_x = Ion_position_x0 - x0
        var r0_Vector_y = Ion_position_y0 - y0
        var r0 = sqrt(r0_Vector_x * r0_Vector_x + r0_Vector_y * r0_Vector_y)
        
        var cosalpha_r_x_0 = r0_Vector_x / r0
        var cosalpha_r_y_0 = r0_Vector_y / r0
        
        var F0 = k * q1 * q2 / r0 * r0
        var F0x = F0 * cosalpha_r_x_0
        var F0y = F0 * cosalpha_r_y_0
        
        var a0x = F0x / m
        var a0y = F0y / m
        
        // first moVement
        var x1 = x0 + V0x * t + 0.5 * a0x * t * t
        var y1 = y0 + V0y * t + 0.5 * a0y * t * t
        
        x0 = x1
        y0 = y1
        V0x = V0x + a0x * t
        V0y = V0y + a0y * t
        
        print("x0, y0 = \(x0) \(y0)")
        print("v0x, v0y = \(V0x) \(V0y)")
    }
    
    @IBOutlet var backgroundView: NSView!
    
    private var balls: [BallView] = []
    private weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer?.backgroundColor = NSColor.white.cgColor
        startTimer()
        
        let aBall = BallView(view: view)
        aBall.x = CGFloat(Ion_position_x0)
        aBall.y = CGFloat(Ion_position_y0)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        for _ in 1...1 {
            let aBall = BallView(view: view)
            balls.append(aBall)
        }
    }
    
    func startTimer() {
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let zelf = self else {
                return
            }
            // do something here
            print("...")
            
            for aBall in zelf.balls {
                aBall.x = CGFloat(zelf.x0)
                aBall.y = CGFloat(zelf.y0)
            }

            zelf.startCalculation()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    deinit {
        stopTimer()
    }
}

