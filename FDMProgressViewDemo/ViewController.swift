//
//  ViewController.swift
//  FDMProgressViewDemo
//
//  Created by 发抖喵 on 2021/1/11.
//

import UIKit
import SnapKit

//MARK: - 进度条
class ViewController: UIViewController {
    
    /* -------------------- */
    let progressView = FDMProgressView()
    var subControlView = UIImageView()
    var value: CGFloat = 0  // 动态进度
    /* -------------------- */
    
    /* 其他 */
    let currentValueLabel = UILabel()
    let currentValueField = UITextField()
    
    let loadValueLabel = UILabel()
    let loadValueField = UITextField()
    
    var switchTitle_1 = UILabel()
    var switch_1 = UISwitch()   // 模拟动态进度
    
    var switchTitle_2 = UILabel()
    var switch_2 = UISwitch()   // 进度条放大缩小
    
    var switchTitle_3 = UILabel()
    var switch_3 = UISwitch()   // 拖动按钮放大缩小
    
    var switchTitle_4 = UILabel()
    var switch_4 = UISwitch()   // 拖动按钮放大缩小

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "进度条"
        self.view.backgroundColor = .white
        
        createUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//MARK: - UI
extension ViewController {
    func createUI() {
        self.view.addSubview(progressView)
        
        /* 进度条（本区域为进度条使用方法） ------------------------------ */
        progressView.delegate = self
        progressView.progressHeight = 5
        progressView.currentProgressColor = .orange
//        progressView.frame = CGRect(x: 15, y: 150, width: view.bounds.width - 30, height: 25)
        progressView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(150)
            make.height.equalTo(25)
        }
        
        /* 创建进度条拖动View */
        setControlSubView()
        
        /*  ----------------------------------- */
            
        /* 创建其他UI */
        createOther()
    }
    
    /**
     设置子控制视图
     */
    func setControlSubView() {
        subControlView.image = UIImage(named: "player_full_settings")
        progressView.setControlSubView(subControlView, size: .init(width: 18, height: 18))
    }
}

//MARK: - 进度条代理
extension ViewController: FDMProgressViewDelegate {
    /// 进度条正在拖动时回调
    func progressView(_ progressView: FDMProgressView, didDraggingProgressView currentValue: CGFloat) {
        currentValueField.text = "\(Int(currentValue * 100))"
        value = currentValue
    }
    
    /// 开始点击拖动视图时回调
    func progressView(_ progressView: FDMProgressView, didTouchBeginDragView currentValue: CGFloat) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            if self?.switch_2.isOn ?? false { progressView.progressHeight = 10 }
            if self?.switch_3.isOn ?? false { progressView.controlSize = .init(width: 35, height: 35) }
            if self?.switch_4.isOn ?? false { progressView.currentProgressColor = .purple }
        }
    }
    
    /// 停止点击拖动视图时回调
    func progressView(_ progressView: FDMProgressView, didTouchEndDragView currentValue: CGFloat) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            if self?.switch_2.isOn ?? false { progressView.progressHeight = 5 }
            if self?.switch_3.isOn ?? false { progressView.controlSize = .init(width: 18, height: 18) }
            if self?.switch_4.isOn ?? false { progressView.currentProgressColor = .orange }
        }
    }
}

//MARK: - Other
extension ViewController: UITextFieldDelegate {
    func createOther() {
        self.view.addSubview(currentValueLabel)
        self.view.addSubview(currentValueField)
        self.view.addSubview(loadValueLabel)
        self.view.addSubview(loadValueField)
        self.view.addSubview(switchTitle_1)
        self.view.addSubview(switch_1)
        self.view.addSubview(switchTitle_2)
        self.view.addSubview(switch_2)
        self.view.addSubview(switchTitle_3)
        self.view.addSubview(switch_3)
        self.view.addSubview(switchTitle_4)
        self.view.addSubview(switch_4)
        
        /* 当前进度值标题 */
        currentValueLabel.text = "当前进度值"
        currentValueLabel.frame = CGRect(x: 15, y: 200, width: 100, height: 30)
        
        /* 当前进度值输入框 */
        currentValueField.delegate = self
        currentValueField.placeholder = "请输入 1 - 100之间的值"
        currentValueField.keyboardType = .numberPad
        currentValueField.frame = CGRect(x: 150, y: 200, width: 210, height: 30)
        currentValueField.layer.borderWidth = 0.5
        currentValueField.layer.borderColor = UIColor.darkGray.cgColor
        currentValueField.layer.cornerRadius = 8
        currentValueField.layer.masksToBounds = true
        
        /* 加载进度值标题 */
        loadValueLabel.text = "加载进度值"
        loadValueLabel.frame = CGRect(x: 15, y: 250, width: 100, height: 30)
        
        /* 当前加载进度输入框 */
        loadValueField.delegate = self
        loadValueField.placeholder = "请输入 1 - 100之间的值"
        loadValueField.keyboardType = .numberPad
        loadValueField.frame = CGRect(x: 150, y: 250, width: 210, height: 30)
        loadValueField.layer.borderWidth = 0.5
        loadValueField.layer.borderColor = UIColor.darkGray.cgColor
        loadValueField.layer.cornerRadius = 8
        loadValueField.layer.masksToBounds = true
        
        /* 开启动态进度 */
        switchTitle_1.text = "递归模拟动态进度"
        switchTitle_1.frame = CGRect(x: 15, y: 300, width: 150, height: 30)
        
        /* 动态进度开关 */
        switch_1.frame = CGRect(x: 200, y: 300, width: 100, height: 30)
        switch_1.addTarget(self, action: #selector(clickSwitch_1(sender:)), for: .touchUpInside)
        
        /* 进度条放大缩小 */
        switchTitle_2.text = "进度条放大与缩小"
        switchTitle_2.frame = CGRect(x: 15, y: 350, width: 150, height: 30)
        
        /* 进度条放大缩小 */
        switch_2.frame = CGRect(x: 200, y: 350, width: 100, height: 30)
        
        /* 拖动按钮放大缩小 */
        switchTitle_3.text = "拖动按钮放大缩小"
        switchTitle_3.frame = CGRect(x: 15, y: 400, width: 150, height: 30)
        
        /* 拖动按钮放大缩小 */
        switch_3.frame = CGRect(x: 200, y: 400, width: 100, height: 30)
        
        /* 拖动修改进度颜色 */
        switchTitle_4.text = "拖动修改进度颜色"
        switchTitle_4.frame = CGRect(x: 15, y: 450, width: 150, height: 30)
        
        /* 拖动修改进度颜色 */
        switch_4.frame = CGRect(x: 200, y: 450, width: 100, height: 30)
    }
    
    /**
     递归模拟动态进度
     */
    func changeProgress() {
        if !switch_1.isOn {return}
        if self.value > 1 { self.value = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.value += 0.01
            self.progressView.setCurrentProgressValue(self.value)
            self.changeProgress()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var value: CGFloat = CGFloat(((textField.text ?? "") as NSString).intValue)
        if value <= 0 { value = 0 }
        if value >= 100 { value = 100 }
        
        if textField == currentValueField {
            progressView.setCurrentProgressValue(value / 100)
        }else if textField == loadValueField {
            progressView.setLoadProgressValue(value / 100)
        }
    }
    
    /**
     点击动态进度开关
     */
    @objc func clickSwitch_1(sender: UISwitch) {
        if sender.isOn { changeProgress() }
    }
}
