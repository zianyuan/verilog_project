# 使用modelsim仿真脚本
# 基础配置
# 退出当前仿真
quit -sim 
# 清楚命令和信息
.main clear


# 编译和仿真文件
# 对当前文件夹下的所有.v文件进行编译 
vlog ./*.v
#-voptargs=+acc：加快仿真速度 work.xxxxxxxx：仿真的顶层设计模块的名称 -t ns:仿真时间分辨率
vsim -t ns -voptargs=+acc work.swap

# 添加波形
add wave swap/*

# 配置时间线单位 默认为ns
configure wave -timelineunits ns

# 运行
run 20ns