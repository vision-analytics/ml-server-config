# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# az login

import os
import time
from collections import deque

import psutil

d = deque(maxlen=120 * 60)  # only look at the last 120 minutes
while True:
    cpu = psutil.cpu_percent()
    d.append(cpu)
    if len(d) >= 120 * 60:  # wait at least 120 min after reboot
        if max(d) < 9:  # max smaller than 9 percent auto shutdown
            os.system('az vm deallocate -g "$GROUP" -n "$VMNAME"')
            # os.system('az vmss deallocate -g "$GROUP" -n "$VMNAME --instance-ids 0"')
    time.sleep(1)
