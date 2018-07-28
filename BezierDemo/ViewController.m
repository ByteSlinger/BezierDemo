//
//  ViewController.m
//  BezierDemo
//
//  Copyright © 2018 ByteSlinger. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *_pickerData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // So I can see the view boundary
    _shapeView.backgroundColor = UIColor.lightGrayColor;
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    // Initialize Data
    _pickerData = @[@"Rectangle",@"Rounded Rectangle",@"Triangle",@"Circle",@"Oval",@"Arc",@"Vertical Arrow",@"Horizontal Arrow"];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reload];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         [self reload];
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    
    [self loadShape:row];
}

- (void) reset {
    // remove any previous subviews that are shape layers (my lines...)
    if (_shapeView.layer.sublayers.count > 0) {
        for (CALayer *layer in [_shapeView.layer.sublayers copy]) {
            if ([layer.name isEqualToString:@"shape"] || [layer.name isEqualToString:@"text"]) {
                [layer removeFromSuperlayer];
            }
        }
    }
}

- (void) reload {
    NSInteger selectedRow = [_picker selectedRowInComponent:0];
    
    [self loadShape:selectedRow];
}

- (void) loadShape:(NSInteger)row {
    [self reset];
    
    switch(row) {
        case 0:
            [self rectangle];
            break;
        case 1:
            [self roundedRectangle];
            break;
        case 2:
            [self triangle];
            break;
        case 3:
            [self circle];
            break;
        case 4:
            [self oval];
            break;
        case 5:
            [self arc];
            break;
        case 6:
            [self verticalArrow];
            break;
        case 7:
            [self horizontalArrow];
            break;
    }
}

- (void) addText:(NSString *)string color:(UIColor *)color {
    NSInteger numberOfLines, index, stringLength = [string length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
    
    CGRect frame = [self getShapeFrame];
    
    CATextLayer *text = [CATextLayer layer];
    
    CGFloat size = 48;
    CGFloat width = size * 6;
    CGFloat height = size * 1.25 * numberOfLines;
    
    text.string = string;
    text.foregroundColor = color.CGColor;
    text.fontSize = size;
    text.alignmentMode = kCAAlignmentCenter;
    text.frame = CGRectMake((frame.size.width - width)/2,(frame.size.height - height)/2,width,height);
    text.contentsScale = UIScreen.mainScreen.scale;
    
    text.name = @"text";
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:text.frame cornerRadius:48];
    
    [path closePath];
    
    CAShapeLayer *background = [CAShapeLayer layer];
    background.path = path.CGPath;
    background.lineWidth = 1;
    background.strokeColor = [UIColor blackColor].CGColor;
    background.fillColor = [UIColor whiteColor].CGColor;
    background.frame = frame;
    background.name = @"shape";
    
    // add a white circle behind the text
    [background addSublayer:text];

    [_shapeView.layer addSublayer:background];
}
// return a frame that is 20 dp smaller than the shape view
- (CGRect)getShapeFrame {
    return CGRectMake(_shapeView.bounds.origin.x + 20,
                      _shapeView.bounds.origin.y + 20,
                      _shapeView.bounds.size.width - 40,
                      _shapeView.bounds.size.height - 40);
}

- (void) rectangle {
    CGRect frame = [self getShapeFrame];
    
    CGPoint upperLeft = frame.origin;
    CGPoint upperRight = CGPointMake(frame.origin.x + frame.size.width,frame.origin.y);
    CGPoint lowerRight = CGPointMake(frame.origin.x + frame.size.width,frame.origin.y + frame.size.height);
    CGPoint lowerLeft = CGPointMake(frame.origin.x,frame.origin.y + frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:upperLeft];
    [path addLineToPoint:upperRight];
    [path addLineToPoint:lowerRight];
    [path addLineToPoint:lowerLeft];
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor yellowColor].CGColor;
    shape.frame =  _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Rectangle" color:UIColor.blackColor];
}

- (void) roundedRectangle {
    CGRect frame = [self getShapeFrame];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:48];
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor orangeColor].CGColor;
    shape.frame = _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Rounded\nRectangle" color:UIColor.blackColor];
}

- (void) triangle {
    CGRect frame = [self getShapeFrame];
    
    CGPoint topCenter = CGPointMake(frame.origin.x + frame.size.width/2,frame.origin.y);
    CGPoint lowerRight = CGPointMake(frame.origin.x + frame.size.width,frame.origin.y + frame.size.height);
    CGPoint lowerLeft = CGPointMake(frame.origin.x,frame.origin.y + frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:topCenter];
    [path addLineToPoint:lowerRight];
    [path addLineToPoint:lowerLeft];
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor blueColor].CGColor;
    shape.frame = _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Triangle" color:UIColor.blackColor];
}

