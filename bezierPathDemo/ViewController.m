//
//  ViewController.m
//  bezierPathDemo
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imgView.contentMode = UIViewContentModeScaleToFill;
}


- (void)test9 {
    // One
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imgView.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(75, 75)];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    self.imgView.layer.mask = layer;

    /*
     结论：
     1、ios9以后，同时设置cornerRadius+clipsToBounds不会离屏渲染
     但是设置背景颜色后，还是会离屏渲染
     2、通过mask设置会产生离谱渲染
     3、shouldRasterize：光栅化位图会产生离屏渲染
     */
    // Two
    self.imgView.backgroundColor = [UIColor redColor];
    self.imgView.layer.cornerRadius = 75;
    self.imgView.clipsToBounds = true;
    
    // Three 光栅化（将图转化为一个个栅格组成的图象）
//    self.imgView.layer.shouldRasterize = true;
    
}

#pragma mark - 圆角绘制
- (void)test8 {
    // 根据图片范围生成bit map
    UIGraphicsBeginImageContextWithOptions(self.imgView.bounds.size, false, 0);
    // 获取当前的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    // cornerRadii设置的值如果超过原来的一半，则会变成一半（切成圆）
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imgView.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(150, 150)];
    // 给上下文添加新的路径（有旧的路径则会叠加）
    CGContextAddPath(context, path.CGPath);
    /*
     保留path内部，裁剪path外部
     如果context没有path，则函数不执行任何操作。
     */
    CGContextClip(context);
    // 在矩形范围内，绘制图像
    [self.imgView drawRect:self.imgView.bounds];
    
    // 设置路径绘制模式
    CGContextDrawPath(context, kCGPathFillStroke);
    // 根据当前上下文的bitmap返回图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 释放上下文
    UIGraphicsEndImageContext();
    self.imgView.image = image;
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
    [self test9];
}

@end
