# CustomNew

A lightweight Windows utility that lets you create a file with **any filename and extension directly from File Explorer.**

Instead of:

`Right-click → New → Text Document → Rename → Remove .txt`

You can simply:

`Right-click → Custom File... → Type filename → Create`

---

## Licensing

This project is licensed under the MIT License. Please visit [`LICENSE`](LICENSE) for more information.

---

## Installing

Installing CustomNew is as easy as running a command in powershell. The installer grabs the latest release, installs the registry edit, and restarts explorer.
Use `irm https://raw.githubusercontent.com/Plutonium-Net/CustomNew/main/install.ps1 | iex` to install CustomNew.

---

## Uninstalling

Uninstalling CustomNew is as easy as it was to install it. Just run `irm https://raw.githubusercontent.com/Plutonium-Net/CustomNew/main/uninstall.ps1 | iex` to completely uninstall CustomNew from your Computer.

---

## NOTE

PLEASE DO NOT RUN AS OF `8/23/26`. THERE IS A PROBLEM WITH THE CONTEXT MENU AS OF A RESULT ADDING CUSTOMNEW CAUSING EXPLORER.EXE TO CRASH AND NOT RESTART/BE ABLE TO BE RESTARTED UNLESS YOU REBOOT YOUR COMPUTER. THERE WILL BE A BUG FIX SOON.
