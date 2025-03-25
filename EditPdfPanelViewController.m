//
//  EditPdfPanelViewController.m
//  PunchCocoa
//
//  Created by Alain Cohen on 09/09/2021.
//

#import "dev-Swift.h"
#import <Foundation/Foundation.h>
#import "EditPdfPanelViewController.h"
@import PSPDFKit;
@import PSPDFKitUI;

static int TOPBAR_HEIGHT = 44;
static int TOOLBAR_HEIGHT = 50;
static int TOOLBAR_INTERNAL_HEIGHT = 44; // also the width of the color button
static int BUTTON_WIDTH = 30;
static int BUTTON_GROUP_GAP = 30; // corresponds to the additional empty space at the right of move_large.png and left of undo_large.png
static int TOOLBAR_ADDITIONAL_WIDTH = 10;
static int NUMBER_OF_BUTTONS = 6;
static int NUMBER_OF_GROUPS = 3;
static int SPACER_INDEX = 3;


@interface EditPdfPanelViewController (Private)
@property (readonly) UIView* pdfView;
@end

@implementation EditPdfPanelViewController(Private)

-(UIView *) pdfView {
    return _pdfView;
}

@end


@implementation EditPdfPanelViewController
@synthesize loader;
@synthesize downloadUrl;
@synthesize attachmentId;

- (instancetype) init {
    if (self = [self initWithNibName:@"EditPdfPanelView" bundle:nil]) {
        [self initPSPDFGlobal];
    }
    return self;
}

- (void)initPSPDFGlobal {
    [PSPDFKitGlobal setLicenseKey:@"P8Dj7Cv2mIIFFIRsFqZLHjXmOttQp9Kp1DTeuMWR3TZXomGt8z9D8qyQeYQo_RkCRSs0bEFB85LnsBtdiBQ56v3aty0f-YDCbn3QGsexhduDlnO_sUD4K3HWVGY58N4_d_DFQc1wk9oPQYw8vyNI_KJisIkizjCROdqt_19Fg20sDSjs-uOL_K465CKSXNTQAmLxc_ALas-1-7Qq_SG3HazZ9P4yrbNCIavIC1NzGP2RLGEu22VzR65ItNSRyNzL7dRqu_at3SfkCiavAHE-hz2abtZo0VD94rXRjQD5ZO-5l0O27ruSU_NBt27L3JRH1rNta7Gfv1LCPSUAL1qJ2PGPRodb5n7yKUr-fexMUja1QaGTcw0VeHLqFQX0smCE0eSFZoU7hK57Us74GctpEdBwHs6h9SI0T4b0YzBFOYW1A35Qu4fB6hdzDl0WZhJjMBpp0swxUVxeCspchN0QI7XE8LV1zE97-KGXrf9FWBcYxiiiwdgth2X1ks4i41vbw6Y2IRqBn4Ls-PbXlLnYcNDAxRA_Dy1cKtbFtzq1fWkzSro5DKGWqTeouL7wzhoJFnTX9WDrubrsxURJt16yoH20-zSS1h19FR8BawF3NOTZrrFWI9CKseEZ0KVPuiRI"];

    
    [PSPDFUsernameHelper setDefaultAnnotationUsername:@"Myself"];
}

