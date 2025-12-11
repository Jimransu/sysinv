# SysInv – Windows System Inventory Script

**SysInv.ps1** is a lightweight PowerShell script designed to quickly gather key system information and generate a list of installed software on a Windows machine. This tool is ideal for IT technicians, system administrators, auditors, or anyone who needs fast system inventory capabilities.

---

## 🔧 Features

### 1. System Information Collection
The script displays:

- Hostname  
- OS version and caption  
- All active IPv4 addresses  
- (Loopback and APIPA addresses are automatically filtered out)

### 2. Installed Software Report
- Collects installed software from both:
  - **64-bit registry uninstall path**
  - **32-bit registry uninstall path (WOW6432Node)**
- Outputs software details including:
  - Display Name  
  - Version  
  - Publisher  
- Automatically exports results to a CSV file named:

