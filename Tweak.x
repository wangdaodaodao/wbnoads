#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//==============================================================================
// 类声明部分
//==============================================================================
// 开屏广告相关（用于 1️⃣）
@interface WBLaunchNewViewController : UIViewController
- (id)_fastLoadSplashAdUid;
- (void)showPushSplashAd;
- (void)abandonSplashAd;
- (void)asyncLoadPushSplashAd;
- (void)asyncLoadSplashAd;
@end

@interface WBSSquareRefreshAttributionLogService : NSObject
@property(nonatomic) BOOL bSplashAdShowing;
- (BOOL)bShowingSplashAd;
@end

// 故事流相关（用于 2️⃣）
@interface WBStoryItemCollectionView : UIView
@end

@interface WBStoryItemCollectionViewCell : UICollectionViewCell
@end

@interface WBStoryItemListController : UIViewController
@end

// 浮动视图相关（用于 3️⃣）
@interface WBFloatingViewManager : NSObject
@end

@interface WBFloatViewContainer : UIView
@end

// 导航栏相关（用于 4️⃣ 5️⃣）
@interface WBNavLotteryButton : UIButton
@end

@interface WBNavEventLotteryHandler : NSObject
@property(retain, nonatomic) WBNavLotteryButton *lotteryButton;
@end

@interface WBNavigationBarButton : UIButton
@end

// 时间线相关（用于 6️⃣）
@interface WBTimelineExtendPageView : UIButton
@end

// UI 组件相关（用于 7️⃣-1️⃣3️⃣）
@interface WBContentHeaderCardCell : UITableViewCell
@end

@interface WBFeedReadStatusButton : UIButton
@end

@interface WBContentHeaderShareCell : UITableViewCell
@end

@interface WBContentHeaderTrendCell : UITableViewCell
@end

@interface WBContentFollowUserView : UIView
@end

@interface SpecialBgImageView : UIView
@end

@interface WBStyleButton : UIButton
@end

// 状态视图相关（用于 1️⃣2️⃣）
@interface WBStatusViewModel : NSObject
@end

@interface WBStatusContentView : UIView
- (void)setSpecialBgImageViewWithURL:(id)arg1;
- (void)setCustomBackgroundImageView:(SpecialBgImageView *)view;
@end


//==============================================================================
// 1️⃣ 移除开屏广告
//==============================================================================

%hook WBLaunchNewViewController

// 阻止加载开屏广告 UID
- (id)_fastLoadSplashAdUid {
    return nil;
}

// 阻止显示开屏广告
- (void)showPushSplashAd {
    return;
}

// 主动放弃开屏广告
- (void)abandonSplashAd {
    %orig;
}

// 阻止异步加载推送开屏广告
- (void)asyncLoadPushSplashAd {
    return;
}

// 阻止异步加载开屏广告
- (void)asyncLoadSplashAd {
    return;
}

// 处理视图加载
- (void)viewDidLoad {
    %orig;
}

// 加快启动消失
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    [self abandonSplashAd];
}

%end

// 防止开屏广告在后台刷新后重新出现
%hook WBSSquareRefreshAttributionLogService

- (void)setBSplashAdShowing:(BOOL)showing {
    %orig(NO);
}

- (BOOL)bSplashAdShowing {
    return NO;
}

- (BOOL)bShowingSplashAd {
    return NO;
}

%end

//==============================================================================
// 2️⃣ 移除故事流广告
//==============================================================================

// 主要的事集合视图
%hook WBStoryItemCollectionView

- (void)layoutSubviews {
    return;
}

- (void)setHidden:(BOOL)hidden {
    %orig(YES);
}

- (CGRect)frame {
    CGRect frame = %orig;
    frame.size.height = 0;
    return frame;
}

%end

// 故事单元格
%hook WBStoryItemCollectionViewCell

- (void)layoutSubviews {
    return;
}

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

%end

// 故事列表控制器
%hook WBStoryItemListController

- (void)viewDidLoad {
    return;
}

- (id)init {
    return nil;
}

%end

//==============================================================================
// 3️⃣ 移除浮动红包广告
//==============================================================================

// 浮动视图管理器
%hook WBFloatingViewManager

- (id)init {
    return nil;
}

- (void)showFloatingView:(id)view {
    return;
}

