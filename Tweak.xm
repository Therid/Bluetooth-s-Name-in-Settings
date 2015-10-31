#import <UIKit/UIKit.h>
#import<Foundation/Foundation.h>

@interface PreferencesAppController : UIApplication 
{
}
-(void)applicationWillResignActive:(id)arg1;
-(void)applicationDidBecomeActive:(id)arg1;
@end

@interface UITableViewLabel : UILabel
{
}
-(id)tableCell;
@property (nonatomic,retain) UITableViewCell* tableCell;
@end

@interface BluetoothManager : NSObject
{
    NSArray* connectedDevices;
}
-(void)_connectedStatusChanged;
+(id)sharedInstance;
-(id)connectedDevices;
-(BOOL)powered;
@property (nonatomic,retain) NSArray* connectedDevices;
@end

@interface BluetoothDevice : NSObject
{
    NSString *name;
}
@property (nonatomic,retain) NSString* name;
@end

static BluetoothManager* manager;
static UITableView* tableTarget;
static UITableViewCell* cell ; 

%hook UITableViewCell

//ajoute le nom de l'appareil bluetooth apres que la cellule soit apparue

-(void)layoutSubviews
{
      %orig;
      if ([self.textLabel.text isEqualToString:NSLocalizedString(@"BTMACAddress",@"Bluetooth") ]==YES && [self isKindOfClass:[objc_getClass("PSSwitchTableCell") class]]== NO && self.detailTextLabel.frame.size.height == self.textLabel.frame.size.height )
      {   
             tableTarget = ((UITableView*)[[self superview]superview]); 
             if([[manager connectedDevices]count]!=0)
             {
                    self.detailTextLabel.text=((BluetoothDevice*)[[manager connectedDevices]objectAtIndex:0]).name;   
             }
            else if ([manager powered]== NO)
            {
            }  
            else
            {
                 if ([NSLocalizedString(@"On",@"On") isEqualToString:@"oui"] == YES)
                 {
                          self.detailTextLabel.text=@"Oui";   
                 }
                 else
                 {
                         self.detailTextLabel.text=NSLocalizedString(@"On",@"On");   
                 }
            }  
      }
}
%end

%hook PreferencesAppController

// recupere l'instance BluetoothManager globale et gete une notification signalant qu'elle est prete a etre utilisee

-(void)applicationDidBecomeActive:(id)arg1
{
    %orig;
    manager =[BluetoothManager sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothAvailabilityChanged:) name:@"BluetoothAvailabilityChangedNotification" object:nil];
}

// retire l'observer

-(void)applicationWillResignActive:(id)arg1
{
    %orig;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//affiche le nom de l'appareil bluetooth si il y en avait deja un de connecter avant l'ouverture de l'application 

%new
- (void)bluetoothAvailabilityChanged:(NSNotification *)notification
{
    for (int i = 0; i< [tableTarget.visibleCells count]; i++)
    {
            cell= [tableTarget.visibleCells objectAtIndex:i];
            if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"BTMACAddress",@"Bluetooth") ]==YES && [cell isKindOfClass:[objc_getClass("PSSwitchTableCell") class]]== NO && cell.detailTextLabel.frame.size.height == cell.textLabel.frame.size.height)
            {
                 if([[manager connectedDevices]count]!=0)
                 {
                        cell.detailTextLabel.text=((BluetoothDevice*)[[manager connectedDevices]objectAtIndex:0]).name;   
                 }
                 else if ([manager powered]== NO)
                 {
                 }  
                else
                {
                       cell.detailTextLabel.text=NSLocalizedString(@"On",@"On");   
                       if ([cell.detailTextLabel.text isEqualToString:@"oui"] == YES)
                       {
                            cell.detailTextLabel.text=@"Oui";   
                       }
                 }   
            }
      }
}
%end

%hook BluetoothManager

//lorsqu'un appareil est connecte ou deconnecte, change le sous titre de la case bluetooth en indiquant le nom de l'appareil ou la phrase "Oui"

-(void)_connectedStatusChanged 
{
    %orig;
    for (int i = 0; i< [tableTarget.visibleCells count]; i++)
    {
            cell= [tableTarget.visibleCells objectAtIndex:i];
            if ( [cell.textLabel.text isEqualToString:NSLocalizedString(@"BTMACAddress",@"Bluetooth") ]==YES && [cell isKindOfClass:[objc_getClass("PSSwitchTableCell") class]]== NO && cell.detailTextLabel.frame.size.height == cell.textLabel.frame.size.height)
            {
                    if([[manager connectedDevices]count]!=0)
                    {
                          cell.detailTextLabel.text=((BluetoothDevice*)[[manager connectedDevices]objectAtIndex:0]).name;   
                    }
                    else if ([manager powered]== NO)
                    {
                    }  
                   else
                   {
                          cell.detailTextLabel.text=NSLocalizedString(@"On",@"On");   
                          if ([cell.detailTextLabel.text isEqualToString:@"oui"] == YES)
                         {
                                cell.detailTextLabel.text=@"Oui";   
                         }
                   }  
            }
      }
}
%end
