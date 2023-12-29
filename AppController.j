/*
 * AppController.j
 *
 *  Test application for EFLaceView
 *  Copyright (C) 2023 Daniel Boehringer
 */

@import <Foundation/Foundation.j>
@import <AppKit/CPTextView.j>
@import "EFLaceView.j"
@import "EFView.j"

@implementation CPConservativeDictionary:CPDictionary
- (void)setValue:(id)aVal forKey:(CPString)aKey
{
    if ([self objectForKey:aKey] != aVal)
        [super setValue:aVal forKey:aKey];
}
@end
@implementation CPArray(outletsContainer)
- (CPArray)allObjects
{
    return self;
}
@end

@implementation CPColor(BlendAddititon)
- (CPColor)blendedColorWithFraction:(CGFloat)fraction ofColor:(CPColor)color
{
    var red = [_components[0], color._components[0]],
        green = [_components[1], color._components[1]],
        blue = [_components[2], color._components[2]],
        alpha = [_components[3], color._components[3]];

    var blendedRed = red[0] + fraction * (red[1] - red[0]);
    var blendedGreen = green[0] + fraction * (green[1] - green[0]);
    var blendedBlue = blue[0] + fraction * (blue[1] - blue[0]);
    var blendedAlpha = alpha[0] + fraction * (alpha[1] - alpha[0]);

    return [CPColor colorWithCalibratedRed:blendedRed green:blendedGreen blue:blendedBlue alpha:blendedAlpha];
}
@end

@implementation AppController : CPObject
{
    EFLaceView  laceView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    [contentView setBackgroundColor:[CPColor colorWithWhite:0.95 alpha:1.0]];

    var mybutton=[[CPButton alloc] initWithFrame:CGRectMake(0, 0, 250, 25)];
    [mybutton setTitle:"Add"]
    [mybutton setTarget:self];
    [mybutton setAction:@selector(addBlock:)];

    [contentView addSubview:mybutton];


    laceView = [[EFLaceView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    var ac = [CPArrayController new];

    //
    // block 1
    //

    var mydata = [CPConservativeDictionary new];
    [mydata setValue:'test' forKey:'title'];
    [mydata setValue:100 forKey:'originX'];
    [mydata setValue:100 forKey:'originY'];
    [mydata setValue:'b' forKey:'data'];

    var myoutput = [CPConservativeDictionary new];
    [myoutput setValue:'Ausgang' forKey:'label'];
    [myoutput setValue:0 forKey:'x'];
    [myoutput setValue:0 forKey:'y'];
    [myoutput setValue:10 forKey:'with'];
    [myoutput setValue:10 forKey:'height'];
    [mydata setValue:@[myoutput] forKey:'outputs'];

    [ac insertObject:mydata atArrangedObjectIndex:0];

    //
    // block 2
    //

    var mydata2 = [CPConservativeDictionary new];
    [mydata2 setValue:'test' forKey:'title'];
    [mydata2 setValue:150 forKey:'originX'];
    [mydata2 setValue:100 forKey:'originY'];
    [mydata2 setValue:'a' forKey:'data'];

    var myinput = [CPConservativeDictionary new];
    [myinput setValue:'Eingang' forKey:'label'];
    [myinput setValue:0 forKey:'x'];
    [myinput setValue:0 forKey:'y'];
    [myinput setValue:10 forKey:'with'];
    [myinput setValue:10 forKey:'height'];
    [mydata2 setValue:@[myinput] forKey:'inputs'];

    [ac insertObject:mydata2 atArrangedObjectIndex:0];

    [laceView bind:"selectionIndexes" toObject:ac withKeyPath:"selectionIndexes" options:nil]
    [laceView bind:"dataObjects" toObject:ac withKeyPath:"arrangedObjects" options:nil]

    [theWindow orderFront:self];
    [CPMenu setMenuBarVisible:YES];

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(20, 70, 520, 510)];
    [scrollView setDocumentView:laceView];
    [contentView addSubview:scrollView];
}

- (void)addBlock:(id)sender
{
    alert("hello");
}

@end
