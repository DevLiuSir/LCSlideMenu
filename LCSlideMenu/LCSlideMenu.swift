//
//  LCSlideMenu.swift
//  LCSlideMenu
//
//  Created by Liu Chuan on 2017/1/14.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 选择菜单标题样式
///
/// - normal: 默认
/// - gradient: 渐变颜色
/// - transfrom: 放大
public enum LCSlideMenuTitleStyle {
    case normal
    case gradient
    case transfrom
}

/// 选择菜单指示器风格
///
/// - normal: 默认
/// - stretch: 伸缩
/// - followText: 跟随文本长度
/// - cover: 遮罩
/// - circle: 圆圈
public enum LCSlideMenuIndicatorStyle {
    case normal
    case stretch
    case followText
    case cover
    case circle
}

/// 滑动菜单
open class LCSlideMenu: UIView {
    
    //MARK: - 属性( Attribute )
    
    /// 指示器类型
    public var indicatorType: LCSlideMenuIndicatorStyle = .normal
    
    /// 标题样式
    public var titleStyle: LCSlideMenuTitleStyle = .normal
    
    /// 标题数组
    private var titles: [String]
    
    /// 定义一个数组, 记录UILabel
    fileprivate var itemsLabel: [UILabel] = []
    
    /// 定义一个数组, 记录circleIndicator
    fileprivate var itemsView: [UIView] = []
    
    /// 控制器数组
    private var controllers: [UIViewController]
    
    /// 圆圈指示器的宽度
    private var circleIndicatorWidth: CGFloat = 10
    
    /// Item的间距
    private var itemMargin: CGFloat = 15.0
    
    /// 选中的索引
    fileprivate var itemSelectedIndex: Int = 0
    
    /// 左边索引
    fileprivate var leftIndex = 0
    
    /// 右边索引
    fileprivate var rightIndex = 0
    
    /// 伸缩动画的偏移量
    fileprivate let indicatorAnimatePadding: CGFloat = 8.0
    
