# *nasty-aliases*

**Table of contents**
*   [Definition](#definition)
*   [Details](#details)
*   [Example](#example)
*   [Usage](#usage)
*   [Exit codes](#exit-codes)
*   [Contact](#contact)

----

## Definition

Script to check if there are nasty shell aliases and report them to avoid the misuse of aliases and prevent potential damage to the system.

[Top](#nasty-aliases)

## Details

Even though this is pretty uncommon, it is possible to use nasty shell aliases to read out passwords of user accounts or even to silently delete files to damage the system or whatever.

The `nasty-aliases.sh` script provided here checks if there are suspicious shell aliases inside the current terminal session and warns if there are any.

The script has been primarily built for the *Bash* shell. So, by default, it checks the `/etc/bashrc` file as well as the `~/.bashrc` file of the user that just logged into the shell.

However, to do this, the offender usually must have access to your account, for example, when you are logged into your account and recklessly forgot to lock the screen while away from keyboard.

Feel free to modify!

[Top](#nasty-aliases)

## Example

This example is **not** meant as a guide how to misuse aliases!

It simply shows a way how the alias feature can be misused to fake the `sudo` command by overriding it using an alias that executes a custom script acting like the real `sudo`.

Such a script could look like this:

```bash
#!/bin/bash

read -s -p "[sudo] password for $USER: " password
echo $password > /tmp/rootpass.log
echo
sleep 2
echo "Sorry, try again."
sudo $@
```

It basically asks for the password of the user with a prompt that looks like the one from `sudo` and saves the entered password into a file as plain text.

Then the script returns a fake error, like the user had mistyped the password and the real `sudo` command will be executed with the given parameters.

When that script has been created (e.g. `/tmp/fakesudo.sh`) and marked as executable, the nasty alias must be inserted in to the `.bashrc` file of the user:

```bash
alias sudo='/tmp/fakesudo.sh'
```

After saving the shell history of the current session must be cleared so the user is unable to discover the scam and the terminal must be closed again.

Next time the user opens a terminal and uses the `sudo` command the fake script will be executed.

[Top](#nasty-aliases)

## Usage

There are two ways the script can be used. Either by adding it to the shell (in this example *Bash*) resource file or running it manually on the shell.

### Resource file

How to add the script to the Bash resource file:

1.  Copy the `nasty-aliases.sh` script file into a directory of your choice (e.g. `/opt/nasty-aliases`).

1.  Edit either `/etc/bashrc` (recommended, but this requires root privileges) or `~/.bashrc` (the `.bashrc` file of the current user) and add the following line:

    ```bash
    source /opt/nasty-aliases/nasty-aliases.sh
    ```

1.  Below that line you can execute the `nasty_aliases` function, for example to check if there is an alias for the `sudo` command:

    ```bash
    nasty_aliases sudo
    ```

    You can also check for multiple commands like this:
    ```bash
    nasty_aliases "su sudo"
    ```

    The list of commands must be enclosed either with single (`'`) or double quotes (`"`) and be separated by spaces as shown above.

    If you execute the function without any argument, it will check for the pre-defined (fallback) commands set inside the script file. These can be changed by modifying the line

    ```bash
    check_for="su sudo"
    ```

    inside the script.

### Manual execution

When you run the script without any command-line arguments

```bash
./nasty_aliases.sh
```

nothing will happen and the it exits instantly.

However, you can give the name of the command you want to check if there are aliases for as an argument, e.g. for `sudo`:

```bash
./nasty_aliases.sh sudo
```

You can also check for multiple commands like this:

```bash
./nasty_aliases "su sudo"
```

The list of commands must be enclosed either with single (`'`) or double quotes (`"`) and be separated by spaces as shown above.

[Top](#nasty-aliases)

## Exit codes

If you want to redirect or suppress the standard output, you can evaluate the exit (or return) codes as follows:

| Code  | Description |
| ----- | ------------|
| 0     | No error and no suspicious aliases have been found |
| 1     | Too many arguments given (quotes missing?) |
| 2     | No error but suspicious aliases have been found |

[Top](#nasty-aliases)

## Contact

Any suggestions, questions, bugs to report or feedback to give?

You can contact me by sending an email to [dev@urbanware.org](mailto:dev@urbanware.org).

[Top](#nasty-aliases)
