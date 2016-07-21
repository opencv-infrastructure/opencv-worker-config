if [ -f "/sys/fs/cgroup/memory/${USER}/tasks" ] ; then
    echo $$ > /sys/fs/cgroup/memory/${USER}/tasks
fi

export PATH=/app/bin:$PATH