    /// 标题字体
    public var itemFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {    // 监听数值 `itemFont` 的改变, 从而修改当前label的标题字体
            if itemFont != oldValue {
                itemsLabel[itemSelectedIndex].font = itemFont
            }
        }
    }
    
    /// 是否显示指示器视图
    public var isShowIndicatorView: Bool = false {
        didSet{     // 监听数值 `isShowIndicatorView` 的改变,隐藏 `indicatorView`
            if !isShowIndicatorView {
                indicatorView.isHidden = true
            }
            configIndicatorView()
        }
    }
    
    /// 是否需要遮罩
    public var isNeedMask: Bool = false {
        didSet {    // 监听数值 `isNeedMask` 的改变,隐藏 `coverView`
            if !isNeedMask {
                coverView.isHidden = true
            }
            configCoverView()
        }
    }
    
    /// 圆圈指示器的颜色
    public var circleIndicatorColor: CGColor = UIColor.red.cgColor {
        didSet {    // 监听数值 `circleIndicatorColor` 的改变, 从而修改 `circleIndicator` 的边框色
            if circleIndicatorColor != oldValue {
                for (index, _) in titles.enumerated() {     // 遍历titles
                    itemsView[index].layer.borderColor = circleIndicatorColor
                }
            }
        }
    }
    
    /// 遮罩颜色
    public var coverColor: UIColor = UIColor(white: 0.4, alpha: 0.5) {
        didSet {    // 监听数值 `coverColor` 的改变, 从而修改 `coverView` 的背景色
            if coverColor != oldValue {
                coverView.backgroundColor = coverColor
            }
        }
    }

    /// 选中颜色
    public var selectedColor: UIColor = .red {
        didSet {    // 监听数值 `selectedColor` 的改变, 从而修改当前label的选中颜色
            if selectedColor != oldValue {
                itemsLabel[itemSelectedIndex].textColor = selectedColor
            }
        }
    }
    
    /// 未选中颜色
    public var unSelectedColor: UIColor = .black {
        didSet {    // 监听数值 `unSelectedColor` 的改变, 从而修改当前label的未选中颜色
            if unSelectedColor != oldValue {
                itemsLabel[itemSelectedIndex].textColor = unSelectedColor
            }
        }
    }
    
    /// 遮罩高度
    public var coverHeight : CGFloat = 25.0 {
        didSet {    // 监听数值 `coverHeight` 的改变, 从而修改遮罩的高度
            if coverHeight != oldValue {
                coverView.frame.size.height = coverHeight
            }
        }
    }
    
    /// 指示器距离底部距离
    public var bottomPadding: CGFloat = 2.0 {
        didSet {
            
        }
    }
    
    /// 指示器高度
    public var indicatorHeight: CGFloat = 2.0 {
        didSet{      // 监听数值 `indicatorHeight` 的改变, 从而修改指示器的高度
            if indicatorHeight != oldValue {
                indicatorView.frame.size.height = indicatorHeight
            }
        }
    }
    
    // MARK: - 懒加载视图( Lazy loading )
    
    /// 指示器视图
    public lazy var indicatorView: UIView = UIView()
    
    /// 遮罩视图
    public lazy var coverView : UIView = UIView()
    
    /// 内容视图
    fileprivate lazy var mainScrollView: UIScrollView = UIScrollView()
    
    /// 菜单栏
    fileprivate lazy var tabScrollView: UIScrollView = {
        let tabScrollView = UIScrollView(frame: self.bounds)
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.backgroundColor = .clear
        return tabScrollView
    }()
    
    /// 底部长线
    private lazy var scrollLine: UIView = { [unowned self] in
        let scrollLine = UIView()
        let scrollLineH: CGFloat = 0.5
        scrollLine.backgroundColor = UIColor.lightGray
        scrollLine.frame = CGRect(x: 0, y: self.bounds.height - scrollLineH, width: self.bounds.width, height: scrollLineH)
        return scrollLine
    }()
    
    /// 背景模糊视图
    private lazy var blurView: UIVisualEffectView = { [unowned self] in
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = self.bounds
        return blurView
    }()
    
    
    //MARK: - 自定义构造函数( Custom initialization functions )
    ///
    /// - Parameters:
    ///   - frame: 尺寸
    ///   - titles: 标题数组
    ///   - childControllers: 控制器数组
    public init(frame: CGRect,titles: [String],childControllers: [UIViewController]) {
        self.titles = titles
        self.controllers = childControllers
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        addSubview(blurView)
        addSubview(scrollLine)
        configTabScrollView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 布局子视图( Layout subview )
    /*
     1、init初始化不会触发layoutSubviews, 
        但是是用initWithFrame 进行初始化时，当rect的值不为CGRectZero时,也会触发
     2、addSubview会触发layoutSubviews
     3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
     4、滚动一个UIScrollView会触发layoutSubviews
     5、旋转Screen会触发父UIView上的layoutSubviews事件
     6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
     */
     override open func layoutSubviews() {
        super.layoutSubviews()
        
        configMainScrollView()
    }
}



// MARK: - 方法(method)
extension LCSlideMenu {
    
    /// 配置主要滚动视图
    private func configMainScrollView() {
        if mainScrollView.superview == nil {
            mainScrollView.frame = (self.superview?.bounds)!
            self.superview?.insertSubview(mainScrollView, belowSubview: self)
            // 设置内容视图的相关属性
            mainScrollView.contentSize = CGSize(width: CGFloat(controllers.count) * mainScrollView.bounds.width, height: 0)
            mainScrollView.bounces = false
            mainScrollView.isPagingEnabled = true
            mainScrollView.delegate = self
        }
        configChildControllers()
    }
    
