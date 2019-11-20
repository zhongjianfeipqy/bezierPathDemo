//
//  ViewController.m
//  bezierPathDemo
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 实战绘制
- (void)test7 {
    CGPoint point1 = CGPointMake(0, 300);
    CGPoint Point2 = CGPointMake(0, 500);
    CGPoint Point3 = CGPointMake(self.view.frame.size.width, 500);
    CGPoint Point4 = CGPointMake(self.view.frame.size.width, 300);
    CGPoint controlPoint1 = CGPointMake(self.view.frame.size.width * 0.5, 100);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:Point2];
    [path addLineToPoint:Point3];
    [path addLineToPoint:Point4];
    [path addQuadCurveToPoint:point1 controlPoint:controlPoint1];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor greenColor].CGColor;
    
    [self.view.layer addSublayer:layer];
}

#pragma mark - 曲线动画
- (void)test6 {
    CGPoint starPoint = CGPointMake(100, 100);
    CGPoint endPoint = CGPointMake(200, 100);
    // 控制点
    CGPoint controlPoint1 = CGPointMake(100, 50);
    CGPoint controlPoint2 = CGPointMake(200, 150);
    
    CALayer *layer1 = [[CALayer alloc] init];
    layer1.frame = CGRectMake(starPoint.x, starPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer2 = [[CALayer alloc] init];
    layer2.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer3 = [[CALayer alloc] init];
    layer3.frame = CGRectMake(controlPoint1.x, controlPoint1.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer4 = [[CALayer alloc] init];
    layer4.frame = CGRectMake(controlPoint2.x, controlPoint2.y, 5, 5);
    layer4.backgroundColor = [UIColor redColor].CGColor;
            
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    // 绘制路径
    [bezierPath moveToPoint:starPoint];
    [bezierPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        
    // path路径，需要layer用来显示
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    // 路径围起后，内容的颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 线条颜色
    layer.strokeColor = [UIColor blueColor].CGColor;
    /*
     https://www.jianshu.com/p/5db371bb3fb7
     strokeStart
     默认是0，0~1过程中，相当于橡皮擦，擦线
     
     strokeEnd
     默认是1，0~1过程中，相当于画笔，画线
    */
    layer.lineWidth = 5;
    
    // 描述画线的过程
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    // 动画持续时间
    animation.duration = 2;
    [layer addAnimation:animation forKey:@"animation"];
    
    [self.view.layer addSublayer:layer1];
    [self.view.layer addSublayer:layer2];
    [self.view.layer addSublayer:layer3];
    [self.view.layer addSublayer:layer4];
    [self.view.layer addSublayer:layer];
}

#pragma mark - 两个控制点画曲线
- (void)test5 {
    CGPoint starPoint = CGPointMake(100, 100);
    CGPoint endPoint = CGPointMake(200, 100);
    // 控制点
    CGPoint controlPoint1 = CGPointMake(100, 50);
    CGPoint controlPoint2 = CGPointMake(200, 150);
    
    CALayer *layer1 = [[CALayer alloc] init];
    layer1.frame = CGRectMake(starPoint.x, starPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer2 = [[CALayer alloc] init];
    layer2.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer3 = [[CALayer alloc] init];
    layer3.frame = CGRectMake(controlPoint1.x, controlPoint1.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer4 = [[CALayer alloc] init];
    layer4.frame = CGRectMake(controlPoint2.x, controlPoint2.y, 5, 5);
    layer4.backgroundColor = [UIColor redColor].CGColor;
            
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    // 绘制路径
    [bezierPath moveToPoint:starPoint];
    [bezierPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        
    // path路径，需要layer用来显示
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    // 路径围起后，内容的颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 线条颜色
    layer.strokeColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer1];
    [self.view.layer addSublayer:layer2];
    [self.view.layer addSublayer:layer3];
    [self.view.layer addSublayer:layer4];
    [self.view.layer addSublayer:layer];
}


#pragma mark - 一个控制点画曲线
- (void)test4 {
    CGPoint starPoint = CGPointMake(100, 100);
    CGPoint endPoint = CGPointMake(200, 100);
    // 控制点
    CGPoint controlPoint = CGPointMake(100, 50);
    
    CALayer *layer1 = [[CALayer alloc] init];
    layer1.frame = CGRectMake(starPoint.x, starPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer2 = [[CALayer alloc] init];
    layer2.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer3 = [[CALayer alloc] init];
    layer3.frame = CGRectMake(controlPoint.x, controlPoint.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
            
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    // 绘制路径
    [bezierPath moveToPoint:starPoint];
    [bezierPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
        
    // path路径，需要layer用来显示
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    // 路径围起后，内容的颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 线条颜色
    layer.strokeColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer1];
    [self.view.layer addSublayer:layer2];
    [self.view.layer addSublayer:layer3];
    [self.view.layer addSublayer:layer];
}

#pragma mark - 画圆二
- (void)test3 {
    // 参数：圆点，半径，圆弧起始角度，圆弧终止角度，是否顺时针画
    CGFloat startAngle = M_PI; // 起点为圆心的最左边
    CGFloat endAngle = M_PI * 3 / 4; // 终点为起点的下面
    
    // 绘制了3/4的圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:100 startAngle:startAngle endAngle:endAngle clockwise:true];
    // path路径，需要layer用来显示
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    // 路径围起后，内容的颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    // 线条颜色
    layer.strokeColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer];
}

#pragma mark - 画圆一
- (void)test2 {
    // 此刻拿到的是100，100的正方形，半径50则会变成圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 100) cornerRadius:50];
    
    // path路径，需要layer用来显示
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    // 路径围起后，内容的颜色
    layer.fillColor = [UIColor redColor].CGColor;
    // 线条颜色
    layer.strokeColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer];
}

#pragma mark - 画三角形
- (void)test1 {
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    // 起始位置
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(100, 0)];
    [bezierPath addLineToPoint:CGPointMake(100, 100)];
    [bezierPath closePath];
    // path路径，需要layer用来显示
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    // 路径围起后，内容的颜色
    layer.fillColor = [UIColor redColor].CGColor;
    // 线条颜色
    layer.strokeColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test6];
}

@end