-(CustomViewController *) buildPdfController:(NSURL *) documentUrl{
    __strong PSPDFDocument *document = [[PSPDFDocument alloc] initWithURL:documentUrl];
    PSPDFConfiguration * _Nonnull configuration = [PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.pageLabelEnabled = NO;
        builder.documentLabelEnabled = NO;
        builder.thumbnailBarMode = PSPDFThumbnailBarModeNone;
        builder.freeTextAccessoryViewEnabled = NO;
        builder.autosaveEnabled = NO;
//        builder.shouldHideNavigationBarWithUserInterface = PSPDFUserInterfaceViewModeAlways;
        builder.scrollDirection = PSPDFScrollDirectionVertical;
        [builder overrideClass:PSPDFViewController.class withClass:CustomViewController.class];
        [builder overrideClass:PSPDFAnnotationToolbar.class withClass:CustomAnnotationToolbar.class];
        [builder overrideClass:PSPDFToolbarSelectableButton.class withClass:CustomToolbarSelectableButton.class];
        [builder overrideClass:PSPDFToolbarButton.class withClass:CustomToolbarButton.class];
        [builder overrideClass:PSPDFToolbarGroupButton.class withClass:CustomToolbarGroupButton.class];
    }];
    CustomViewController *pdfController = [[CustomViewController alloc] initWithDocument:document configuration:configuration];

    [pdfController.document setAnnotationSaveMode:PSPDFAnnotationSaveModeEmbedded];


    [self setupDefaultStyles];

    pdfController.annotationToolbarController.annotationToolbar.toolbarDelegate = self;

    return pdfController;
}

- (void) setupDefaultStyles {
    __strong id<PSPDFAnnotationStyleManager>  _Nonnull styleManager = PSPDFKitGlobal.sharedInstance.styleManager;
    
    // Line widths.
    [styleManager setLastUsedValue:@(2) forProperty:NSStringFromSelector(@selector(lineWidth)) forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
    
    // Colors.
    UIColor *blue = [UIColor colorNamed:@"blue"];
    
    [styleManager setLastUsedValue:blue forProperty:NSStringFromSelector(@selector(color)) forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringInk, nil)];
    [styleManager setLastUsedValue:blue forProperty:NSStringFromSelector(@selector(color)) forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringFreeText, nil)];

    // Fonts.
    [styleManager setLastUsedValue:@(12) forProperty:NSStringFromSelector(@selector(fontSize)) forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringFreeText, nil)];
    [styleManager setLastUsedValue:@"Helvetica" forProperty:NSStringFromSelector(@selector(fontName)) forKey:PSPDFAnnotationStateVariantIDMake(PSPDFAnnotationStringFreeText, nil)];
}

- (PSPDFAnnotationToolbarConfiguration *)makeToolbarConfiguration {
    return [[PSPDFAnnotationToolbarConfiguration alloc] initWithAnnotationGroups:@[
        [PSPDFAnnotationGroup groupWithItems:@[
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringInk variant:nil configurationBlock:
                 ^UIImage *(PSPDFAnnotationGroupItem *item, id container, UIColor *tintColor) {
                UIImage *image = [UIImage imageNamed:@"ink_Normal.png"];
                return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }]
        ]],
        [PSPDFAnnotationGroup groupWithItems:@[
            [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringFreeText variant:nil configurationBlock:
                 ^UIImage *(PSPDFAnnotationGroupItem *item, id container, UIColor *tintColor) {
                UIImage *image = [UIImage imageNamed:@"freetext_Normal.png"];
                return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }]
        ]],
    ]];
}

-(void) buildViewOnPdfLoaded:(NSURL *) pdfUrl {
    
    _canClose = NO;
    
    [self setupColorDesign];
    
    _pdfController = [self buildPdfController:pdfUrl];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_pdfController];
    [_pdfView addSubview: navController.view];
    navController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
                                             [navController.view.leadingAnchor constraintEqualToAnchor:_pdfView.leadingAnchor constant:0],
                                             [navController.view.trailingAnchor constraintEqualToAnchor:_pdfView.trailingAnchor constant:0],
                                             [navController.view.topAnchor constraintEqualToAnchor:_pdfView.topAnchor constant:0],
                                             [navController.view.bottomAnchor constraintEqualToAnchor:_pdfView.bottomAnchor constant:0],
                                             nil]];
    
    [navController setNavigationBarHidden:YES];
    
    [self setupAnnotationToolbar];

}

