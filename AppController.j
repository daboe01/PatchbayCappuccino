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
+ (CPArray)keysForNonBoundsProperties
{
    return [];
}

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

+ (CPDictionary)constantTextBlockAtPoint:(CGPoint)aPoint value:(CPString)aValue
{
    var mydata = [CPConservativeDictionary new];
    [mydata setValue:'Constant' forKey:'title'];
    [mydata setValue:aPoint.x forKey:'originX'];
    [mydata setValue:aPoint.y forKey:'originY'];
    [mydata setValue:aValue forKey:'constantValue'];

    var myoutput = [CPConservativeDictionary new];
    [myoutput setValue:'↣' forKey:'label'];
    [mydata setValue:@[myoutput] forKey:'outputs'];

    return mydata;
}

+ (CPDictionary)fetchBlockAtPoint:(CGPoint)aPoint
{
    var mydata = [CPConservativeDictionary new];
    [mydata setValue:'Fetch' forKey:'title'];
    [mydata setValue:aPoint.x forKey:'originX'];
    [mydata setValue:aPoint.y forKey:'originY'];

    var myoutput = [CPConservativeDictionary new];
    [myoutput setValue:'↣' forKey:'label'];
    [mydata setValue:@[myoutput] forKey:'outputs'];

    return mydata;
}

+ (CPDictionary)LLMBlockAtPoint:(CGPoint)aPoint inputNumber:(unsigned)inputNumber
{
    var mydata = [CPConservativeDictionary new];
    [mydata setValue:'LLM' forKey:'title'];
    [mydata setValue:aPoint.x forKey:'originX'];
    [mydata setValue:aPoint.y forKey:'originY'];

    var myoutput = [CPConservativeDictionary new];
    [myoutput setValue:'↣' forKey:'label'];
    [mydata setValue:@[myoutput] forKey:'outputs'];

    var myinputArray = [];
    var myinput = [CPConservativeDictionary new];
    [myinput setValue:'SystemPrompt' forKey:'label'];
    myinputArray.push(myinput);
    myinput = [CPConservativeDictionary new];
    [myinput setValue:'PromptTemplate' forKey:'label'];
    myinputArray.push(myinput);

    for(var i = 0 ; i < inputNumber ; i++)
    {
        myinput = [CPConservativeDictionary new];
        [myinput setValue:'Input ' + ((i + 1) + '')  forKey:'label'];
        myinputArray.push(myinput);
    }
    [mydata setValue:myinputArray forKey:'inputs'];

    return mydata;
}

+ (CPDictionary)regexBlockAtPoint:(CGPoint)aPoint
{
    var mydata = [CPConservativeDictionary new];
    [mydata setValue:'Regexp' forKey:'title'];
    [mydata setValue:aPoint.x forKey:'originX'];
    [mydata setValue:aPoint.y forKey:'originY'];

    var myoutput = [CPConservativeDictionary new];
    [myoutput setValue:'↣' forKey:'label'];
    [mydata setValue:@[myoutput] forKey:'outputs'];

    var myinputArray = [];
    var myinput = [CPConservativeDictionary new];
    [myinput setValue:'Input' forKey:'label'];
    myinputArray.push(myinput);
    myinput = [CPConservativeDictionary new];
    [myinput setValue:'Regex' forKey:'label'];
    myinputArray.push(myinput);

    [mydata setValue:myinputArray forKey:'inputs'];

    return mydata;
}

+ (void)connectBlock:(id)mydata toOtherBlock:(id)mydata2 usingOutletNamed:(CPString)name
{
    var startHoles = [mydata valueForKey:'outputs'];
    var endHoles = [mydata2 valueForKey:'inputs'];
    var myinput;

    for (var i = 0; i < [endHoles count] ; i++)
    {
        if ([endHoles[i] valueForKey:"label"] == name)
        {
            myinput = endHoles[i];
            break;
        }
    }

    [startHoles[0] setValue:[myinput] forKey:"laces"]
    [myinput setValue:mydata2 forKey:"data"]
    [startHoles[0] setValue:mydata forKey:"data"]
}

- (void)_createSimpleSetupIntoAC:(id)ac
{
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
        var endHoles = [mydata2 valueForKey:'inputs'];
        [startHoles[0] setValue:endHoles forKey:"laces"]
        [endHoles[0] setValue:mydata2 forKey:"data"]
        [startHoles[0] setValue:mydata forKey:"data"]
    }
}
- (void)_createComplexSetupIntoAC:(id)ac
{
    var block0 = [AppController fetchBlockAtPoint:CGPointMake(30,10)];
    [ac insertObject:block0 atArrangedObjectIndex:0];

    var block1 = [AppController constantTextBlockAtPoint:CGPointMake(10,70) value:"You are a helpful assistant"];
    [ac insertObject:block1 atArrangedObjectIndex:0];
    var block2 = [AppController constantTextBlockAtPoint:CGPointMake(10,120) value:"You are a helpful assistant"];
    [ac insertObject:block2 atArrangedObjectIndex:0];
    var block3 = [AppController constantTextBlockAtPoint:CGPointMake(10,170) value:"You are a helpful assistant"];
    [ac insertObject:block3 atArrangedObjectIndex:0];
    var block4 = [AppController LLMBlockAtPoint:CGPointMake(100,10) inputNumber:1]
    [ac insertObject:block4 atArrangedObjectIndex:0];
    [AppController connectBlock:block0 toOtherBlock:block4 usingOutletNamed:"Input 1"]

    var block5 = [AppController LLMBlockAtPoint:CGPointMake(250,10) inputNumber:1]
    [block5 setValue:'2000' forKey:'id']; // blocks must be unique
    [ac insertObject:block5 atArrangedObjectIndex:0];

    var block6 = [AppController constantTextBlockAtPoint:CGPointMake(400,3) value:"You are a helpful assistant"]
    [ac insertObject:block6 atArrangedObjectIndex:0];

    var block7 = [AppController regexBlockAtPoint:CGPointMake(400,50)]
    [ac insertObject:block7 atArrangedObjectIndex:0];

}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
    laceView = [[EFLaceView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    var ac = [CPArrayController new];

    contentView = [theWindow contentView];
    [contentView setBackgroundColor:[CPColor colorWithWhite:0.95 alpha:1.0]];

    var mybutton = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    [mybutton setTitle:"Add"]
    [mybutton setTarget:self];
    [mybutton setAction:@selector(addBlock:)];
    [contentView addSubview:mybutton];

     mybutton=[[CPButton alloc] initWithFrame:CGRectMake(100, 0, 90, 25)];
    [mybutton setTitle:"Delete"]
    [mybutton setTarget:laceView];
    [mybutton setAction:@selector(delete:)];
    [contentView addSubview:mybutton];



    if (0)
        [self _createSimpleSetupIntoAC:ac];
    else
        [self _createComplexSetupIntoAC:ac];

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
