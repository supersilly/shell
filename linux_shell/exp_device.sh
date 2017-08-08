#~/bin/bash
rm -rf dev.txt
./redis-cli hgetAll sdk_device > dev.txt
sed -i '/^{/!d' dev.txt
