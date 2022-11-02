# FritzBoxShell

You need to create an user with Access from the internet allowed in your FritzBox panel, after that:

* Download the script and edit line 2 and 3 with your username and your password

* Make the script executable
  ```
  chmod +x /path/to/fritzBoxShell.sh
  ```

* Add this to your .bashrc
  ```
  alias fritzbox="/path/to/fritzBoxShell.sh"
  ```

* Restart your shell and then you can use FritzBoxShell
  ```
  fritzbox help
  ```
