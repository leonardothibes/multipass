NAME=$(shell sed 's/[\", ]//g' package.json | grep name | cut -d: -f2 | head -1)
DESC=$(shell sed 's/[\",]//g' package.json | grep description | cut -d: -f2 | sed -e 's/^[ \t]*//')
VERSION=$(shell sed 's/[\", ]//g' package.json | grep version | cut -d: -f2)

launch: .clear
	@multipass launch -n ${NAME} --mount ${PWD}:/home/ubuntu/scripts
	@echo ""
	@multipass ls
	@echo ""
	@multipass shell ${NAME}

stop:
	@multipass delete ${NAME}
	@multipass purge

shell:
	@multipass shell ${NAME}

.clear:
	@clear

help: .clear
	@echo "${DESC} (${NAME} - ${VERSION})"
	@echo "Uso: make [options]"
	@echo ""
	@echo "  launch             Lança um VM no Multipass com a imagem do build"
	@echo "  stop               Para a VM no Multipass"
	@echo "  shell              Obtém um shell na VM"
	@echo "  help               Exibe esta mensagem de HELP"
	@echo ""
