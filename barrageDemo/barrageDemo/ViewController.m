//
//  ViewController.m
//  barrageDemo
//
//  Created by qujiahong on 2018/4/18.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "ViewController.h"
#import <BarrageRenderer.h>
#import "MBSafeObject.h"

#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
{
    /** 弹幕 */
    BarrageRenderer *_renderer;
    NSTimer * _timer;
}
/** danMuText*/
@property (nonatomic, strong) NSArray * danMuText;

/** danMuView*/
@property (weak, nonatomic) IBOutlet UIView *danMuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupRenderer{
    _renderer = [[BarrageRenderer alloc]init];
    _renderer.canvasMargin = UIEdgeInsetsMake(ScreenHeight*0.3, 10, 10, 10);
    [self.danMuView addSubview:_renderer.view];
    MBSafeObject * safeObj = [[MBSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
}


#pragma mark - 弹幕描述符生产方法
- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}


//long _index = 0;

/** 生成精灵描述 - 过场文字弹幕*/
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction{
    BarrageDescriptor *descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
//    descriptor.params[@"clickAction"] = ^{
//        NSLog(@"您点击了弹幕");
//    };
    
    return descriptor;
}

#pragma mark - 弹幕控制 方法
- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}
- (IBAction)startBtn:(id)sender {
    
    [self setupRenderer];
    
    [_renderer start];
}

- (IBAction)closeBtn:(id)sender {
    [_renderer stop];
    [_renderer.view removeFromSuperview];
    _renderer = nil;
}






@end
