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
    IBOutlet UIView *_mainView;
    IBOutlet UIView *_contentView;
    IBOutlet UINavigationBar *_navigationBar;
    IBOutlet UIView *_pdfView;
    IBOutlet UIView *_topbarView;
    IBOutlet UIButton *_saveButton;
    IBOutlet UIButton *_backgroundSaveButton;
    IBOutlet UIView *_toolbarView;

    UpdateDocumentCoordinator *_updateDocumentCoordinator;
    CustomViewController* _pdfController;
    BOOL _isEdited;
    BOOL _canClose;
    BOOL _isSaving;
}

@property NSString *downloadUrl;
@property id attachmentId;
@property PDFLoader *loader;

@end



#endif /* EditPdfPanelViewController_h */
