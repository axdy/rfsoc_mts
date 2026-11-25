set source_dir [file dirname [file normalize [info script]]]
set project_dir [file join $source_dir rfsoc_mts]
if {[llength $argv] > 0} {
    set project_dir [file normalize [lindex $argv 0]]
}

create_project rfsoc_mts $project_dir -part xczu49dr-ffvf1760-2-e
set_property board_part xilinx.com:zcu216:part0:2.0 [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths [file normalize [file join $source_dir ../../iprepo]] [current_project]
update_ip_catalog

add_files -fileset constrs_1 -norecurse [file join $source_dir mts.xdc]
source [file join $source_dir block_design.tcl]
