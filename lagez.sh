# made by notjunar 6/28 commited 10:33
# lagez for linux?

#!/bin/bash
clear
echo "LagEZ - Linux Optimizer"
echo "Optimizing your system for performance..."
sleep 2

MODE_CHOICE=""
if command -v zenity >/dev/null 2>&1; then
    MODE_CHOICE=$(zenity --list --title="LagEZ - Mode Selection" --text="Choose optimization mode:" --column="Mode" "GUI Mode" "Terminal Mode" --height=200 --width=300)
    if [ "$?" -ne 0 ]; then
        echo "No mode selected. Exiting."
        exit 1
    fi
else
    echo "Zenity not found. Falling back to Terminal Mode."
    MODE_CHOICE="Terminal Mode"
fi

if [[ "$MODE_CHOICE" == "GUI Mode" ]]; then
    # GUI Mode operations
    (
    echo "0"
    echo "# Detecting system specifications..."
    sleep 1
    RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    RAM_GB=$((RAM_KB / 1024 / 1024))
    CPU_CORES=$(nproc)

    PERFORM_AGGRESSIVE_MEMORY_OPT=0
    PERFORM_GUI_OPTIMIZATIONS=0
    PERFORM_CPU_GOVERNOR_OPT=0
    PERFORM_NETWORK_TUNING=0

    if (( RAM_GB <= 2 )); then
        PERFORM_AGGRESSIVE_MEMORY_OPT=1
        PERFORM_GUI_OPTIMIZATIONS=1
        PERFORM_CPU_GOVERNOR_OPT=1
        PERFORM_NETWORK_TUNING=1
    elif (( RAM_GB <= 4 )); then
        PERFORM_AGGRESSIVE_MEMORY_OPT=1
        PERFORM_GUI_OPTIMIZATIONS=1
        PERFORM_CPU_GOVERNOR_OPT=1
        PERFORM_NETWORK_TUNING=1
    fi

    if (( CPU_CORES <= 2 )); then
        PERFORM_CPU_GOVERNOR_OPT=1
        PERFORM_NETWORK_TUNING=1
    fi

    echo "10"
    echo "# Detected RAM: ${RAM_GB}GB, CPU Cores: ${CPU_CORES}"
    echo "# Applying system-wide optimizations..."
    sync
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

    if (( PERFORM_AGGRESSIVE_MEMORY_OPT == 1 )); then
        sudo swapoff -a
        sudo swapon -a
        sudo sysctl -w vm.swappiness=10
        sudo sysctl -w vm.vfs_cache_pressure=50
    fi

    if (( PERFORM_NETWORK_TUNING == 1 )); then
        sudo sysctl -w net.ipv4.tcp_fastopen=3
        sudo sysctl -w net.ipv4.tcp_tw_reuse=1
        sudo sysctl -w net.ipv4.tcp_syncookies=1
        sudo sysctl -w net.ipv4.conf.all.rp_filter=1
        sudo sysctl -w net.ipv4.conf.default.rp_filter=1
        sudo sysctl -w net.ipv4.ip_forward=0
        sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0
        sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
        sudo sysctl -w net.ipv4.tcp_fin_timeout=15
        sudo sysctl -w net.ipv4.tcp_keepalive_time=600
        sudo sysctl -w net.ipv4.tcp_keepalive_probes=3
        sudo sysctl -w net.ipv4.tcp_keepalive_intvl=10
        sudo sysctl -w net.ipv4.tcp_mtu_probing=1
        sudo sysctl -w net.ipv4.tcp_sack=1
        sudo sysctl -w net.ipv4.tcp_dsack=1
        sudo sysctl -w net.ipv4.tcp_fack=1
        sudo sysctl -w net.ipv4.tcp_window_scaling=1
        sudo sysctl -w net.ipv4.tcp_timestamps=1
        sudo sysctl -w net.core.rmem_max=16777216
        sudo sysctl -w net.core.wmem_max=16777216
        sudo sysctl -w net.core.rmem_default=16777216
        sudo sysctl -w net.core.wmem_default=16777216
        sudo sysctl -w net.core.netdev_max_backlog=16384
        sudo sysctl -w net.core.somaxconn=16384
    fi

    sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
    sudo sh -c 'echo noop > /sys/block/sda/queue/scheduler'
    sudo sh -c 'echo noop > /sys/block/sdb/queue/scheduler'
    sudo sh -c 'echo noop > /sys/block/sdc/queue/scheduler'
    sudo sh -c 'echo noop > /sys/block/sdd/queue/scheduler'
    sudo sysctl -w kernel.perf_event_max_sample_rate=1000000
    sudo sysctl -w kernel.nmi_watchdog=0
    sudo sysctl -w kernel.hung_task_timeout_secs=0
    sudo sysctl -w kernel.numa_balancing=0
    sudo sysctl -w kernel.randomize_va_space=0
    echo "30"
    echo "# Cleaning up system files..."
    sudo apt clean
    sudo apt autoremove -y
    echo "40"

    if (( PERFORM_CPU_GOVERNOR_OPT == 1 )); then
        echo "# Setting CPU governor to performance mode..."
        if command -v cpufreq-set >/dev/null 2>&1; then
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                sudo sh -c "echo performance > $cpu"
            done
        else
            echo "# cpufreq-set not found. Please install cpufrequtils for this optimization (sudo apt install cpufrequtils)."
        fi
    fi
    echo "50"

    if (( PERFORM_GUI_OPTIMIZATIONS == 1 )); then
        echo "# Applying user and display optimizations..."
        gsettings set org.gnome.desktop.interface enable-animations false
        gsettings set org.gnome.desktop.interface cursor-size 24
        gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
        gsettings set org.gnome.desktop.session idle-delay 0
        gsettings set org.gnome.shell.overrides attach-modal-dialogs false
        gsettings set org.gnome.shell.overrides dynamic-workspaces false
        gsettings set org.gnome.shell.overrides workspaces-only-on-primary false
        gsettings set org.gnome.shell.window-switcher current-workspace-only true
        dconf write /org/gnome/desktop/interface/enable-hot-corners false
        dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'"
        dconf write /org/gnome/desktop/wm/preferences/focus-mode "'sloppy'"
        dconf write /org/gnome/desktop/wm/preferences/mouse-button-modifier "<Super>"
        dconf write /org/gnome/desktop/wm/preferences/resize-grip-on-right false
        dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Cantarell 11'"
        dconf write /org/gnome/desktop/wm/preferences/titlebar-uses-system-font true
        dconf write /org/gnome/desktop/wm/preferences/visual-bell false
        dconf write /org/unity/launcher/hide-behavior "'2'"
        dconf write /org/unity/launcher/minimize-window-on-click true
        dconf write /org/compiz/profiles/unity/plugins/unityshell/hide-launcher true
    fi
    echo "70"

    echo "# Applying Minecraft specific optimizations..."
    sudo sh -c 'echo "vm.overcommit_memory=1" >> /etc/sysctl.conf'
    sudo sysctl -p
    if ! grep -q "options nouveau modeset=0" /etc/modprobe.d/blacklist.conf; then
        sudo sh -c 'echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist.conf'
        sudo update-initramfs -u
    fi
    if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash pcie_aspm=force\"" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pcie_aspm=force"/g' /etc/default/grub
        sudo update-grub
    fi
    mkdir -p ~/.minecraft/resourcepacks
    mkdir -p ~/.minecraft/shaderpacks
    mkdir -p ~/.minecraft/mods
    echo "80"

    zenity --question --title="LagEZ - Minecraft Optimization" --text="Enable Swils.gg Mode for Minecraft?"
    swils_choice=$?
    if [[ "$swils_choice" == "0" ]]; then
        echo "# Enabling Swils.gg Mode..."
        sudo sysctl -w net.ipv4.tcp_timestamps=0
        sudo sysctl -w net.ipv4.tcp_sack=0
        sudo sysctl -w net.ipv4.tcp_dsack=0
        sudo sysctl -w net.ipv4.tcp_fack=0
        sudo sysctl -w net.ipv4.tcp_window_scaling=0
    fi

    zenity --question --title="LagEZ - Minecraft Optimization" --text="Enable EZPing Mode for Minecraft?"
    ezping_choice=$?
    if [[ "$ezping_choice" == "0" ]]; then
        echo "# Enabling EZPing Mode..."
        sudo sysctl -w net.ipv4.tcp_syncookies=0
        sudo sysctl -w net.ipv4.tcp_fastopen=0
        sudo sysctl -w net.ipv4.tcp_tw_reuse=0
        sudo sysctl -w net.ipv4.tcp_fin_timeout=60
    fi
    echo "100"
    echo "# Optimization complete! Some changes require a system restart to take full effect."
    echo "# Thank you for using LagEZ - Linux Optimizer."
    ) | zenity --progress --title="LagEZ - Linux Optimizer" --text="Starting optimization..." --percentage=0 --auto-close --auto-kill
    zenity --info --title="LagEZ - Optimization Complete" --text="Optimization complete! Some changes require a system restart to take full effect.\n\nThank you for using LagEZ - Linux Optimizer."

