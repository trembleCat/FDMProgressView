//
//  FDMProgressView.swift
//
//  Created by 发抖喵 on 2021/1/7.
//
//  控制按钮的宽高，根据当前视图的高度而定。 目前只支持横向

import UIKit

//MARK: - FDMProgressViewDelegate
@objc protocol FDMProgressViewDelegate: NSObjectProtocol {
    
    @objc func progressView(_ progressView: FDMProgressView, didDraggingProgressView currentValue: CGFloat)
    
    @objc optional func progressView(_ progressView: FDMProgressView, didTouchBeginDragView currentValue: CGFloat)
    
    @objc optional func progressView(_ progressView: FDMProgressView, didTouchEndDragView currentValue: CGFloat)
}


//MARK: - 自定义进度条
class FDMProgressView: UIView {
    
    weak var delegate: FDMProgressViewDelegate?
    
    /// 拖拽速度
    var dragSpeed: CGFloat = 1.0
    
    /// 当前播放进度
    var currentValue: CGFloat = 0
    
    /// 当前加载进度
    var loadValue: CGFloat = 0
    
    /// 进度条高度
    var progressHeight: CGFloat = 8 { didSet { resetProgressView() } }
    
    /// 拖动控制子视图Size - 默认小圆点Size
    var controlSize: CGSize = .init(width: 16, height: 16) { didSet { setSubControlViewCenter() } }
    
    /// 总进度颜色
    var totalProgressColor: UIColor? { didSet { totalProgressView.backgroundColor = totalProgressColor } }
    
    /// 加载进度颜色
    var loadProgressColor: UIColor? { didSet { loadProgressView.backgroundColor = loadProgressColor } }
    
    /// 当前进度颜色
    var currentProgressColor: UIColor? { didSet { currentProgressView.backgroundColor = currentProgressColor } }
    
    /// 总进度
    private let totalProgressView = UIView()
    
    /// 加载进度
    private let loadProgressView = UIView()
    
    /// 当前进度
    private let currentProgressView = UIView()
    
    /// 拖动控制视图
    private let dragControlView = UIView()
    
    /// 拖动控制起点
    private var startValue: CGFloat?
    
    /// 拖动控制X值
    private var dragControlX: CGFloat?
    
    /// 拖动控制子视图 - 默认为小圆点
    private var controlView = UIView()
    
    /// 是否修改进度视图
    private var shouldChangeProgress = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
        createAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - PublicAction ------------------------------------------------------------------
extension FDMProgressView {
    /**
     设置当前播放进度值
     
     - 建议使用此方法设置播放进度
     - parameter value: 播放进度
     */
    func setCurrentProgressValue(_ value: CGFloat) {
        var progressValue = value
        
        if progressValue <= 0 { progressValue = 0 }
        if progressValue >= 1 { progressValue = 1 }
        
        currentValue = progressValue
        
        guard shouldChangeProgress else { return }
        let progressWidth = currentValue * totalProgressView.bounds.width
        currentProgressView.frame = CGRect(origin: .zero, size: .init(width: progressWidth, height: progressHeight))
        dragControlView.center.x = progressWidth + dragControlView.bounds.height * 0.5
    }
    
    /**
     设置加载进度值
     
     - 建议使用此方法设置加载进度
     - parameter value: 加载进度
     */
    func setLoadProgressValue(_ value: CGFloat) {
        var progressValue = value
        
        if progressValue <= 0 { progressValue = 0 }
        if progressValue >= 1 { progressValue = 1 }
        
        loadValue = progressValue
        
        let progressWidth = loadValue * totalProgressView.bounds.width
        loadProgressView.frame = CGRect(origin: .zero, size: .init(width: progressWidth, height: progressHeight))
    }
    
    /**
     设置控制按钮子视图
     
     - 控制按钮的点击范围不会发生变化
     - parameter view: 子视图
     - parameter size: 子视图大小
     */
    func setControlSubView(_ view: UIView, size: CGSize) {
        controlView.removeFromSuperview()
        
        controlView = view
        controlSize = size
        self.dragControlView.addSubview(controlView)
    }
    
