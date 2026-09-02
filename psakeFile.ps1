#Requires -Modules psake, PWBuild

##############################################################################
# This is the PowerShell Module psake build script. It inherits the following
# tasks from module PWBuild:
#
# Clean, Build, Sign, BuildHelp, Install, Test and Publish.
#
# The default task is Build.  This task copies the appropriate files from the
# $SrcRootDir under the $OutDir.  Later, other tasks such as Sign and BuildHelp
# will further modify the contents of $OutDir and add new files.
#
# The Sign task will only sign scripts if the $SignScripts variable is set to
# $true.  A code-signing certificate is required for this task to complete.
#
# The BuildHelp task invokes platyPS to generate markdown files from
# comment-based help for your exported commands.  platyPS then generates
# a help file for your module from the markdown files.
#
# The Install task simply copies the module folder under $OutDir to your
# profile's Modules folder.
#
# The Test task invokes Pester on the $TestRootDir.
#
# The Publish task uses the Publish-Module command to publish
# to either the PowerShell Gallery (the default) or you can change
# the $PublishRepository property to the name of an alternate repository.
# Note: the Publish task requires that the Test task execute without failures.
#
# You can execute a specific task, such as the Test task by running the
# following command:
#
# PS C:\> invoke-psake -taskList Test
#
# You can execute the Publish task with the following command.
# The first time you execute the Publish task, you will be prompted to enter
# your PowerShell Gallery NuGetApiKey.  After entering the key, it is encrypted
# and stored so you will not have to enter it again.
#
# PS C:\> invoke-psake -taskList Publish
#
# You can verify the stored and encrypted NuGetApiKey by running the following
# command which will display a portion of your NuGetApiKey in plain text.
#
# PS C:\> invoke-psake -taskList ShowApiKey
#
# You can store a new NuGetApiKey with this command. You can leave off
# the -properties parameter and you'll be prompted for the key.
#
# PS C:\> invoke-psake -taskList StoreApiKey -properties @{NuGetApiKey='test123'}
#

###############################################################################
# Dot source the user's customized properties and extension tasks.
###############################################################################
Include $PSScriptRoot\build.settings.ps1

###############################################################################
# Core task implementations.
###############################################################################
Task default -depends Build

Task Build -FromModule PWBuild
