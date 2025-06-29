#!/bin/bash
# author: notjunar trust 6/28 11:41
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
    REAL_USER="${SUDO_USER:-$(whoami)}"
    USER_DBUS_ADDRESS=""
    USER_XDG_RUNTIME_DIR=""

    if [ "$REAL_USER" != "root" ]; then
        USER_DBUS_ADDRESS=$(pgrep -u "$REAL_USER" gnome-session | xargs -r -I {} cat "/proc/{}/environ" 2>/dev/null | tr '\0' '\n' | grep '^DBUS_SESSION_BUS_ADDRESS=' | cut -d'=' -f2-)
        USER_XDG_RUNTIME_DIR=$(pgrep -u "$REAL_USER" gnome-session | xargs -r -I {} cat "/proc/{}/environ" 2>/dev/null | tr '\0' '\n' | grep '^XDG_RUNTIME_DIR=' | cut -d'=' -f2-)
    fi

    run_gui_command() {
        local output
        if [ -n "$USER_DBUS_ADDRESS" ] && [ -n "$USER_XDG_RUNTIME_DIR" ]; then
            output=$(sudo -u "$REAL_USER" env DBUS_SESSION_BUS_ADDRESS="$USER_DBUS_ADDRESS" XDG_RUNTIME_DIR="$USER_XDG_RUNTIME_DIR" "$@" 2>&1)
            echo "${output}" | sed 's/^/# /'
            return $?
        else
            echo "# WARNING: Could not detect user's graphical session environment. Skipping GUI optimization for: $*"
            return 1
        fi
    }

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
    COMMAND_OUTPUT=$(sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' 2>&1)
    if [ $? -ne 0 ]; then echo "# ERROR: Failed to drop caches: ${COMMAND_OUTPUT}"; else echo "# Caches dropped."; fi

    if (( PERFORM_AGGRESSIVE_MEMORY_OPT == 1 )); then
        echo "# Aggressive memory optimizations..."
        COMMAND_OUTPUT=$(sudo swapoff -a 2>&1)
        if [ $? -ne 0 ]; then echo "# ERROR: Failed to swapoff: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo swapon -a 2>&1)
        if [ $? -ne 0 ]; then echo "# ERROR: Failed to swapon: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w vm.swappiness=10 2>&1)
        if [ $? -ne 0 ]; then echo "# ERROR: Failed to set vm.swappiness: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w vm.vfs_cache_pressure=50 2>&1)
        if [ $? -ne 0 ]; then echo "# ERROR: Failed to set vm.vfs_cache_pressure: ${COMMAND_OUTPUT}"; fi
    fi

    if (( PERFORM_NETWORK_TUNING == 1 )); then
        echo "# Network tuning..."
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_fastopen=3 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_tw_reuse=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_syncookies=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.conf.all.rp_filter=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.conf.default.rp_filter=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.ip_forward=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_fin_timeout=15 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_keepalive_time=600 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_keepalive_probes=3 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_keepalive_intvl=10 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_mtu_probing=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_sack=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_dsack=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_fack=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_window_scaling=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_timestamps=1 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.core.rmem_max=16777216 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.core.wmem_max=16777216 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.core.rmem_default=16777216 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.core.wmem_default=16777216 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.core.netdev_max_backlog=16384 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.core.somaxconn=16384 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    fi

    COMMAND_OUTPUT=$(sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' 2>&1)
    if [ $? -ne 0 ]; then echo "# ERROR: Failed to disable transparent huge pages: ${COMMAND_OUTPUT}"; fi

    echo "# Setting I/O scheduler to noop for detected block devices..."
    for scheduler_path in /sys/block/*/queue/scheduler; do
        if [ -f "$scheduler_path" ]; then
            DEVICE_NAME=$(basename "$(dirname "$scheduler_path")")
            COMMAND_OUTPUT=$(sudo sh -c "echo noop > $scheduler_path" 2>&1)
            if [ $? -ne 0 ]; then
                echo "# ERROR: Failed to set scheduler for ${DEVICE_NAME}: ${COMMAND_OUTPUT}"
            else
                echo "# Scheduler set to noop for ${DEVICE_NAME}."
            fi
        fi
    done

    COMMAND_OUTPUT=$(sudo sysctl -w kernel.perf_event_max_sample_rate=1000000 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    COMMAND_OUTPUT=$(sudo sysctl -w kernel.nmi_watchdog=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    COMMAND_OUTPUT=$(sudo sysctl -w kernel.hung_task_timeout_secs=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    COMMAND_OUTPUT=$(sudo sysctl -w kernel.numa_balancing=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    COMMAND_OUTPUT=$(sudo sysctl -w kernel.randomize_va_space=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    echo "30"
    echo "# Cleaning up system files..."
    COMMAND_OUTPUT=$(sudo apt clean 2>&1); echo "# ${COMMAND_OUTPUT}"
    COMMAND_OUTPUT=$(sudo apt autoremove -y 2>&1); echo "# ${COMMAND_OUTPUT}"
    echo "40"

    if (( PERFORM_CPU_GOVERNOR_OPT == 1 )); then
        echo "# Setting CPU governor to performance mode..."
        if command -v cpufreq-set >/dev/null 2>&1; then
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                COMMAND_OUTPUT=$(sudo sh -c "echo performance > $cpu" 2>&1)
                if [ $? -ne 0 ]; then echo "# ERROR: Failed to set governor for $cpu: ${COMMAND_OUTPUT}"; fi
            done
            echo "# CPU governor set to performance."
        else
            echo "# cpufreq-set not found. Please install cpufrequtils for this optimization (sudo apt install cpufrequtils)."
        fi
    fi
    echo "50"

    if (( PERFORM_GUI_OPTIMIZATIONS == 1 )); then
        echo "# Applying user and display optimizations..."
        run_gui_command gsettings set org.gnome.desktop.interface enable-animations false
        run_gui_command gsettings set org.gnome.desktop.interface cursor-size 24
        run_gui_command gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
        run_gui_command gsettings set org.gnome.desktop.session idle-delay 0
        run_gui_command gsettings set org.gnome.shell.overrides attach-modal-dialogs false
        run_gui_command gsettings set org.gnome.shell.overrides dynamic-workspaces false
        run_gui_command gsettings set org.gnome.shell.overrides workspaces-only-on-primary false
        run_gui_command gsettings set org.gnome.shell.window-switcher current-workspace-only true
        run_gui_command dconf write /org/gnome/desktop/interface/enable-hot-corners false
        run_gui_command dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:'"
        run_gui_command dconf write /org/gnome/desktop.wm.preferences focus-mode "'sloppy'"
        run_gui_command dconf write /org/gnome/desktop.wm.preferences mouse-button-modifier "<Super>"
        run_gui_command dconf write /org/gnome/desktop.wm.preferences resize-grip-on-right false
        run_gui_command dconf write /org/gnome/desktop.wm.preferences titlebar-font "'Cantarell 11'"
        run_gui_command dconf write /org/gnome/desktop.wm.preferences titlebar-uses-system-font true
        run_gui_command dconf write /org/gnome/desktop.wm.preferences visual-bell false
        run_gui_command dconf write /org/unity/launcher/hide-behavior "'2'"
        run_gui_command dconf write /org/unity/launcher/minimize-window-on-click true
        run_gui_command dconf write /org/compiz/profiles/unity/plugins/unityshell/hide-launcher true
    fi
    echo "70"

    echo "# Applying Minecraft specific optimizations..."
    COMMAND_OUTPUT=$(sudo sh -c 'echo "vm.overcommit_memory=1" >> /etc/sysctl.conf' 2>&1); echo "# ${COMMAND_OUTPUT}"
    COMMAND_OUTPUT=$(sudo sysctl -p 2>&1); echo "# ${COMMAND_OUTPUT}"
    if ! grep -q "options nouveau modeset=0" /etc/modprobe.d/blacklist.conf; then
        COMMAND_OUTPUT=$(sudo sh -c 'echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist.conf' 2>&1); echo "# ${COMMAND_OUTPUT}"
        COMMAND_OUTPUT=$(sudo update-initramfs -u 2>&1); echo "# ${COMMAND_OUTPUT}"
    fi
    if ! grep -q "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash pcie_aspm=force\"" /etc/default/grub; then
        COMMAND_OUTPUT=$(sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pcie_aspm=force"/g' /etc/default/grub 2>&1); echo "# ${COMMAND_OUTPUT}"
        COMMAND_OUTPUT=$(sudo update-grub 2>&1); echo "# ${COMMAND_OUTPUT}"
    fi
    mkdir -p ~/.minecraft/resourcepacks
    mkdir -p ~/.minecraft/shaderpacks
    mkdir -p ~/.minecraft/mods
    echo "80"

    zenity --question --title="LagEZ - Minecraft Optimization" --text="Enable Swils.gg Mode for Minecraft?"
    swils_choice=$?
    if [[ "$swils_choice" == "0" ]]; then
        echo "# Enabling Swils.gg Mode..."
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_timestamps=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_sack=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_dsack=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_fack=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_window_scaling=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    fi

    zenity --question --title="LagEZ - Minecraft Optimization" --text="Enable EZPing Mode for Minecraft?"
    ezping_choice=$?
    if [[ "$ezping_choice" == "0" ]]; then
        echo "# Enabling EZPing Mode..."
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_syncookies=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_fastopen=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_tw_reuse=0 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
        COMMAND_OUTPUT=$(sudo sysctl -w net.ipv4.tcp_fin_timeout=60 2>&1); if [ $? -ne 0 ]; then echo "# ERROR: ${COMMAND_OUTPUT}"; fi
    fi

    zenity --question --title="LagEZ - Gaming QoS" --text="Enable Gaming QoS Mode to prioritize game traffic? (Requires 'iproute2' package for 'tc' command)"
    qos_choice=$?
    if [[ "$qos_choice" == "0" ]]; then
        echo "# Enabling Gaming QoS Mode..."
        ACTIVE_INTERFACE=$(ip -o -4 route show default | awk '{print $5}' | head -n 1)
        if [ -z "$ACTIVE_INTERFACE" ]; then
            echo "# ERROR: Could not detect active network interface for QoS. Skipping Gaming QoS Mode."
        elif ! command -v tc >/dev/null 2>&1; then
            echo "# ERROR: 'tc' command not found. Please install 'iproute2' package (e.g., sudo apt install iproute2) to use Gaming QoS Mode."
        else
            echo "# Applying QoS to interface: ${ACTIVE_INTERFACE}"
            COMMAND_OUTPUT=$(sudo tc qdisc del dev "$ACTIVE_INTERFACE" root 2>/dev/null)
            COMMAND_OUTPUT=$(sudo tc qdisc add dev "$ACTIVE_INTERFACE" root handle 1: htb default 10 2>&1); echo "# ${COMMAND_OUTPUT}"
            COMMAND_OUTPUT=$(sudo tc class add dev "$ACTIVE_INTERFACE" parent 1: classid 1:1 htb rate 1000mbit ceil 1000mbit 2>&1); echo "# ${COMMAND_OUTPUT}"
            COMMAND_OUTPUT=$(sudo tc class add dev "$ACTIVE_INTERFACE" parent 1:1 classid 1:10 htb rate 1000mbit ceil 1000mbit 2>&1); echo "# ${COMMAND_OUTPUT}"
            COMMAND_OUTPUT=$(sudo tc class add dev "$ACTIVE_INTERFACE" parent 1:1 classid 1:20 htb rate 1000mbit ceil 1000mbit 2>&1); echo "# ${COMMAND_OUTPUT}"
            # Prioritize Minecraft default port (TCP and UDP)
            COMMAND_OUTPUT=$(sudo tc filter add dev "$ACTIVE_INTERFACE" protocol ip parent 1:0 prio 1 u32 match ip dport 25565 0xffff flowid 1:10 2>&1); echo "# ${COMMAND_OUTPUT}"
            COMMAND_OUTPUT=$(sudo tc filter add dev "$ACTIVE_INTERFACE" protocol ip parent 1:0 prio 1 u32 match ip sport 25565 0xffff flowid 1:10 2>&1); echo "# ${COMMAND_OUTPUT}"
            echo "# Gaming QoS Mode applied. Note: QoS rules are temporary and will reset on reboot."
            echo "# To manually remove QoS: sudo tc qdisc del dev ${ACTIVE_INTERFACE} root"
        fi
    fi
    echo "100"
    echo "# Optimization complete! Some changes require a system restart to take full effect."
    echo "# Thank you for using LagEZ - Linux Optimizer."
    ) | zenity --progress --title="LagEZ - Linux Optimizer" --text="Starting optimization..." --percentage=0 --auto-close --auto-kill
    zenity --info --title="LagEZ - Optimization Complete" --text="Optimization complete! Some changes require a system restart to take full effect.\n\nThank you for using LagEZ - Linux Optimizer."

elif [[ "$MODE_CHOICE" == "Terminal Mode" ]]; then
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

    echo "Setting I/O scheduler to noop for detected block devices..."
    for scheduler_path in /sys/block/*/queue/scheduler; do
        if [ -f "$scheduler_path" ]; then
            DEVICE_NAME=$(basename "$(dirname "$scheduler_path")")
            COMMAND_OUTPUT=$(sudo sh -c "echo noop > $scheduler_path" 2>&1)
            if [ $? -ne 0 ]; then
                echo "ERROR: Failed to set scheduler for ${DEVICE_NAME}: ${COMMAND_OUTPUT}"
            fi
        fi
    done

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
        dconf write /org/gnome/desktop.wm.preferences focus-mode "'sloppy'"
        dconf write /org/gnome/desktop.wm.preferences mouse-button-modifier "<Super>"
        dconf write /org/gnome/desktop.wm.preferences resize-grip-on-right false
        dconf write /org/gnome/desktop.wm.preferences titlebar-font "'Cantarell 11'"
        dconf write /org/gnome/desktop.wm.preferences titlebar-uses-system-font true
        dconf write /org/gnome/desktop.wm.preferences visual-bell false
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

    read -p "Enable Gaming QoS Mode to prioritize game traffic? (y/n - Requires 'iproute2' package for 'tc' command): " qos_choice
    if [[ "$qos_choice" == "y" || "$qos_choice" == "Y" ]]; then
        echo "Enabling Gaming QoS Mode..."
        ACTIVE_INTERFACE=$(ip -o -4 route show default | awk '{print $5}' | head -n 1)
        if [ -z "$ACTIVE_INTERFACE" ]; then
            echo "ERROR: Could not detect active network interface for QoS. Skipping Gaming QoS Mode."
        elif ! command -v tc >/dev/null 2>&1; then
            echo "ERROR: 'tc' command not found. Please install 'iproute2' package (e.g., sudo apt install iproute2) to use Gaming QoS Mode."
        else
            echo "Applying QoS to interface: ${ACTIVE_INTERFACE}"
            sudo tc qdisc del dev "$ACTIVE_INTERFACE" root 2>/dev/null
            sudo tc qdisc add dev "$ACTIVE_INTERFACE" root handle 1: htb default 10
            sudo tc class add dev "$ACTIVE_INTERFACE" parent 1: classid 1:1 htb rate 1000mbit ceil 1000mbit
            sudo tc class add dev "$ACTIVE_INTERFACE" parent 1:1 classid 1:10 htb rate 1000mbit ceil 1000mbit
            sudo tc class add dev "$ACTIVE_INTERFACE" parent 1:1 classid 1:20 htb rate 1000mbit ceil 1000mbit
            sudo tc filter add dev "$ACTIVE_INTERFACE" protocol ip parent 1:0 prio 1 u32 match ip dport 25565 0xffff flowid 1:10
            sudo tc filter add dev "$ACTIVE_INTERFACE" protocol ip parent 1:0 prio 1 u32 match ip sport 25565 0xffff flowid 1:10
            echo "Gaming QoS Mode applied. Note: QoS rules are temporary and will reset on reboot."
            echo "To manually remove QoS: sudo tc qdisc del dev ${ACTIVE_INTERFACE} root"
        fi
    fi

    echo "Optimization complete! Some changes require a system restart to take full effect."
    echo "Thank you for using LagEZ - Linux Optimizer."
fi
