
################################################################
# This is a generated script based on design: block_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source block_design_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu49dr-ffvf1760-2-e
   set_property BOARD_PART xilinx.com:zcu216:part0:2.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name block_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES:
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\
xilinx.com:ip:zynq_ultra_ps_e:3.5\
xilinx.com:ip:usp_rf_data_converter:2.6\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:xpm_cdc_gen:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axis_clock_converter:1.1\
xilinx.com:ip:axis_dwidth_converter:1.1\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:ip:blk_mem_gen:8.4\
StrathSDR:mts:bram_player:1.0\
xilinx.com:ip:axis_broadcaster:1.1\
StrathSDR:mts:bram_capture:1.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: adc_20
proc create_hier_cell_adc_20 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_20() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc_32
proc create_hier_cell_adc_32 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_32() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc_30
proc create_hier_cell_adc_30 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_30() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc_22
proc create_hier_cell_adc_22 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_22() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc_10
proc create_hier_cell_adc_10 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_10() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc_02
proc create_hier_cell_adc_02 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_02() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc_12
proc create_hier_cell_adc_12 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_12() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: adc_00
proc create_hier_cell_adc_00 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_adc_00() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn
  create_bd_pin -dir I trigger

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {8} $axis_dwidth_converter


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_capture, and set properties
  set bram_capture [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_capture:1.0 bram_capture ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_capture


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_capture/BRAM_A]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_M_AXIS [get_bd_intf_pins bram_capture/S_AXIS] [get_bd_intf_pins axis_clock_converter/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/S_AXIS] [get_bd_intf_pins axis_dwidth_converter/M_AXIS]
  connect_bd_intf_net -intf_net bram_capture_0_BRAM_A [get_bd_intf_pins bram_capture/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]

  # Create port connections
  connect_bd_net -net Net1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins bram_capture/axis_aclk]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins bram_capture/axis_resetn]
  connect_bd_net -net s_axi_aresetn_2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn]
  connect_bd_net -net trigger_1  [get_bd_pins trigger] \
  [get_bd_pins bram_capture/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: signal_player
proc create_hier_cell_signal_player { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_signal_player() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_00

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_02

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_10

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_12

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_20

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_22

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_30
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_DAC_32


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn

  # Create instance: bram_ctrl, and set properties
  set bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {64} \
    CONFIG.READ_LATENCY {3} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bram_ctrl


  # Create instance: axis_clock_converter, and set properties
  set axis_clock_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter ]
  set_property CONFIG.IS_ACLK_ASYNC {1} $axis_clock_converter


  # Create instance: axis_dwidth_converter, and set properties
  set axis_dwidth_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter ]
  set_property CONFIG.M_TDATA_NUM_BYTES {4} $axis_dwidth_converter


  # Create instance: axis_register_slice, and set properties
  set axis_register_slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice ]
  set_property CONFIG.REG_CONFIG {8} $axis_register_slice


  # Create instance: bmg, and set properties
  set bmg [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bmg ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.PRIM_type_to_Implement {URAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.READ_LATENCY_A {3} \
    CONFIG.READ_LATENCY_B {3} \
    CONFIG.Use_RSTB_Pin {true} \
  ] $bmg


  # Create instance: bram_player, and set properties
  set bram_player [ create_bd_cell -type ip -vlnv StrathSDR:mts:bram_player:1.0 bram_player ]
  set_property -dict [list \
    CONFIG.DATAWIDTH {64} \
    CONFIG.MEM_SIZE_BYTES {16384} \
  ] $bram_player


  set_property -dict [ list \
   CONFIG.MASTER_TYPE {BRAM_CTRL} \
 ] [get_bd_intf_pins $bram_player/BRAM_A]

  # Create instance: gpio_enable, and set properties
  set gpio_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_enable ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $gpio_enable


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: axis_broadcaster, and set properties
  set axis_broadcaster [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster ]
  set_property -dict [list \
    CONFIG.HAS_TKEEP {0} \
    CONFIG.HAS_TLAST {0} \
    CONFIG.HAS_TREADY {1} \
    CONFIG.HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {4} \
    CONFIG.M_TUSER_WIDTH {0} \
    CONFIG.NUM_MI {8} \
    CONFIG.S_TDATA_NUM_BYTES {4} \
    CONFIG.S_TUSER_WIDTH {0} \
    CONFIG.TDEST_WIDTH {0} \
    CONFIG.TID_WIDTH {0} \
  ] $axis_broadcaster


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axis_broadcaster/M00_AXIS] [get_bd_intf_pins AXIS_DAC_00]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axis_broadcaster/M01_AXIS] [get_bd_intf_pins AXIS_DAC_02]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins axis_broadcaster/M02_AXIS] [get_bd_intf_pins AXIS_DAC_10]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins axis_broadcaster/M03_AXIS] [get_bd_intf_pins AXIS_DAC_12]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins axis_broadcaster/M04_AXIS] [get_bd_intf_pins AXIS_DAC_20]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins axis_broadcaster/M05_AXIS] [get_bd_intf_pins AXIS_DAC_22]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins axis_broadcaster/M06_AXIS] [get_bd_intf_pins AXIS_DAC_30]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins axis_broadcaster/M07_AXIS] [get_bd_intf_pins AXIS_DAC_32]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bmg/BRAM_PORTA]
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins axis_clock_converter/M_AXIS] [get_bd_intf_pins axis_dwidth_converter/S_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_pins axis_dwidth_converter/M_AXIS] [get_bd_intf_pins axis_register_slice/S_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_M_AXIS [get_bd_intf_pins axis_register_slice/M_AXIS] [get_bd_intf_pins axis_broadcaster/S_AXIS]
  connect_bd_intf_net -intf_net bram_player_BRAM_A [get_bd_intf_pins bram_player/BRAM_A] [get_bd_intf_pins bmg/BRAM_PORTB]
  connect_bd_intf_net -intf_net bram_player_M_AXIS [get_bd_intf_pins bram_player/M_AXIS] [get_bd_intf_pins axis_clock_converter/S_AXIS]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins gpio_enable/S_AXI]

  # Create port connections
  connect_bd_net -net Net  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins axis_clock_converter/m_axis_aresetn] \
  [get_bd_pins axis_dwidth_converter/aresetn] \
  [get_bd_pins axis_register_slice/aresetn] \
  [get_bd_pins axis_broadcaster/aresetn]
  connect_bd_net -net Net1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins bram_ctrl/s_axi_aclk] \
  [get_bd_pins axis_clock_converter/s_axis_aclk] \
  [get_bd_pins bram_player/axis_aclk] \
  [get_bd_pins gpio_enable/s_axi_aclk] \
  [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net Net2  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins bram_ctrl/s_axi_aresetn] \
  [get_bd_pins axis_clock_converter/s_axis_aresetn] \
  [get_bd_pins bram_player/axis_resetn] \
  [get_bd_pins gpio_enable/s_axi_aresetn] \
  [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net clk_wiz_adc1_clk_out1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins axis_clock_converter/m_axis_aclk] \
  [get_bd_pins axis_dwidth_converter/aclk] \
  [get_bd_pins axis_register_slice/aclk] \
  [get_bd_pins axis_broadcaster/aclk]
  connect_bd_net -net gpio_enable_gpio_io_o  [get_bd_pins gpio_enable/gpio_io_o] \
  [get_bd_pins bram_player/enable]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: signal_capture
