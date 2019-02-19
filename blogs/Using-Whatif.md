# PowerShell Basics: Don't Fear Hitting Enter with -WhatIf
Chances are you've run into this situation. You've built a script, or a one-liner, to perform a specific task, but you don't have a way to thoroughly test it without hitting Enter. That moment before hitting enter can be difficult. Knowing this need, there is a switch available with many PowerShell commands called `-whatif`. 

With `-whatif`, PowerShell will run your command in its entirety without executing the actions of the command so no changes occur. It displays a listing of actions to be performed against the affected objects in the console window. This is great for the commands that do not display any output when executed, or if you are unsure of the overall impact of your command.

Let's see an example of how this works. A common scenario is needing to clean up a file share by file type. In this case, I want to find all of the video files in an MP4 format and remove them from my `c:\recordings` directory. Here's the process you would run through:

First, let's find all of the MP4 files with  `Get-ChildItem`:

```powershell

PS C:\> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ 

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

PS C:\> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ | Select-Object Name,Directory

Name                         Directory
----                         ---------
Attitude-Control.mp4         C:\Recordings\car-Talks\Attitude-Control
Personal-kanBan.mp4          C:\Recordings\car-Talks\Personal-KanBan
Redmond-Week-1.mp4           C:\Recordings\car-Talks\Redmond-Week-1\Redmond-Week-1
SoundTest1.mp4               C:\Recordings\car-Talks\Soundtest

```

That looks better. What I did was use the pipeline and `select-object` to choose just the properties I wanted from the objects output from the initial command

After I've reviewed the list, I think that it includes all the items I want to remove. But being paranoid, I'd really like to know that it is going to remove just those files in a specific directory, and not all the files. That's where -whatif comes in with the `remove-item` command:

```powershell

PS C:\> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ | Remove-Item -WhatIf
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

Based on the output, I've verified that on the MP4 files in the c:\recordings directory are being removed. Now I can go back to my command and execute it by removing the -whatif parameter.

Now, let's say it's 2am in your time zone, and you need to perform multiple tasks through the PowerShell Console. If you are like me, 2am is not my 'peak productivity' hour so making mistakes, like forgetting the `-whatif` switch could be disasterous. For those occassions, you can modify the $WhatIfPreference variable in your console like this:

```powershell

PS C:\> $whatifpreference
False
PS C:\> $whatifpreference = 'True'
PS C:\> $whatifpreference
True
PS C:\> Get-ChildItem -File *.MP4 -Recurse -LiteralPath C:\Recordings\ | Remove-Item
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Attitude-Control\Attitude-Control.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Personal-KanBan\Personal-kanBan.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Redmond-Week-1\Redmond-Week-1\Redmond-Week-1.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\car-Talks\Soundtest\SoundTest1.mp4".
What if: Performing the operation "Remove File" on target "C:\Recordings\Microsoft\Content-Development-AMA\Content-Development-AMA.mp4".

```

When the command to remove all the files is run and I do not include -whatif since it's 2am, it defaults to running ALL commands with `-whatif`.
Now if you actually want to run the command and remove the files, you add the `-whatif` switch parameter and specify `:$false` like this:

```powershell
PS C:\> Get-ChildItem -File *.MP4 -LiteralPath C:\Recordings\Test-Recording\ | Remove-Item -WhatIf:$false -Verbose
VERBOSE: Performing the operation "Remove File" on target "C:\Recordings\Test-Recording\Test-Take-SA.mp4".
PS C:\> Get-ChildItem -File *.MP4 -LiteralPath C:\Recordings\Test-Recording\
PS C:\>

```
One thing to remember with this and other preference variables you define in the console is they only maintain the setting in your current shell. When you close and re-open PowerShell, the preference will reset.

So the next time you need to perform some PowerShell tasks, add -whatif before you execute, and stop fearing the `Enter` key.

For more information on the commands used in this post, click on the links below:
- [Get-ChildItem](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

- [Remove-Item](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Management/Remove-Item?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

- [Select-Object](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Select-Object?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

- [_about_preference_variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?WT_id.md=blog-techcommunity-mibender&view=powershell-6)

For more information on PowerShell, check out the docs [here](https://docs.microsoft.com/en-us/powershell/?WT_id.md=blog-techcommunity-mibender)

