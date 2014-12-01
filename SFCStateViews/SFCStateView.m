//
//  SFCStateView.m
//  SFCStateViews
//
//  Created by Bubnov Slavik on 10/18/11.
//  Copyright (c) 2011 Slavik Bubnov, bubnovslavik@gmail.com. All rights reserved.
//

#import "SFCStateView.h"


@implementation SFCStateView

@synthesize
contentView = _contentView,
delegate = _delegate, 
keepStateViewBackgroundColor = _keepStateViewBackgroundColor,
showDuration = _showDuration, 
hideDuration = _hideDuration;


static const NSInteger _kStateViewTag = -500;


+ (instancetype)stateViewWithDelegate:(id<SFCStateViewDelegate>)delegate {
   SFCStateView *view = [[[self class] alloc] initWithStateViewDelegate:delegate];
   return view;
}


- (instancetype)initWithStateViewDelegate:(id<SFCStateViewDelegate>)delegate {
   if ((self = [super initWithFrame:CGRectMake(0, 0, 100, 100)])) { // Use non-zero frame here!
      _delegate = delegate;
      
      // Defaults
      self.keepStateViewBackgroundColor = NO;
      self.showDuration = self.hideDuration = 0.25f;
      
      // State view configuration
      self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
      self.backgroundColor = [UIColor clearColor];
      
      // Load state view content from nib...
      if ([self nibName]) {
         [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self options:nil];
      }
      // ...or create it by hands
      else {
         [self createUI];
      }
   
      // Configurate content view and add it to the view
      _contentView.frame = self.frame;
      _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
      
      if ( ! self.keepStateViewBackgroundColor) {
         _contentView.backgroundColor = [UIColor clearColor];
      }
      
      [self addSubview:_contentView];
   }
   
   return self;
}


- (NSString *)nibName {
   return nil;
}


- (void)createUI {
   // Create content view
   _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
   [super willMoveToSuperview:newSuperview];
   
   if ( ! newSuperview) {
      return;
   }
   
   // When state view moving to superview we have to set proper frame 
   // for it. If state view has delegate - trying to ask him for frame. 
   // Otherwise, using superview's bounds.
   
   CGRect frame = CGRectZero;
   
   if (_delegate && [_delegate respondsToSelector:@selector(stateViewContainerRect:)]) {
      frame = [_delegate stateViewContainerRect:self];
   } else {
      frame = newSuperview.bounds;
   }
   
   self.frame = frame;
}



#pragma mark -

- (void)showInView:(UIView *)view {
   // Do nothing if view is nil
   if ( ! view) {
      return;
   }
   
   // Try to find previous state view. If it is exists and it's animation 
   // is in progress - cancel it and remove
   SFCStateView *previousStateView = (SFCStateView *)[view viewWithTag:_kStateViewTag];
   if (previousStateView && [previousStateView isKindOfClass:[SFCStateView class]]) {
      // If previous state view is not the same as current state view
      if (previousStateView != self) {
         // Clear tag because new state view is upcoming
         previousStateView.tag = 0;
         
         // Send hide message with delay to prevent animation flicking 
         // if state views switching very fast.
         [previousStateView performSelector:@selector(hide) withObject:nil afterDelay:0.1];
      }
   }
   
   // Add state view to the view
   if (self.superview != view) {
      [view addSubview:self];
      self.tag = _kStateViewTag;
   }
   
   // Prepare state view
   [self willShow];
   
   // Show state view
   [UIView animateWithDuration:[self showDuration]
                         delay:0 
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                       // Configurate state view for showed state
                       [self didShow];
                    } completion:^(BOOL finished) {
                       [self completedShowAnimation:finished];
                    }];
}


- (void)hide {
   // Prepare state view for hidding
   [self willHide];
   
   // Hide state view
   [UIView animateWithDuration:[self hideDuration] 
                         delay:0 
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                       // Configurate state view for hidden state
                       [self didHide];
                    } completion:^(BOOL finished) {
                       [self completedHideAnimation:finished];
                    }];
}



#pragma mark -

- (void)willShow {
   // Informing delegate that state view is going to be showed
   if (self.delegate && [self.delegate respondsToSelector:@selector(stateViewWillShow:)]) {
      [self.delegate performSelector:@selector(stateViewWillShow:) withObject:self];
   }
   
   // Prepare state view for appearing
   self.alpha = 0;
}


- (void)didShow {
   self.alpha = 1;
}


- (void)completedShowAnimation:(BOOL)finished {
   if (finished) {
      // Inform delegate that state view did show
      if (self.delegate && [self.delegate respondsToSelector:@selector(stateViewDidShow:)]) {
         [self.delegate performSelector:@selector(stateViewDidShow:) withObject:self];
      }
   }
}


- (void)willHide {
   // Inform delegate that state view is going to hide
   if (self.delegate && [self.delegate respondsToSelector:@selector(stateViewWillHide:)]) {
      [self.delegate performSelector:@selector(stateViewWillHide:) withObject:self];
   }
   
   // Override in child
}


- (void)didHide {
   self.alpha = 0;
}


- (void)completedHideAnimation:(BOOL)finished {
   if (finished) {
      // Inform delegate that state view did hide
      if (self.delegate && [self.delegate respondsToSelector:@selector(stateViewDidHide:)]) {
         [self.delegate performSelector:@selector(stateViewDidHide:) withObject:self];
      }
      
      // Remove state view from superview
      [self removeFromSuperview];
   }
}

@end