proc create_hier_cell_signal_capture { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_signal_capture() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_00

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_02

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_10

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_12

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_20

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_22

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_30

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 AXIS_ADC_32


  # Create pins
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir I -type rst s_axis_aresetn
  create_bd_pin -dir I -type clk m_axis_aclk
  create_bd_pin -dir I -type rst m_axis_aresetn

  # Create instance: adc_00
  create_hier_cell_adc_00 $hier_obj adc_00

  # Create instance: smartconnect, and set properties
  set smartconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect ]
  set_property -dict [list \
    CONFIG.NUM_MI {9} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect


  # Create instance: adc_12
  create_hier_cell_adc_12 $hier_obj adc_12

  # Create instance: adc_02
  create_hier_cell_adc_02 $hier_obj adc_02

  # Create instance: adc_10
  create_hier_cell_adc_10 $hier_obj adc_10

  # Create instance: signal_capture_trigger, and set properties
  set signal_capture_trigger [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 signal_capture_trigger ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $signal_capture_trigger


  # Create instance: adc_22
  create_hier_cell_adc_22 $hier_obj adc_22

  # Create instance: adc_30
  create_hier_cell_adc_30 $hier_obj adc_30

  # Create instance: adc_32
  create_hier_cell_adc_32 $hier_obj adc_32

  # Create instance: adc_20
  create_hier_cell_adc_20 $hier_obj adc_20

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins smartconnect/S00_AXI] [get_bd_intf_pins S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins adc_00/S_AXIS] [get_bd_intf_pins AXIS_ADC_00]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins adc_02/S_AXIS] [get_bd_intf_pins AXIS_ADC_02]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins adc_10/S_AXIS] [get_bd_intf_pins AXIS_ADC_10]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins adc_12/S_AXIS] [get_bd_intf_pins AXIS_ADC_12]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins adc_20/S_AXIS] [get_bd_intf_pins AXIS_ADC_20]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins adc_22/S_AXIS] [get_bd_intf_pins AXIS_ADC_22]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins adc_30/S_AXIS] [get_bd_intf_pins AXIS_ADC_30]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins adc_32/S_AXIS] [get_bd_intf_pins AXIS_ADC_32]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins adc_12/S_AXI] [get_bd_intf_pins smartconnect/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_M00_AXI [get_bd_intf_pins smartconnect/M00_AXI] [get_bd_intf_pins adc_00/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_M01_AXI [get_bd_intf_pins smartconnect/M01_AXI] [get_bd_intf_pins adc_02/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_M02_AXI [get_bd_intf_pins smartconnect/M02_AXI] [get_bd_intf_pins adc_10/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_M04_AXI [get_bd_intf_pins smartconnect/M04_AXI] [get_bd_intf_pins adc_20/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_M05_AXI [get_bd_intf_pins smartconnect/M05_AXI] [get_bd_intf_pins adc_22/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_M06_AXI [get_bd_intf_pins smartconnect/M06_AXI] [get_bd_intf_pins adc_30/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_M07_AXI [get_bd_intf_pins smartconnect/M07_AXI] [get_bd_intf_pins adc_32/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_M08_AXI [get_bd_intf_pins signal_capture_trigger/S_AXI] [get_bd_intf_pins smartconnect/M08_AXI]

  # Create port connections
  connect_bd_net -net aresetn_1  [get_bd_pins s_axis_aresetn] \
  [get_bd_pins adc_00/s_axis_aresetn] \
  [get_bd_pins adc_02/s_axis_aresetn] \
  [get_bd_pins adc_10/s_axis_aresetn] \
  [get_bd_pins adc_12/s_axis_aresetn] \
  [get_bd_pins adc_22/s_axis_aresetn] \
  [get_bd_pins adc_30/s_axis_aresetn] \
  [get_bd_pins adc_32/s_axis_aresetn] \
  [get_bd_pins adc_20/s_axis_aresetn]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins m_axis_aclk] \
  [get_bd_pins adc_00/m_axis_aclk] \
  [get_bd_pins adc_12/m_axis_aclk] \
  [get_bd_pins adc_10/m_axis_aclk] \
  [get_bd_pins adc_02/m_axis_aclk] \
  [get_bd_pins smartconnect/aclk] \
  [get_bd_pins signal_capture_trigger/s_axi_aclk] \
  [get_bd_pins adc_22/m_axis_aclk] \
  [get_bd_pins adc_30/m_axis_aclk] \
  [get_bd_pins adc_32/m_axis_aclk] \
  [get_bd_pins adc_20/m_axis_aclk]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins m_axis_aresetn] \
  [get_bd_pins adc_00/m_axis_aresetn] \
  [get_bd_pins adc_02/m_axis_aresetn] \
  [get_bd_pins adc_10/m_axis_aresetn] \
  [get_bd_pins adc_12/m_axis_aresetn] \
  [get_bd_pins smartconnect/aresetn] \
  [get_bd_pins signal_capture_trigger/s_axi_aresetn] \
  [get_bd_pins adc_22/m_axis_aresetn] \
  [get_bd_pins adc_30/m_axis_aresetn] \
  [get_bd_pins adc_32/m_axis_aresetn] \
  [get_bd_pins adc_20/m_axis_aresetn]
  connect_bd_net -net s_axis_aclk_1  [get_bd_pins s_axis_aclk] \
  [get_bd_pins adc_00/s_axis_aclk] \
  [get_bd_pins adc_10/s_axis_aclk] \
  [get_bd_pins adc_12/s_axis_aclk] \
  [get_bd_pins adc_02/s_axis_aclk] \
  [get_bd_pins adc_22/s_axis_aclk] \
  [get_bd_pins adc_30/s_axis_aclk] \
  [get_bd_pins adc_32/s_axis_aclk] \
  [get_bd_pins adc_20/s_axis_aclk]
  connect_bd_net -net trig_cap_1  [get_bd_pins signal_capture_trigger/gpio_io_o] \
  [get_bd_pins adc_00/trigger] \
  [get_bd_pins adc_02/trigger] \
  [get_bd_pins adc_10/trigger] \
  [get_bd_pins adc_12/trigger] \
  [get_bd_pins adc_22/trigger] \
  [get_bd_pins adc_30/trigger] \
  [get_bd_pins adc_32/trigger] \
  [get_bd_pins adc_20/trigger]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sysref_capture
proc create_hier_cell_sysref_capture { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_sysref_capture() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pl_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pl_sysref


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 user_sysref
  create_bd_pin -dir O -type clk user_clk
  create_bd_pin -dir I -type rst s_axi_resetn
  create_bd_pin -dir O -from 0 -to 0 -type rst user_aresetn
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir I -type clk s_axi_aclk

  # Create instance: clkwiz, and set properties
  set clkwiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clkwiz ]
  set_property -dict [list \
    CONFIG.AUTO_PRIMITIVE {MMCM} \
    CONFIG.CLKIN1_JITTER_PS {0.10} \
    CONFIG.CLKIN1_UI_JITTER {0.10} \
    CONFIG.CLKIN2_JITTER_PS {100.000} \
    CONFIG.CLKIN2_UI_JITTER {100.000} \
    CONFIG.CLKOUT1_DRIVES {Buffer} \
    CONFIG.CLKOUT1_JITTER {67.875} \
    CONFIG.CLKOUT1_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT1_PHASE_ERROR {64.867} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {500.0} \
    CONFIG.CLKOUT2_DRIVES {Buffer} \
    CONFIG.CLKOUT2_JITTER {78.335} \
    CONFIG.CLKOUT2_MATCHED_ROUTING {false} \
    CONFIG.CLKOUT2_PHASE_ERROR {66.020} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
    CONFIG.CLKOUT2_USED {false} \
    CONFIG.CLKOUT3_DRIVES {Buffer} \
    CONFIG.CLKOUT4_DRIVES {Buffer} \
    CONFIG.CLKOUT5_DRIVES {Buffer} \
    CONFIG.CLKOUT6_DRIVES {Buffer} \
    CONFIG.CLKOUT7_DRIVES {Buffer} \
    CONFIG.ENABLE_CLOCK_MONITOR {true} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.JITTER_OPTIONS {PS} \
    CONFIG.JITTER_SEL {Min_O_Jitter} \
    CONFIG.MMCM_BANDWIDTH {HIGH} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {3.125} \
    CONFIG.MMCM_CLKIN1_PERIOD {2.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.125} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
    CONFIG.MMCM_COMPENSATION {AUTO} \
    CONFIG.MMCM_DIVCLK_DIVIDE {1} \
    CONFIG.MMCM_REF_JITTER1 {0.000} \
    CONFIG.MMCM_REF_JITTER2 {0.010} \
    CONFIG.NUM_OUT_CLKS {1} \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {false} \
    CONFIG.PRIMITIVE {MMCM} \
    CONFIG.PRIM_IN_FREQ {500.0} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
    CONFIG.USE_DYN_RECONFIG {false} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
    CONFIG.USE_RESET {true} \
  ] $clkwiz


  # Create instance: proc_sys_reset_500M, and set properties
  set proc_sys_reset_500M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_500M ]

  # Create instance: synch_sysref, and set properties
  set synch_sysref [ create_bd_cell -type ip -vlnv xilinx.com:ip:xpm_cdc_gen:1.0 synch_sysref ]
  set_property -dict [list \
    CONFIG.CDC_TYPE {xpm_cdc_single} \
    CONFIG.DEST_SYNC_FF {2} \
    CONFIG.INIT_SYNC_FF {true} \
  ] $synch_sysref


  # Create instance: ibufds_pl_clk, and set properties
  set ibufds_pl_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 ibufds_pl_clk ]

  # Create instance: ibufds_pl_sysref, and set properties
  set ibufds_pl_sysref [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 ibufds_pl_sysref ]

  # Create instance: bufg_pl_clk, and set properties
  set bufg_pl_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 bufg_pl_clk ]
  set_property CONFIG.C_BUF_TYPE {BUFG} $bufg_pl_clk


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ibufds_pl_clk/CLK_IN_D] [get_bd_intf_pins pl_clk]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins ibufds_pl_sysref/CLK_IN_D] [get_bd_intf_pins pl_sysref]
  connect_bd_intf_net -intf_net control_interconnect_M07_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins clkwiz/s_axi_lite]

  # Create port connections
  connect_bd_net -net MTSclkwiz_interrupt  [get_bd_pins clkwiz/interrupt] \
  [get_bd_pins irq]
  connect_bd_net -net RFingressReset_peripheral_aresetn  [get_bd_pins proc_sys_reset_500M/peripheral_aresetn] \
  [get_bd_pins user_aresetn]
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins clkwiz/clk_out1] \
  [get_bd_pins user_clk] \
  [get_bd_pins proc_sys_reset_500M/slowest_sync_clk] \
  [get_bd_pins synch_sysref/dest_clk]
  connect_bd_net -net clk_wiz_0_locked  [get_bd_pins clkwiz/locked] \
  [get_bd_pins proc_sys_reset_500M/dcm_locked]
  connect_bd_net -net ibufds_pl_sysref_IBUF_OUT  [get_bd_pins ibufds_pl_sysref/IBUF_OUT] \
  [get_bd_pins synch_sysref/src_in]
  connect_bd_net -net pl_clk_ibufds_IBUF_OUT  [get_bd_pins ibufds_pl_clk/IBUF_OUT] \
  [get_bd_pins bufg_pl_clk/BUFG_I]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins s_axi_resetn] \
  [get_bd_pins clkwiz/s_axi_aresetn] \
  [get_bd_pins proc_sys_reset_500M/ext_reset_in]
  connect_bd_net -net synch_sysref_dest_out  [get_bd_pins synch_sysref/dest_out] \
  [get_bd_pins user_sysref]
  connect_bd_net -net util_ds_buf_0_BUFG_O  [get_bd_pins bufg_pl_clk/BUFG_O] \
  [get_bd_pins clkwiz/clk_in1] \
  [get_bd_pins synch_sysref/src_clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0  [get_bd_pins s_axi_aclk] \
  [get_bd_pins clkwiz/s_axi_aclk] \
  [get_bd_pins clkwiz/ref_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set sysref_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in ]

  set vin00 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin00 ]

  set vin10 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin10 ]

  set adc2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc2_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {500000000.0} \
   ] $adc2_clk

  set vin20 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin20 ]

  set vin30 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin30 ]

  set vout00 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout00 ]

  set vout10 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout10 ]

  set dac2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac2_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {500000000.0} \
   ] $dac2_clk

  set vout20 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout20 ]

  set vout30 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout30 ]

  set pl_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pl_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {500000000} \
   ] $pl_clk

  set pl_sysref [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pl_sysref ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {5000000} \
   ] $pl_sysref

  set vin32 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin32 ]

  set vout12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout12 ]

  set vin22 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin22 ]

  set vout02 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout02 ]

  set vin02 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin02 ]

  set vout22 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout22 ]

  set vin12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin12 ]

  set vout32 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout32 ]


  # Create ports

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 zynq_ultra_ps_e_0 ]
  set_property -dict [list \
    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
    CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1} \
    CONFIG.PSU_MIO_13_POLARITY {Default} \
    CONFIG.PSU_MIO_20_POLARITY {Default} \
    CONFIG.PSU_MIO_21_POLARITY {Default} \
    CONFIG.PSU_MIO_22_POLARITY {Default} \
    CONFIG.PSU_MIO_23_POLARITY {Default} \
    CONFIG.PSU_MIO_24_POLARITY {Default} \
    CONFIG.PSU_MIO_25_POLARITY {Default} \
    CONFIG.PSU_MIO_26_POLARITY {Default} \
    CONFIG.PSU_MIO_27_POLARITY {Default} \
    CONFIG.PSU_MIO_28_POLARITY {Default} \
    CONFIG.PSU_MIO_29_POLARITY {Default} \
    CONFIG.PSU_MIO_30_POLARITY {Default} \
    CONFIG.PSU_MIO_31_POLARITY {Default} \
    CONFIG.PSU_MIO_32_POLARITY {Default} \
    CONFIG.PSU_MIO_33_POLARITY {Default} \
    CONFIG.PSU_MIO_34_POLARITY {Default} \
    CONFIG.PSU_MIO_35_POLARITY {Default} \
    CONFIG.PSU_MIO_36_POLARITY {Default} \
    CONFIG.PSU_MIO_37_POLARITY {Default} \
    CONFIG.PSU_MIO_38_POLARITY {Default} \
    CONFIG.PSU_MIO_43_POLARITY {Default} \
    CONFIG.PSU_MIO_44_POLARITY {Default} \
    CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad\
SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1\
MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem\
3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
    CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#gpio0[20]#gpio0[21]#gpio0[22]#gpio0[23]#gpio0[24]#gpio0[25]#gpio1[26]#gpio1[27]#gpio1[28]#gpio1[29]#gpio1[30]#gpio1[31]#gpio1[32]#gpio1[33]#gpio1[34]#gpio1[35]#gpio1[36]#gpio1[37]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out}\
\
    CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1049.989502} \
    CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.988037} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997498} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997498} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {524.994751} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1066} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.997498} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {524.994751} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.994995} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.994995} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997498} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.984985} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.998749} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997498} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.997498} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.994995} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498123} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.998749} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.498123} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.997498} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.999800} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
    CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
    CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
    CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
    CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
    CONFIG.PSU__DDRC__CL {15} \
    CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
    CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
    CONFIG.PSU__DDRC__CWL {11} \
    CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
    CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
    CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
    CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
    CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
    CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
    CONFIG.PSU__DDRC__ECC {Disabled} \
    CONFIG.PSU__DDRC__FGRM {1X} \
    CONFIG.PSU__DDRC__LP_ASR {manual normal} \
    CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
    CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
    CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
    CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
    CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
    CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
    CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
    CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
    CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
    CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
    CONFIG.PSU__DDRC__T_FAW {30.0} \
    CONFIG.PSU__DDRC__T_RAS_MIN {33} \
    CONFIG.PSU__DDRC__T_RC {46.5} \
    CONFIG.PSU__DDRC__T_RCD {15} \
    CONFIG.PSU__DDRC__T_RP {15} \
    CONFIG.PSU__DDRC__VREF {1} \
    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.000} \
    CONFIG.PSU__DLL__ISUSED {1} \
    CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
    CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
    CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
    CONFIG.PSU__ENET3__PTP__ENABLE {0} \
    CONFIG.PSU__ENET3__TSU__ENABLE {0} \
    CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
    CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__GEM3_COHERENCY {0} \
    CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__GEM__TSU__ENABLE {0} \
    CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
    CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.999001} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
    CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
    CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
    CONFIG.PSU__PL_CLK0_BUF {TRUE} \
    CONFIG.PSU__PMU_COHERENCY {0} \
    CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
    CONFIG.PSU__PMU__GPI0__ENABLE {0} \
    CONFIG.PSU__PMU__GPI1__ENABLE {0} \
    CONFIG.PSU__PMU__GPI2__ENABLE {0} \
    CONFIG.PSU__PMU__GPI3__ENABLE {0} \
    CONFIG.PSU__PMU__GPI4__ENABLE {0} \
    CONFIG.PSU__PMU__GPI5__ENABLE {0} \
    CONFIG.PSU__PMU__GPO0__ENABLE {0} \
    CONFIG.PSU__PMU__GPO1__ENABLE {0} \
    CONFIG.PSU__PMU__GPO2__ENABLE {0} \
    CONFIG.PSU__PMU__GPO3__ENABLE {0} \
    CONFIG.PSU__PMU__GPO4__ENABLE {0} \
    CONFIG.PSU__PMU__GPO5__ENABLE {0} \
    CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
    CONFIG.PSU__PRESET_APPLIED {1} \
    CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1}\
