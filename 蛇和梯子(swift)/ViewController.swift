//
//  ViewController.swift
//  蛇和梯子(swift)
//
//  Created by Yoyo on 2018/4/16.
//  Copyright © 2018年 clearning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var geziDic = [Int: CGPoint]()
    var countIndex = 0
    var currentIndex = 1
    var peopleV:UIImageView = UIImageView()
    var diceV = UIButton(type: UIButtonType.custom)
    var countLabel:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let widthRate = CGFloat(self.view.viewWidth/750)
        let heightRate = CGFloat(self.view.viewHeight/1334)
        let ViewWidth = CGFloat(self.view.viewWidth)
        let ViewHeight = CGFloat(self.view.viewHeight)
        let CellHeight = CGFloat(90*heightRate)

        self.view.backgroundColor = UIColor.white;
        let wh = CGFloat(700*widthRate);
        let imgV = UIImageView(image: UIImage(named: "beijing"))
        imgV.frame = CGRect(x:CGFloat((ViewWidth-wh)/2), y:CellHeight*2, width:wh, height:wh)
        self.view.addSubview(imgV)
        
        let v = UIView(frame:imgV.frame)
        self.view.addSubview(v)
        
        var index:Int = 0
        for i in (0..<5) {
            let y = CGFloat((4-i)) * CGFloat(wh/5)
            var x : CGFloat
            if(i % 2 != 0) {
                var j = 5
                while(j > 0) {
                    index += 1
                    x = CGFloat(j-1) * CGFloat(wh/5)
                    geziDic[index] = CGPoint(x: x, y: y)
                    j -= 1
                }
            } else {
                for j in 0...4 {
                    index += 1
                    x = CGFloat(j)*CGFloat(wh/5)
                    geziDic[index] = CGPoint(x: x, y: y)
                }
            }
        }
        
        let point = geziDic[1];
        peopleV = UIImageView(image: UIImage(named: "people"))
        peopleV.frame = CGRect(x:point!.x, y:point!.y, width:CGFloat(wh/5), height:CGFloat(wh/5))
        v.addSubview(peopleV)
        
        let shaiziWH = CGFloat(200*widthRate)
        diceV.frame = CGRect(x:CGFloat((ViewWidth-shaiziWH)/2), y:CGFloat(CellHeight*5+wh), width:shaiziWH, height:shaiziWH)
        diceV.setBackgroundImage(UIImage(named: "1"), for: UIControlState.normal)
        diceV.adjustsImageWhenDisabled = false
        diceV.addTarget(self, action: #selector(self.shakeDice), for: UIControlEvents.touchUpInside)
        self.view.addSubview(diceV)
        
        countLabel = UILabel(frame: CGRect(x:CellHeight, y:CGFloat(CellHeight*3+wh), width:CGFloat(ViewWidth-CellHeight*2), height:(CellHeight)))
        countLabel.textColor = UIColor.blue
        countLabel.layer.cornerRadius = 10
        countLabel.layer.borderColor = UIColor.blue.cgColor
        countLabel.layer.borderWidth = 1
        countLabel.textAlignment = NSTextAlignment.center
        countLabel.text = "您已走了0步"
        self.view.addSubview(countLabel)
        
    }

    @objc func shakeDice() {
        if diceV.isEnabled {
            diceV.isEnabled = false
            let ary = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6")]
            var count:Int = 0
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
                let r: Int = Int(arc4random() % 5)
                UIView.animate(withDuration: 0.2, animations: {
                    self.diceV.setBackgroundImage(ary[r], for: UIControlState.normal)
                }, completion: { (complete) in
                    count += 1
                    if count > 10 {
                        timer.invalidate()
                        self.peopleGo(count: r+1);
                    }
                })
            }
        }
    }

    func peopleGo(count: Int) {
        let t = self.pathAnimationLine(count: count)
        Timer.scheduledTimer(withTimeInterval: TimeInterval(t), repeats: false) { (timer) in
            self.check()
        }
    }
    
    func check(){
        var change = true
        var end: Int = 0
        switch currentIndex {
            case 3:
                end = 11
                break
            case 10:
                end = 12
                break
            case 9:
                end = 18
                break
            case 6:
                end = 17
                break
            case 24:
                end = 16
                break
            case 14:
                end = 4
                break
            case 19:
                end = 8
                break
            case 22:
                end = 20
                break
            default:
                change = false
                break
        }
        if change {
            self.pathAnimationLadder(start: currentIndex, end: end)
        }
        if currentIndex == 25 {
            countIndex += 1
            let t = self.pathAnimationLine(count: 24)
            Timer.scheduledTimer(withTimeInterval: TimeInterval(t), repeats: false, block: { (tim) in
                self.countLabel.text = "成功,您走了"+String(self.countIndex)+"步"
                self.countIndex = 0
                self.diceV.isEnabled = true
            })
        } else {
            countIndex += 1
            countLabel.text = "您已走了"+String(self.countIndex)+"步"
            diceV.isEnabled = true
        }
    }
    
    func pathAnimationLadder(start: Int, end: Int) {
        let runAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")//只能写position
        runAnimation.values = [NSValue(cgPoint: geziDic[start]!), NSValue(cgPoint: geziDic[end]!)]
        runAnimation.duration = 1.0
        runAnimation.repeatCount = 0
        runAnimation.isRemovedOnCompletion = false
        runAnimation.fillMode = kCAFillModeForwards
        peopleV.layer.anchorPoint = CGPoint(x: 0, y: 0)
        peopleV.layer.add(runAnimation, forKey: nil)
        currentIndex = end
    }
    
    func pathAnimationLine(count: Int) -> Float {
        var ary = [NSValue]()
        var n = currentIndex
        if count + currentIndex < 26 {
            while n <= currentIndex + count {
                let point:CGPoint = geziDic[n]!
                ary.append(NSValue(cgPoint: point))
                n += 1
            }
            currentIndex += count
        } else {
            while n <= 25 {
                let point: CGPoint = geziDic[n]!
                ary.append(NSValue(cgPoint: point))
                n += 1
            }
            n = 25
            while n >= 50 - (count + currentIndex) {
                let point:CGPoint = geziDic[n]!
                ary.append(NSValue(cgPoint: point))
                n -= 1
            }
            currentIndex = 50 - (currentIndex + count)
        }
        let runAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        runAnimation.values = ary
        runAnimation.duration = Double(ary.count) * 0.5
        runAnimation.repeatCount = 0
        runAnimation.isRemovedOnCompletion = false
        runAnimation.fillMode = kCAFillModeForwards
        peopleV.layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        peopleV.layer.add(runAnimation, forKey: nil)
        return Float(ary.count)*0.5
    }
}

extension UIView {
    var viewWidth: CGFloat {
        return self.frame.size.width
    }
    var viewHeight: CGFloat {
        return self.frame.size.height
    }
}
