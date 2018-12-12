# PowerShell Basics: Getting More Information with Get-Member 

PowerShell is an effective command line interface to retrieve information about computer systems and services. Type in a command like get-service, and you receive a listing of all the services on a Windows system and their status.
```
PS C:\GitHub\demos> get-service

Status   Name               DisplayName
------   ----               -----------
Running  AdobeARMservice    Adobe Acrobat Update Service
Stopped  AJRouter           AllJoyn Router Service
Stopped  ALG                Application Layer Gateway Service
Stopped  AppIDSvc           Application Identity
Running  Appinfo            Application Information
Stopped  AppMgmt            Application Management
Stopped  AppReadiness       App Readiness
Stopped  AppVClient         Microsoft App-V Client
Stopped  AppXSvc            AppX Deployment Service (AppXSVC)
Stopped  AssignedAccessM... AssignedAccessManager Service
Running  AudioEndpointBu... Windows Audio Endpoint Builder
Running  Audiosrv           Windows Audio
```

While helpful, you might think there must be more information on the services running on a system than what is displayed here. Well, there is. By default, PowerShell uses default views to display common properties when commands are run. To see all of the properties available from a command, we use the pipeline, and a command called *Get-Member*. One of the commands everyone should know, Get-Member retrieves the 'membership' of an object by showing its properties and methods.
use the commands output as input for get-member using the syntax of 
```
 Some-Command | Get-Member or gm (an alias for get-member) 
```

Now let's see what information lies within the output of get-service.

```
PS C:\GitHub\demos> get-service | Get-Member


   TypeName: System.ServiceProcess.ServiceController

Name                      MemberType    Definition
----                      ----------    ----------
Name                      AliasProperty Name = ServiceName
RequiredServices          AliasProperty RequiredServices = ServicesDependedOn
Disposed                  Event         System.EventHandler Disposed(System.Object, System.EventArgs)
Close                     Method        void Close()
Continue                  Method        void Continue()
CreateObjRef              Method        System.Runtime.Remoting.ObjRef CreateObjRef(type requestedType)
Dispose                   Method        void Dispose(), void IDisposable.Dispose()
Equals                    Method        bool Equals(System.Object obj)
ExecuteCommand            Method        void ExecuteCommand(int command)
GetHashCode               Method        int GetHashCode()
GetLifetimeService        Method        System.Object GetLifetimeService()
GetType                   Method        type GetType()
InitializeLifetimeService Method        System.Object InitializeLifetimeService()
Pause                     Method        void Pause()
Refresh                   Method        void Refresh()
Start                     Method        void Start(), void Start(string[] args)
Stop                      Method        void Stop()
WaitForStatus             Method        void WaitForStatus(System.ServiceProcess.ServiceControllerStatus desiredStatus), void WaitForStatus(System.ServiceProcess.ServiceCon...
CanPauseAndContinue       Property      bool CanPauseAndContinue {get;}
CanShutdown               Property      bool CanShutdown {get;}
CanStop                   Property      bool CanStop {get;}
Container                 Property      System.ComponentModel.IContainer Container {get;}
DependentServices         Property      System.ServiceProcess.ServiceController[] DependentServices {get;}
DisplayName               Property      string DisplayName {get;set;}
MachineName               Property      string MachineName {get;set;}
ServiceHandle             Property      System.Runtime.InteropServices.SafeHandle ServiceHandle {get;}
ServiceName               Property      string ServiceName {get;set;}
ServicesDependedOn        Property      System.ServiceProcess.ServiceController[] ServicesDependedOn {get;}
ServiceType               Property      System.ServiceProcess.ServiceType ServiceType {get;}
Site                      Property      System.ComponentModel.ISite Site {get;set;}
StartType                 Property      System.ServiceProcess.ServiceStartMode StartType {get;}
Status                    Property      System.ServiceProcess.ServiceControllerStatus Status {get;}
ToString                  ScriptMethod  System.Object ToString();
```
From this we see there are a lot of properties not being displayed, actually 14 if we do a quick check.
```
PS C:\GitHub\demos> ( Get-Service | Get-Member | Where-Object -Property Membertype -EQ Property ).count
14
```
So now that you know the properties available for each get-service object, you use the data contained in each property anyway you see fit. For ease of demonstration, lets say you have a server whose services are not starting up properly, and you believe the issue may be due to dependent services not starting in a timely fashion. To assist, you want a list of all services including service name, service status, and the names of any services depended on (ServicesDependedOn) to start properly. Using format-table, we can view that in a flash. 
```
PS C:\GitHub\demos> get-service | format-table -Property Name,Status,ServicesDependedOn

Name                                                    Status ServicesDependedOn
----                                                    ------ ------------------
AdobeARMservice                                        Running {}
AJRouter                                               Stopped {}
ALG                                                    Stopped {}
AppIDSvc                                               Stopped {RpcSs, CryptSvc, AppID}
Appinfo                                                Running {RpcSs, ProfSvc}
AppMgmt                                                Stopped {}
AppReadiness                                           Stopped {}
```
And there you have your table showing all the information you need.

Another great use for get-member is when working with Active Directory objects. As you can imagine, user objects have a bunch of properties, and they are not all displayed when using the *Get-ADUser* command. Using Get-Member will help you find all the properties for user objects. 

**Important Note**
With Get-ADUser and other Get- commands for Active Directory, the default usage only displays a subset of the properties available on a user object. To retrieve all the properties associated with an AD object, you need to add the parameter *-Properties* with the '*' (or wildcard) value. Here's how to use Get-Member to see all the user properties.
```
Get-ADUser -Properties * | Get-Member
```

So next time you run into a PowerShell command and it is not giving you all the information you need, turn to Get-Member.

For more information on Get-Member, check out the docs [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-member?WT.md_id=blog-techcommunity-mibender&view=powershell-6)

For more information on Get-ADUser, check out the docs [here](https://docs.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?WT.md_id=blog-techcommunity-mibender&view=winserver2012-ps)