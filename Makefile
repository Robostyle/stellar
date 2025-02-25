deploy_dir := "firmware"
config_dir := "config"

config_path := $(abspath config)
build_path := $(abspath build)
deploy_path := $(abspath $(deploy_dir))
draw_path := $(abspath keymap-drawer)
draw_config_path := $(abspath $(config_path)/boards/shields/stellar)

define INIT_PYTHON_VENV
	if [[ "$$VIRTUAL_ENV" == "" ]]; then									\
		source .venv/bin/activate;	 										\
	fi
endef

define info_log
	echo -e "\033[32;1m*** $1\033[0m"
endef

# Deploys the given halve.
#
# Argument 1: halve to deploy.
#
define DEPLOY_HALVE
	$(call info_log,$1 halve deployed to $(deploy_dir));					\
	mkdir -p $(deploy_path);												\
	cp $(build_path)/$1/zephyr/zmk.uf2 $(deploy_path)/firmware_$1.uf2
endef

.PHONY: all
all: deploy

.PHONY: init
init: init-west init-zmk


.PHONY: init-west
init-west:
	@if [ ! -d ".venv" ]; then 												\
		$(call info_log,installing Python venv and west);					\
		python3 -m venv .venv;												\
		source .venv/bin/activate;	 										\
		pip install west;													\
	else																	\
		$(call info_log,West is installed);									\
	fi


.PHONY: init-zmk
init-zmk:
	@if [ ! -d ".west" ]; then 												\
		$(call info_log,installing ZMK);									\
		$(call INIT_PYTHON_VENV);											\
		west init -l config;												\
		west update;														\
		west zephyr-export;													\
		pip install -r zephyr/scripts/requirements.txt;						\
	else																	\
		$(call info_log,ZMK is installed);									\
	fi


.PHONY: build-full
build-full: build-left-full build-right-full

.PHONY: build-left-full
build-left-full: init
	@$(call info_log,Building left halve);									\
	$(call INIT_PYTHON_VENV);												\
	west build -s zmk/app -p -d $(build_path)/left -b nice_nano_v2			\
		-- -DSHIELD=stellar_left -DZMK_CONFIG=$(config_path)

.PHONY: build-right-full
build-right-full: init
	@$(call info_log,Building right halve);									\
	$(call INIT_PYTHON_VENV);												\
	west build -s zmk/app -p -d $(build_path)/right -b nice_nano_v2			\
		-- -DSHIELD=stellar_right -DZMK_CONFIG=$(config_path)


.PHONY: build
build: init-west clean-deploy build-left build-right

.PHONY: build-left
build-left:
	@$(call info_log,Building left halve (incremental));					\
	$(call INIT_PYTHON_VENV);												\
	west build -d $(build_path)/left;										\
	$(call DEPLOY_HALVE,left)

.PHONY: build-right
build-right:
	@$(call info_log,Building right halve (incremental));					\
	$(call INIT_PYTHON_VENV);												\
	west build -d $(build_path)/right;										\
	$(call DEPLOY_HALVE,right)


.PHONY: deploy
deploy: build-full
	@$(call info_log,Deploying halves into $(deploy_path)); 				\
	$(call DEPLOY_HALVE,left);												\
	$(call DEPLOY_HALVE,right)



.PHONY: draw
draw:
	keymap -c "$(draw_path)/config.yaml" parse 								\
		-z "$(draw_config_path)/stellar.keymap" >"$(draw_path)/base.yaml"; 	\
	keymap -c "$(draw_path)/config.yaml" draw 								\
		"$(draw_path)/base.yaml" 											\
		-j "$(draw_path)/stellar.json" >"$(draw_path)/base.svg"

.PHONY: clean
clean: clean-deploy
	@rm -rf build

.PHONY: clean-deploy
clean-deploy:
	@rm -rf $(deploy_dir) 

.PHONY: clean-dist
clean-dist: clean
	@rm -rf .venv .west modules zephyr zmk
