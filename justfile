set shell := ["bash", "-cu"]

install:
	uv pip install --upgrade pip
	uv init --name network_monitor
	uv add typer[all] httpx pytest psutil datetime

# Run with local or internet args
run *ARGS:
	.venv/bin/python main.py {{ARGS}}

test:
	.venv/bin/python -m pytest

clean:
	rm -rf .venv __pycache__ pyproject.toml uv.lock

monitor:
	bash -c ' \
		if [ -f .monitor.pid ]; then \
			PID=$(cat .monitor.pid); \
			echo "⚠️ Monitoring déjà actif avec PID: $PID"; \
		else \
			nohup .venv/bin/python main.py monitor > /dev/null 2>&1 & \
			PID=$!; echo $PID > .monitor.pid; \
			echo "✅ Monitoring lancé avec PID: $PID"; \
		fi \
	'


stop-monitor:
	if [ -f .monitor.pid ]; then \
		PID=$(cat .monitor.pid); \
		case "$PID" in \
			*[!0-9]*) \
				echo "⚠️ PID invalide trouvé dans .monitor.pid, suppression forcée."; \
				rm .monitor.pid ;; \
			*) \
				kill $PID && rm .monitor.pid && echo "🛑 Monitoring arrêté." ;; \
		esac; \
	else \
		echo "⚠️ Aucun monitoring actif."; \
	fi


status-monitor:
	bash -c ' \
		if [ -f .monitor.pid ]; then \
			PID=$(cat .monitor.pid); \
			if ps -p $PID > /dev/null 2>&1; then \
				echo "✅ Monitoring actif (PID $PID)"; \
			else \
				echo "⚠️ PID $PID mort. Supprime .monitor.pid manuellement si nécessaire."; \
			fi; \
		else \
			echo "ℹ️ Aucun fichier .monitor.pid trouvé (monitoring non lancé ?)"; \
		fi \
	'
