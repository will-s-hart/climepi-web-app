"""
Python script to start a Dask local cluster.
"""

import logging
import sys
import time

from climepi.app import DASK_SCHEDULER_ADDRESS, DASK_SCHEDULER_PORT
from dask.distributed import LocalCluster


def get_logger(name):
    """Set up logger."""
    _logger = logging.getLogger(name)
    _logger.handlers.clear()
    handler = logging.StreamHandler()
    handler.setStream(sys.stdout)
    formatter = logging.Formatter(
        "%(asctime)s | %(levelname)s | %(name)s | %(message)s"
    )
    handler.setFormatter(formatter)
    _logger.addHandler(handler)
    _logger.propagate = False
    _logger.setLevel(logging.INFO)
    return _logger


if __name__ == "__main__":
    logger = get_logger(name="cluster")
    logger.info("Starting Dask local cluster")
    cluster = LocalCluster(scheduler_port=DASK_SCHEDULER_PORT)
    logger.info(
        "Dask local cluster started at %s with %s workers",
        DASK_SCHEDULER_ADDRESS,
        len(cluster.workers),
    )
    while True:
        time.sleep(3600)  # Sleep for 1 hour, then continue sleeping
