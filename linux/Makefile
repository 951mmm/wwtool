usr_home := $(HOME)
usr_bin_path := $(usr_home)/.local/bin
pwd := $(PWD)

all: install

.PHONY: install
install: install_nvim \
	install_common \
	install_desktop
	@echo "install done"

## ANCHOR nvim
nvim_bin_path := $(pwd)/nvim-linux-x86_64/bin/nvim 
nvim_dst_path := $(usr_bin_path)/nvim

install_nvim: uninstall_nvim
	@ln -sf $(nvim_bin_path) $(nvim_dst_path) 
	@echo nvim done

uninstall_nvim:
	@rm -f $(nvim_dst_path)

## ANCHOR common
src := ./sbom-scanner-linux-amd64 \
			 ./async-profiler-4.1-linux-x64/bin/asprof
src := $(addprefix $(pwd)/, $(src))

dst := sbom-scanner \
			 asprof
dst := $(addprefix $(usr_bin_path)/, $(dst))

define get_seq
	$(shell seq 1 $(words $(1)))
endef

# NOTE function
# ln_list
# args: [
# 	index: num, 
# 	src: list[str], 
# 	dst: lists[str]]
define ln_list
	ln -sf $(word $(1), $(2)) $(word $(1), $(3));
endef

# NOTE function
# install_list
# args: [
# 	list_installer: Fn[index: num, src: list[str], dst: list[str]], 
# 	src: list[str], 
# 	dst: list[str]]
define install_list
	$(foreach i, \
		$(call get_seq, $(3)), \
		$(call $(1), $(i), $(2), $(3)) \
		)
endef

# NOTE function
# rm_list
# args: [list: list[str]]
define rm_list
	$(foreach i, \
		$(call get_seq, $(1)), \
		sudo rm -f $(word $(i), $(1)) \
		)
endef

install_common: uninstall_common
	$(call install_list, ln_list, $(src), $(dst))
uninstall_common:
	$(call rm_list, $(dst))	

## ANCHOR desktop
desktop_dst_path := /usr/share/applications
desktop_src := ./cgroup-wrapper/idea.desktop
desktop_dst := $(notdir $(desktop_src))
desktop_dst := $(addprefix $(desktop_dst_path)/, $(desktop_dst)) 

# NOTE function
# cp_list
# only cp, don't set mask as executable
# args: [
# 	index: num,
# 	src: list[str],
# 	dst: list[str]]
define cp_txt_list
	sudo install -C $(word $(1), $(2)) $(word $(1), $(3))
endef

install_desktop: uninstall_desktop
	$(call install_list, cp_txt_list, $(desktop_src), $(desktop_dst))

uninstall_desktop:
	$(call rm_list, $(desktop_dst))


## ANCHOR sync
.PHONY: sync
sync: cfg-sync \
	proj-sync

## ANCHOR cfg sync
## WARN does not sync remote
## *ssh key*
cfg_sync_path := $(usr_home)/.config/nvim \
						 $(usr_home)/.logrotate* \
						 $(usr_home)/.ssh \
						 $(usr_home)/.bashrc \
						 $(usr_home)/.ideavimrc \
						 $(usr_home)/.vimrc \
						 $(usr_home)/.envrc \
						 $(usr_home)/.m2/settings.xml

cfg_sync_dst_path := $(pwd)/sync/cfg
# NOTE function
# sync
# args: [
# 	src: list[str],            \
# 	dst: str]
define sync
	mkdir -p $(2)
	$(foreach i, $(call get_seq, $(1)), \
		rsync -ahPv $(word $(i), $(1)) $(2);\
		)
endef
	
cfg-sync:
	$(call sync, $(cfg_sync_path), $(cfg_sync_dst_path))

## ANCHOR proj sync
proj_path := $(usr_home)/Documents/proj
proj_sync_path := $(proj_path)/benchmarks \
									$(proj_path)/stress
								
proj_sync_dst_path := $(pwd)/sync/proj
proj-sync:
	$(call sync, $(proj_sync_path), $(proj_sync_dst_path))

## ANCHOR test
define greet
	@echo Hello $(1)! age is $(2).
endef
test_path := some/path/to/file.txt
test: 
	$(call greet , a, 11)
	@echo basename is $(notdir $(test_path))
	@echo without suffix: $(basename $(test_path)) 
	@echo desktop_src is $(desktop_src)
	@echo desktop_dst is $(desktop_dst) 
	
