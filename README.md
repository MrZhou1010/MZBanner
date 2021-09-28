# MZBanner

自动轮播图（图片+文字+自定义PageControl）

效果图:

![image](https://github.com/MrZhou1010/MZBanner/blob/master/demoImage/demo1.png)![image](https://github.com/MrZhou1010/MZBanner/blob/master/demoImage/demo2.png)![image](https://github.com/MrZhou1010/MZBanner/blob/master/demoImage/demo3.png)![image](https://github.com/MrZhou1010/MZBanner/blob/master/demoImage/demo4.png)![image](https://github.com/MrZhou1010/MZBanner/blob/master/demoImage/demo5.png)![image](https://github.com/MrZhou1010/MZBanner/blob/master/demoImage/demo6.png)

实现:

一.自定义PageControl

    属性:
    1.page个数 numberOfPages
    2.page间隔 pageSpacing
    3.page大小 pageSize
    4.当前page大小 currentPageSize
    5.page位置 alignment
    6.page圆角 pageCornerRadius
    7.当前page圆角 currentPageCornerRadius
    8.当前page currentPage
    9.page颜色 pageIndicatorTintColor
    10.当前page颜色 currentPageIndicatorTintColor
    11.以image作为page pageImage
    12.当前page的image currentPageImage
    13.是否显示page的序号 isShowPageNumber
    14.page的序号文字颜色 pageNumberColor
    15.page的序号文字字体 pageNumberFont
    16.当前page的序号文字颜色 currentPageNumberColor
    17.当前page的序号文字字体 currentPageNumberFont
    18.是否显示page的边框 isShowPageBorder
    19.page的边框宽度 pageBorderWidth
    20.page的边框颜色 pageBorderColor
    21.当前page的边框宽度 currentPageBorderWidth
    22.当前page的边框颜色 currentPageBorderColor
    23.是否可以点击page isClickEnable
    24.点击page的回调 pageClickBlock
    25.是否动画 isAnimationEnable
    注：当前动画仅在当前page和其他page高度相同时有较好效果,对高度不一样的、以image作为page、添加序号的会存在问题

二.自动轮播图Banner

    属性:
    1.自动轮播 isAutomatic
    2.无穷值 isInfinite
    3.轮播时间间隔 timeInterval
    4.轮播方向 scrollDirection
    5.占位图 placeholderImage
    6.item的大小 itemSize
    7.中间item的放大比例 itemZoomScale
    8.item的间距 itemSpacing
    9.item的圆角 itemCornerRadius
    10.item的边框 itemBorderWidth
    11.item的边框颜色 itemBorderColor
    12.图片的填充模式 imageContentMode
    13.文本高度 titleViewHeight
    14.文本颜色 titleColor
    15.文本字体 titleFont
    16.文本对齐方式 titleAlignment
    17.文本背景颜色 titleBackgroundColor
    18.文本默认为单行显示 titleNumberOfLines
    19.文本的breakMode titleLineBreakMode
    20.是否显示pageControl showPageControl
    .
    .
    .
    
    回调事件:
    1.选中item的事件回调 didSelectedItem
    2.滚动到某一位置的事件回调 didScrollToIndex
    
    方法:
    1.设置本地轮播图片
    setImagesGroup(_ imagesGroup: [UIImage]?, titlesGroup: [String]? = nil, attributedTitlesGroup: [NSAttributedString]? = nil)
    2.设置网络轮播图片
    setImageUrlsGroup(_ urlsGroup: [String]?, titlesGroup: [String]? = nil, attributedTitlesGroup: [NSAttributedString]? = nil)
    3.设置轮播文字
    setTitlesGroup(_ titlesGroup: [String]?, attributedTitlesGroup: [NSAttributedString]? = nil)
    4.设置本地描述图标
    setTitleImagesGroup(_ titleImagesGroup: [UIImage]?, sizeGroup: [CGSize]?)
    5.设置网络描述图标
    setTitleImageUrlsGroup(_ titleImageUrlsGroup: [String]?, sizeGroup:[CGSize]?)
