# FDMProgressView
>Swift - ProgressView
>Swift - 进度条小工具

> ----------
> **功能**
>* 支持修改拖拽速度。
>* 支持添加自定义拖动控件。
>* 支持动态修改拖动控件大小。
>* 支持动态修改进度条颜色与大小。
>* 支持播放进度，加载进度等显示。

> **注意** -【ProgressView】的高度即可触控范围，修改内部【progressHeight】属性并不会修改触控范围。

> ----------
>```swift
>  /*可用属性*/
>  var progressHeight: CGFloat    // 进度条高度
>  var dragSpeed: CGFloat    // 拖拽速度
>  var currentValue: CGFloat   // 当前播放进度
>  var loadValue: CGFloat    // 当前加载进度
>  var controlSize: CGSize    // 拖动控制子视图Size
>  var totalProgressColor: UIColor?    // 总进度颜色
>  var loadProgressColor: UIColor?    // 加载进度颜色
>  var currentProgressColor: UIColor?    // 当前进度颜色
>```

> ----------
>```swift
>  /*可用方法*/
>
>  // 设置当前播放进度值 
>  // - parameter value: 播放进度
>  func setCurrentProgressValue(_ value: CGFloat)
>
>  // 设置加载进度值 
>  // - parameter value: 加载进度
>  func setLoadProgressValue(_ value: CGFloat)
>
>  // 设置控制按钮子视图
>  // - 控制按钮的点击范围不会发生变化
>  // - parameter view: 子视图
>  // - parameter size: 子视图大小
>  func setControlSubView(_ view: UIView, size: CGSize)
>
>  // 重新布局视图
>  func resetProgressView()
>```

> ----------
> ```swift
>  /* 代理方法 - FDMProgressViewDelegate */
>
>  // 进度条正在拖动时回调
>  @objc func progressView(_ progressView: FDMProgressView, didDraggingProgressView currentValue: CGFloat)
>
>  // 开始点击拖动视图时回调
>  @objc optional func progressView(_ progressView: FDMProgressView, didTouchBeginDragView currentValue: CGFloat)
>
>  // 停止点击拖动视图时回调
>  @objc optional func progressView(_ progressView: FDMProgressView, didTouchEndDragView currentValue: CGFloat)
> ```