    /**
     重新布局子视图
     */
    func resetProgressView() {
        let currentBounds = self.bounds
        
        /* 总进度 */
        totalProgressView.layer.cornerRadius = progressHeight * 0.5
        totalProgressView.frame = CGRect(x: currentBounds.height * 0.5,
                                         y: currentBounds.height * 0.5 - progressHeight * 0.5,
                                         width: currentBounds.width - currentBounds.height,
                                         height: progressHeight)
        
        /* 加载进度 */
        let loadProgressWidth = loadValue * totalProgressView.frame.width
        loadProgressView.layer.cornerRadius = progressHeight * 0.5
        loadProgressView.frame = CGRect(origin: .zero, size: .init(width: loadProgressWidth, height: progressHeight))

        /* 当前进度 */
        let currentProgressWidth = currentValue * totalProgressView.frame.width
        currentProgressView.layer.cornerRadius = progressHeight * 0.5
        currentProgressView.frame = CGRect(origin: .zero, size: .init(width: currentProgressWidth, height: progressHeight))

        /* 拖动控制块 */
        let dragControlX = currentValue * totalProgressView.frame.width
        dragControlView.frame = CGRect(origin: .init(x: dragControlX, y: 0),
                                       size: .init(width: bounds.height, height: bounds.height))
        
        /* 拖动显示视图 */
        controlView.bounds.size = controlSize
        controlView.center = CGPoint(x: dragControlView.frame.width * 0.5, y: dragControlView.frame.height * 0.5)
        
    }
}


//MARK: - UI ------------------------------------------------------------------
extension FDMProgressView {
    private func createUI() {
        self.addSubview(totalProgressView)
        self.totalProgressView.addSubview(loadProgressView)
        self.totalProgressView.addSubview(currentProgressView)
        self.addSubview(dragControlView)
        self.dragControlView.addSubview(controlView)
        
        /* 控制器默认颜色 */
        totalProgressColor = .init(red: 207.0 / 225.0, green: 207.0 / 225.0, blue: 207.0 / 225.0, alpha: 1.0)
        loadProgressColor = .init(red: 179.0 / 225.0, green: 179.0 / 225.0, blue: 179.0 / 225.0, alpha: 1.0)
        currentProgressColor = .init(red: 102.0 / 225.0, green: 102.0 / 225.0, blue: 102.0 / 225.0, alpha: 1.0)
        controlView.backgroundColor = .init(red: 244.0 / 225.0, green: 164.0 / 225.0, blue: 96.0 / 225.0, alpha: 1.0)
        
        controlSize = .init(width: progressHeight * 2, height: progressHeight * 2)
        controlView.layer.cornerRadius = progressHeight
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        resetProgressView()
    }
}


//MARK: - PrivateAction ------------------------------------------------------------------
extension FDMProgressView {
    private func createAction() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(dragWithLongGestureGesture(_:)))
        longGesture.minimumPressDuration = 0
        dragControlView.addGestureRecognizer(longGesture)
    }
    
    /**
     private - 长按控制块
     */
    @objc private func dragWithLongGestureGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            shouldChangeProgress = false
            startValue = gesture.location(in: self).x
            dragControlX = dragControlView.frame.origin.x
            
            self.delegate?.progressView?(self, didTouchBeginDragView: currentValue)
            break
            
        case .changed:
            guard startValue != nil && dragControlX != nil else { return }
            let changeX = gesture.location(in: self).x
            var originX = dragControlX! + (changeX - startValue!) * dragSpeed
            
            if originX <= 0 { originX = 0 }
            if originX >= self.bounds.width - self.bounds.height { originX = self.bounds.width - self.bounds.height }
            dragControlView.frame.origin.x = originX
            setCurrentProgress()
            
            self.delegate?.progressView(self, didDraggingProgressView: currentValue)
            break
            
        case .ended:
            startValue = nil
            dragControlX = nil
            
            self.delegate?.progressView?(self, didTouchEndDragView: currentValue)
            self.shouldChangeProgress = true
            break
            
        case .cancelled:
            startValue = nil
            dragControlX = nil
            
            self.delegate?.progressView?(self, didTouchEndDragView: currentValue)
            self.shouldChangeProgress = true
            break
            
        case .failed:
            startValue = nil
            dragControlX = nil
            
            self.delegate?.progressView?(self, didTouchEndDragView: currentValue)
            self.shouldChangeProgress = true
            break
            
        case .possible:
            break
            
        @unknown default:
            break
        }
    }
    
    /**
     private - 设置当前进度条
     */
    private func setCurrentProgress() {
        let progressWidth = dragControlView.center.x - totalProgressView.frame.origin.x
        currentProgressView.frame = CGRect(origin: .zero, size: .init(width: progressWidth, height: progressHeight))
        
        /* 计算进度值 */
        currentValue = progressWidth / totalProgressView.bounds.width
    }
    
    /**
     private - 设置拖动子控件的center
     */
    private func setSubControlViewCenter() {
        controlView.bounds.size = controlSize
    }
}
