//
//  ViewController.swift
//  SHESelectCityView
//
//  Created by she on 03/09/2018.
//  Copyright © 2018 she. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ///点击弹出
        /*
         weak var weakSelf = self
         let cityPicker = SelectCityPickerView(frame: ScreenWindowFrame)
         ///回调展示
         cityPicker.cityPickerResultBlock = {(province,city,area)in
            weakSelf?.addressCity.text = province + city + area
            if weakSelf?.provincePickerResultBlock != nil{
                weakSelf?.provincePickerResultBlock(province,city,area)
            }
         }
         KeyWindow?.addSubview(cityPicker)
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

