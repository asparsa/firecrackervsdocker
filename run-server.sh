arch=`uname -m`
dest_kernel="hello-vmlinux.bin"
dest_rootfs="hello-rootfs.ext4"
image_bucket_url="https://s3.amazonaws.com/spec.ccfc.min/img/quickstart_guide/$arch"

if [ ${arch} = "x86_64" ]; then
	    kernel="${image_bucket_url}/kernels/vmlinux.bin"
	        rootfs="${image_bucket_url}/rootfs/bionic.rootfs.ext4"
	elif [ ${arch} = "aarch64" ]; then
		    kernel="${image_bucket_url}/kernels/vmlinux.bin"
		        rootfs="${image_bucket_url}/rootfs/bionic.rootfs.ext4"
		else
			    echo "Cannot run firecracker on $arch architecture!"
			        exit 1
fi

arch=`uname -m`
kernel_path=$(pwd)"/hello-vmlinux.bin"

if [ ${arch} = "x86_64" ]; then
	    curl --unix-socket /tmp/firecracker.socket -i \
		          -X PUT 'http://localhost/boot-source'   \
			        -H 'Accept: application/json'           \
				      -H 'Content-Type: application/json'     \
				            -d "{
	                \"kernel_image_path\": \"${kernel_path}\",
			            \"boot_args\": \"console=ttyS0 reboot=k panic=1 pci=off\"
				           }"
			   elif [ ${arch} = "aarch64" ]; then
				       curl --unix-socket /tmp/firecracker.socket -i \
					             -X PUT 'http://localhost/boot-source'   \
						           -H 'Accept: application/json'           \
							         -H 'Content-Type: application/json'     \
								       -d "{
				                   \"kernel_image_path\": \"${kernel_path}\",
						               \"boot_args\": \"keep_bootcon console=ttyS0 reboot=k panic=1 pci=off\"
							              }"
						      else
							          echo "Cannot run firecracker on $arch architecture!"
								      exit 1
fi

rootfs_path=$(pwd)"/hello-rootfs.ext4"
curl --unix-socket /tmp/firecracker.socket -i \
	  -X PUT 'http://localhost/drives/rootfs' \
	    -H 'Accept: application/json'           \
	      -H 'Content-Type: application/json'     \
	        -d "{
        \"drive_id\": \"rootfs\",
	        \"path_on_host\": \"${rootfs_path}\",
		        \"is_root_device\": true,
			        \"is_read_only\": false
				   }"

boot_args="ip=192.168.0.2:::255.255.255.0::eth0:off"

curl --unix-socket ${api_sock} -i  \
	           -X PUT "http://localhost/boot-source" \
		              -H "accept: application/json" \
			                 -H "Content-Type: application/json" \
					            -d "{
                  \"boot_args\": \"${boot_args}\",
		                    \"kernel_image_path\": \"${kernel}\"
				                  }"

curl --unix-socket /tmp/firecracker.socket -i \
	  -X PUT 'http://localhost/network-interfaces/eth0' \
	    -H 'Accept: application/json' \
	      -H 'Content-Type: application/json' \
	        -d '{
      "iface_id": "eth0",
            "guest_mac": "AA:FC:00:00:00:01",
	          "host_dev_name": "tap0"
		      }'



curl --unix-socket /tmp/firecracker.socket -i  \
	  -X PUT 'http://localhost/machine-config' \
	    -H 'Accept: application/json'            \
	      -H 'Content-Type: application/json'      \
	        -d '{
      "vcpu_count": 8,
            "mem_size_mib": 16384
	      }'

curl --unix-socket /tmp/firecracker.socket -i \
	  -X PUT 'http://localhost/actions'       \
	    -H  'Accept: application/json'          \
	      -H  'Content-Type: application/json'    \
	        -d '{
      "action_type": "InstanceStart"
         }'

