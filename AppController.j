/*
 * AppController.j
 *
 *  Test application for EFLaceView
 *  Copyright (C) 2023 Daniel Boehringer
 *
 * todo
 *
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

    var myoutput = [CPConservativeDictionary new];
    [myoutput setValue:'Ausgang' forKey:'label'];
    [mydata setValue:@[myoutput] forKey:'outputs'];

    [ac insertObject:mydata atArrangedObjectIndex:0];

    //
    // block 2
    //

    var mydata2 = [CPConservativeDictionary new];
    [mydata2 setValue:'test2' forKey:'title'];
    [mydata2 setValue:180 forKey:'originX'];
    [mydata2 setValue:100 forKey:'originY'];

    var myinput = [CPConservativeDictionary new];
    [myinput setValue:'Eingang' forKey:'label'];
    [mydata2 setValue:@[myinput] forKey:'inputs'];

    [ac insertObject:mydata2 atArrangedObjectIndex:0];

    // make a connection programmatically
    if (1){
        var startHoles = [mydata valueForKey:'outputs'];
        [startHoles[0] setValue:[mydata2 valueForKey:'inputs'] forKey:"laces"]
        [myinput setValue:mydata2 forKey:"data"]
        [myoutput setValue:mydata forKey:"data"]
    }

    [laceView bind:"selectionIndexes" toObject:ac withKeyPath:"selectionIndexes" options:nil]
    [laceView bind:"dataObjects" toObject:ac withKeyPath:"arrangedObjects" options:nil]

    [theWindow orderFront:self];
    [CPMenu setMenuBarVisible:YES];

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(20, 70, 520, 510)];
    [scrollView setDocumentView:laceView];
    [contentView addSubview:scrollView];

    //
    // add tableview to see what is going on
    //

    var tableView = [CPTableView new];

    var column = [[CPTableColumn alloc] initWithIdentifier:@"x"];
    [column setEditable:YES];
    [[column headerView] setStringValue:@"X"];
    [tableView addTableColumn:column];
    [column bind:CPValueBinding toObject:ac
          withKeyPath:@"arrangedObjects.originX" options:nil];

    column = [[CPTableColumn alloc] initWithIdentifier:@"y"];
    [column setEditable:YES];
    [[column headerView] setStringValue:@"Y"];
    [tableView addTableColumn:column];
    [column bind:CPValueBinding toObject:ac
     withKeyPath:@"arrangedObjects.originY" options:nil];

    var scrollView2 = [[CPScrollView alloc] initWithFrame:CGRectMake(600, 70, 520, 510)];
    [scrollView2 setDocumentView:tableView];
    [contentView addSubview:scrollView2];
}

- (void)addBlock:(id)sender
{
    alert("hello");
}

@end
