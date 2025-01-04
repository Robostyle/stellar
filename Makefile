draw := $(realpath keymap-drawer)
config := $(realpath config/boards/shields/stellar)

$(info "test: $(draw)")

draw:
	keymap -c "$(draw)/config.yaml" parse -z "$(config)/stellar.keymap" >"$(draw)/base.yaml" && \
	keymap -c "$(draw)/config.yaml" draw "$(draw)/base.yaml" -j "$(draw)/stellar.json" >"$(draw)/base.svg" && \
	/Applications/Zen\ Browser.app/Contents/MacOS/zen "file:///$(draw)/base.svg"

clean:
	@rm -rf build