%end

// 浮动视图容器
%hook WBFloatViewContainer

- (void)layoutSubviews {
    return;
}

- (void)setHidden:(BOOL)hidden {
    %orig(YES);
}

- (CGRect)frame {
    CGRect frame = %orig;
    frame.size.height = 0;
    frame.size.width = 0;
    return frame;
}

%end

//==============================================================================
// 4️⃣ 移除导航栏抽奖按钮
//==============================================================================

// 处理抽奖按钮
%hook WBNavLotteryButton

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

- (void)layoutSubviews {
    return;
}

- (void)setHidden:(BOOL)hidden {
    %orig(YES);
}

%end

// 处理抽奖事件处理器
%hook WBNavEventLotteryHandler

- (id)init {
    return nil;
}

- (void)setLotteryButton:(WBNavLotteryButton *)button {
    %orig(nil);
}

%end

//==============================================================================
// 5️⃣ 移除导航栏日历按钮
//==============================================================================

%hook WBNavigationBarButton

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}

%end

//==============================================================================
// 6️⃣ 移除时间线扩展页面
//==============================================================================

%hook WBTimelineExtendPageView

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
    // 强制更新父视图布局
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
}

- (CGRect)frame {
    return CGRectZero;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeZero;
}

- (CGSize)intrinsicContentSize {
    return CGSizeZero;
}

%end

//==============================================================================
// 7️⃣ 移除内容头部卡片广告
//==============================================================================

%hook WBContentHeaderCardCell

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
    // 强制更新父视图布局
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
}

- (CGFloat)height {
    return 0;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeZero;
}

- (CGSize)intrinsicContentSize {
    return CGSizeZero;
}

// 处理 tableView 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

%end

//==============================================================================
// 8️⃣ 移除信息流阅读状态按钮
//==============================================================================

%hook WBFeedReadStatusButton

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
    // 强制更新父视图布局
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeZero;
}

- (CGSize)intrinsicContentSize {
    return CGSizeZero;
}

%end

//==============================================================================
// 9️⃣ 移除内容头部分享单元格
//==============================================================================

%hook WBContentHeaderShareCell

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}

%end

//==============================================================================
// 🔟 移除内容头部趋势单元格
//==============================================================================

%hook WBContentHeaderTrendCell

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}

%end

//==============================================================================
// 1️⃣1️⃣ 移除评论上方浮动关注用户弹窗
//==============================================================================

%hook WBContentFollowUserView

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}

- (CGFloat)height {
    return 0;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeZero;
}

%end

//==============================================================================
// 1️⃣2️⃣ 移除微博特殊背景图片
//==============================================================================

%hook SpecialBgImageView

- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}

- (CGRect)frame {
    return CGRectZero;
}

%end

%hook WBStatusContentView

- (void)setSpecialBgImageViewWithURL:(id)arg1 {
    return;
}

- (void)setCustomBackgroundImageView:(SpecialBgImageView *)view {
    %orig(nil);
}

%end

%hook WBStatusViewModel

- (BOOL)shouldShowSpecialBgImageView {
    return NO;
}

%end

//==============================================================================
// 1️⃣3️⃣ 移除微博右方关注样式按钮
//==============================================================================

%hook WBStyleButton

// 处理关注按钮
- (void)layoutSubviews {
    %orig;
    
    // 获取按钮的标题
    NSString *title = [self titleForState:UIControlStateNormal];
    if(!title) return;
    
    // 隐藏关注按钮
    if([title isEqualToString:@"关注"] || 
       [title isEqualToString:@"+ 关注"] ||
       [title isEqualToString:@"+关注"]) {
        self.hidden = YES;
        
        // 强制父视图布局
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }
}

// 处理按钮尺寸
- (CGSize)sizeThatFits:(CGSize)size {
    CGSize origSize = %orig;
    
    // 获取按钮的标题
    NSString *title = [self titleForState:UIControlStateNormal];
    if(!title) return origSize;
    
    // 如果关注按钮，返回零尺寸
    if([title isEqualToString:@"关注"] || 
       [title isEqualToString:@"+ 关注"] ||
       [title isEqualToString:@"+关注"]) {
        return CGSizeZero;
    }
    
    return origSize;
}

%end
