//
//  UIView+SFCStateView.m
//  SFCStateViews
//
//  Created by Slavik Bubnov on 26.03.11.
//  Copyright 2010 Slavik Bubnov, bubnovslavik@gmail.com. All rights reserved.
//

#import "UIView+SFCStateView.h"
#import "SFCStateView.h"
#import <objc/runtime.h>


@implementation UIView (SFCStateView)

static char *_viewStateKey;
static char *_stateViewsKey;


- (NSString *)keyForState:(NSInteger)state {
   return [NSString stringWithFormat:@"%ld", (long)state];
}


- (NSMutableDictionary *)stateViews {
   // Get state views dictionary or create lazily
   // This method used only if we are going to set new state view to the dictionary, 
   // because there are no reasons to create assosiated dictionary, 
   // if we need just read from dictionary.
   NSMutableDictionary *stateViews = objc_getAssociatedObject(self, &_stateViewsKey);
   if ( ! stateViews) {
      stateViews = [NSMutableDictionary dictionary];
      objc_setAssociatedObject(self, &_stateViewsKey, stateViews, OBJC_ASSOCIATION_RETAIN);
   }
   return stateViews;
}


- (void)sfc_setStateView:(SFCStateView *)stateView forViewState:(NSInteger)state {
   // Validate state view
   if ( ! stateView || ! [stateView isKindOfClass:[SFCStateView class]]) {
      return;
   }
   
   // Add state view for state
   [[self stateViews] setObject:stateView forKey:[self keyForState:state]];
}


- (SFCStateView *)sfc_stateViewForViewState:(NSInteger)state {
   NSMutableDictionary *stateViews = objc_getAssociatedObject(self, &_stateViewsKey);
   if (stateViews) {
      return [stateViews objectForKey:[self keyForState:state]];
   }
   return nil;
}


- (SFCStateView *)sfc_currentStateView {
   for (UIView *subview in self.subviews) {
      if ([subview isKindOfClass:[SFCStateView class]]) {
         return (SFCStateView *)subview;
      }
   }
   return nil;
}


- (void)sfc_removeAllStateViews {
   // Remove state views
   NSMutableArray *stateViews = objc_getAssociatedObject(self, &_stateViewsKey);
   if (stateViews) {
      [stateViews removeAllObjects];
   }
   
   // Clear assosiated dictionary
   objc_setAssociatedObject(self, &_stateViewsKey, nil, OBJC_ASSOCIATION_ASSIGN);
}



#pragma mark -

- (NSInteger)sfc_viewState {
   // Read view state from associated object
   NSNumber *viewState = objc_getAssociatedObject(self, &_viewStateKey);
   return [viewState intValue];
}


- (void)sfc_setViewState:(NSInteger)newViewState {
   if (self.sfc_viewState != newViewState) {
      // Remember the state associated object
      objc_setAssociatedObject(self, &_viewStateKey, @(newViewState), OBJC_ASSOCIATION_RETAIN);
      
      // Try to show proper state view
      // If state view for state isn't set - just hide current state view if exists
      SFCStateView *stateView = [self sfc_stateViewForViewState:newViewState];
      if (stateView) {
         [stateView showInView:self];
      } else {
         [self sfc_hideStateView];
      }
   }
}



#pragma mark -

- (void)sfc_showStateView:(SFCStateView *)stateView {
   // Validate state view
   if ( ! stateView || ! [stateView isKindOfClass:[SFCStateView class]]) {
      return;
   }
   
   // Show state view
   [stateView showInView:self];
}


- (void)sfc_hideStateView {
   // Find state view and hide it
   for (UIView *subview in self.subviews) {
      if ([subview isKindOfClass:[SFCStateView class]]) {
         // Send hide message with delay to prevent animation flicking 
         // if state views switching very fast.
         [subview performSelector:@selector(hide) withObject:nil afterDelay:0.1];
      }
   }
}

@end
