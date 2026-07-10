import logging
from logging.handlers import RotatingFileHandler
from waitress import serve
from api import app

# ---------- Logging ----------
formatter = logging.Formatter(
    "%(asctime)s | %(levelname)s | %(message)s"
)

file_handler = RotatingFileHandler(
    "server_logs.txt",
    maxBytes=10 * 1024 * 1024,   # 10 MB
    backupCount=5,
    encoding="utf-8"
)
file_handler.setFormatter(formatter)

console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)

root_logger = logging.getLogger()
root_logger.setLevel(logging.INFO)
root_logger.addHandler(file_handler)
root_logger.addHandler(console_handler)

logger = logging.getLogger(__name__)

logger.info("========================================")
logger.info("Starting Waitress Server")
logger.info("Listening on http://0.0.0.0:5000")
logger.info("========================================")

if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=5000)