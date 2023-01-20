#include "HUSRootListController.h"
#import <Photos/Photos.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSliderTableCell.h>
#import <spawn.h>


@implementation HUSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}
-(void)DisplaySelectedPic{

UIImage *bobImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/ToldYou/GotYou.PNG"];
            UIImageView *bobImageView = [[UIImageView alloc] initWithImage:bobImage];
           CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            [bobImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            [[[UIApplication sharedApplication] keyWindow] addSubview:bobImageView];
            bobImageView.alpha = 1.0;
                        [UIView animateWithDuration:5.00 animations:^{
                            bobImageView.alpha = 1.0;
                [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                [UIView setAnimationBeginsFromCurrentState:YES];
                bobImageView.alpha = 0.0;
            } completion:^(BOOL finished){
            }];
}
 -(void)PickImage{

        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>) self;

            // Use delegate methods to get result of photo library -- Look up 
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:true completion:nil];
            
         
    }
    //image picker wuah
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
            NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/ToldYou/GotYou.PNG"];
            UIImage *picture = info[UIImagePickerControllerEditedImage];
            NSData *imageData = UIImagePNGRepresentation(picture);
            [imageData writeToFile:path atomically:YES];
            //animation ends
            [self dismissViewControllerAnimated: YES completion: nil];
        }


-(void)_returnKeyPressed:(id)arg1 {
    [self.view endEditing:YES];
}

@end
