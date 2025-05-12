# Simple UAC Bypass


This repository demonstrates a basic User Account Control (UAC) bypass method. It is intended to help understand how privilege escalation techniques can work in Windows environments.

---

## 🧩 What It Does

This script performs a **simple UAC bypass** by taking advantage of a known Windows mechanism to open a administrator or system level cmd.exe window without triggering a UAC prompt or password prompts.

---

## 🚀 How to Use

1. 📥 **Download the Code:**
   - Click the green **Code** button.
   - Select **Download ZIP**.

2. 🗂️ **Unzip the Archive:**
   - Extract the ZIP file in your downloads folder.

3. ⚙️ **Run the Script:**
   - Double-click `run.vbs` to run any file as admin or system.  


4. 🧹 **Cleanup:**
   - Double-click `clean.vbs` to remove any changes or files made during execution.

---

## 📂 Files Included

- `run.vbs` — Executes `run.bat`.
- `run.bat` — Executes the UAC bypass
- `clean.vbs` — Executes the `clean.ps1`.
- `clean.ps1` — Cleans up all changes made by the script.
- `menu.ps1` — Shows the menu.
- `admin.ps1` — elevates to admin.

---


## 📚 Learn More

Want to understand how it works? Check out the links or explore the following topics:

- [Creative UAC Bypass Methods for the Modern Era](https://g3tsyst3m.github.io/privilege%20escalation/Creative-UAC-Bypass-Methods-for-the-Modern-Era/)
- [Privilege Escalation Techniques](https://www.elastic.co/security-labs/exploring-windows-uac-bypasses-techniques-and-detection-strategies)
- [Windows UAC](https://www.atomicredteam.io/atomic-red-team/atomics/T1548.002)
- Windows Registry/Task Scheduler Exploits

---

> ⚠️ **Disclaimer:** This project is for **educational and research purposes only**. Misuse of this code may be illegal. The author is not responsible for any damage or misuse.

