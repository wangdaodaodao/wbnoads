#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 使用前向声明替代导入头文件
@interface WBLaunchNewViewController : UIViewController
- (id)_fastLoadSplashAdUid;
- (void)showPushSplashAd;
- (void)abandonSplashAd;
- (void)asyncLoadPushSplashAd;
- (void)asyncLoadSplashAd;
@end

// 添加新的接口声明
@interface WBSSquareRefreshAttributionLogService : NSObject
@property(nonatomic) BOOL bSplashAdShowing;
- (BOOL)bShowingSplashAd;
@end

// 添加品牌广告相关的前向声明
@interface WBPageCardBrandAdvertisementCardView : UIView
@end

@interface WBPageCardBrandAdvertisementCard : NSObject
- (BOOL)isValid;
@end

@interface WBPageCardBrandAdvertisementCardSubItem : NSObject
- (BOOL)isValid;
@end

@interface WBPageCardBrandAdvertisementAvatarView : UIView
@end

@interface WBPageCardBrandAdvertisementCardCapsuleSGTitleView : UIView
@end

@interface WBPageCardBrandAdvertisementCardCapsuleButton : UIButton
@end

// 添加新的广告相关声明
@interface WBUniversalStatus : NSObject
@property(nonatomic) BOOL isAd;
@end

@interface WBStatus : NSObject
- (BOOL)vp_isAdVideo;
@end

@interface WBLBasePlaybackItem : NSObject
@property(nonatomic) BOOL isAd;
@end

@interface WBVideoAccountsHeaderView : UIView
@property(nonatomic) BOOL isAd;
@end

@interface WBVideoShareContentView : UIView
@property(nonatomic) BOOL isAd;
@end

@interface WBAdWeiboProxy : NSObject
+ (BOOL)isAdFeatureEnabled:(id)arg1;
- (BOOL)isAdFeatureEnabledLaunchGet:(id)arg1;
- (BOOL)isAdFeatureEnabledServerPolicy:(id)arg1;
- (BOOL)isAdFeatureEnabledLifeCyclePolicy:(id)arg1;
- (BOOL)isAdFeatureEnabled:(id)arg1;
@end

@interface WBSTCardChallengeNormalHeaderView : UIView
- (BOOL)shouldShowSponsorNameLabel;
- (BOOL)showSponsorActionLabel;
- (BOOL)shouldShowSponsor;
@end

@interface WBSTCardChallengeAdHeaderView : UIView
- (BOOL)showSponsorActionLabel;
- (BOOL)shouldShowSponsorNameLabel;
- (BOOL)shouldShowSponsor;
@end

// 开屏广告处理
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

// 去除刷新，后台后开屏广告重新出现
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

// 处理品牌广告卡
%hook WBPageCardBrandAdvertisementCardView
- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}
%end

// 处理品牌广告卡片的基类
%hook WBPageCardBrandAdvertisementCard
- (BOOL)isValid {
    return NO;
}
%end

// 处理图片查看器中的广告
%hook WBPhotoViewerViewController
- (void)showFlowAdvertisementView:(id)arg1 {
    return;
}

- (void)creatAdvertisementView {
    return;
}
%end

// 处理 Feed 流广告
%hook WBNormalFeedGroup
- (void)resetAdvertisements {
    %orig;
}
%end

// 处理广告加载
%hook WBAdDebugAvailableAdController
- (void)loadAdvertisement {
    return;
}

- (void)assembleAdvertisement:(id)arg1 {
    return;
}

- (void)assembleDataCacheAdvertisement:(id)arg1 {
    return;
}
%end

// 处理品牌广告卡片子项
%hook WBPageCardBrandAdvertisementCardSubItem
- (BOOL)isValid {
    return NO;
}
%end

// 处理品牌广告头像视图
%hook WBPageCardBrandAdvertisementAvatarView
- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}
%end

// 处理品牌广告标题视图
%hook WBPageCardBrandAdvertisementCardCapsuleSGTitleView
- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}
%end

// 处理品牌广告按钮
%hook WBPageCardBrandAdvertisementCardCapsuleButton
- (void)layoutSubviews {
    %orig;
    self.hidden = YES;
}
%end

