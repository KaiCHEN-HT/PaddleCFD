#!/bin/bash
CONDA_INIT_SCRIPT="$HOME/miniconda3/etc/profile.d/conda.sh"

# 确认conda的初始化脚本存在
if [ -f "$CONDA_INIT_SCRIPT" ]; then
    # 初始化conda环境
    source "$CONDA_INIT_SCRIPT"
    echo "Conda init script found."
else
    echo "Conda init script not found: $CONDA_INIT_SCRIPT"
    echo "Please adjust the CONDA_INIT_SCRIPT variable to match your conda installation."
    exit 1
fi
conda activate ppcfd
cd /root/paddlejob/PaddleCFD/examples/aerodynamic_drag_pred/ppfno