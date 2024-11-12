#!/usr/bin/env python3
import os
import subprocess
import json

def run_command(command):
    result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return result.stdout.strip(), result.stderr.strip()

def gather_process_info(process_name):
    info = {}
    info["Process"] = process_name
    
    # Activity Monitor equivalent
    info["Activity Monitor"] = run_command(f"ps aux | grep {process_name}")[0]
    
    # List open files
    info["Open Files"] = run_command(f"sudo lsof -c {process_name}")[0]
    
    # Launchctl list
    info["Launchctl"] = run_command(f"sudo launchctl list | grep {process_name}")[0]
    
    return info

def gather_smb_info():
    info = {}
    info["Process"] = "smbd"
    
    # Activity Monitor equivalent
    info["Activity Monitor"] = run_command("ps aux | grep smbd")[0]
    
    # SMB status
    info["SMB Status"] = run_command("smbstatus")[0]
    
    return info

def save_info_to_file(info, filename):
    with open(filename, 'w') as file:
        json.dump(info, file, indent=4)

# Example usage
process_info = gather_process_info("example_process")
save_info_to_file(process_info, "process_info.json")

smb_info = gather_smb_info()
save_info_to_file(smb_info, "smb_info.json")

def gather_wifivelocityd_info():
    info = {}
    info["Process"] = "wifivelocityd"
    
    # Activity Monitor equivalent
    info["Activity Monitor"] = run_command("ps aux | grep wifivelocityd")[0]
    
    # File details
    info["File Details"] = run_command("ls -l /usr/libexec/wifivelocityd")[0]
    info["File Stat"] = run_command("stat /usr/libexec/wifivelocityd")[0]
    
    return info

def gather_firewall_logs():
    logs = {}
    
    # Firewall log for specific processes and Safari
    log_entries = run_command("sudo cat /var/log/appfirewall.log | grep 'remoted\\|replicatord\\|smbd\\|wifivelocityd\\|Safari'")[0]
    logs["Firewall Logs"] = log_entries
    
    return logs

def compile_info():
    all_info = {}
    
    all_info["remoted"] = gather_process_info("remoted")
    all_info["replicatord"] = gather_process_info("replicatord")
    all_info["smbd"] = gather_smb_info()
    all_info["wifivelocityd"] = gather_wifivelocityd_info()
    all_info["firewall_logs"] = gather_firewall_logs()
    
    return all_info

def save_info_to_file(info, filename="process_info.txt"):
    with open(filename, "w") as file:
        for process, details in info.items():
            file.write(f"{process}:\n")
            for key, value in details.items():
                file.write(f"  {key}:\n{value}\n\n")

if __name__ == "__main__":
    info = compile_info()
    save_info_to_file(info)
    process_info = gather_process_info("example_process")
    save_info_to_file(process_info, "process_info.json")

    smb_info = gather_smb_info()
    save_info_to_file(smb_info, "smb_info.json")