# FritzBoxShell

You need to create an user with Access from the internet allowed in your FritzBox panel, after that:

Download and make the script executable
```
chmod +x /path/to/fritzBoxShell.sh
```

Then add this to your .bashrc
```
alias fritzbox="/path/to/fritzBoxShell.sh"
```

After that you can restart your shell and try
```
fritzbox help
```