\
    CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;0|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1}\
\
    CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__QSPI_COHERENCY {0} \
    CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
    CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
    CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
    CONFIG.PSU__SATA__LANE0__ENABLE {0} \
    CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
    CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk3} \
    CONFIG.PSU__SD1_COHERENCY {0} \
    CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
    CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
    CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
    CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
    CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
    CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
    CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
    CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
    CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__UART0__BAUD_RATE {115200} \
    CONFIG.PSU__UART0__MODEM__ENABLE {0} \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
    CONFIG.PSU__USB0_COHERENCY {0} \
    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
    CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
    CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
    CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
    CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
    CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
    CONFIG.PSU__USE__IRQ0 {1} \
    CONFIG.PSU__USE__M_AXI_GP0 {1} \
    CONFIG.PSU__USE__M_AXI_GP1 {1} \
    CONFIG.PSU__USE__M_AXI_GP2 {0} \
  ] $zynq_ultra_ps_e_0


  # Create instance: rfdc, and set properties
  set rfdc [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.6 rfdc ]
  # Enable slices before applying parameters that depend on active tiles.
  set slice_settings {}
  set tile_rates {}
  set adc_types {}
  foreach tile {0 1 2 3} {
    lappend tile_rates CONFIG.ADC${tile}_Sampling_Rate 2.0 CONFIG.DAC${tile}_Sampling_Rate 2.0
    lappend slice_settings CONFIG.ADC_Slice${tile}1_Enable false \
      CONFIG.DAC_Slice${tile}1_Enable false
    foreach slice {0 2} {
      lappend slice_settings CONFIG.ADC_Slice${tile}${slice}_Enable true \
        CONFIG.DAC_Slice${tile}${slice}_Enable true
      lappend adc_types CONFIG.ADC_Data_Type${tile}${slice} 1
    }
  }
  set_property -dict $slice_settings $rfdc
  set_property -dict $tile_rates $rfdc
  set_property -dict $adc_types $rfdc
  set_property -dict [list \
    CONFIG.ADC0_Clock_Source {2} \
    CONFIG.ADC0_Multi_Tile_Sync {true} \
    CONFIG.ADC1_Clock_Source {2} \
    CONFIG.ADC1_Multi_Tile_Sync {true} \
    CONFIG.ADC2_Clock_Dist {2} \
    CONFIG.ADC2_Multi_Tile_Sync {true} \
    CONFIG.ADC2_PLL_Enable {true} \
    CONFIG.ADC2_Refclk_Freq {500.000} \
    CONFIG.ADC3_Clock_Source {2} \
    CONFIG.ADC3_Multi_Tile_Sync {true} \
    CONFIG.ADC_Data_Width00 {2} \
    CONFIG.ADC_Data_Width02 {2} \
    CONFIG.ADC_Data_Width10 {2} \
    CONFIG.ADC_Data_Width12 {2} \
    CONFIG.ADC_Data_Width20 {2} \
    CONFIG.ADC_Data_Width22 {2} \
    CONFIG.ADC_Data_Width30 {2} \
    CONFIG.ADC_Data_Width32 {2} \
    CONFIG.ADC_Decimation_Mode00 {4} \
    CONFIG.ADC_Decimation_Mode02 {4} \
    CONFIG.ADC_Decimation_Mode10 {4} \
    CONFIG.ADC_Decimation_Mode12 {4} \
    CONFIG.ADC_Decimation_Mode20 {4} \
    CONFIG.ADC_Decimation_Mode22 {4} \
    CONFIG.ADC_Decimation_Mode30 {4} \
    CONFIG.ADC_Decimation_Mode32 {4} \
    CONFIG.ADC_Mixer_Type00 {2} \
    CONFIG.ADC_Mixer_Type02 {2} \
    CONFIG.ADC_Mixer_Type10 {2} \
    CONFIG.ADC_Mixer_Type12 {2} \
    CONFIG.ADC_Mixer_Type20 {2} \
    CONFIG.ADC_Mixer_Type22 {2} \
    CONFIG.ADC_Mixer_Type30 {2} \
    CONFIG.ADC_Mixer_Type32 {2} \
    CONFIG.ADC_NCO_Freq00 {1.0} \
    CONFIG.DAC0_Clock_Source {6} \
    CONFIG.DAC0_Multi_Tile_Sync {true} \
    CONFIG.DAC1_Clock_Source {6} \
    CONFIG.DAC1_Multi_Tile_Sync {true} \
    CONFIG.DAC2_Clock_Dist {2} \
    CONFIG.DAC2_Multi_Tile_Sync {true} \
    CONFIG.DAC2_PLL_Enable {true} \
    CONFIG.DAC2_Refclk_Freq {500.000} \
    CONFIG.DAC3_Clock_Source {6} \
    CONFIG.DAC3_Multi_Tile_Sync {true} \
    CONFIG.DAC_Data_Type00 {0} \
    CONFIG.DAC_Data_Type10 {0} \
    CONFIG.DAC_Data_Type12 {0} \
    CONFIG.DAC_Data_Width00 {2} \
    CONFIG.DAC_Data_Width02 {2} \
    CONFIG.DAC_Data_Width10 {2} \
    CONFIG.DAC_Data_Width12 {2} \
    CONFIG.DAC_Data_Width20 {2} \
    CONFIG.DAC_Data_Width22 {2} \
    CONFIG.DAC_Data_Width30 {2} \
    CONFIG.DAC_Data_Width32 {2} \
    CONFIG.DAC_Interpolation_Mode00 {4} \
    CONFIG.DAC_Interpolation_Mode02 {4} \
    CONFIG.DAC_Interpolation_Mode10 {4} \
    CONFIG.DAC_Interpolation_Mode12 {4} \
    CONFIG.DAC_Interpolation_Mode20 {4} \
    CONFIG.DAC_Interpolation_Mode22 {4} \
    CONFIG.DAC_Interpolation_Mode30 {4} \
    CONFIG.DAC_Interpolation_Mode32 {4} \
    CONFIG.DAC_Mixer_Type00 {2} \
    CONFIG.DAC_Mixer_Type02 {2} \
    CONFIG.DAC_Mixer_Type10 {2} \
    CONFIG.DAC_Mixer_Type12 {2} \
    CONFIG.DAC_Mixer_Type20 {2} \
    CONFIG.DAC_Mixer_Type22 {2} \
    CONFIG.DAC_Mixer_Type30 {2} \
    CONFIG.DAC_Mixer_Type32 {2} \
  ] $rfdc

  # Apply the AXI-stream clock rates after the converter datapaths are configured.
  set stream_clocks {}
  foreach tile {0 1 2 3} {
    lappend stream_clocks CONFIG.ADC${tile}_Outclk_Freq 250.000 \
      CONFIG.DAC${tile}_Outclk_Freq 250.000
  }
  set_property -dict $stream_clocks $rfdc


  # Create instance: sysref_capture
  create_hier_cell_sysref_capture [current_bd_instance .] sysref_capture

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: irq_concat, and set properties
  set irq_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_concat ]

  # Create instance: axi_intc, and set properties
  set axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc ]
  set_property CONFIG.C_IRQ_CONNECTION {1} $axi_intc


  # Create instance: signal_capture
  create_hier_cell_signal_capture [current_bd_instance .] signal_capture

  # Create instance: clkwiz_250, and set properties
  set clkwiz_250 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clkwiz_250 ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {20.0} \
    CONFIG.CLKOUT1_DRIVES {Buffer} \
    CONFIG.CLKOUT1_JITTER {76.935} \
    CONFIG.CLKOUT1_PHASE_ERROR {70.309} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
    CONFIG.CLKOUT2_DRIVES {Buffer} \
    CONFIG.CLKOUT3_DRIVES {Buffer} \
    CONFIG.CLKOUT4_DRIVES {Buffer} \
    CONFIG.CLKOUT5_DRIVES {Buffer} \
    CONFIG.CLKOUT6_DRIVES {Buffer} \
    CONFIG.CLKOUT7_DRIVES {Buffer} \
    CONFIG.CLK_OUT1_PORT {clk_250} \
    CONFIG.JITTER_SEL {Min_O_Jitter} \
    CONFIG.MMCM_BANDWIDTH {HIGH} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {6.375} \
    CONFIG.MMCM_CLKIN1_PERIOD {2.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.375} \
    CONFIG.MMCM_DIVCLK_DIVIDE {2} \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {true} \
    CONFIG.PRIM_IN_FREQ {500} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
  ] $clkwiz_250


  # Create instance: reset_250M, and set properties
  set reset_250M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_250M ]

  # Create instance: signal_player
  create_hier_cell_signal_player [current_bd_instance .] signal_player

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [list \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {1} \
  ] $axi_smc


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create interface connections
  connect_bd_intf_net -intf_net AXIS_ADC_12_1 [get_bd_intf_pins signal_capture/AXIS_ADC_12] [get_bd_intf_pins rfdc/m12_axis]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins signal_capture/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net adc2_clk_1 [get_bd_intf_ports adc2_clk] [get_bd_intf_pins rfdc/adc2_clk]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins rfdc/s_axi]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins sysref_capture/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins axi_intc/s_axi]
  connect_bd_intf_net -intf_net dac2_clk_1 [get_bd_intf_ports dac2_clk] [get_bd_intf_pins rfdc/dac2_clk]
  connect_bd_intf_net -intf_net pl_clk_0_1 [get_bd_intf_ports pl_clk] [get_bd_intf_pins sysref_capture/pl_clk]
  connect_bd_intf_net -intf_net pl_sysref_0_1 [get_bd_intf_ports pl_sysref] [get_bd_intf_pins sysref_capture/pl_sysref]
  connect_bd_intf_net -intf_net rfdc_m02_axis [get_bd_intf_pins rfdc/m02_axis] [get_bd_intf_pins signal_capture/AXIS_ADC_02]
  connect_bd_intf_net -intf_net rfdc_m22_axis [get_bd_intf_pins rfdc/m22_axis] [get_bd_intf_pins signal_capture/AXIS_ADC_22]
  connect_bd_intf_net -intf_net rfdc_m32_axis [get_bd_intf_pins rfdc/m32_axis] [get_bd_intf_pins signal_capture/AXIS_ADC_32]
  connect_bd_intf_net -intf_net rfdc_vout02 [get_bd_intf_ports vout02] [get_bd_intf_pins rfdc/vout02]
  connect_bd_intf_net -intf_net rfdc_vout12 [get_bd_intf_ports vout12] [get_bd_intf_pins rfdc/vout12]
  connect_bd_intf_net -intf_net rfdc_vout22 [get_bd_intf_ports vout22] [get_bd_intf_pins rfdc/vout22]
  connect_bd_intf_net -intf_net rfdc_vout32 [get_bd_intf_ports vout32] [get_bd_intf_pins rfdc/vout32]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_00 [get_bd_intf_pins signal_player/AXIS_DAC_00] [get_bd_intf_pins rfdc/s00_axis]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_01 [get_bd_intf_pins signal_player/AXIS_DAC_02] [get_bd_intf_pins rfdc/s02_axis]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_10 [get_bd_intf_pins signal_player/AXIS_DAC_10] [get_bd_intf_pins rfdc/s10_axis]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_11 [get_bd_intf_pins signal_player/AXIS_DAC_12] [get_bd_intf_pins rfdc/s12_axis]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_20 [get_bd_intf_pins signal_player/AXIS_DAC_20] [get_bd_intf_pins rfdc/s20_axis]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_21 [get_bd_intf_pins signal_player/AXIS_DAC_22] [get_bd_intf_pins rfdc/s22_axis]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_30 [get_bd_intf_pins signal_player/AXIS_DAC_30] [get_bd_intf_pins rfdc/s30_axis]
  connect_bd_intf_net -intf_net signal_player_AXIS_DAC_32 [get_bd_intf_pins signal_player/AXIS_DAC_32] [get_bd_intf_pins rfdc/s32_axis]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins signal_player/S_AXI]
  connect_bd_intf_net -intf_net sysref_in_1 [get_bd_intf_ports sysref_in] [get_bd_intf_pins rfdc/sysref_in]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m00_axis [get_bd_intf_pins rfdc/m00_axis] [get_bd_intf_pins signal_capture/AXIS_ADC_00]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m10_axis [get_bd_intf_pins rfdc/m10_axis] [get_bd_intf_pins signal_capture/AXIS_ADC_10]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m20_axis [get_bd_intf_pins rfdc/m20_axis] [get_bd_intf_pins signal_capture/AXIS_ADC_20]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_m30_axis [get_bd_intf_pins rfdc/m30_axis] [get_bd_intf_pins signal_capture/AXIS_ADC_30]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout00 [get_bd_intf_ports vout00] [get_bd_intf_pins rfdc/vout00]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout10 [get_bd_intf_ports vout10] [get_bd_intf_pins rfdc/vout10]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout20 [get_bd_intf_ports vout20] [get_bd_intf_pins rfdc/vout20]
  connect_bd_intf_net -intf_net usp_rf_data_converter_0_vout30 [get_bd_intf_ports vout30] [get_bd_intf_pins rfdc/vout30]
  connect_bd_intf_net -intf_net vin00_1 [get_bd_intf_ports vin00] [get_bd_intf_pins rfdc/vin00]
  connect_bd_intf_net -intf_net vin02_0_1 [get_bd_intf_ports vin02] [get_bd_intf_pins rfdc/vin02]
  connect_bd_intf_net -intf_net vin10_1 [get_bd_intf_ports vin10] [get_bd_intf_pins rfdc/vin10]
  connect_bd_intf_net -intf_net vin12_0_1 [get_bd_intf_ports vin12] [get_bd_intf_pins rfdc/vin12]
  connect_bd_intf_net -intf_net vin20_1 [get_bd_intf_ports vin20] [get_bd_intf_pins rfdc/vin20]
  connect_bd_intf_net -intf_net vin22_0_1 [get_bd_intf_ports vin22] [get_bd_intf_pins rfdc/vin22]
  connect_bd_intf_net -intf_net vin30_1 [get_bd_intf_ports vin30] [get_bd_intf_pins rfdc/vin30]
  connect_bd_intf_net -intf_net vin32_0_1 [get_bd_intf_ports vin32] [get_bd_intf_pins rfdc/vin32]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM1_FPD [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]

  # Create port connections
  connect_bd_net -net axi_intc_irq  [get_bd_pins axi_intc/irq] \
  [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net clkwiz_250_clk_250  [get_bd_pins clkwiz_250/clk_250] \
  [get_bd_pins reset_250M/slowest_sync_clk] \
  [get_bd_pins signal_capture/m_axis_aclk] \
  [get_bd_pins signal_player/s_axis_aclk] \
  [get_bd_pins smartconnect_0/aclk] \
  [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk]
  connect_bd_net -net clkwiz_250_locked  [get_bd_pins clkwiz_250/locked] \
  [get_bd_pins reset_250M/dcm_locked]
  connect_bd_net -net irq_concat_dout  [get_bd_pins irq_concat/dout] \
  [get_bd_pins axi_intc/intr]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_pins sysref_capture/s_axi_resetn] \
  [get_bd_pins rfdc/s_axi_aresetn] \
  [get_bd_pins axi_intc/s_axi_aresetn] \
  [get_bd_pins axi_smc/aresetn]
  connect_bd_net -net reset_250M_peripheral_aresetn  [get_bd_pins reset_250M/peripheral_aresetn] \
  [get_bd_pins signal_capture/m_axis_aresetn] \
  [get_bd_pins signal_player/s_axis_aresetn] \
  [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net s_axi_aclk_1  [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
  [get_bd_pins sysref_capture/s_axi_aclk] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins rfdc/s_axi_aclk] \
  [get_bd_pins axi_intc/s_axi_aclk] \
  [get_bd_pins axi_smc/aclk] \
  [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
  connect_bd_net -net sysref_capture_irq  [get_bd_pins sysref_capture/irq] \
  [get_bd_pins irq_concat/In0]
  connect_bd_net -net sysref_capture_user_aresetn  [get_bd_pins sysref_capture/user_aresetn] \
  [get_bd_pins rfdc/m0_axis_aresetn] \
  [get_bd_pins rfdc/m1_axis_aresetn] \
  [get_bd_pins rfdc/m2_axis_aresetn] \
  [get_bd_pins rfdc/m3_axis_aresetn] \
  [get_bd_pins rfdc/s0_axis_aresetn] \
  [get_bd_pins rfdc/s1_axis_aresetn] \
  [get_bd_pins rfdc/s2_axis_aresetn] \
  [get_bd_pins rfdc/s3_axis_aresetn] \
  [get_bd_pins signal_capture/s_axis_aresetn] \
  [get_bd_pins clkwiz_250/resetn] \
  [get_bd_pins signal_player/m_axis_aresetn]
  connect_bd_net -net sysref_capture_user_clk  [get_bd_pins sysref_capture/user_clk] \
  [get_bd_pins rfdc/m0_axis_aclk] \
  [get_bd_pins rfdc/m1_axis_aclk] \
  [get_bd_pins rfdc/m2_axis_aclk] \
  [get_bd_pins rfdc/m3_axis_aclk] \
  [get_bd_pins rfdc/s0_axis_aclk] \
  [get_bd_pins rfdc/s1_axis_aclk] \
  [get_bd_pins rfdc/s2_axis_aclk] \
  [get_bd_pins rfdc/s3_axis_aclk] \
  [get_bd_pins signal_capture/s_axis_aclk] \
  [get_bd_pins clkwiz_250/clk_in1] \
  [get_bd_pins signal_player/m_axis_aclk]
  connect_bd_net -net sysref_capture_user_sysref  [get_bd_pins sysref_capture/user_sysref] \
  [get_bd_pins rfdc/user_sysref_adc] \
  [get_bd_pins rfdc/user_sysref_dac]
  connect_bd_net -net usp_rf_data_converter_0_irq  [get_bd_pins rfdc/irq] \
  [get_bd_pins irq_concat/In1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0  [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in] \
  [get_bd_pins reset_250M/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0xA0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0xB0020000 -range 0x00002000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_00/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB0022000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_1 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_02/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB0024000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_2 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_10/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB0026000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_3 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_12/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB0028000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_4 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_20/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB002A000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_5 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_22/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB002C000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_6 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_30/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB002E000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_7 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/adc_32/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xB0030000 -range 0x00002000 -with_name SEG_bram_ctrl_Mem0_8 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_player/bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0xA0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs sysref_capture/clkwiz/s_axi_lite/Reg] -force
  assign_bd_address -offset 0xB0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_player/gpio_enable/S_AXI/Reg] -force
  assign_bd_address -offset 0xA0000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rfdc/s_axi/Reg] -force
  assign_bd_address -offset 0xB0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs signal_capture/signal_capture_trigger/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################


create_root_design ""
