//
//  ViewController.m
//  RedPackageRain
//
//  Created by kunge on 2018/6/27.
//  Copyright © 2018年 kunge. All rights reserved.
//

#import "ViewController.h"
#import "RedPackageImageView.h"
#define IMAGE_WIDTH 60
#define IMAGEX arc4random()%(int)[[UIScreen mainScreen] bounds].size.width

@interface ViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *arrayImage;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _array = [[NSMutableArray alloc]init];
    _arrayImage = [[NSMutableArray alloc]init];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    _imagesArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 500; ++ i) {
        RedPackageImageView *imageView = [[RedPackageImageView alloc] initWithImage:[UIImage imageNamed:@"hb"]];
        CGFloat imageWidth = IMAGE_WIDTH;
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width-imageWidth;
        CGFloat imageX = IMAGEX;
        CGFloat startX = (maxWidth>imageX)?imageX:maxWidth;
        imageView.frame = CGRectMake(startX, -(imageWidth+10), imageWidth, imageWidth+10);
        imageView.index = i;
        [_array addObject:imageView.layer];
        [_arrayImage addObject:imageView];
        [self.view addSubview:imageView];
        [_imagesArray addObject:imageView];
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
    
}

-(void)click:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self.view];
    
    for (RedPackageImageView * imgView in _arrayImage) {
        if ([imgView.layer .presentationLayer hitTest:touchPoint]) {
            NSLog(@"presentationLayer 点击了 第 %ld 个红包",imgView.index);
            
            return;
        }
    }
}

static int i = 0;
- (void)makeSnow
{
    i = i + 1;
    if ([_imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        imageView.tag = i;
        [_imagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }
}

- (void)snowFall:(UIImageView *)aImageView
{
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, [UIScreen mainScreen].bounds.size.height, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
    float x = IMAGE_WIDTH;
    imageView.frame = CGRectMake(IMAGEX, -45, x, x+10);
    [_imagesArray addObject:imageView];
}

@end
