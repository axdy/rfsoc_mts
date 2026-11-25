set source_dir [file dirname [file normalize [info script]]]
set project_dir [file join $source_dir rfsoc_mts]
set output_dir [file join $source_dir bitstream]
if {[llength $argv] == 2} {
    lassign $argv project_dir output_dir
}
open_project [file join $project_dir rfsoc_mts.xpr]

set bd_file [get_files block_design.bd]
open_bd_design $bd_file
set wrapper_file [make_wrapper -files $bd_file -top]
if {[llength [get_files -quiet $wrapper_file]] == 0} {
    add_files -norecurse $wrapper_file
}
set_property top block_design_wrapper [current_fileset]
update_compile_order -fileset sources_1

launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1
set status [get_property STATUS [get_runs impl_1]]
if {![string match "write_bitstream Complete*" $status]} {
    error "Bitstream generation failed: $status"
}

file mkdir $output_dir
write_hw_platform -fixed -include_bit -force -file [file join $output_dir mts.xsa]
