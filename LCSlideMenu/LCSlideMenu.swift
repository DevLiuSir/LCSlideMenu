//
//  LCSlideMenu.swift
//  LCSlideMenu
//
//  Created by Liu Chuan on 2017/1/14.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 选择菜单指示器标题样式
///
/// - normal: 默认
/// - gradient: 渐变颜色
/// - transfrom: 放大
enum LCSlideMenuTitleStyle {
    case normal
    case gradient
    case transfrom
}

/// 选择菜单指示器风格
///
/// - normal: 默认
/// - stretch: 伸缩
/// - followText: 跟随文本长度
enum LCSlideMenuIndicatorStyle {
    case normal
    case stretch
    case followText
}

// MARK: - 滑动菜单
class LCSlideMenu: UIView {
    
    //MARK: - 属性
    
    /// 指示器类型
    var indicatorType: LCSlideMenuIndicatorStyle = .normal
    
    /// 标题样式
    var titleStyle: LCSlideMenuTitleStyle = .normal
    
    /// 标题数组
    private var titles: [String]
    
    /// 定义一个数组, 记录UILabel
    fileprivate var itemsLabel: [UILabel] = []
    
    /// 控制器数组
    private var controllers: [UIViewController]
    
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
    
    /// 菜单栏
    private lazy var tabScrollView: UIScrollView = {
        let tabScrollView = UIScrollView(frame: self.bounds)
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.backgroundColor = .clear
        return tabScrollView
    }()
    
    /// 内容视图
    fileprivate lazy var mainScrollView: UIScrollView = UIScrollView()
    
    /// 指示器视图
    private lazy var indicatorView: UIView = UIView()
    
    /// 底部长线
    private lazy var scrollLine: UIView = { [unowned self] in
        let scrollLine = UIView()
        let scrollLineH: CGFloat = 0.5     // 底部长线的高度
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
    
    /// 标题字体
    var itemFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
        
        }
    }
    
    /// 选中颜色
    var selectedColor: UIColor = .red {
        didSet {
        
        }
    }
    
    /// 未选中颜色
    var unSelectedColor: UIColor = .black {
        didSet {
            
        }
    }
    
    /// 下标距离底部距离
    var bottomPadding: CGFloat = 2.0 {
        didSet {
        
        }
    }
    
    /// 下标高度
    var indicatorHeight: CGFloat = 2.0 {
        didSet{
        
        }
    }
    
    //MARK: - 自定义构造函数
    ///
    /// - Parameters:
    ///   - frame: 尺寸
    ///   - titles: 标题数组
    ///   - childControllers: 控制器数组
    init(frame: CGRect,titles: [String],childControllers: [UIViewController]) {
        
        self.titles = titles
        controllers = childControllers
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        addSubview(blurView)
        addSubview(scrollLine)
        
        configTabScrollView()
        configIndicatorView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 布局子视图
    /*
     1、init初始化不会触发layoutSubviews, 
        但是是用initWithFrame 进行初始化时，当rect的值不为CGRectZero时,也会触发
     2、addSubview会触发layoutSubviews
     3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
     4、滚动一个UIScrollView会触发layoutSubviews
     5、旋转Screen会触发父UIView上的layoutSubviews事件
     6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configMainScrollView()
    }
    
    // MARK: - 方法(method)
    
    /// 配置主要滚动视图 -> 控制器滑动scrollView
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
        // 遍历控制器数组
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
            
            // 创建Label, 并设置其相关属性
            let label = UILabel()
            label.text = title
            label.font = itemFont
            // 如果标签索引为:选中索引, 设置Label颜色为: 选中颜色, 否则为: 未选中颜色
            label.textColor = index == itemSelectedIndex ? selectedColor : unSelectedColor
            label.isUserInteractionEnabled = true
            
            // 计算title长度
            // 根据文字来计算宽度
            let size = (title as NSString).size(withAttributes: [NSAttributedStringKey.font : itemFont])
           
            label.frame = CGRect(x: originX, y: 0, width: size.width, height: self.bounds.height)
            // 添加tap手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
            label.addGestureRecognizer(tap)
            
            tabScrollView.addSubview(label)
            itemsLabel.append(label)
            
            originX = label.frame.maxX + itemMargin * 2
        }
        // 设置scrollView的滚动范围
        tabScrollView.contentSize = CGSize(width: originX - itemMargin, height: self.bounds.height)
        
        tabScrollView.addSubview(indicatorView)
        
        //如果item的长度小于self的width，就重新计算margin排版
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
    
    /// 监听item点击事件
    ///
    /// - Parameter gesture: 手势
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
    func updateTitleStyle(_ progress:CGFloat) {
        let leftItem = itemsLabel[leftIndex]
        let rightItem = itemsLabel[rightIndex]
        
        switch titleStyle {
        case .gradient: // 渐变
            leftItem.textColor = averageColor(currentColor: selectedColor, oldColor: unSelectedColor, percent: progress)
            rightItem.textColor = averageColor(currentColor: unSelectedColor, oldColor: selectedColor, percent: progress)
        case .normal:   // 默认
            leftItem.textColor = progress <= 0.5 ? selectedColor : unSelectedColor
            rightItem.textColor = progress <= 0.5 ? unSelectedColor : selectedColor
        default:
            if progress <= 0.5 {    // 如果进度 < 0.5
                leftItem.textColor = selectedColor
                rightItem.textColor = unSelectedColor
                UIView.animate(withDuration: 0.25, animations: { 
                    leftItem.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    rightItem.transform = CGAffineTransform.identity
                })
            } else {
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
    fileprivate func handleNormalIndicatorType(_ offsetX: CGFloat) {
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
        /// 间距
        let distance: CGFloat = indicatorType == .stretch ? 0 : indicatorAnimatePadding
        var frame = self.indicatorView.frame
        let maxWidth = rightItem.frame.maxX - leftItem.frame.minX - distance * 2
        if ratio <= 0.5 {
            frame.size.width = leftItem.frame.width + (maxWidth - leftItem.frame.width) * (ratio / 0.5)
            frame.origin.x = leftItem.frame.minX + distance * (ratio / 0.5)
        } else {
            frame.size.width = rightItem.frame.width + (maxWidth - rightItem.frame.width) * ((1 - ratio) / 0.5)
            frame.origin.x = rightItem.frame.maxX - frame.size.width - distance * ((1 - ratio) / 0.5)
        }
        
        self.indicatorView.frame = frame
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
    
    // MARK: 当scrollview处于滚动状态时, offset发生改变,就会调用此函数. 直到停止.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /// 滚动视图横向(x)移动数值
        let offsetX = scrollView.contentOffset.x
        switch indicatorType {
        case .normal:
            handleNormalIndicatorType(offsetX)
        case .stretch:
            handleFollowTextIndicatorType(offsetX)
        case .followText:
            handleFollowTextIndicatorType(offsetX)
        }
        
        //计算偏移的相对位移
        let relativeLacation = mainScrollView.contentOffset.x / mainScrollView.frame.width - CGFloat(leftIndex)
        if relativeLacation == 0 { return }
        //更新UI
        updateTitleStyle(relativeLacation)
    }
    
    // MARK: 结束减速时触发（减速到停止）
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // 根据滚动视图的横向移动数值 和 宽度值 ,计算当前页码
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        /// 当前item
        let currentItem = itemsLabel[currentPage]
        
        /// 获取当前item的手势
        let tap = currentItem.gestureRecognizers
        
        labelClicked(tap?.first as! UITapGestureRecognizer)
    }
    
}
