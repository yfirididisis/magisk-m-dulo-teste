#!/system/bin/sh
# Gaming Profile - Otimizado para KernelSU (Máximo Performance)

echo "gaming" > /data/spectrum/profile

# ====================== GPU MÁXIMO ======================
echo "0" > /sys/class/kgsl/kgsl-3d0/min_pwrlevel 2>/dev/null
echo "0" > /sys/class/kgsl/kgsl-3d0/max_pwrlevel 2>/dev/null

# ... (full content from previous)