// 处理普通挑战卡片头部的赞助内容
%hook WBSTCardChallengeNormalHeaderView
- (BOOL)shouldShowSponsorNameLabel {
    return NO;
}

- (BOOL)showSponsorActionLabel {
    return NO;
}

- (BOOL)shouldShowSponsor {
    return NO;
}
%end

// 处理广告挑战卡片头部的赞助内容
%hook WBSTCardChallengeAdHeaderView
- (BOOL)showSponsorActionLabel {
    return NO;
}

- (BOOL)shouldShowSponsorNameLabel {
    return NO;
}

- (BOOL)shouldShowSponsor {
    return NO;
}
%end

// 处理赞助事件
%hook TaoLiveUserTrackController
- (void)commitSponsorshipShowEvent:(id)arg1 {
    return;
}
%end

// 处理Feed流推荐
%hook WBLBottomRecommendModule
- (BOOL)recommendVisible {
    return NO;
}
%end

// 处理Feed流推荐列表
%hook WBFeedHotNewChannelListView 
- (void)setupCurrentChannels:(id)arg1 recommendChannels:(id)arg2 unusedChannels:(id)arg3 {
    %orig(arg1, nil, arg3);
}
%end

// 处理视频推荐
%hook WBVideoRecommendViewManager
- (id)recommendViewShowDictionary {
    return nil;
}
%end

// 处理文章推荐
%hook WBArticleSlideBRecommendViewController
- (void)viewDidLoad {
    return;
}
%end

// 处理头条文章推荐
%hook WBNewHeadlineArticleViewController
- (void)viewDidLoad {
    %orig;
}

- (void)viewWillAppear:(BOOL)animated {
    %orig;
}

// 拦截所有推荐相关的方法，返回nil
- (id)recommendViewController {
    return nil;
}

- (id)recommendHintView {
    return nil;
}

- (id)recommendTipView {
    return nil;
}

// 阻止推荐相关的视图加载
- (void)loadRecommendView {
    return;
}

- (void)setupRecommendView {
    return;
}

- (void)showRecommendView {
    return;
}

// 拦截推荐相关的 setter 方法
- (void)setRecommendViewController:(id)controller {
    return;
}

- (void)setRecommendHintView:(id)view {
    return;
}

- (void)setRecommendTipView:(id)view {
    return;
}
%end

// 处理用户推荐
%hook WBNewRecommendEngine
- (void)loadData {
    return;
}
%end

// 处理热门推荐
%hook WBHotDataService
- (NSMutableArray *)recommendChannels {
    return nil;
}
%end

// 处理推荐弹窗
%hook WBSGPageRecommendPopup
- (void)show {
    return;
}

- (void)showInView:(id)arg1 {
    return;
}

- (BOOL)isVisible {
    return NO;
}
%end

// 处理用户兴趣推荐
%hook WBPageCardNewUserInterestView
- (id)initWithFrame:(CGRect)frame {
    return nil;
}

- (void)didMoveToSuperview {
    return;
}
%end

// 处理相似用户推荐
%hook WBProfileSimilarRecommendContentView
- (id)initWithFrame:(CGRect)frame {
    return nil;
}

- (void)didMoveToSuperview {
    return;
}
%end

// 处理关注推荐
%hook WBPopFollowedRecommondControl
- (void)didMoveToSuperview {
    return;
}
%end

// 处理视频播放完成推荐
%hook WBVideoItemRecommendVideoPlayGuideModule
- (id)initWithFrame:(CGRect)frame {
    return nil;
}

- (void)didMoveToSuperview {
    return;
}

- (BOOL)isVisible {
    return NO;
}

- (void)show {
    return;
}
%end

// 处理短视频推荐
%hook WBSVideoStreamCollectionOverlayView
- (void)recommendNewSpot:(id)arg1 {
    return;
}
%end

// 处理故事推荐
%hook WBStoryRecommendTableViewCell
- (id)initWithFrame:(CGRect)frame {
    return nil;
}

- (void)didMoveToSuperview {
    return;
}
%end