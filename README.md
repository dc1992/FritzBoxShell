# FritzBoxShell

You need to create an user with Access from the internet allowed in your FritzBox panel, after that:

* Download the script and add `BoxUSER` and `BoxPW` variables to your ~/.zprofile
  ```
  BoxUSER="your_user"
  export BoxUSER

  BoxPW="your_password"
  export BoxPW
  ```

* Make the script executable
  ```
  chmod +x /path/to/fritzBoxShell.sh
  ```

* Add this to your .zshrc
  ```
  alias fritzbox="/path/to/fritzBoxShell.sh"
  ```

* Restart your shell and then you can use FritzBoxShell
  ```
  fritzbox help
  ```