    /// 配置子控制器
    private func configChildControllers() {
        // 遍历控制器数组,将所有控制器都添加到 `mainScrollView` 中
        for (index,vc) in controllers.enumerated() {
            mainScrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(index) * mainScrollView.bounds.width, y: 0, width: mainScrollView.bounds.width, height: mainScrollView.bounds.height)
        }
    }
    
    /// 配置菜单栏
    private func configTabScrollView() {
        
        addSubview(tabScrollView)
        
        /// 边距X
        var originX = itemMargin
        
        // 遍历titles
        for (index,title) in titles.enumerated() {
            
            // 1.创建Label, 并设置其相关属性
            let label = UILabel()
            label.text = title
            label.font = itemFont
            label.isUserInteractionEnabled = true
            label.textAlignment = .center
            
            // 如果标签索引为:选中索引, 设置Label颜色为: 选中颜色, 否则为: 未选中颜色
            label.textColor = index == itemSelectedIndex ? selectedColor : unSelectedColor
            
            // 计算title长度
            // 根据文字来计算宽度
            let size = (title as NSString).size(withAttributes: [NSAttributedStringKey.font : itemFont])
            
            // 2.计算位置
            label.frame = CGRect(x: originX, y: 0, width: size.width + itemMargin, height: self.bounds.height)
            
            // 添加tap手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
            label.addGestureRecognizer(tap)
            
            /*** 创建圆圈指示器,并设置其属性 ***/
            /// 圆圈指示器
            let circleIndicator = UIView()
            circleIndicator.frame = CGRect(x: label.frame.maxX, y: label.frame.origin.y + 5, width: circleIndicatorWidth, height: circleIndicatorWidth)
            circleIndicator.backgroundColor = .clear
            circleIndicator.layer.borderWidth = 2
            circleIndicator.layer.borderColor = circleIndicatorColor
            circleIndicator.layer.cornerRadius = circleIndicatorWidth * 0.5
            circleIndicator.layer.masksToBounds = true
            // 如果索引为:选中索引, 设置不透明, 否则:透明
            circleIndicator.alpha = index == itemSelectedIndex ? 1 : 0
            
            tabScrollView.addSubview(label)
            tabScrollView.addSubview(circleIndicator)
            itemsLabel.append(label)
            itemsView.append(circleIndicator)
            
            originX = label.frame.maxX + itemMargin * 2
        }
        // 3.设置scrollView的滚动范围
        tabScrollView.contentSize = CGSize(width: originX - itemMargin, height: self.bounds.height)
        tabScrollView.addSubview(indicatorView)
        
        // 4.如果item的长度小于当前视图的width，就重新计算margin排版
        if tabScrollView.contentSize.width < self.bounds.width {
            updateLabelsFrame()
        }
    }
    
    /// 配置指示器视图
    private func configIndicatorView() {
        
        /// 1.取出当前选中item的尺寸
        var frame = itemsLabel[itemSelectedIndex].frame
        frame.origin.y = self.bounds.height - bottomPadding - indicatorHeight
        frame.size.height = indicatorHeight
        
        // 2. 设置下标视图的相关属性
        indicatorView.frame = frame
        indicatorView.backgroundColor = selectedColor
        indicatorView.layer.cornerRadius = frame.height * 0.5
        indicatorView.layer.masksToBounds = true
    }
    
    /// 配置遮罩视图
    private func configCoverView() {
        
        tabScrollView.insertSubview(coverView, at: 0)
        
        guard let titleLabel = itemsLabel.first else { return }
        let coverX : CGFloat = titleLabel.frame.origin.x
        let coverW : CGFloat = titleLabel.frame.width
        let coverH : CGFloat = coverHeight
        let coverY : CGFloat = (titleLabel.frame.height - coverH) * 0.5
        
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        coverView.layer.cornerRadius = coverHeight * 0.4
        coverView.layer.masksToBounds = true
        coverView.backgroundColor = coverColor
    }
    
    
    /// 监听item点击事件
    ///
    /// - Parameter gesture: 点击手势识别器
    @objc fileprivate func labelClicked(_ gesture: UITapGestureRecognizer) {
        
        // 1.获取当前label
        guard let currentLabel = gesture.view as? UILabel else { return }
        
        // 如果是重复点击同一个Label,那么直接返回
        if currentLabel == itemsLabel[itemSelectedIndex] { return }
        
        // 2.获取之前的 label
        let currentIndex = itemSelectedIndex
        
        itemSelectedIndex = itemsLabel.index(of: currentLabel)!
        
        changeItemTitle(currentIndex, old: itemSelectedIndex)
        
        changeIndicatorViewPosition(currentIndex, old: itemSelectedIndex)
        
        changeCoverViewPosition(currentIndex, old: itemSelectedIndex)
        
        changeCircleIndicatorPosition(currentIndex, old: itemSelectedIndex)
        
        resetTabScrollViewContentOffset(currentLabel)
        
        resetMainScrollViewContentOffset(itemSelectedIndex)
    }
    
    /// 改变itemTitle的颜色
    ///
    /// - Parameters:
    ///   - current: 当前标题索引
    ///   - old: 之前标题索引
    private func changeItemTitle(_ current: Int, old: Int) {
        itemsLabel[current].textColor = unSelectedColor
        itemsLabel[old].textColor = selectedColor
        
        if titleStyle == .transfrom {   // 放大
            UIView.animate(withDuration: 0.25, animations: {
                self.itemsLabel[old].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.itemsLabel[current].transform = CGAffineTransform.identity
            })
        }
    }
    
    /// 改变indicatorView位置
    ///
    /// - Parameters:
    ///   - current: 当前标题索引
    ///   - old: 之前标题索引
    private func changeIndicatorViewPosition(_ current: Int, old: Int) {
        
        // 获取之前label的尺寸
        let frame = itemsLabel[old].frame
        
        let indicatorFrame = CGRect(x: frame.origin.x, y: indicatorView.frame.origin.y, width: frame.size.width, height: indicatorHeight)
        
        // 动画改变 indicatorView 的位置
        UIView.animate(withDuration: 0.25) {
            self.indicatorView.frame = indicatorFrame
        }
    }
    
    /// 改变coverView的位置
    ///
    /// - Parameters:
    ///   - current: 当前标题索引
    ///   - old: 之前标题索引
    private func changeCoverViewPosition(_ current: Int, old: Int) {
        
        // 获取之前label的尺寸
        let frame = itemsLabel[old].frame
        
        /// 遮罩视图的Frame
        let coverFrame = CGRect(x: frame.origin.x, y: coverView.frame.origin.y, width: frame.size.width, height: coverHeight)
        
        // 动画改变 coverView 的位置
        UIView.animate(withDuration: 0.25) {
            self.coverView.frame = coverFrame
        }
    }
    
    /// 改变CircleIndicator的位置
    ///
    /// - Parameters:
    ///   - current: 当前标题索引
    ///   - old: 之前标题索引
    private func changeCircleIndicatorPosition(_ current: Int, old: Int) {
        
        /// 获取当前的View
        let currentV = itemsView[current]
        /// 获取之前的View
        let oldV = itemsView[old]
        
        // 动画改变`CircleIndicator`的显示
        UIView.animate(withDuration: 0.25) {
            currentV.alpha = 0
            oldV.alpha = 1
            currentV.transform = .identity
            oldV.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    /// 当item过少时，更新itemLabel位置
    private func updateLabelsFrame() {
        
        let newMargin = itemMargin + (self.bounds.width - tabScrollView.contentSize.width) / CGFloat(itemsLabel.count * 2)
        var originX = newMargin
        
        for item in itemsLabel {
            var frame = item.frame
            frame.origin.x = originX
            item.frame = frame
            originX = frame.maxX + 2 * newMargin
        }
        tabScrollView.contentSize = CGSize(width: originX - newMargin, height: self.bounds.height)
    }
    
    
    /// 更新标题风格样式
    ///
    /// - Parameter progress: 进度
    private func updateTitleStyle(_ progress:CGFloat) {
        let leftItem = itemsLabel[leftIndex]
        let rightItem = itemsLabel[rightIndex]
        
        switch titleStyle {
        case .gradient: // 渐变
            leftItem.textColor = averageColor(currentColor: selectedColor, oldColor: unSelectedColor, percent: progress)
            rightItem.textColor = averageColor(currentColor: unSelectedColor, oldColor: selectedColor, percent: progress)
        case .normal:   // 默认
            leftItem.textColor = progress <= 0.5 ? selectedColor : unSelectedColor
            rightItem.textColor = progress <= 0.5 ? unSelectedColor : selectedColor
        default:       // .transfrom:放大
            if progress <= 0.5 {    // 如果进度 < 0.5
                leftItem.textColor = selectedColor
                rightItem.textColor = unSelectedColor
                UIView.animate(withDuration: 0.25, animations: {
                    leftItem.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    rightItem.transform = CGAffineTransform.identity
                })
            }else {
                leftItem.textColor = unSelectedColor
                rightItem.textColor = selectedColor
                UIView.animate(withDuration: 0.25, animations: {
                    leftItem.transform = CGAffineTransform.identity
                    rightItem.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                })
            }
            break
        }
    }
    
    
    /// 点击item 修改tabScrollView的偏移量
    ///
    /// - Parameter item: UILabel
    private func resetTabScrollViewContentOffset(_ item: UILabel) {
        
        // 标题居中
        // 本质: 修改标题滚动视图的偏移量
        // 偏移量 = label的中心 - 屏幕宽度的一半
        
        /// 偏移量x
        var destinationX: CGFloat = 0
        
        /// item的中心
        let itemCenterX = item.center.x
        
        /// 滚动视图宽度的一半
        let scrollHalfWidth = tabScrollView.bounds.width / 2
        
        //item中心点超过最高滚动范围时
        if tabScrollView.contentSize.width - itemCenterX < scrollHalfWidth {
            destinationX = tabScrollView.contentSize.width - scrollHalfWidth * 2
            tabScrollView.setContentOffset(CGPoint(x: destinationX, y: 0), animated: true)
            return
        }
        //item中心点低于最低滚动范围时
        if itemCenterX > scrollHalfWidth{
            destinationX = itemCenterX - scrollHalfWidth
            tabScrollView.setContentOffset(CGPoint(x: destinationX, y: 0), animated: true)
            return
        }
        // 滚动标题,带动画
        tabScrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
    }
    
    
    /// 点击item 修改mainScrollView的偏移量
    ///
    /// - Parameter index: 索引
    private func resetMainScrollViewContentOffset(_ index: Int) {
        mainScrollView.setContentOffset(CGPoint(x: CGFloat(index) * mainScrollView.bounds.width, y: 0), animated: false)
    }
    
    /// 处理normal状态下的indicatorView
    private func handleNormalIndicatorType(_ offsetX: CGFloat) {
        if offsetX <= 0 {
            //左边界
            leftIndex = 0
            rightIndex = 0
        } else if offsetX >= mainScrollView.contentSize.width {
            //右边界
            leftIndex = itemsLabel.count - 1
            rightIndex = leftIndex
        } else {
            //中间
            leftIndex = Int(offsetX / mainScrollView.bounds.width)
            rightIndex = leftIndex + 1
        }
        
        let ratio = offsetX / mainScrollView.bounds.width - CGFloat(leftIndex)
        if ratio == 0 { return }
        
        let leftItem = itemsLabel[leftIndex]
        let rightItem = itemsLabel[rightIndex]
        /// 总得移动距离
        let totalSpace = rightItem.center.x - leftItem.center.x
        indicatorView.center = CGPoint(x:leftItem.center.x + totalSpace * ratio, y: indicatorView.center.y)
    }
    
    /// 处理followText状态的 indicatorView
    fileprivate func handleFollowTextIndicatorType(_ offsetX: CGFloat) {
        if offsetX <= 0 {
            //左边界
            leftIndex = 0
            rightIndex = 0
        } else if offsetX >= mainScrollView.contentSize.width {
            //右边界
            leftIndex = itemsLabel.count - 1
            rightIndex = leftIndex
        } else {
            //中间
            leftIndex = Int(offsetX / mainScrollView.bounds.width)
            rightIndex = leftIndex + 1
        }
        /// 比例
        let ratio = offsetX / mainScrollView.bounds.width - CGFloat(leftIndex)
        if ratio == 0 { return }
        
        let leftItem = itemsLabel[leftIndex]
        let rightItem = itemsLabel[rightIndex]
        
        var frame = self.indicatorView.frame
        let leftItemWidth: CGFloat = leftItem.frame.width
        let leftItemFrameMinX: CGFloat = leftItem.frame.minX
        let rightItemWidth: CGFloat = rightItem.frame.width
        let rightItemFrameMaxX: CGFloat = rightItem.frame.maxX
        
        /// 间距
        let distance: CGFloat = indicatorType == .stretch ? 0 : indicatorAnimatePadding
        
        /// 最大宽度: 右边Item最大X值 - 左边Item最小X值 - 2倍间距
        let maxWidth = rightItemFrameMaxX - leftItemFrameMinX - distance * 2
        
        if ratio <= 0.5 {
            frame.size.width = leftItemWidth + (maxWidth - leftItemWidth) * (ratio / 0.5)
            frame.origin.x = leftItemFrameMinX + distance * (ratio / 0.5)
        } else {
            frame.size.width = rightItemWidth + (maxWidth - rightItemWidth) * ((1 - ratio) / 0.5)
            frame.origin.x = rightItemFrameMaxX - frame.size.width - distance * ((1 - ratio) / 0.5)
        }
        
        self.indicatorView.frame = frame
    }
    
    
    /// 处理cover状态
    ///
    /// - Parameter offsetX: 偏移量
    fileprivate func handleCoverType(_ offsetX: CGFloat) {
        
        if offsetX <= 0 {
            //左边界
            leftIndex = 0
            rightIndex = 0
        } else if offsetX >= mainScrollView.contentSize.width {
            //右边界
            leftIndex = itemsLabel.count - 1
            rightIndex = leftIndex
        } else {
            //中间
            leftIndex = Int(offsetX / mainScrollView.bounds.width)
            rightIndex = leftIndex + 1
        }
        /// 比例
        let ratio = offsetX / mainScrollView.bounds.width - CGFloat(leftIndex)
        if ratio == 0 { return }
        
        let leftItem = itemsLabel[leftIndex]
        let rightItem = itemsLabel[rightIndex]
        
        var frame = self.coverView.frame
        let leftItemWidth: CGFloat = leftItem.frame.width
        let leftItemFrameMinX: CGFloat = leftItem.frame.minX
        let rightItemWidth: CGFloat = rightItem.frame.width
        let rightItemFrameMaxX: CGFloat = rightItem.frame.maxX
        
        /// 间距
        let distance: CGFloat = indicatorType == .cover ? 0 : 8
        
        /// 最大宽度: 右边Item最大X值 - 左边Item最小X值 - 2倍间距
        let maxWidth = rightItem.frame.maxX - leftItem.frame.minX - distance * 2
        
        if ratio <= 0.5 {
            frame.size.width = leftItemWidth + (maxWidth - leftItemWidth) * (ratio / 0.5)
            frame.origin.x = leftItemFrameMinX + distance * (ratio / 0.5)
        } else {
            frame.size.width = rightItemWidth + (maxWidth - rightItemWidth) * ((1 - ratio) / 0.5)
            frame.origin.x = rightItemFrameMaxX - frame.size.width - distance * ((1 - ratio) / 0.5)
        }
        self.coverView.frame = frame
        
    }
    
    /// 处理circle状态
    ///
    /// - Parameter offsetX: 偏移量
    fileprivate func handleCircleType(_ offsetX: CGFloat) {
        
        if offsetX <= 0 {   //左边界
            leftIndex = 0
            rightIndex = 0
        } else if offsetX >= mainScrollView.contentSize.width { //右边界
            leftIndex = itemsLabel.count - 1
            rightIndex = leftIndex
        } else {        //中间
            leftIndex = Int(offsetX / mainScrollView.bounds.width)
            rightIndex = leftIndex + 1
        }
        /// 左边视图
        let leftItem = itemsView[leftIndex]
        /// 右边视图
        let rightItem = itemsView[rightIndex]
        /// 进度
        let progress = offsetX / mainScrollView.bounds.width - CGFloat(leftIndex)
        if progress == 0 { return }
        
        if progress <= 0.5 {
            UIView.animate(withDuration: 0.25, animations: {
                leftItem.transform = CGAffineTransform(scaleX: CGFloat(1 - progress), y: CGFloat(1 - progress))
                leftItem.alpha = 1
                rightItem.alpha = 0
            })
        }else {
            UIView.animate(withDuration: 0.25, animations: {
                rightItem.transform = CGAffineTransform(scaleX: CGFloat(progress), y: CGFloat(progress))
                leftItem.alpha = 0
                rightItem.alpha = 1
            })
        }
    }
    
    /// 渐变颜色
    ///
    /// - Parameters:
    ///   - currentColor: 当前颜色
    ///   - oldColor: 之前颜色
    ///   - percent: 百分比
    /// - Returns: UIColor
    fileprivate func averageColor(currentColor: UIColor, oldColor: UIColor, percent: CGFloat) -> UIColor {
        var currentRed:CGFloat = 0.0
        var currentGreen:CGFloat = 0.0
        var currentBlue:CGFloat = 0.0
        var currentAlpha:CGFloat = 0.0
        
        // 获取RGB颜色空间中组成颜色的组件
        currentColor.getRed(&currentRed, green: &currentGreen, blue: &currentBlue, alpha: &currentAlpha)
        
        var oldRed:CGFloat = 0.0
        var oldGreen:CGFloat = 0.0
        var oldBlue:CGFloat = 0.0
        var oldAlpha:CGFloat = 0.0
        
        // 获取RGB颜色空间中组成颜色的组件
        oldColor.getRed(&oldRed, green: &oldGreen, blue: &oldBlue, alpha: &oldAlpha)
        
        let nowRed = currentRed + (oldRed - currentRed) * percent
        let nowGreen = currentGreen + (oldGreen - currentGreen) * percent
        let nowBlue = currentBlue + (oldBlue - currentBlue) * percent
        let nowAlpha = currentAlpha + (oldAlpha - currentAlpha) * percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
}


//MARK: - UIScrollViewDelegate
extension LCSlideMenu: UIScrollViewDelegate {
    
    // 当scrollview处于滚动状态时, offset发生改变,就会调用此函数. 直到停止.
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        /// 滚动视图横向(x)移动数值
        let offsetX = scrollView.contentOffset.x
        switch indicatorType {
        case .normal:
            handleNormalIndicatorType(offsetX)
        case .stretch:
            handleFollowTextIndicatorType(offsetX)
        case .followText:
            handleFollowTextIndicatorType(offsetX)
        case .cover:
            handleCoverType(offsetX)
        case .circle:
            handleCircleType(offsetX)
        }
        
        //计算偏移的相对位移
        let relativeLacation = mainScrollView.contentOffset.x / mainScrollView.frame.width - CGFloat(leftIndex)
        if relativeLacation == 0 { return }
        //更新UI
        updateTitleStyle(relativeLacation)
    }
    
    // 结束减速时触发（减速到停止）
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // 根据滚动视图的横向移动数值 和 宽度值 ,计算当前页码
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        /// 当前item
        let currentItem = itemsLabel[currentPage]
        
        /// 获取当前item的手势
        let tap = currentItem.gestureRecognizers
        
        labelClicked(tap?.first as! UITapGestureRecognizer)
    }
}
