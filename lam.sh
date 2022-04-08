#!/bin/zsh
#
#  Created by Fabien Conus for the State of Geneva
#  See https://github.com/fabienconus/zerouser/blob/main/zerotouch_zerouser_deployment.md
#  Modified by everette_allen@ncsu.edu 04082022
#  Creates a macOS LaunchAgent configuration plist that runs jamf custom policy trigger
#  Could run anything really. For Jamf put this script into a post install script
#  in a no payload package and add to Jamf Prestage as needed

eventName="runSomething"
launchAgentName="com.github.${eventName}.plist"
# production path - uncomment to before deployment
# launchAgentPath="/Library/LaunchAgents/${launchAgentName}"

# testing path - comment before deployment in production
launchAgentPath="/Users/Shared/Desktop/${launchAgentName}"

# full path to the defaults command for security
defaultsPath="/usr/bin/defaults"

# Write the LaunchAgent to execute the Jamf custom policy
echo "Writing agent ${launchAgentPath}"
${defaultsPath} write ${launchAgentPath} Label ${launchAgentName}
${defaultsPath} write ${launchAgentPath} LimitLoadToSessionType "LoginWindow"
${defaultsPath} write ${launchAgentPath} ProgramArguments -array-add "/usr/local/bin/jamf"
${defaultsPath} write ${launchAgentPath} ProgramArguments -array-add "policy"
${defaultsPath} write ${launchAgentPath} ProgramArguments -array-add "-event"
${defaultsPath} write ${launchAgentPath} ProgramArguments -array-add "${eventName}"
${defaultsPath} write ${launchAgentPath} RunAtLoad -bool true
${defaultsPath} write ${launchAgentPath} LaunchOnlyOnce -bool true
${defaultsPath} write ${launchAgentPath} StandardErrorPath "/tmp/${eventName}.err"
${defaultsPath} write ${launchAgentPath} StandardOutPath "/tmp/${eventName}.out"
/usr/sbin/chown root:wheel ${launchAgentPath}
/bin/chmod 644 ${launchAgentPath}

# Load the agent
# Uncomment for production deployment
# /bin/launchctl load -S LoginWindow ${launchAgentPath}

exit 0