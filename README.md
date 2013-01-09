# Background
I had a need to create a registration form in an iOS application and started looking around for a good framework for building forms.  IBAForms looks to be one of the most robust frameworks for creating forms, so I started down this road.  I'm pretty new to iOS and Objective-C, and have mostly been dealing with Storyboards so far within XCode.  So when I first started looking at IBAForms, it was quite confusing trying to wrap my head around how to mix Storyboards and programatically building a View and the form.  That on top of the "my-code-is-my-documentation" mentality of IBAForms made it somewhat difficult to figure out.  So I took the afternoon to figure it out and while I was at it, decided to document things along the way.  So this is an example of how to use IBAForms with Storyboards for iOS.  I hope someone else finds this usefull as well!  Here are all of the steps I went though to create this example:

# Starting out 
Create a new project
Choose a Single View Application
Make sure Use Storyboards and Use ARC are selected
Close your Xcode Project (don't worry, we'll open it again later!)

## Adding IBAForms
Now before we get too far, we have to add IBAForms to our project.  We are going to use [CocoaPods](http://cocoapods.org "cocoapods.org") to help us with that.  (I'm assuming you already have cocoapods installed.  if not, look at their page, it's very easy to install) 
First create a file called `Podfile` in the root of your project directory. 
Put the following as the contents of that file:

    platform :ios
    pod 'IBAForms', '~> 1.1.0'

Then run:

    pod install

Now open the new `.xcworkspace` file that was created.  Use this file from now on instead of the .xcodeproj
 
    open IBAFormStoryboard.xcworkspace

#Creating our view in the Storyboard
Open up the storyboard
Add a `TableView` to the View Controller
Click on the Table View and change the Style to Grouped.  
Now we are going to add an outlet for the table view so we can reference it later.  Make sure your editor is set to show the Assistant Editor. Control click and drag from the table view to your .h file.
You will create a connection of type Outlet.  
Name it `tableView`
The Type should be `UITableView`
The Storage should be Weak

Now select your implementation file (.m) for your view controller. 
Add:

    @synthesize tableView;

In your .h file, we need to change what your view controller implements. We first need to import the IBAForms.h file in your header then extend from IBAFormViewController:

So now you should have:

    #import <UIKit/UIKit.h>
    #import "IBAForms/IBAForms.h"

    @interface ViewController : IBAFormViewController
    @property (weak, nonatomic) IBOutlet UITableView *tableView;

    @end

#Creating our Form
Now before moving on to the View implementation, we are going to take a look at the Form setup.  IBAForms requires 3 basic things to implement it's forms.
  
* First create a Model to store the information that is entered into the form.  
* We will next create a DataSource that will get the form data from the user.  
* And 3rd we will attach the Model to the DataSource and the DataSource to the View.  

##Model
I made this simple model object (it just extends NSObject):

    @interface User : NSObject

    @property (nonatomic, copy) NSString *email;
    @property (nonatomic, copy) NSString *password;

    @end

    #import "User.h"

    @implementation User

    @end

##Datasource
Next we are going to create a data source for the User data.  This Data source will implement IBAFormDataSource and as such will have to implement one method:

    - (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action;

We will also add an `IBAButtonFormFieldBlock` that will be an action for us to use when the user click a button. 

So here is the basic one:

    #import "IBAForms/IBAForms.h"
    #import <IBAForms/IBAButtonFormField.h>

    @interface UserDataSource : IBAFormDataSource

    @property (nonatomic, copy) IBAButtonFormFieldBlock actionBlock;

    - (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action;

    @end

Now the implementation of this class is the meat of the form.  We will map fields to the model, add form fields, and map the action to a field as well. 

	#import "UserDataSource.h"
	#import <IBAForms/IBAForms.h>
	
	@implementation UserDataSource
	@synthesize actionBlock = actionBlock_;
	
	- (void)dealloc {
		actionBlock_ = nil;
	}
	
	- (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action
	{
	    if ((self = [super initWithModel:model])) {
	        //Save the Action for later use.
			[self setActionBlock:action];
	        
	        //Create the form fields for the login info.
			IBAFormSection *loginFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
	        //Note the keyPath.  This is the selector for the field in our Model that will map to this field.
			IBATextFormField *emailTextFormField = [IBATextFormField emailTextFormFieldWithSection:loginFormSection
	                                                                                       keyPath:@"email"
	                                                                                         title:NSLocalizedString(@"Email", @"")
	                                                                              valueTransformer:nil];
			IBATextFormField *passwordTextFormField = [IBATextFormField passwordTextFormFieldWithSection:loginFormSection
	                                                                                             keyPath:@"password"
	                                                                                               title:NSLocalizedString(@"Password", @"")
	                                                                                    valueTransformer:nil];
	        
	        //Give the fields a little more style
	        [emailTextFormField setFormFieldStyle:[self textFormFieldStyle]];
	        [passwordTextFormField setFormFieldStyle:[self textFormFieldStyle]];
	        
	        //Change the behavior of the password text field.
			UITextField *passwordTextField = [[passwordTextFormField textFormFieldCell] textField];
			[passwordTextField setKeyboardType:UIKeyboardTypeDefault];
			[passwordTextField setReturnKeyType:UIReturnKeyDone];
	        
	        //Attach our action to when the user is done editing the text field.
			[passwordTextField addTarget:self
								  action:@selector(passwordTextFieldEditingDidEnd:withEvent:)
						forControlEvents:UIControlEventEditingDidEnd];
	        
	        //Create a Login button they can click on and attach our action to it.
			IBAFormSection *submitFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
			IBAButtonFormField *submitFormField = [[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Login", @"")
	                                                                                   icon:nil
	                                                                         executionBlock:action];
	        [submitFormField setFormFieldStyle:[self buttonFormFieldStyle]];
			[submitFormSection addFormField:submitFormField];
		}
	    
		return self;
	}
	
	- (void)passwordTextFieldEditingDidEnd:(id)sender withEvent:(UIEvent *)event {
		if ([self actionBlock]) {
			[self actionBlock]();
		}
	}
	
	- (IBAFormFieldStyle *)textFormFieldStyle {
		IBAFormFieldStyle *style = [[IBAFormFieldStyle alloc] init];
	    
		[style setLabelTextColor:[UIColor blackColor]];
		[style setLabelFont:[UIFont boldSystemFontOfSize:13.]];
		[style setLabelTextAlignment:UITextAlignmentRight];
		[style setLabelFrame:CGRectMake(IBAFormFieldLabelX, 8., 180., IBAFormFieldLabelHeight)];
	    
		[style setValueTextAlignment:UITextAlignmentLeft];
		[style setValueTextColor:[UIColor colorWithRed:.22 green:.329 blue:.529 alpha:1.]];
		[style setValueFont:[UIFont systemFontOfSize:14.]];
		[style setValueFrame:CGRectMake(210., 20., 110., IBAFormFieldValueHeight)];
	    
		return style;
	}
	
	- (IBAFormFieldStyle *)buttonFormFieldStyle {
		IBAFormFieldStyle *style = [[IBAFormFieldStyle alloc] init];
	    
		[style setLabelTextColor:[UIColor colorWithRed:.318 green:.4 blue:.569 alpha:1.]];
		[style setLabelFont:[UIFont boldSystemFontOfSize:20.]];
		[style setLabelFrame:CGRectMake(10., 8., 300., 30.)];
		[style setLabelTextAlignment:UITextAlignmentCenter];
		[style setLabelAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	    
		return style;
	}
Note: The action is mapped to both when the user leaves editing the password field and when they hit Login button. This might not be what you want.  In this example, if you enter the password and his the login button, it will execute the action twice. So handle it the way you want to. 

#Implement the ViewController
Now we can move over to the implementation of our view controller.  We are going to do a couple of things.  In our viewDidLoad, we are going to register our tableView, create our model, action, and datasource and map them all together.  Then lastly, map our data source to the view controller.  Also, you must call [super viewDidLoad].  This is my ViewController.m now:

    #import "ViewController.h"
    #import "User.h"
    #import "UserDataSource.h"

	@interface ViewController ()
	
	@end
	
	@implementation ViewController
	
	@synthesize tableView;
	
	- (void)viewDidLoad
	{
	    [super viewDidLoad];
		// Do any additional setup after loading the view, typically from a nib.
	    
	    [self setTableView:tableView];
	    User *user = [User alloc];
	    IBAButtonFormFieldBlock action = ^{
			[[IBAInputManager sharedIBAInputManager] performSelector:@selector(setActiveInputRequestor:)
														  withObject:nil
														  afterDelay:1.];
	        
			UIAlertView *info = [[UIAlertView alloc]
	                             initWithTitle:@"Form Info"
	                             message:[NSString stringWithFormat:@"User Entered: \nEmail - %@\nPassword - %@",
	                                      user.email, user.password]
	                             delegate:nil
	                             cancelButtonTitle:@"OK"
	                             otherButtonTitles:nil];
	        
	        // shows alert to user
	        [info show];
		};
	    
	    UserDataSource *dataSource = [[UserDataSource alloc] initWithModel:user formAction:action];
	    [self setFormDataSource:dataSource];
	
	}
	
	- (void)didReceiveMemoryWarning
	{
	    [super didReceiveMemoryWarning];
	    // Dispose of any resources that can be recreated.
	}
	
	@end

#Fin
Now, RUN IT!


###Disclaimer
Like I said, I'm new to all this Objective-C stuff and ARC specifcally.  There may be places in here where I'm not cleaning things up like I should be.  If anyone has edits, please feel free to submit a pull request!!  It would help me learn!  



