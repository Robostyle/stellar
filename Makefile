draw := $(realpath keymap-drawer)
config := $(realpath config/boards/shields/stellar)

draw:
	keymap -c "$(draw)/config.yaml" parse -z "$(config)/stellar.keymap" >"$(draw)/base.yaml" && \
	keymap -c "$(draw)/config.yaml" draw "$(draw)/base.yaml" -j "$(draw)/stellar.json" >"$(draw)/base.svg"

clean:
	@rm -rf build
