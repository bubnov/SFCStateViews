//
//  SFCStateView.h
//  SFCStateViews
//
//  Created by Bubnov Slavik on 10/18/11.
//  Copyright (c) 2011 Slavik Bubnov, bubnovslavik@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SFCStateView.h"


@protocol SFCStateViewDelegate;

/**
 Base state view class
 
 State view is a view that represent defined state of the view 
 (e.g. 'loading', 'error', 'no data', etc.)
 
 Every view can contain only one state view at a time.
 */
@interface SFCStateView : UIView {
 @protected
   __weak id<SFCStateViewDelegate> _delegate;
   IBOutlet UIView *_contentView;
   BOOL _keepStateViewBackgroundColor;
   CGFloat _showDuration;
   CGFloat _hideDuration;
}

@property (readonly) UIView *contentView;
@property (weak, nonatomic) id<SFCStateViewDelegate> delegate;
@property (assign, nonatomic) BOOL keepStateViewBackgroundColor;
@property (assign, nonatomic) CGFloat showDuration;
@property (assign, nonatomic) CGFloat hideDuration;

/**
 Designated factory method
 @return SFStateView
 */
+ (instancetype)stateViewWithDelegate:(id<SFCStateViewDelegate>)delegate;

/**
 Designated initializer
 Init state view with title with delegate
 @return SFStateView
 */
- (instancetype)initWithStateViewDelegate:(id<SFCStateViewDelegate>)delegate;

/**
 Returns nib name for view. By default returns current class name.
 If return value is nil, all UI should be created in -createUI method by hands.
 @return NSString or nil
 */
- (NSString *)nibName;

/**
 Used for UI creation (if no nib used)
 Do nothing by default. Should be overriden in child
 One should create state view's UI by hands here.
 */
- (void)createUI;

/**
 Show state view in the view
 If view already has state view - last will be hidden 
 (animation will be canceled)
 */
- (void)showInView:(UIView *)view;

/**
 Hide state view
 */
- (void)hide;

/**
 Methods to handle state view's appearance state
 Can be used for state view configurations
 */
- (void)willShow;
- (void)didShow;
- (void)completedShowAnimation:(BOOL)finished;
- (void)willHide;
- (void)didHide;
- (void)completedHideAnimation:(BOOL)finished;

@end



#pragma mark - SFCStateViewDelegate

@protocol SFCStateViewDelegate<NSObject>

@optional

/**
 Inform state view delegate that state view is going to change its appearance state
 */
- (void)stateViewWillShow:(SFCStateView *)stateView;
- (void)stateViewDidShow:(SFCStateView *)stateView;
- (void)stateViewWillHide:(SFCStateView *)stateView;
- (void)stateViewDidHide:(SFCStateView *)stateView;

/**
 Ask for view container rect
 @return CGRect
 */
- (CGRect)stateViewContainerRect:(SFCStateView *)stateView;

@end