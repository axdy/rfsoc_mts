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
set bd_dir [file join $project_dir rfsoc_mts.srcs sources_1 bd]
file mkdir $bd_dir
file copy [file join $source_dir block_design] $bd_dir
add_files -fileset sources_1 -norecurse [file join $bd_dir block_design block_design.bd]
open_bd_design [get_files block_design.bd]
validate_bd_design
save_bd_design
