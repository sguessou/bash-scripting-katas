#!/bin/bash


# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne '0' ]]
then
  echo "Please run with sudo or as root."
  exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
NUMBER_OF_PARAMETERS="${#}"
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [USER_NAME]..."
  exit 1
fi

# The first parameter is the user name.
USER_NAME="${1}"
shift
# The rest of the parameters are for the account comments.
COMMENT=""
while [[ "${#}" -gt 0 ]]
do
  COMMENT+="${1} "
  shift
done  

# Generate a password.
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne '0' ]]
then
  echo 'Error while adding the user. Exiting script!'
  exit 1
fi

# Set the password.
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
echo
echo "username:"
echo "${USER_NAME}"
echo
echo "password:"
echo "${PASSWORD}"
echo 
echo "host:"
hostname

exit 0
