//
//  ILSwapSendText.m
//  Catalog
//
//  Created by ∞ on 07/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ILSwapSendText.h"

#import <SwapKit/SwapKit.h>

#import "ILSwapCatalogAppDelegate.h"

@implementation ILSwapSendText

- (id) initWithApplicationIdentifier:(NSString*) a type:(NSString*) t target:(id) ta didFinishSelector:(SEL) finish;
{
	if (!(self = [super initWithNibName:@"ILSwapSendText" bundle:nil]))
		return nil;
	
	self.title = NSLocalizedString(@"Send Text", @"Send text pane title");
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Send", @"Send button") style:UIBarButtonItemStyleDone target:self action:@selector(send)] autorelease];
	
	app = [a copy];
	type = [t copy];
	
	target = ta;
	didFinish = finish;
	
	return self;
}

- (void) dealloc
{
	[app release];
	[type release];
	[super dealloc];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
	return UIInterfaceOrientationIsPortrait(toInterfaceOrientation) || [ILSwapCatalogApp() shouldSupportAdditionalOrientation:toInterfaceOrientation forViewController:self];
}

- (void) viewDidLoad;
{
	[super viewDidLoad];
	textView.frame = self.view.bounds;
}

- (void) viewDidUnload;
{
	[super viewDidUnload];
	[textView release];
	textView = nil;
}

- (void) viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
		
	[[L0Keyboard sharedInstance] addObserver:self];
	[textView becomeFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated;
{
	if (animated)
		[textView flashScrollIndicators];
}

- (void) viewWillDisappear:(BOOL)animated;
{
	[super viewWillDisappear:animated];
	[[L0Keyboard sharedInstance] removeObserver:self];
}

- (void) keyboardWillAppear:(L0Keyboard *)k;
{
	//[k resizeViewToPreventCovering:textView originalFrame:self.view.bounds animated:YES];
	[k beginViewAnimationsAlongsideKeyboard:nil context:NULL];
	
	CGRect f = self.view.bounds;
	f.size.height -= k.bounds.size.height;
	textView.frame = f;
	
	[UIView commitAnimations];
}

- (void) keyboardWillDisappear:(L0Keyboard *)k;
{
	[k resizeViewToPreventCovering:textView originalFrame:self.view.bounds animated:YES];
}

- (void) send;
{
	[[ILSwapService sharedService] sendItem:[ILSwapItem itemWithValue:textView.text type:type attributes:nil] forAction:nil toApplicationWithIdentifier:app];
	
	if (target && didFinish)
		[target performSelector:didFinish withObject:self];	
}

- (void) dismissModal;
{
	[self dismissModalViewControllerAnimated:YES];
	
	if (target && didFinish)
		[target performSelector:didFinish withObject:self];
}

@end
