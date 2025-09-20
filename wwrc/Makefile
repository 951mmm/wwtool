all: install

.PHONY: install

install: wwrc

wwrc_src_path := ./wwrc.bash
wwrc_dst_file := .wwrc
rizhiyi_home := /home/rizhiyi
root_home := /root
wwrc_dst := rzy_179:$(rizhiyi_home) \
            rzy_41_138:$(rizhiyi_home) \
						rzy_42_250:$(rizhiyi_home) \
						rzy_110:$(rizhiyi_home) \
						root_179:$(root_home) \
						root_42_250:$(root_home) \
						root_43_196:$(root_home)

rc := rsync -ahPv -e "ssh -F $$HOME/.ssh/config"

wwrc: $(wwrc_src_path)
	@echo "开始部署到各主机..."
	$(foreach dst, $(wwrc_dst), \
		$(eval host = $(firstword $(subst :, ,$(dst)))) \
		echo "正在处理主机: $(host)"; \
		{ \
			echo "# Automatically added host info"; \
			echo "ww_host=$(host)"; \
			echo; \
			cat $(wwrc_src_path); \
		} > $(wwrc_src_path).tmp && \
		$(rc) $(wwrc_src_path).tmp $(dst)/$(wwrc_dst_file) && \
		rm -f $(wwrc_src_path).tmp; \
	)
	@echo "部署完成"