- (void) circle {
    CGRect frame = [self getShapeFrame];
    CGRect circleFrame = frame;
    if (frame.size.width > frame.size.height) {
        circleFrame.origin.x += (frame.size.width - frame.size.height) / 2;
        circleFrame.size.width = frame.size.height;
    } else {
        circleFrame.origin.y += (frame.size.height - frame.size.width) / 2;
        circleFrame.size.height = frame.size.width;
    }
    
    // Create an oval shape path in a square frame to get a circle
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor redColor].CGColor;
    shape.frame = _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Circle" color:UIColor.blackColor];
}

- (void) oval {
    CGRect frame = [self getShapeFrame];
    
    // Create an oval shape path in my frame
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor greenColor].CGColor;
    shape.frame = _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Oval" color:UIColor.blackColor];
}

- (void) arc {
    CGRect frame = [self getShapeFrame];
    
    CGPoint center = CGPointMake(frame.origin.x + frame.size.width/2,frame.origin.y + frame.size.height * 0.75);
    CGFloat radius = frame.size.width / 2;
    if (frame.size.width > frame.size.height) {
        center = CGPointMake(frame.origin.x + frame.size.width/2,frame.origin.y + frame.size.height);
        radius = frame.size.height;
    }
    CGFloat startAngle = ((M_PI * 180)/180);
    CGFloat endAngle = ((M_PI * 0)/180);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor brownColor].CGColor;
    shape.frame = _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Arc" color:UIColor.blackColor];
}

- (void) verticalArrow {
    CGRect frame = [self getShapeFrame];
    
    CGPoint point = CGPointMake(frame.origin.x + frame.size.width/2,frame.origin.y);
    CGFloat distance = 192;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 10 lines to outline the double ended arrow
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(point.x + distance, point.y + distance)];                      // top head, right side
    [path addLineToPoint:CGPointMake(point.x + distance/2, point.y + distance)];                    // top head, bottom right
    [path addLineToPoint:CGPointMake(point.x + distance/2, point.y + frame.size.height - distance)];// right side
    [path addLineToPoint:CGPointMake(point.x + distance, point.y + frame.size.height - distance)];  // bottom head, top right
    [path addLineToPoint:CGPointMake(point.x, point.y + frame.size.height)];                        // bottom head, right side
    [path addLineToPoint:CGPointMake(point.x - distance, point.y + frame.size.height - distance)];  // bottom head, left side
    [path addLineToPoint:CGPointMake(point.x - distance/2, point.y + frame.size.height - distance)];// bottom head, top left
    [path addLineToPoint:CGPointMake(point.x - distance/2, point.y + distance)];                    // left side
    [path addLineToPoint:CGPointMake(point.x - distance, point.y + distance)];                      // top head, bottom left
    [path addLineToPoint:point];                                                                    // top head, left side
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor cyanColor].CGColor;
    shape.frame = _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Vertical\nArrow" color:UIColor.blackColor];
}

- (void) horizontalArrow {
    CGRect frame = [self getShapeFrame];
    
    CGPoint point = CGPointMake(frame.origin.x,frame.origin.y + frame.size.height/2);
    CGFloat distance = 192;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 10 lines to outline the double ended arrow
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(point.x + distance, point.y - distance)];
    [path addLineToPoint:CGPointMake(point.x + distance, point.y - distance/2)];
    [path addLineToPoint:CGPointMake(point.x + frame.size.width - distance, point.y - distance/2)];
    [path addLineToPoint:CGPointMake(point.x + frame.size.width - distance, point.y - distance)];
    [path addLineToPoint:CGPointMake(point.x + frame.size.width, point.y)];
    [path addLineToPoint:CGPointMake(point.x + frame.size.width - distance, point.y + distance)];
    [path addLineToPoint:CGPointMake(point.x + frame.size.width - distance, point.y + distance/2)];
    [path addLineToPoint:CGPointMake(point.x + distance, point.y + distance/2)];
    [path addLineToPoint:CGPointMake(point.x + distance, point.y + distance)];
    [path addLineToPoint:point];
    
    [path closePath];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    shape.lineWidth = 2;
    shape.strokeColor = [UIColor blackColor].CGColor;
    shape.fillColor = [UIColor magentaColor].CGColor;
    shape.frame = _shapeView.bounds;
    shape.name = @"shape";
    
    [_shapeView.layer addSublayer:shape];
    
    [self addText:@"Horizontal\nArrow" color:UIColor.blackColor];
}

@end
