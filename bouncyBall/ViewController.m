//
//  ViewController.m
//  bouncyBall
//
//  Created by kenny on 10/15/15.
//  Copyright © 2015 kenny. All rights reserved.
//

#import "ViewController.h"
@interface ViewController () <UICollisionBehaviorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ball = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tennis-ball.jpg"]];
    self.ball.frame = CGRectMake(100, 0, 50, 50);
    self.ball.layer.cornerRadius = self.ball.frame.size.height/2;
    self.ball.layer.masksToBounds = YES;
    self.ball.layer.borderWidth = 3;
    [self.view addSubview:self.ball];
    
//    self.racket = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"racket.png"]];
    self.racket = [[UIView alloc]init];
    self.racket.frame = CGRectMake(100, [UIScreen mainScreen].bounds.size.height-50, 200, 30);
    self.racket.layer.backgroundColor = [[UIColor blackColor] CGColor];
    self.racket.userInteractionEnabled = YES;
    [self.view addSubview:self.racket];
    
    self.lava = [[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-20, [UIScreen mainScreen].bounds.size.width, 1)];
    self.lava.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lava];
    
    self.highScore = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    self.highScore.backgroundColor = [UIColor whiteColor];
    self.highScore.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.highScore];
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    [animator addBehavior:gravityBehavior];
    
    self.collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[self.ball,self.racket]];
    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.action = ^{
        if (CGRectIntersectsRect(self.ball.frame, self.lava.frame)) {
            [self.ball removeFromSuperview];
            [self.racket removeFromSuperview];
            self.score = 0;
            [self viewDidLoad];
            
        }
    };

    [animator addBehavior:self.collisionBehavior];
    
    UIDynamicItemBehavior *racketDynamics =
    [[UIDynamicItemBehavior alloc] initWithItems:@[self.racket]];
    racketDynamics.density = 999;
    racketDynamics.allowsRotation = NO;
    racketDynamics.resistance = 2;
    [animator addBehavior:racketDynamics];
    
    UIDynamicItemBehavior *ballDynamics = [[UIDynamicItemBehavior alloc]initWithItems:@[self.ball]];
    ballDynamics.friction = 1.1;
    ballDynamics.elasticity = 1.05;
    ballDynamics.resistance = 0;
    [animator addBehavior:ballDynamics];
    self.animator = animator;
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePanGesture:)];
    [self.racket addGestureRecognizer:panRecognizer];
    
    
    
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    if(UIGestureRecognizerStateChanged ==gestureRecognizer.state) {
        
        CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        
        gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, gestureRecognizer.view.center.y );
        
        [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view];
        [self.animator updateItemUsingCurrentState:self.racket];
        
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    self.score++;
    self.highScore.text = [NSString stringWithFormat:@"%d", self.score];
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.backgroundColor = color;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
