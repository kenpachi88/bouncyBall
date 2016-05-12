//
//  ViewController.h
//  bouncyBall
//
//  Created by kenny on 10/15/15.
//  Copyright © 2015 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic)  UIImageView *ball;
@property (retain, nonatomic) UIView *racket;
@property (nonatomic, retain) UICollisionBehavior *collisionBehavior;
@property (nonatomic, retain) UIDynamicAnimator *animator;
@property (nonatomic, retain) UIView *lava;
@property (nonatomic, retain) UILabel *highScore;
@property  BOOL *isVerticalPan;
@property int score;

@end

