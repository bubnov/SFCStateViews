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
- (NSInteger)sfc_viewState;
- (void)sfc_setViewState:(NSInteger)newViewState;

/**
 Set state view for state
 When view's state will become |state| - |stateView| will be presented
 */
- (void)sfc_setStateView:(SFCStateView *)stateView forViewState:(NSInteger)state;

/**
 Return state view for state, if it's set
 @return SFCStateView or nil
 */
- (SFCStateView *)sfc_stateViewForViewState:(NSInteger)state;

/**
 Return current appeared state view
 @return SFCStateView or nil
 */
- (SFCStateView *)sfc_currentStateView;

/**
 Remove all state views of the view
 */
- (void)sfc_removeAllStateViews;

/**
 Shows state view in the view
 */
- (void)sfc_showStateView:(SFCStateView *)stateView;

/**
 Hides state view
 */
- (void)sfc_hideStateView;

@end
