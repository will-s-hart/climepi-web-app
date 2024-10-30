"""Python script defining the web app."""

import logging
import os
import pathlib

from climepi import climdata
from climepi.app import get_app
from dask.distributed import Client

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

try:
    dask_scheduler_address = os.environ["DASK_SCHEDULER_ADDRESS"]
except KeyError as e:
    raise ValueError("DASK_SCHEDULER_ADDRESS environment variable not set") from e
client = Client(dask_scheduler_address)
logger.info(
    "Dask client connected to cluster at {%s} with {%s} workers",
    dask_scheduler_address,
    len(client.ncores()),
)

clim_dataset_example_base_dir = pathlib.Path(__file__).parents[1] / "data"
clim_dataset_example_names = [
    name
    for name, details in climdata.EXAMPLES.items()
    if details.get("formatted_data_downloadable", False)
]
get_app(
    clim_dataset_example_base_dir=clim_dataset_example_base_dir,
    clim_dataset_example_names=clim_dataset_example_names,
).servable()
