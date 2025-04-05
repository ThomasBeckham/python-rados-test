import rados
import os

# Configuration: replace with your actual Ceph configuration
CEPH_CONF_PATH = '/etc/ceph/ceph.conf'  # Path to Ceph config file
CEPH_POOL_NAME = 'my_pool'  # The name of the pool

# Connect to the Ceph cluster
try:
    cluster = rados.Rados(conffile=CEPH_CONF_PATH)
    cluster.connect()
    print("Connected to Ceph cluster")

    # Access a pool
    ioctx = cluster.open_ioctx(CEPH_POOL_NAME)
    print(f"Accessing pool: {CEPH_POOL_NAME}")

    # Create an object (e.g., test object)
    object_name = "test_object"
    data = b'Hello, Ceph!'

    # Write an object to the pool
    ioctx.write(object_name, data)
    print(f"Written object {object_name} to the pool")

    # Read the object back
    read_data = ioctx.read(object_name)
    print(f"Read data: {read_data.decode('utf-8')}")

    # Clean up
    ioctx.remove(object_name)
    print(f"Removed object {object_name}")

except rados.Error as e:
    print(f"Error connecting to Ceph: {e}")
finally:
    # Clean up connection
    cluster.shutdown()
