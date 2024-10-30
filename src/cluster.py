"""
Python script to start a Dask local cluster.
"""

import logging
import time

from climepi.app import DASK_SCHEDULER_PORT
from dask.distributed import LocalCluster

if __name__ == "__main__":
    logger = logging.getLogger(__name__)
    cluster = LocalCluster(scheduler_port=DASK_SCHEDULER_PORT)
    logger.info(
        "Dask cluster started. Check the Dask dashboard at %s.",
        {cluster.dashboard_link},
    )
    while True:
        time.sleep(3600)  # Sleep for 1 hour, then continue sleeping
