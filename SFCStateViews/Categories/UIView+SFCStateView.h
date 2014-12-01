//
//  UIView+SFCStateView.h
//  SFCStateViews
//
//  Created by Slavik Bubnov on 26.03.11.
//  Copyright 2010 Slavik Bubnov, bubnovslavik@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFCStateView;

/**
 Category, that adds the methods to working with state views in view.
 @see SFCStateView
 */
@interface UIView (SFCStateView)

/**
 View state getter and setter
 When view state changed - proper state view will be presented (if exists)
 */
- (NSInteger)viewState;
- (void)setViewState:(NSInteger)newViewState;

/**
 Set state view for state
 When view's state will become |state| - |stateView| will be presented
 */
- (void)setStateView:(SFCStateView *)stateView forViewState:(NSInteger)state;

/**
 Return state view for state, if it's set
 @return SFCStateView or nil
 */
- (SFCStateView *)stateViewForViewState:(NSInteger)state;

/**
 Return current appeared state view
 @return SFCStateView or nil
 */
- (SFCStateView *)currentStateView;

/**
 Remove all state views of the view
 */
- (void)removeAllStateViews;

/**
 Shows state view in the view
 */
- (void)showStateView:(SFCStateView *)stateView;

/**
 Hides state view
 */
- (void)hideStateView;

@end
