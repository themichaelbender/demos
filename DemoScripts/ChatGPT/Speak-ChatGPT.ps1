# Script to speak ChatGPT output
# Based on module PowerShellAI
# Parameter Block
$script:OpenAI_Key = <Enter-OpenAI-Key>
Set-Item -Path env:OpenAIKey -Value $script:OpenAI_Key

function Speak-ChatGPT3 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter ChatGPT Prompt")]
        [String] $prompt,

        [parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter ChatGPT Tokens")]
        [Int] $tokens = 500,

        [Parameter(Mandatory = $false,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        HelpMessage = "Enter ChatGPT Temperature")]
        [Double] $temperature = .2
    )
    $psai = Get-Module -name PowerShellAI

    $script:OpenAI_Key = <Enter-OpenAI-Key>
    Set-Item -Path env:OpenAIKey -Value $script:OpenAI_Key

    if ($psai -eq $null)
        {
            Install-Module -Name PowerShellAI -Force
        }
    #$OpenAIKey = Read-host "Enter OpenAI Key"

    $text = Get-GPT3Completion -prompt $Prompt 

    $SpokenWord = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer

    Write-Output $text

    $SpokenWord.Speak($Text)
}
 
Speak-ChatGPT3 -prompt "What is the color of water and average weight" -tokens 500 -temperature .2
