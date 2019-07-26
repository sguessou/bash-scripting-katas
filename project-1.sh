#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne '0' ]]
then
  echo "You need to be root in order to run the script!"
  exit 1
fi

# Ask for the  user name (login).
read -p 'Enter the username to create: ' USER_NAME

# Get the real name (content for the description field).
read -p 'Enter the name of the person or application that will be using this account: ' COMMENT

# Get the password.
read -p 'Enter the password to use for the account: ' PASSWORD

# Create the user.
useradd -c "${COMMENT}" -m ${USER_NAME}

#  Check to see if the useradd command succeeded.
if [[ "${?}" -ne '0' ]]
then
  echo 'Error while adding the user. Exiting script!'
  exit 1
fi

# Set the password for the user.
echo "Changing password for user ${USER_NAME}."
echo "${USER_NAME}:${PASSWORD}" | chpasswd

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne '0' ]]
then 
  echo 'Error while configuring password. Exiting script!'
  exit 1
fi

# Force password change on first login.
echo "Expiring password for user ${USER_NAME}."
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo ' '
echo "username:"
echo "${USER_NAME}"
echo ' '
echo "password:"
echo ' '
echo "host:"
hostname

exit 0
