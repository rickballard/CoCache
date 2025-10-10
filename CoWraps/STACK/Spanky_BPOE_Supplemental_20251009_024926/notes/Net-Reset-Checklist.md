# Network Reset Checklist
1. Disable proxy and WPAD.
2. Flush DNS: `ipconfig /flushdns`
3. Reset Winsock/IP stack:
   ```powershell
   netsh winsock reset
   netsh int ip reset
   ```
4. Remove stale firewall rules referencing old Chrome paths.