# PowerShell Basics: Don't Fear Hitting Enter with -WhatIf

Chances are you've run into this situation. You've built a script, or a one-liner, to perform a specific task, but you don't have a way to thoroughly test it without hitting Enter. That moment before hitting enter can be difficult. Knowing this need, there is a switch available with many PowerShell commands called `-whatif`. 

With `-whatif`, PowerShell will run your command in its entirety without executing the actions of the command so no changes occur. It displays a listing of actions to be performed against the affected objects in the console window. This is great for the commands that do not display any output when executed, or if you are unsure of the overall impact of your command.


How do you know if a command supports `-WhatIf?` That's pretty simple. Use `get-help` to view the syntax of the command.

```powershell

PS> get-help remove-item

```

```
NAME
    Remove-Item

SYNOPSIS
    Deletes files and folders.


SYNTAX
    Remove-Item [-Confirm] [-Credential <PSCredential>] [-Exclude <String[]>] [-Filter <String>] [-Force] [-Include
    <String[]>] -LiteralPath <String[]> [-Recurse] [-Stream <String[]>] [-UseTransaction] [-WhatIf]
    [<CommonParameters>]

    Remove-Item [-Path] <String[]> [-Confirm] [-Credential <PSCredential>] [-Exclude <String[]>] [-Filter <String>]
    [-Force] [-Include <String[]>] [-Recurse] [-Stream <String[]>] [-UseTransaction] [-WhatIf] [<CommonParameters>]

    Remove-Item [-Stream <string>] [<CommonParameters>]
    
```
As you can see, `[-WhatIf]` is listed in the syntax for the command. Also it will be available as a tab-complete option when entering the command. If you do happen to enter it with a command that doesn't support it, you'll receive the following error:

```powershell

PS C:\Users\mibender> get-help -Whatif

```
```
Get-Help : A parameter cannot be found that matches parameter name 'Whatif'.
At line:1 char:10
+ get-help -Whatif
+          ~~~~~~~
    + CategoryInfo          : InvalidArgument: (:) [Get-Help], ParameterBindingException
    + FullyQualifiedErrorId : NamedParameterNotFound,Microsoft.PowerShell.Commands.GetHelpCommand

```
Now let's see an example of how this works. A common scenario is needing to clean up a file share by file type. In this case, I want to find all of the video files in an MP4 format and remove them from my `c:\recordings` directory. Here's the process you would run through:

First, let's find all of the MP4 files with  `Get-ChildItem`:

```powershell

PS> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ 

```

```

    Directory: C:\Recordings\car-Talks\Attitude-Control

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         9/7/2018   3:47 PM       58188931 Attitude-Control.mp4

    Directory: C:\Recordings\car-Talks\Personal-KanBan

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        10/5/2018   1:56 PM       45875317 Personal-kanBan.mp4

    Directory: C:\Recordings\car-Talks\Redmond-Week-1\Redmond-Week-1

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         8/3/2018   9:01 AM       19616170 Redmond-Week-1.mp4
```

So that shows us all of the MP4 files, but I'd like to see them in a standard tables format with just their name and directory location and not separated by directory. To do that, we use `Select-Object`:

```powershell

PS> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ | Select-Object Name,Directory

Name                         Directory
----                         ---------
Attitude-Control.mp4         C:\Recordings\car-Talks\Attitude-Control
Personal-kanBan.mp4          C:\Recordings\car-Talks\Personal-KanBan
Redmond-Week-1.mp4           C:\Recordings\car-Talks\Redmond-Week-1\Redmond-Week-1
SoundTest1.mp4               C:\Recordings\car-Talks\Soundtest

```

That looks better. What I did was use the pipeline and `select-object` to choose just the properties I wanted from the objects output from the initial command

After I've reviewed the list, I think that it includes all the items I want to remove. But being paranoid, I'd really like to know that it is going to remove just those files in a specific directory, and not all the files. That's where `-WhatIf` comes in with the `remove-item` command:

```powershell

PS> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ | Remove-Item -WhatIf

```

```

What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Attitude-Control\Attitude-Control.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Personal-KanBan\Personal-kanBan.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Redmond-Week-1\Redmond-Week-1\Redmond-Week-1.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Soundtest\SoundTest1.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\Content-Development-AMA\Content-Development-AMA.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\MITT\HYB10\HYB10-Demos-DryRun1-0.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\MITT\HYB10\HYB10-Demos-DryRun1-1.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\MITT\HYB10\HYB10-Demos-DryRun1-2.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\MITT\HYB10\HYB10-Demos-DryRun1-3.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\MITT\HYB10\DryRuns\HYB10-Dress-Run-GSL-01.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\MITT\HYB10\DryRuns\HYB10-DryRun-01.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\MITT\HYB20\HYB20-Demo-SecureScore.mp4".

```

Based on the output, I've verified that on the MP4 files in the c:\recordings directory are being removed. Now I can go back to my command and execute it by removing the `-WhatIf` switch.

Now, let's say it's 2am in your time zone, and you need to perform multiple tasks through the PowerShell Console. If you are like me, 2am is not my 'peak productivity' hour so making mistakes, like forgetting the `-WhatIf` switch, could be dangerous. For those instances, you can modify the $WhatIfPreference variable in your console like this:

```powershell

PS> $whatifpreference
False
PS> $whatifpreference = 'True'
PS> $whatifpreference
True
PS> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ | Remove-Item

```

```

What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Attitude-Control\Attitude-Control.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Personal-KanBan\Personal-kanBan.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Redmond-Week-1\Redmond-Week-1\Redmond-Week-1.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Soundtest\SoundTest1.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\Content-Development-AMA\Content-Development-AMA.mp4".

```

When the command to remove all the files is run and I do not include -whatif since it's 2am, it defaults to running ALL commands with `-WhatIf`.
Now if you actually want to run the command and remove the files, you add the `-WhatIf` switch parameter and specify `:$false` like this:

```powershell

PS> Get-ChildItem -File *.MP4 -LiteralPath C:\Recordings\Test-Recording\ | Remove-Item -WhatIf:$false -Verbose

```

```

VERBOSE: Performing the operation "Remove File" on target "C:\Recordings\Test-Recording\Test-Take-SA.mp4".

```powershell

PS CMD> Get-ChildItem -File *.MP4 -LiteralPath C:\Recordings\Test-Recording\
PS CMD>

```

One thing to remember with this and other preference variables you define in the console is they only maintain the setting in your current shell. When you close and re-open PowerShell, the preference will reset.

Another thing is a *word of caution* on using `-WhatIf`. Because it is functionality that is added into commands, the implementer may not implement it properly. I've never run into issues with Microsoft-built commands using -whatif like Microsoft Exchange, Active Directory, and many of the built-in commands I use below. However, I cannot speak for code samples you may find in the wild. To be safe, you should test -whatif against a smaller pool of targets vs. trying to modify every Exchange mailbox in your organization.

So the next time you need to perform some PowerShell tasks, add -whatif before you execute, and stop fearing the `Enter` key.

For more information on the commands used in this post, click on the links below:
- [Get-ChildItem](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

- [Remove-Item](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Management/Remove-Item?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

- [Select-Object](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Select-Object?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

- [_about_preference_variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

For more information on PowerShell, check out the docs [here](https://docs.microsoft.com/en-us/powershell/?WT_id.md=blog-techcommunity-mibender)

