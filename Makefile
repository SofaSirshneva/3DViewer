BUILD_DIR := build

.PHONY: all tests app install clang clean

SRC := $(wildcard ./Controller/*.cc) \
       $(wildcard ./Controller/*.h) \
       $(wildcard ./Model/*.cc) \
	   $(wildcard ./Model/*.h) \
       $(wildcard ./View/*.cc) \
	   $(wildcard ./View/*.h) \
       $(wildcard ./tests/*.cc)

all: install tests

banner:
	@echo "\033[1;31m _  _ ____ ____ ____ _ _ ___  _ ___     |    ____ _ _  _ ____ ____    _ ____ _  _\033[0m"  \
	&& echo "\033[1;31m |-:_ |--| |--< |===  Y  |--' | |==] -- | -- |--| | |\/| |=== |=== ___| [__] |--|\033[0m"\
	&& echo "\033[1;32m                                                              ▀▀,    \033[0m"\
	&& echo "\033[1;32m                                                               j▓µ\033[0m"\
	&& echo "\033[1;32m                                                                └║▓\033[0m"\
	&& echo "\033[1;32m                               ╫▓   ║▓                           ║▓\033[0m"\
	&& echo "\033[1;32m                              ▓██╓▄▓██            ╓╓╓╓╓╓╓╓-        ▓▌\033[0m"\
	&& echo "\033[1;32m                          Æ▄▄╬╬╬╬╬╬╬╬╬▄▄▄L     ▄▄▄▓▓▓▓▓███▓▄     ╔▄╙└\033[0m"\
	&& echo "\033[1;32m                       ▓▓▓▓▓╬╬╠▓█╠╣█▌╠████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▓   ╟▓\033[0m"\
	&& echo "\033[1;32m                  ,╫▓▓▓▓▌╠╠╠╠╠╠╠╠╠╠╠╠█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▌\033[0m"\
	&& echo "\033[1;32m                ▄▄╬╬╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▌\033[0m"\
	&& echo "\033[1;32m              @▓█▓╠╠╠▓▓▓▓▓▓▓   ╫▓▓▓▓▓▓████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓└\033[0m"\
	&& echo "\033[1;32m              ╫██▓▓▓▓             j█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓⌐\033[0m"\
	&& echo "\033[1;32m                                  j███▀▀▓▓▓       █████▓▓▓▓▓─\033[0m"\
	&& echo "\033[1;32m                                  j█▌╙  ▓▓▓       ███▌╙▓▓▓▌└\033[0m"\
	&& echo "\033[1;32m                                   ▓▓▓b ▓▓▓▌      ╫▓█▌ ▐▓▓▓\033[0m"

testing_banner:
	@echo "\033[1;33m  _____           _           _     _______        _   _                \033[0m" \
	&& echo "\033[1;33m |  __ \         (_)         | |   |__   __|      | | (_)               \033[0m" \
	&& echo "\033[1;33m | |__) | __ ___  _  ___  ___| |_     | | ___  ___| |_ _ _ __   __ _    \033[0m" \
	&& echo "\033[1;33m |  ___/ '__/ _ \| |/ _ \/ __| __|    | |/ _ \/ __| __| | '_ \ / _\` |   \033[0m" \
	&& echo "\033[1;33m | |   | | | (_) | |  __/ (__| |_     | |  __/\__ \ |_| | | | | (_| |   \033[0m" \
	&& echo "\033[1;33m |_|   |_|  \___/| |\___|\___|\__|    |_|\___||___/\__|_|_| |_|\__, |   \033[0m" \
	&& echo "\033[1;33m                _/ |                                            __/ |   \033[0m" \
	&& echo "\033[1;33m               |__/                                            |___/    \033[0m"

cow:
	@echo "\033[1;34m ______\033[0m" \
	&& echo "\033[1;34m/ why? \ \033[0m" \
	&& echo "\033[1;34m\      /\033[0m" \
	&& echo "\033[1;34m ------\033[0m" \
	&& echo "\033[1;34m        \   ^__^\033[0m" \
	&& echo "\033[1;34m         \  (oo)\_______\033[0m" \
	&& echo "\033[1;34m            (__)\       )\/\\033[0m" \
	&& echo "\033[1;34m                ||----w |\033[0m" \
	&& echo "\033[1;34m                ||     ||    \033[0m"

install: banner
	@mkdir -p $(BUILD_DIR) \
	&& cd $(BUILD_DIR) \
	&& echo "\033[42;34m[+]::Building application. Please, wait! ...\033[0m" \
	&& mkdir bin \
	&& cmake -Wno-dev .. >/dev/null \
 	&& make 2>&1 | awk -F'[][]' '/\[ *[0-9]+%\]/ { printf "\r[%s]", $$2; fflush(stdout) } END { print "" }' \
	&& mv 3dViewer.app ./bin/ \
	&& cd ../  \
	&& sleep 1
	@open ./build/bin/3dViewer.app \
	&& echo "\033[42;34m[+]::Application Installed DONE \033[0m" \
	&& make clean

run:
	@if [ ! -d "./build/bin/3dViewer.app" ]; then \
	echo "\033[42;34m[!]::Application is not installed. Do you want to install it? [y/n]\033[0m"; \
	read -r choice; \
	if [ "$$choice" = "y" ]; then \
	make install; \
	else \
	make cow; \
	fi; \
	else \
	open ./build/bin/3dViewer.app; \
	fi

uninstall: cow
	@rm -rf ./build \
	@echo "\033[43;31m[+]::Application Removed DONE\033[0m"

tests: testing_banner clang
	@mkdir -p $(BUILD_DIR) && cd $(BUILD_DIR) \
	&& echo "\033[42;34m[+]::Testing started. Please, wait! ...\033[0m" \
	&& mkdir bin \
	&& cmake .. -Wno-dev .. >/dev/null \
	&& make 2>&1 | awk -F'[][]' '/\[ *[0-9]+%\]/ { printf "\r[%s]", $$2; fflush(stdout) } END { print "" }' \
	&& mv 3dViewer_Tests ./bin/ \
	&& cd ../
	@./build/bin/3dViewer_Tests
	@rm -rf ./build
	@echo "\033[42;34m[+]::GOOGLE_TESTS DONE\033[0m"
	@echo "\033[43;31m[+]::Build Removed DONE\033[0m"

dvi:
	@open README.md

dist:
	@cd ../ && tar -cvf 3dViewer_Project.tar src

clang:
	@cp ../materials/linters/.clang-format ./.clang-format
	@clang-format -n $(SRC)
	@clang-format -n $(SRC)
	@rm .clang-format
	@echo "\033[43;32m[+]::ClangFormat DONE\033[0m"

clean:
	@cd $(BUILD_DIR) \
	&& rm -rf .generated .qt .qt_plugins .rcc CMakeFiles 3dViewer_autogen \
	cmake_install.cmake CMakeCache.txt qmltypes meta_types \
	3dviewer_qmltyperegistrations.cpp Example \
	&& cd ../../ \
	&& rm -rf build-src-Qt_6_4_2_for_macOS_qt_qt6-Debug
	@echo "\033[43;31m[+]::Cleaning Trash DONE\033[0m"

