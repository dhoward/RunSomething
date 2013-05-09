//
//  ChoosePromptViewController.m
//  Run
//
//  Created by Daniel Howard on 3/22/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "ChoosePromptViewController.h"
#import "RunViewController.h"


@interface ChoosePromptViewController ()

@end

@implementation ChoosePromptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *customFont = [UIFont fontWithName:@"Oxygen-Regular" size:12];
    _easyLabel.font = customFont;
    _easyLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    _mediumLabel.font = customFont;
    _mediumLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    _hardLabel.font = customFont;
    _hardLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    NSLog(@"Getting prompts");
    NSString *requestString = @"http://localhost:3000/getPrompts";
        
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60.0];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:theRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *prompts = (NSDictionary *) JSON;
        
            for (NSDictionary *prompt in prompts) {
                [self parsePromptFromJson:prompt];                
            }
        
            UIFont *customFont = [UIFont fontWithName:@"Oxygen-Regular" size:12];
            _onePoint.titleLabel.font = customFont;
            _twoPoints.titleLabel.font = customFont;
            _threePoints.titleLabel.font = customFont;
        
            [ _onePoint setTitle:_prompt1.word forState: UIControlStateNormal];
            [ _twoPoints setTitle:_prompt2.word forState: UIControlStateNormal];
            [ _threePoints setTitle:_prompt3.word forState: UIControlStateNormal];
        
        } failure:nil];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choosePrompt:(id)sender
{
    switch([sender tag]) {
        case 1:
            [self beginGameWithPrompt: _prompt1];
            break;
        case 2:
            [self beginGameWithPrompt: _prompt2];
            break;
        case 3:
            [self beginGameWithPrompt: _prompt3];
            break;
    }
}

- (void)beginGameWithPrompt: (Prompt*)prompt
{
    _chosenPrompt = prompt;
    [self performSegueWithIdentifier:@"startGameWithPromptSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing for segue");
    if([segue.identifier isEqualToString:@"startGameWithPromptSegue"]) {
        NSLog(@"Found one");
        RunViewController *vc = [segue destinationViewController];
        vc.game = _game;
        vc.prompt = _chosenPrompt;
    }
}

- (Prompt*) parsePromptFromJson: (NSDictionary*)json {
    
    NSLog(@"Parsing prompt: %@", json);
    
    Prompt *newPrompt = [[Prompt alloc] init];
    
    NSLog(@"%@", [json objectForKey:@"_id"]);
    
    NSLog(@"PROMPT: %@", newPrompt);
    
    newPrompt.promptId = [json objectForKey:@"_id"];
    newPrompt.word = [json objectForKey:@"word"];
    newPrompt.points = [json objectForKey:@"points"];
    if([newPrompt.points isEqualToNumber:[NSNumber numberWithInt:1]]) {
        _prompt1 = newPrompt;
    } else if([newPrompt.points isEqualToNumber:[NSNumber numberWithInt:2]]) {
        _prompt2 = newPrompt;
    } else if([newPrompt.points isEqualToNumber:[NSNumber numberWithInt:3]]) {
        _prompt3 = newPrompt;
    }
    
    return newPrompt;
}

@end
