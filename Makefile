draw := keymap-drawer
config := config/boards/shields/stellar

draw:
	#!/usr/bin/env bash
	set -euo pipefail
	keymap -c "$(draw)/config.yaml" parse -z "$(config)/stellar.keymap" >"$(draw)/base.yaml"
	keymap -c "$(draw)/config.yaml" draw "$(draw)/base.yaml" -j "$(draw)/stellar.json" >"$(draw)/base.svg"

clean:
	@rm -rf build
