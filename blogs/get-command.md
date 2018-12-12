For me, one of the most important features of PowerShell is the ability to find all the answers you need in the shell. From the early days, PowerShell has included commands for finding cmdlets and functions within the shell including `Get-Command`. `Get-Command` is one of the three most well-known PowerShell commands, `Get-Help` and `Get-Member` being the other two. This post will be an exploration of using `Get-Command` and `Get-Help`. You can get information on Get-Member [in this post](https://techcommunity.microsoft.com/t5/ITOps-Talk-Blog/PowerShell-Basics-Getting-More-Information-with-Get-Member/ba-p/285407?WT.mc_id=blog-techcommunity-mibender).

Let's start with `Get-Command`. Let's say you want to see *everything* installed in your PowerShell console. That's pretty easy. Type `Get-Command` and it produces a list of all the commands installed (functions, aliases, cmdlets).
```
PS C:\Users\mibender> get-command

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Add-AdlAnalyticsDataSource                         0.5.0      Az.DataLakeAnalytics
Alias           Add-AdlAnalyticsFirewallRule                       0.5.0      Az.DataLakeAnalytics
Alias           Add-AdlStoreFirewallRule                           0.5.0      Az.DataLakeStore
Alias           Add-AdlStoreItemContent                            0.5.0      Az.DataLakeStore
Alias           Add-AdlStoreTrustedIdProvider                      0.5.0      Az.DataLakeStore
Alias           Add-AdlStoreVirtualNetworkRule                     0.5.0      Az.DataLakeStore
...
```

This displays a few things of importance:
- CommandType is the type of command. These include alias, function, and cmdlet commands currently installed.
- Name is self-explanatory and is what you invoke to run the command.
- Version is the current version of the command you have installed.
- Source is the module that includes the command.

Let's say you want to find just functions in the console. To do this, you simply add the `-commandtype` parameter with a value of `function` and it produces a list of functions only.
```
PS C:\Users\mibender> get-command -CommandType Function

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        A:
Function        Add-BCDataCacheExtension                           1.0.0.0    BranchCache
Function        Add-BitLockerKeyProtector                          1.0.0.0    BitLocker
Function        Add-DnsClientNrptRule                              1.0.0.0    DnsClient
Function        AddDscResourceProperty                             0.0        PSDesiredStateConfiguration
Function        AddDscResourcePropertyFromMetadata                 0.0        PSDesiredStateConfiguration
Function        Add-EtwTraceProvider                               1.0.0.0    EventTracingManagement
...
```
Venturing further down the rabbit whole, let's see just the functions that start with the verb `get-` so we use the `-name` parameter with a value of `Get-*` and it produces the list we want.
```
PS C:\Users\mibender> get-command -CommandType Function -name Get-*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-AppxLastError                                  2.0.1.0    Appx
Function        Get-AppxLog                                        2.0.1.0    Appx
Function        Get-AssignedAccess                                 1.0.0.0    AssignedAccess
Function        Get-AutologgerConfig                               1.0.0.0    EventTracingManagement
Function        Get-BCClientConfiguration                          1.0.0.0    BranchCache
Function        Get-BCContentServerConfiguration                   1.0.0.0    BranchCache
Function        Get-BCDataCache                                    1.0.0.0    BranchCache
...
```
You'll notice I used a wildcard (`*`) in my value for name. It will get every command that begins with "Get-". You can also see I'm following a systematic approach to find to what I'm looking for: Start with a wide net, and gradually reduce the size of the items caught. I use this approach with all queries for information with PowerShell. 

So, let's try something, I want to find a command that allows me to modify the firewall rules on a Windows host. Sure I could look on the internet, but that defeats the purpose of using tools in the box.

First, I'll do a search using `Get-Command` looking for commands with "FireWall" in the `-name` parameter.

```
PS C:\Users\mibender> get-command -name *firewall*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Add-AdlAnalyticsFirewallRule                       0.5.0      Az.DataLakeAnalytics
Alias           Add-AdlStoreFirewallRule                           0.5.0      Az.DataLakeStore
Alias           Get-AdlAnalyticsFirewallRule                       0.5.0      Az.DataLakeAnalytics
Alias           Get-AdlStoreFirewallRule                           0.5.0      Az.DataLakeStore
Alias           Remove-AdlAnalyticsFirewallRule                    0.5.0      Az.DataLakeAnalytics
Alias           Remove-AdlStoreFirewallRule                        0.5.0      Az.DataLakeStore
Alias           Set-AdlAnalyticsFirewallRule                       0.5.0      Az.DataLakeAnalytics
Alias           Set-AdlStoreFirewallRule                           0.5.0      Az.DataLakeStore
Function        Copy-NetFirewallRule                               2.0.0.0    NetSecurity
Function        Disable-NetFirewallRule                            2.0.0.0    NetSecurity
Function        Enable-NetFirewallRule                             2.0.0.0    NetSecurity
Function        Get-NetFirewallAddressFilter                       2.0.0.0    NetSecurity
Function        Get-NetFirewallApplicationFilter                   2.0.0.0    NetSecurity
Function        Get-NetFirewallInterfaceFilter                     2.0.0.0    NetSecurity
Function        Get-NetFirewallInterfaceTypeFilter                 2.0.0.0    NetSecurity
Function        Get-NetFirewallPortFilter                          2.0.0.0    NetSecurity
Function        Get-NetFirewallProfile                             2.0.0.0    NetSecurity
Function        Get-NetFirewallRule                                2.0.0.0    NetSecurity
Function        Get-NetFirewallSecurityFilter                      2.0.0.0    NetSecurity
Function        Get-NetFirewallServiceFilter                       2.0.0.0    NetSecurity
Function        Get-NetFirewallSetting                             2.0.0.0    NetSecurity
Function        New-NetFirewallRule                                2.0.0.0    NetSecurity
```

From the partial output, we received a variety of commands. This is because I used Wildcard (`*`) before and after `firewall`. This gives me the largest pool of commands containing "firewall" anywhere in the name of the command. 

Reviewing the results, I see that there is a noun of NetFirewallRule. That sounds like it may be what I'm looking for so let's try searching for -name `*netfirewallrule`, and we see what results.

```
PS C:\Users\mibender> get-command -name *netfirewallrule

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Copy-NetFirewallRule                               2.0.0.0    NetSecurity
Function        Disable-NetFirewallRule                            2.0.0.0    NetSecurity
Function        Enable-NetFirewallRule                             2.0.0.0    NetSecurity
Function        Get-NetFirewallRule                                2.0.0.0    NetSecurity
Function        New-NetFirewallRule                                2.0.0.0    NetSecurity
Function        Remove-NetFirewallRule                             2.0.0.0    NetSecurity
Function        Rename-NetFirewallRule                             2.0.0.0    NetSecurity
Function        Set-NetFirewallRule                                2.0.0.0    NetSecurity
Function        Show-NetFirewallRule                               2.0.0.0    NetSecurity
```
Ah yes, now we are getting somewhere. I've managed to list all of the commands that work with NetFirewallRule. Ok. Which should I pick? Well, that can be tricky. We have a number of verbs here used with -NetFireWallRule. In this case, two verbs stick out: New and Set. Here's the best way to remember these verbs and how they work:
- New **ALWAYS** should create net-new things. It should never be used to modify existing things. Use it to create new things.
- Set **NEVER** should create net-new things. Use it to modify things.

So `Set-NetFirewallRule` looks to be our winner. So, how do we use it? PowerShell Help to the rescue. PowerShell has a built-in help system to provide you all the information you need. It's run by typing `Get-Help <Command>`.

**Note: If you don't see the output below, run `Update-Help`. Microsoft updates help files on a regular basis so you should make sure to run this occassionaly. You may need to run PowerShell as an admin for `Update-Help` to work. Also, all versions of PowerShell ship without the help files so they need to be updated upon first use.**

```
PS C:\Users\mibender> get-help set-netfirewallrule

NAME
    Set-NetFirewallRule

SYNOPSIS
    Modifies existing firewall rules.


SYNTAX
    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession
    <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget
    <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption
    <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>]
    [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>]
    [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName
    <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru]
    [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol
    <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>]
    [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] -DisplayGroup <String[]>
    [-Confirm] [-WhatIf] [<CommonParameters>]

    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession
    <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget
    <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption
    <Encryption>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType
    <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>]
    [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName <String>]
    [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru] [-Platform
    <String[]>] [-Profile <Profile>] [-Program <String>] [-Protocol <String>] [-RemoteAddress
    <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>] [-RemoteUser <String>] [-Service
    <String>] [-ThrottleLimit <Int32>] -InputObject <CimInstance[]> [-Confirm] [-WhatIf]
    [<CommonParameters>]

    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession
    <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget
    <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption
    <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>]
    [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>]
    [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName
    <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru]
    [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol
    <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>]
    [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] -DisplayName <String[]>
    [-Confirm] [-WhatIf] [<CommonParameters>]

    Set-NetFirewallRule [-Name] <String[]> [-Action <Action>] [-AsJob] [-Authentication
    <Authentication>] [-CimSession <CimSession[]>] [-Description <String>] [-Direction <Direction>]
    [-DynamicTarget <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>]
    [-Encryption <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias
    <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>]
    [-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping
    <Boolean>] [-NewDisplayName <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package
    <String>] [-PassThru] [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>]
    [-Program <String>] [-Protocol <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>]
    [-RemotePort <String[]>] [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>]
    [-Confirm] [-WhatIf] [<CommonParameters>]

    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession
    <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget
    <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption
    <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>]
    [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>]
    [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName
    <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru]
    [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol
    <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>]
    [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] -Group <String[]> [-Confirm]
    [-WhatIf] [<CommonParameters>]


DESCRIPTION
    The Set-NetFirewallRule cmdlet modifies existing firewall rule properties. This cmdlet gets one or
    more firewall rules to be modified with the Name parameter (default), the DisplayName parameter,
    or by group association using the DisplayGroup or Group parameter. Rules cannot be queried by
    property in this cmdlet, but the querying can be done by the Get-NetFirewallRule cmdlet and piped
    into this cmdlet. The remaining parameters modify the properties of the specified rules. If the
    DisplayGroup or Group parameter is specified, then all sets associated with the specified group
    receive the same modifications.

    To move a rule to a new GPO, copy the existing rule using the Copy-NetFirewallRule cmdlet with the
    NewPolicyStore parameter, then remove the old rule with this cmdlet.


RELATED LINKS
    Online Version: http://go.microsoft.com/fwlink/?LinkId=288218
    Copy-NetFirewallRule
    Disable-NetFirewallRule
    Enable-NetFirewallRule
    Get-NetFirewallAddressFilter
    Get-NetFirewallApplicationFilter
    Get-NetFirewallInterfaceFilter
    Get-NetFirewallInterfaceTypeFilter
    Get-NetFirewallPortFilter
    Get-NetFirewallRule
    Get-NetFirewallSecurityFilter
    Get-NetFirewallServiceFilter
    New-NetFirewallRule
    Open-NetGPO
    Remove-NetFirewallRule
    Rename-NetFirewallRule
    Save-NetGPO
    Set-NetIPsecRule
    Set-NetFirewallRule
    Set-NetFirewallSetting
    Show-NetFirewallRule
    New-GPO

REMARKS
    To see the examples, type: "get-help Set-NetFirewallRule -examples".
    For more information, type: "get-help Set-NetFirewallRule -detailed".
    For technical information, type: "get-help Set-NetFirewallRule -full".
    For online help, type: "get-help Set-NetFirewallRule -online"
```
And, it is the command we are looking for. The Synopsis and Description tell us what the command does (modifies the firewall rules). 

To begin using the command, you can review the syntax for the parameters available with the command. For those new to PowerShell, this can be daunting so I'll show you my favorite use of help with the `-examples` parameter

```
PS C:\Users\mibender> get-help set-netfirewallrule -examples

NAME
    Set-NetFirewallRule

SYNOPSIS
    Modifies existing firewall rules.


    EXAMPLE 1

    PS C:\>Set-NetFirewallRule -DisplayName "AllowWeb80" -RemoteAddress "192.168.0.2"

    This example changes a rule to match a different remote IP address of a web server for which
    traffic is allowed by a rule.
    EXAMPLE 2

    PS C:\>Set-NetFirewallRule -DisplayGroup "Windows Firewall Remote Management" -Enabled True


    This cmdlet shows an alternate way to enable all of the rules in a predefined group.
    PS C:\>Enable-NetFirewallRule -DisplayGroup "Windows Firewall Remote Management"

    This example enables all of the rules in a predefined group.
    EXAMPLE 3

    PS C:\>Set-NetFirewallRule -DisplayName "AllowMessenger" -Authentication Required –Profile Domain

    This example changes a rule to require authentication and scopes the rule to apply on the domain
    profile. A separate IPsec rule must exist to perform the authentication.

```
This handy parameter provides you examples, usually listed from simple to more complex, of how to work with the command. Often times, you'll find a command that does some or all of the things you want. I like to copy the command from the help and use it as a base as I work through a command's usage.

Let's say example 1 that sets the remote IP address on a rule is what you want, but your not sure how to use the `-remoteaddress` parameter. For this, there are a couple of options.

First, you can run `Get-Help <command> -Full` to see all of the help content including detailed information on parameters. This will produce a ton of information in the console so try using help, a shortcut for get-help, instead. It still runs help but it adds the `more` functionality of paging each screen. This is great to use when you want all of the help information to review.

```
PS C:\Users\mibender> help Set-NetFirewallRule -Full

NAME
    Set-NetFirewallRule

SYNOPSIS
    Modifies existing firewall rules.


SYNTAX
    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru] [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>] [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] -DisplayGroup <String[]> [-Confirm] [-WhatIf] [<CommonParameters>]

    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption <Encryption>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru] [-Platform <String[]>] [-Profile <Profile>] [-Program <String>] [-Protocol <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>] [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] -InputObject <CimInstance[]> [-Confirm] [-WhatIf] [<CommonParameters>]

    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru] [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>] [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] -DisplayName <String[]> [-Confirm] [-WhatIf] [<CommonParameters>]

    Set-NetFirewallRule [-Name] <String[]> [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru] [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>] [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] [-Confirm] [-WhatIf] [<CommonParameters>]

    Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession <CimSession[]>] [-Description <String>] [-Direction <Direction>] [-DynamicTarget <DynamicTransport>] [-EdgeTraversalPolicy <EdgeTraversal>] [-Enabled <Enabled>] [-Encryption <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>] [-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>] [-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>] [-NewDisplayName <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru] [-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol <String>] [-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>] [-RemoteUser <String>] [-Service <String>] [-ThrottleLimit <Int32>] -Group <String[]> [-Confirm] [-WhatIf] [<CommonParameters>]


DESCRIPTION
    The Set-NetFirewallRule cmdlet modifies existing firewall rule properties. This cmdlet gets one or more firewall rules to be modified with the Name parameter (default), the DisplayName parameter, or by group association using the DisplayGroup or Group parameter. Rules cannot be queried by property in this cmdlet, but the querying can be done by the Get-NetFirewallRule cmdlet and piped into this cmdlet. The remaining parameters modify the properties of the specified rules. If the DisplayGroup or Group parameter is specified, then all sets associated with the specified group receive the same modifications.

    To move a rule to a new GPO, copy the existing rule using the Copy-NetFirewallRule cmdlet with the NewPolicyStore parameter, then remove the old rule with this cmdlet.


PARAMETERS
    -Action <Action>
        Specifies that matching firewall rules of the indicated action are modified.

        This parameter specifies the action to take on traffic that matches this rule.
        The acceptable values for this parameter are:  Allow or Block.

         -- Allow: Network packets that match all of the criteria specified in this rule are permitted through the firewall.

         -- Block: Network packets that match all of the criteria specified in this rule are dropped by the firewall.

        The default value is Allow.
        Note: The OverrideBlockRules field changes an allow rule into an allow bypass rule.

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

```
The next option is to get more granular and just search for the `-RemoteAddress` parameter by using `-Parameter` with help like this.

```
PS C:\Users\mibender> Help set-netfirewallrule -Parameter RemoteAddress

-RemoteAddress <String[]>
    Specifies that network packets with matching IP addresses match this rule.

    This parameter value is the second end point of an IPsec rule and specifies the computers that are subject to the requirements of this rule.

    This parameter value is an IPv4 or IPv6 address, hostname, subnet, range, or the following keyword: Any.

    The acceptable formats for this parameter are:

     -- Single IPv4 Address: 1.2.3.4

     -- Single IPv6 Address: fe80::1

     -- IPv4 Subnet (by network bit count): 1.2.3.4/24

     -- IPv6 Subnet (by network bit count): fe80::1/48

     -- IPv4 Subnet (by network mask): 1.2.3.4/255.255.255.0

     -- IPv4 Range: 1.2.3.4 through 1.2.3.7

     -- IPv6 Range: fe80::1 through fe80::9
    Note: Querying for rules with this parameter can only be performed using filter objects. See the Get-NetFirewallAddressFilter cmdlet for more information.

    Required?                    false
    Position?                    named
    Default value
    Accept pipeline input?       false
    Accept wildcard characters?  false

```
Now, that gets us the information we are looking for including a description of the parameter, acceptable formats for the parameter, and more. One important piece of information is the `<...>` value after the parameter name. This tells you the type of value the parameter accepts. In this case it's a string value (numbers/letters/symbols). But it could have been a boolean or other value. This is important so you know what you can and can't use in a parameter. This becomes super important later in your PowerShell journey when you begin using the pipeline.

So there you have it! A quick and easy approach for finding commands & how to use them. Use `Get-Command` and `Get-Help` whenever you need to do something in PowerShell. Add on `Get-Member`, and your on your way to becoming a PowerShell Guru!

If you want more information on each of these commands, check out the docs below:
[Get-Command](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-command?WT.mc_id=blog-techcommunity-mibender,view=powershell-6)
[Get-Help](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help?WT.mc_id=blog-techcommunity-mibender,view%3Dpowershell-6&view=powershell-6)
