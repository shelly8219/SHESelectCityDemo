//
//  SelectCityPickerView.swift
//  she
//
//  Created by she on 24/08/2018.
//  Copyright © 2018 she. All rights reserved.
//

import UIKit

class SelectCityPickerView: UIView {
    
    typealias CityPickerResultBlock = (String,String,String)->Void
    
    public  var cityPickerResultBlock:CityPickerResultBlock!
    

    private let baseBackgroundView:UIView = UIView()
    
    private let subView:UIView  = UIView()
    
    private let headerBgView:UIView  = UIView()
    
    public let cityPicker = UIPickerView()
    
    private let confirmButton:UIButton  = UIButton(title: "确认",titleColor: TBIThemeWhite,titleSize: 16)
    
    private let cancelButton:UIButton   = UIButton(title: "取消",titleColor: TBIThemeWhite,titleSize: 16)
    
    fileprivate var provinceArr = [SelectCityModel]()
    fileprivate var cityArr = [SelectCityModel]()
    fileprivate var districtArr = [SelectCityModel]()
    
    //选择的省索引
    fileprivate var provinceIndex = 0
    //选择的市索引
    fileprivate var cityIndex = 0
    //选择的县索引
    fileprivate var areaIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subView.backgroundColor = TBIThemeWhite
        headerBgView.backgroundColor = TBIThemeLinkColor
        self.addSubview(subView)
        subView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(175)
        }
        self.addSubview(headerBgView)
        headerBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.bottom.equalTo(subView.snp.top)
        }
        
        headerBgView.addSubview(confirmButton)
        headerBgView.addSubview(cancelButton)
        cancelButton.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        confirmButton.addOnClickListener(target: self, action: #selector(confirmButtonAction))
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        subView.addSubview(cityPicker)
        cityPicker.dataSource = self
        cityPicker.delegate = self
        cityPicker.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        getProvinces()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confirmButtonAction() {
        
        printDebugLog(message: provinceArr[provinceIndex].value)
        printDebugLog(message: cityArr[cityIndex].value)
        printDebugLog(message: districtArr[areaIndex].value)
        if cityPickerResultBlock != nil{
            cityPickerResultBlock(provinceArr[provinceIndex].value,cityArr[cityIndex].value,districtArr[areaIndex].value)
        }
        self.removeFromSuperview()
    }
    func cancelButtonAction() {
        self.removeFromSuperview()
    }
    ///请求省
    func getProvinces()  {
        weak var weakSelf = self
        SelectCityService.sharedInstance.getProvinces()
            .subscribe{(event) in
                switch event {
                case .next(let result):
                     printDebugLog(message: result.count)
                     weakSelf?.provinceArr = result
                     ///默认请求第一个省的市
                     weakSelf?.getCities(code: (result.first?.key)!)
                    weakSelf?.cityPicker.reloadAllComponents()
                case .error:
                    break
                case .completed:
                    break
                }
        }
    }
    ///请求市
    func getCities(code:String)  {
         weak var weakSelf = self
        SelectCityService.sharedInstance.getCities(code: code)
            .subscribe{(event) in
                switch event {
                case .next(let result):
                    printDebugLog(message: result.count)
                    weakSelf?.cityArr = result
                    ///默认请求第一个市的区
                    weakSelf?.getDistricts(code: (result.first?.key)!)
                    weakSelf?.cityPicker.reloadAllComponents()
                case .error:
                    break
                case .completed:
                    break
                }
        }
    }
    ///请求区
    func getDistricts(code:String)  {
        weak var weakSelf = self
        SelectCityService.sharedInstance.getDistricts(code: code)
            .subscribe{(event) in
                switch event {
                case .next(let result):
                    printDebugLog(message: result.count)
                    weakSelf?.districtArr = result
                    weakSelf?.cityPicker.reloadAllComponents()
                case .error:
                    break
                case .completed:
                    break
                }
        }
    }
}
extension SelectCityPickerView:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            printDebugLog(message: provinceArr.count)
            return provinceArr.count
        }else if component == 1{
            return cityArr.count
        }else{
            return districtArr.count
        }
    }
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
//                    forComponent component: Int) -> String? {
//        if component == 0 {
//            return self.provinceArr[row].value
//        }else if component == 1 {
//            return self.cityArr[row].value
//        }else {
//            return self.districtArr[row].value
//        }
//    }
    //设置行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int)
        -> CGFloat {
            return 40
    }
    //自定义选项视图 换行展示
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16)
            pickerLabel?.textAlignment = .center
            
        }
        pickerLabel?.numberOfLines = 0 //不限制行数
        if component == 0 {
            pickerLabel?.text = self.provinceArr[row].value
        }else if component == 1 {
            pickerLabel?.text = self.cityArr[row].value
        }else {
            pickerLabel?.text = self.districtArr[row].value
        }
        return pickerLabel!
    }
    
    //选中项改变事件（将在滑动停止后触发）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        //根据列、行索引判断需要改变数据的区域
        switch (component) {
        case 0:
            provinceIndex = row;
            cityIndex = 0;
            areaIndex = 0;
            pickerView.reloadComponent(1);
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
            ///根据选的省 请求市
            getCities(code: provinceArr[provinceIndex].key)
            
        case 1:
            cityIndex = row;
            areaIndex = 0;
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false)
            ///根据选的市 请求区
            getDistricts(code: cityArr[cityIndex].key)
        case 2:
            areaIndex = row;
        default:
            break;
        }
    }
    
}