- (void)setupColorDesign {
    UIColor * _Nonnull white = [UIColor colorWithWhite:1.f alpha:1.f];
    UIColor * _Nonnull grey = [UIColor colorWithWhite:0.4f alpha:.7f];
    UIColor * _Nonnull darkGrey = [UIColor colorWithWhite:0.1f alpha:1.f];
    
    PSPDFAnnotationToolbar *annotationToolbarProxy = [PSPDFAnnotationToolbar appearance];
    annotationToolbarProxy.selectedTintColor = darkGrey;
    annotationToolbarProxy.tintColor = grey;

    UIToolbarAppearance *appearance = [[UIToolbarAppearance alloc] init];
    appearance.backgroundColor = white;
    annotationToolbarProxy.standardAppearance = appearance;
    annotationToolbarProxy.compactAppearance = appearance;
    annotationToolbarProxy.selectedBackgroundColor = white;
    
    annotationToolbarProxy.borderedToolbarPositions = PSPDFFlexibleToolbarPositionNone;
    
    _pdfView.layer.borderWidth = 1;
    _pdfView.layer.borderColor = darkGrey.CGColor;
    _pdfView.layer.cornerRadius = 4;
    _pdfView.layer.masksToBounds = true;
}

- (void)setupAnnotationToolbar {
    [_pdfController.annotationToolbarController updateHostView:nil container:nil viewController:_pdfController];
    [_pdfController.annotationToolbarController showToolbarAnimated:YES completion:nil];

    PSPDFFlexibleToolbarContainer * _Nullable annotationContainer = _pdfController.annotationToolbarController.flexibleToolbarContainer;
    
    
    NSLog(@"annotationContainer.isHidden: %d", annotationContainer.isHidden);

    annotationContainer.flexibleToolbar.supportedToolbarPositions = PSPDFFlexibleToolbarPositionInTopBar;
    
    
    [annotationContainer.flexibleToolbar setToolbarPosition: PSPDFFlexibleToolbarPositionInTopBar];
    
    [_toolbarView addSubview:annotationContainer];
    
    annotationContainer.containerDelegate = self;

    PSPDFAnnotationToolbar * _Nonnull annotationToolbar = _pdfController.annotationToolbarController.annotationToolbar;

    
    annotationToolbar.collapseUndoButtonsForCompactSizes = NO;
    PSPDFAnnotationToolbarConfiguration *toolbarConfiguration = [self makeToolbarConfiguration];
    annotationToolbar.configurations = @[toolbarConfiguration];

    
    NSArray<__kindof UIButton *> * _Nonnull buttons = [annotationToolbar buttons];
    PSPDFToolbarGroupButton * inkGroupButton = (PSPDFToolbarGroupButton *)buttons[0];
    inkGroupButton.actionBlock = ^(PSPDFButton * _Nonnull button) {
        [self->_pdfController.annotationStateManager setState:PSPDFAnnotationStringInk variant:nil];
    };
    PSPDFToolbarGroupButton * textGroupButton = (PSPDFToolbarGroupButton *)buttons[1];
    textGroupButton.actionBlock = ^(PSPDFButton * _Nonnull button) {
        [self->_pdfController.annotationStateManager setState:PSPDFAnnotationStringFreeText variant:nil];
    };
    
    PSPDFToolbarSpacerButton *spacer = ((PSPDFToolbarSpacerButton *)buttons[SPACER_INDEX]);
    spacer.flexible = NO;
    spacer.length = 0;
    
    PSPDFColorButton * colorButton = annotationToolbar.strokeColorButton;
    colorButton.shape = PSPDFColorButtonShapeRoundedRect;
    colorButton.outerBorderPadding = 0;
    colorButton.outerBorderWidth = 1;
    colorButton.outerBorderColor = [UIColor colorWithWhite:0.5f alpha:1.f];
    CGFloat length = 15;
    colorButton.contentInset = UIEdgeInsetsMake(length, length, length, length);
    
    PSPDFToolbarButton *undoButton = ((PSPDFToolbarButton *)annotationToolbar.undoButton);
    undoButton.flexible = YES;
    undoButton.touchAreaInsets = UIEdgeInsetsMake(0, BUTTON_GROUP_GAP, 0, 0);
}

