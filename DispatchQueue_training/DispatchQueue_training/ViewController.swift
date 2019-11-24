//
//  ViewController.swift
//  DispatchQueue_training
//
//  Created by Shu Nakamura on 2019/11/24.
//  Copyright © 2019 Shu. All rights reserved.
//




/*
 
 同期
 処理の完了を"待つ"
 GCDのメソッドはsync〜
 
 非同期
 処理の完了を"待たない"
 GCDのメソッドはasync〜
 
 並列サンプルソース実行結果(ランダム値があるので実行するたびに結果は変わる)
 #3 Start
 #4 Start
 #1 Start
 #2 Start
 #5 Start
 #1 sleepTime:0.4797872304916382
 #4 sleepTime:0.5034537315368652
 #5 sleepTime:0.7111668586730957
 #1 End
 #2 sleepTime:0.1679520606994629
 #5 End
 #3 sleepTime:0.558417797088623
 #4 End
 #2 End
 #3 End
 All Process Done!
 
 
 直列サンプル実行結果（何度やっても順番は変わらず）
 #1 Start
 #1 sleepTime:0.22510439157485962
 #1 End
 #2 Start
 #2 sleepTime:0.6778431534767151
 #2 End
 #3 Start
 #3 sleepTime:0.9106206297874451
 #3 End
 #4 Start
 #4 sleepTime:0.6230582594871521
 #4 End
 #5 Start
 #5 sleepTime:0.672798752784729
 #5 End
 All Process Done!
 
 */

///参考資料
// https://dev.classmethod.jp/smartphone/iphone/gcd_swift/
// https://qiita.com/shtnkgm/items/d9b78365a12b08d5bde1

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 片方のみ動かしたほうがわかりやすい。
        //        // 並列サンプル
        //        doMultiAsyncProcessParallel()
        // 直列サンプル
        doMultiAsyncProcessSeries()
    }
    
    // 並列処理
    func doMultiAsyncProcessParallel() {
        let dispatchGroup = DispatchGroup()
        //ここが重要。 attributes: .concurrent
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        
        
        // 5つの非同期処理を実行
        for i in 1...5 {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                [weak self] in
                self?.asyncProcess(number: i) {
                    (number: Int) -> Void in
                    print("#\(number) End")
                    dispatchGroup.leave()
                }
            }
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            print("All Process Done!")
        }
    }
    
    // 非同期処理
    func asyncProcess(number: Int, completion: (_ number: Int) -> Void) {
        print("#\(number) Start")
        let sleepTime = Float.random(in: 0 ..< 1)
        print("#\(number) sleepTime:\(Double(sleepTime))")
        sleep(UInt32(sleepTime))
        
        completion(number)
    }
    
    // 直列処理
    func doMultiAsyncProcessSeries() {
        let dispatchGroup = DispatchGroup()
        // 直列キュー attibutes指定なし
        let dispatchQueue = DispatchQueue(label: "queue")
        
        // 5つの非同期処理を実行
        for i in 1...5 {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                [weak self] in
                self?.asyncProcess(number: i) {
                    (number: Int) -> Void in
                    print("#\(number) End")
                    dispatchGroup.leave()
                }
            }
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            print("All Process Done!")
        }
    }
}
