//
//  EditPdfPanelViewController.h
//  PunchCocoa
//
//  Created by Alain Cohen on 09/09/2021.
//

#ifndef EditPdfPanelViewController_h
#define EditPdfPanelViewController_h

#import <UIKit/UIKit.h>
#import <PDFKit/PDFView.h>
#import <PDFKit/PDFAnnotation.h>
#import "PSPDFKitUI/PSPDFFlexibleToolbar.h"
#import "PSPDFKitUI/PSPDFFlexibleToolbarContainer.h"
#import "PSPDFKitUI/PSPDFAnnotationToolbar.h"
#import "PSPDFKitUI/PSPDFColorButton.h"
#import "PSPDFKitUI/PSPDFToolbarButton.h"

@class UpdateDocumentCoordinator;


@interface EditPdfPanelInitializer : NSObject

@property NSString *downloadUrl;
@property id attachmentId;

@end

@interface CustomAnnotationToolbar : PSPDFAnnotationToolbar @end

@interface CustomToolbarSelectableButton : PSPDFToolbarSelectableButton @end

@interface CustomToolbarButton : PSPDFToolbarButton @end

@interface CustomToolbarGroupButton : PSPDFToolbarGroupButton @end

@interface CustomViewController : PSPDFViewController @end


@class PSPDFViewController;
@class CustomToolbarSelectableButton;
@class PDFLoader;

@interface EditPdfPanelViewController : UIViewController<PSPDFFlexibleToolbarDelegate, PSPDFFlexibleToolbarContainerDelegate> {
    __strong IBOutlet UIView *_mainView;
    __strong IBOutlet UIView *_contentView;
    __strong IBOutlet UINavigationBar *_navigationBar;
    __strong IBOutlet UIView *_pdfView;
    __strong IBOutlet UIView *_topbarView;
    __strong IBOutlet UIButton *_saveButton;
    __strong IBOutlet UIButton *_backgroundSaveButton;
    __strong IBOutlet UIView *_toolbarView;

    __strong UpdateDocumentCoordinator *_updateDocumentCoordinator;
    __strong CustomViewController* _pdfController;
    BOOL _isEdited;
    BOOL _canClose;
    BOOL _isSaving;
}

@property (strong) NSString *downloadUrl;
@property (strong) id attachmentId;
@property (strong) PDFLoader *loader;

@end



#endif /* EditPdfPanelViewController_h */