elif [[ "$MODE_CHOICE" == "Terminal Mode" ]]; then
    # Terminal Mode operations (existing logic)
    RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    RAM_GB=$((RAM_KB / 1024 / 1024))
    CPU_CORES=$(nproc)

    PERFORM_AGGRESSIVE_MEMORY_OPT=0
    PERFORM_GUI_OPTIMIZATIONS=0
    PERFORM_CPU_GOVERNOR_OPT=0
    PERFORM_NETWORK_TUNING=0

    if (( RAM_GB <= 2 )); then
        PERFORM_AGGRESSIVE_MEMORY_OPT=1
        PERFORM_GUI_OPTIMIZATIONS=1
        PERFORM_CPU_GOVERNOR_OPT=1
        PERFORM_NETWORK_TUNING=1
    elif (( RAM_GB <= 4 )); then
        PERFORM_AGGRESSIVE_MEMORY_OPT=1
        PERFORM_GUI_OPTIMIZATIONS=1
        PERFORM_CPU_GOVERNOR_OPT=1
        PERFORM_NETWORK_TUNING=1
    fi

    if (( CPU_CORES <= 2 )); then
        PERFORM_CPU_GOVERNOR_OPT=1
        PERFORM_NETWORK_TUNING=1
    fi

    echo "Detected RAM: ${RAM_GB}GB, CPU Cores: ${CPU_CORES}"
    sleep 1

    echo "Applying system-wide optimizations..."
    sync
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

    if (( PERFORM_AGGRESSIVE_MEMORY_OPT == 1 )); then
        sudo swapoff -a
        sudo swapon -a
        sudo sysctl -w vm.swappiness=10
        sudo sysctl -w vm.vfs_cache_pressure=50
    fi

    if (( PERFORM_NETWORK_TUNING == 1 )); then
        sudo sysctl -w net.ipv4.tcp_fastopen=3
        sudo sysctl -w net.ipv4.tcp_tw_reuse=1
        sudo sysctl -w net.ipv4.tcp_syncookies=1
        sudo sysctl -w net.ipv4.conf.all.rp_filter=1
        sudo sysctl -w net.ipv4.conf.default.rp_filter=1
        sudo sysctl -w net.ipv4.ip_forward=0
        sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0
        sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
        sudo sysctl -w net.ipv4.tcp_fin_timeout=15
        sudo sysctl -w net.ipv4.tcp_keepalive_time=600
        sudo sysctl -w net.ipv4.tcp_keepalive_probes=3
        sudo sysctl -w net.ipv4.tcp_keepalive_intvl=10
        sudo sysctl -w net.ipv4.tcp_mtu_probing=1
        sudo sysctl -w net.ipv4.tcp_sack=1
        sudo sysctl -w net.ipv4.tcp_dsack=1
        sudo sysctl -w net.ipv4.tcp_fack=1
        sudo sysctl -w net.ipv4.tcp_window_scaling=1
        sudo sysctl -w net.ipv4.tcp_timestamps=1
        sudo sysctl -w net.core.rmem_max=16777216
        sudo sysctl -w net.core.wmem_max=16777216
        sudo sysctl -w net.core.rmem_default=16777216
        sudo sysctl -w net.core.wmem_default=16777216
        sudo sysctl -w net.core.netdev_max_backlog=16384
        sudo sysctl -w net.core.somaxconn=16384
    fi

    sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
    sudo sh -c 'echo noop > /sys/block/sda/queue/scheduler'
    sudo sh -c 'echo noop > /sys/block/sdb/queue/scheduler'
    sudo sh -c 'echo noop > /sys/block/sdc/queue/scheduler'
    sudo sh -c 'echo noop > /sys/block/sdd/queue/scheduler'
    sudo sysctl -w kernel.perf_event_max_sample_rate=1000000
    sudo sysctl -w kernel.nmi_watchdog=0
    sudo sysctl -w kernel.hung_task_timeout_secs=0
    sudo sysctl -w kernel.numa_balancing=0
    sudo sysctl -w kernel.randomize_va_space=0
    sleep 1

    echo "Cleaning up system files..."
    sudo apt clean
    sudo apt autoremove -y
    sleep 1

    if (( PERFORM_CPU_GOVERNOR_OPT == 1 )); then
        echo "Setting CPU governor to performance mode..."
        if command -v cpufreq-set >/dev/null 2>&1; then
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                sudo sh -c "echo performance > $cpu"
            done
            echo "CPU governor set to performance."
        else
            echo "cpufreq-set not found. Please install cpufrequtils for this optimization (sudo apt install cpufrequtils)."
        fi
        sleep 1
    fi

    if (( PERFORM_GUI_OPTIMIZATIONS == 1 )); then
        echo "Applying user and display optimizations..."
        gsettings set org.gnome.desktop.interface enable-animations false
        gsettings set org.gnome.desktop.interface cursor-size 24
        gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
        gsettings set org.gnome.desktop.session idle-delay 0
        gsettings set org.gnome.shell.overrides attach-modal-dialogs false
        gsettings set org.gnome.shell.overrides dynamic-workspaces false
        gsettings set org.gnome.shell.overrides workspaces-only-on-primary false
        gsettings set org.gnome.shell.window-switcher current-workspace-only true
        dconf write /org/gnome/desktop/interface/enable-hot-corners false
        dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'"
        dconf write /org/gnome/desktop/wm/preferences/focus-mode "'sloppy'"
        dconf write /org/gnome/desktop/wm/preferences/mouse-button-modifier "<Super>"
        dconf write /org/gnome/desktop/wm/preferences/resize-grip-on-right false
        dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Cantarell 11'"
        dconf write /org/gnome/desktop/wm/preferences/titlebar-uses-system-font true
        dconf write /org/gnome/desktop/wm/preferences/visual-bell false
        dconf write /org/unity/launcher/hide-behavior "'2'"
        dconf write /org/unity/launcher/minimize-window-on-click true
        dconf write /org/compiz/profiles/unity/plugins/unityshell/hide-launcher true
        sleep 1
    fi

    echo "Applying Minecraft specific optimizations..."
    sudo sh -c 'echo "vm.overcommit_memory=1" >> /etc/sysctl.conf'
    sudo sysctl -p
    if ! grep -q "options nouveau modeset=0" /etc/modprobe.d/blacklist.conf; then
        sudo sh -c 'echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist.conf'
        sudo update-initramfs -u
    fi
    if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash pcie_aspm=force\"" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pcie_aspm=force"/g' /etc/default/grub
        sudo update-grub
    fi
    mkdir -p ~/.minecraft/resourcepacks
    mkdir -p ~/.minecraft/shaderpacks
    mkdir -p ~/.minecraft/mods
    sleep 1

    read -p "Enable Swils.gg Mode for Minecraft? (y/n): " swils_choice
    if [[ "$swils_choice" == "y" || "$swils_choice" == "Y" ]]; then
        echo "Enabling Swils.gg Mode..."
        sudo sysctl -w net.ipv4.tcp_timestamps=0
        sudo sysctl -w net.ipv4.tcp_sack=0
        sudo sysctl -w net.ipv4.tcp_dsack=0
        sudo sysctl -w net.ipv4.tcp_fack=0
        sudo sysctl -w net.ipv4.tcp_window_scaling=0
        echo "Swils.gg Mode enabled. Restart your system for full effect."
    fi

    read -p "Enable EZPing Mode for Minecraft? (y/n): " ezping_choice
    if [[ "$ezping_choice" == "y" || "$ezping_choice" == "Y" ]]; then
        echo "Enabling EZPing Mode..."
        sudo sysctl -w net.ipv4.tcp_syncookies=0
        sudo sysctl -w net.ipv4.tcp_fastopen=0
        sudo sysctl -w net.ipv4.tcp_tw_reuse=0
        sudo sysctl -w net.ipv4.tcp_fin_timeout=60
        echo "EZPing Mode enabled. Restart your system for full effect."
    fi

    echo "Optimization complete! Some changes require a system restart to take full effect."
    echo "Thank you for using LagEZ - Linux Optimizer."
fi