- (int) getToolbarWidth {
    return NUMBER_OF_BUTTONS * BUTTON_WIDTH + TOOLBAR_INTERNAL_HEIGHT + (NUMBER_OF_GROUPS - 1) * BUTTON_GROUP_GAP + TOOLBAR_ADDITIONAL_WIDTH;
}

// `PSPDFFlexibleToolbarDelegate`
- (void)flexibleToolbarWillShow:(PSPDFFlexibleToolbar *)toolbar {
    [_pdfController.annotationStateManager setState:PSPDFAnnotationStringInk variant:nil];
}

- (CGRect)getFrameForFullscreenPdfView {
    CGFloat topbarHeight = 30;
    CGFloat toolbarHeight = _toolbarView.bounds.size.height;
    CGRect outerBounds = _contentView.bounds;
    float x = outerBounds.origin.x + 18;
    float y = outerBounds.origin.y + topbarHeight;
    float width = outerBounds.size.width + 100;
    float height = outerBounds.size.height - topbarHeight - toolbarHeight;
    CGRect result = CGRectMake(x, y, width, height);
    return CGRectIntersection(outerBounds, result);
}

- (CGRect)getFrameForToolbar {
    CGRect outerBounds = [[UIScreen mainScreen] bounds];
    float x = outerBounds.origin.x + 13;
    float y = outerBounds.origin.y + outerBounds.size.height - (TOOLBAR_HEIGHT + TOOLBAR_INTERNAL_HEIGHT);
    float width = [self getToolbarWidth];
    float height = TOOLBAR_INTERNAL_HEIGHT * 2;
    CGRect result = CGRectMake(x, y, width, height);
    return CGRectIntersection(outerBounds, result);
}

- (void)updateLayout {

    _contentView.frame = self.view.bounds;
    
    _toolbarView.frame = [self getFrameForToolbar];
    _pdfView.frame = [self getFrameForFullscreenPdfView];
    
    [self.view addSubview:_toolbarView];
}

- (void)initLayout {
    [self.view addSubview:_contentView];
    [self updateLayout];
}

-(void) viewDidLoad {
    [super viewDidLoad];

    _canClose = YES;
    
    [self initLayout];
    
    [self.navigationController pushViewController:_pdfController animated:YES];
    [_pdfController didMoveToParentViewController:self];

    
    NSURL *documentURL = [[NSBundle mainBundle] URLForResource:@"Fichier" withExtension:@"pdf"];
    
    [self buildViewOnPdfLoaded:documentURL];

}
@end


#pragma mark CustomAnnotationToolbar

@implementation CustomAnnotationToolbar

-(UIButton *) doneButton {
    return nil;
}

-(UIButton *) applePencilButton {
    return nil;
}

@end

@implementation CustomToolbarSelectableButton

- (CGFloat) length {
    return BUTTON_WIDTH;
}

@end

@implementation CustomToolbarButton

- (CGFloat) length {
    return BUTTON_WIDTH;
}

@end

@implementation CustomToolbarGroupButton

- (CGFloat) length {
    return BUTTON_WIDTH;
}

@end

@implementation CustomViewController

- (BOOL)resolutionManager:(PSPDFConflictResolutionManager *)manager shouldPerformAutomaticResolutionForForDocument:(PSPDFDocument *)document dataProvider:(id<PSPDFCoordinatedFileDataProviding>)dataProvider conflictType:(PSPDFFileConflictType)type resolution:(inout PSPDFFileConflictResolution *)resolution {
    switch (type) {
        case PSPDFFileConflictTypeDeletion:
            // Unconditionally close the document — EVEN WHEN THERE ARE UNSAVED CHANGES!
            *resolution = PSPDFFileConflictResolutionClose;
            return YES;
        case PSPDFFileConflictTypeModification:
            // Unconditionally reload the document from disk — EVEN WHEN THERE ARE UNSAVED CHANGES!
            *resolution = PSPDFFileConflictResolutionReload;
            return YES;
    }
}

@end

