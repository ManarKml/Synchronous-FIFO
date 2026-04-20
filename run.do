vlib work
vlog -f src_files.list +cover=sbeft -covercells
vsim -voptargs=+acc work.FIFO_top -cover
add wave -position insertpoint  \
sim:/FIFO_top/F_if/clk
add wave -position insertpoint  \
sim:/FIFO_top/mon/FIFO_txn 
add wave -position insertpoint  \
sim:/shared_pkg::correct_count \
sim:/shared_pkg::error_count
run -all
coverage save FIFO_coverage.ucdb -onexit -du FIFO
#coverage report -detail -cvg -directive -comments -output funcov_assercov_FIFO.txt
#quit -sim
#vcover report FIFO_coverage.ucdb -details -annotate -all -output codecov_FIFO.txt
#vcover report FIFO_coverage.ucdb -du=FIFO -recursive -assert -directive -cvg -codeAll -output cov_rprt_summary_FIFO.txt