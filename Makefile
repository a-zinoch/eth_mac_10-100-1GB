VC=irun
VC_FLAGS=-64bit -gui -sv -access +rwc -nowarn NONPRT -seed random -mess +bus_conflict_off\
	-v /home/users/lib_user/libraries/TSMCHOME/digital/Front_End/verilog/tpdn90fnu_sc_100a/tpdn90fnu_sc.v \
	-v /home/users/lib_user/libraries/TSMCHOME/digital/Front_End/verilog/tcbn90lpefbwp7t_130a/tcbn90lpefbwp7t.v

VIP_NAME=enet
# ace ahb apb axi can chi csi2 csi3 dp dsi enet hdmi i2c icm jtag lli mphy ocp pcie plb6 sas sata srio stream ufs unipro usb

VIP_DIR=vip_lib
WORK_DIR=run

DUT_NAME=mac_eth_kmx32_1GB
UVM_VERBOSITY=UVM_NONE

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dir $(MKFILE_PATH))
CDN_VIP_LIB_PATH := $(CURRENT_DIR)$(VIP_DIR)
CDN_VIP_UVMHOME := `${CDN_VIP_ROOT}/bin/cds_root.sh ncsim`/tools/uvm-1.1/uvm_lib/uvm_sv

CMD_FILE=cmd_file.sh

VIP_FILES=${DENALI}/ddvapi/sv/denaliMem.sv\
	${DENALI}/ddvapi/sv/denaliEnet.sv \
	${DENALI}/ddvapi/sv/uvm/enet/cdnEnetUvmTop.sv \
	${CDN_VIP_LIB_PATH}/64bit/ncsim_psui.sv

VIP_DEFINES=-define DENALI_SV_NC\
	-define DENALI_UVM\

VIP_FLASG=-top specman \
	-top specman_wave \
	-loadpli1 ${DENALI}/verilog/libdenpli.so:den_PLIPtr:export \
	-ncsimargs "-loadrun ${CDN_VIP_LIB_PATH}/64bit/libcdnvipcuvm.so" \
	-snprerun notest -snnoauto

UVM_FLAGS=-uvm +UVM_VERBOSITY=$(UVM_VERBOSITY) +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR\
	-incdir ${CDN_VIP_UVMHOME}/src ${CDN_VIP_UVMHOME}/src/uvm_pkg.sv

COVERAGE_FLAGS=-covdut $(DUT_NAME) -coverage all -covtest test1 -covscope DUT -covoverwrite

INC_DIRS = -incdir ${DENALI}/ddvapi/sv \
	-incdir ${DENALI}/ddvapi/sv/uvm/enet \
	-incdir ../../ \
	-incdir ../../../general_lib/ \
	-incdir ../../../../kmx32_periph/

TOP_FILE=../../bench/tb_top.sv

TOP_NAME=eth_1GB_tb_top

.PHONY: clean start vip_setting all

all: vip_setting check_env irun_cmd start
outside_only: vip_setting check_env irun_os_cmd start

vip_setting:
	if [ ! -d "$(VIP_DIR)" ]; then \
		echo "Compiling VIP library "; \
		${CDN_VIP_ROOT}/bin/cdn_vip_setup_env -s ncsim_irun -cdn_vip_root ${CDN_VIP_ROOT} -m sv_uvm -cdn_vip_lib $(VIP_DIR) -i $(VIP_NAME) -64; \
	fi;

	echo "source $(CURRENT_DIR)/cdn_vip_env_irun_sv_uvm_64.sh" > $(CMD_FILE);
	echo "CDN_VIP_LIB_PATH=$(CDN_VIP_LIB_PATH)" >> $(CMD_FILE);
	echo "CDN_VIP_UVMHOME=`${CDN_VIP_ROOT}/bin/cds_root.sh ncsim`/tools/uvm-1.1/uvm_lib/uvm_sv" >> $(CMD_FILE);

check_env:
	echo "${CDN_VIP_ROOT}/bin/cdn_vip_check_env -cdn_vip_root ${CDN_VIP_ROOT} \
	-sim ncsim_irun -method sv_uvm -cdn_vip_lib $(CDN_VIP_LIB_PATH) -64" >> $(CMD_FILE);

irun_cmd:
	echo "$(VC) $(VC_FLAGS) $(UVM_FLAGS) $(COVERAGE_FLAGS) $(INC_DIRS) $(VIP_FILES) $(VIP_DEFINES) $(VIP_FLASG) $(TOP_FILE) -top $(TOP_NAME)" \
		>> $(CMD_FILE);

irun_os_cmd:
	echo "$(VC) $(VC_FLAGS) $(UVM_FLAGS) $(COVERAGE_FLAGS) $(INC_DIRS) $(VIP_FILES) $(VIP_DEFINES) $(VIP_FLASG) $(TOP_FILE) -define OUTSIDE_ONLY -top $(TOP_NAME)" \
		>> $(CMD_FILE);
start:
	mkdir -p $(WORK_DIR);
	cd $(WORK_DIR); bash ../$(CMD_FILE);

clean:
	rm -rf $(VIP_DIR)
	rm -rf $(WORK_DIR)