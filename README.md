# Distributed Systems Project 1: Bitcoin Mining

Karan Goel @karangoel16								
Siddesh Muley @siddheshmuley

# Introduction
```
In this project, we have a Banker who keeps record of all the initialization vectors(IVs) used so far. This way we send a new IV every time and always get unique hashed output which increases the possibility of getting new bitcoins.

We have a Server which does the following once started:
It waits for clients to connect and while it is waiting for a connection request, it spawns its own worker which acts exactly like any other client.
Once connected the client gets added into the node’s list and we request the core information of the client, and start the Worker processes to mine bitcoins on all cores.
Whenever a worker finds a bitcoin with the specified length of leading zeroes, it returns the bitcoin to the server and requests a new key to start mining again.'
```
# Setup Information
**Remote Setup:-**
```
1. Copy the entire Folder
2. Run command mix deps.get
3. Then get the ip address of the server computer using ifconfig or /bin/ip addr (on a linux machine)
4. Run `mix escript.build`
5. For local setup run the code on server `./project1 <leading_zeroes_in_bitcoin>`
6. For remote setup start the same code on client following steps 1-3 and then running `./project1 <server_IP_address>`

At times system doesn’t start node in that case epmd daemon and refuses the connection in that case we need to run the following command **iex --sname <Garbage name>** and close the terminal and try to run the process again.
```

# More Information
```
Work Unit: The random string generator creates 32 bit character string with the (36)^(32) possible combination. In our project each worker gets initialization vectors(IV) from the server and then works till it gets a bitcoin. So every spawned worker gets one IV(Work unit), works on it and then asks for more IVs from the server. Reason for this architecture:-

All the workers work on the parallel system and the problem given is mutually exclusive, i.e. no two workers will have same initialisation vector.Also we are hashing again on the hash after appending “karangoel16;” and clashing of hash has very low probability, this architecture will produce unique string and therefore unique bitcoins. 
Also we can add more workers in the system as it is horizontally scalable.

The result of running ./project1 4 is given below in the format specified

input--><ufid>;<initialisation_vector/previous_hash>
output--><valid_bitcoin>
karangoel16;f8ca9be2ff1b2b65198d6c38c1db0e9f5581465194516df83fe4779dfe9cde29 0000d136fcbf085d4865b8063b15ce68d9629e7aba7cb18cd723966f7d15110d
karangoel16;3d685d81744360e7ddb6a1db740df3588f977d9a85ac4c54d40b38ecfcc0e1dc 000050483ecb6ccec556cebb98fe5592ac9aa33e9845025b45ba57bbfaa15fe2
karangoel16;3f7ef65c402431074e55f2a3c8f277f670e0664d8296f547c20bcb62c883357c 0000cf299ea11541b793f6980f0631dc893a218cf481d8a486aa5303ce789d19
karangoel16;a16bf8b2e16ae2b55167f41812faeb48cb47034657b17953c050c38e6c034b6b 0000a64626ecf3b73cd421fe8ad96e5617703e6c8d4537ce9e7067953e59e14f
karangoel16;c1ad213f506b3b0c1ec255dc4cf2537fa8a862ff595887a025b210491c2dc6b6 000094f2ada083c0378a5a839c4eca73dd78ab1c8ff41eecc4e74af04fca0ded
karangoel16;249428c5831793237ec757357e77dc9723498677fb3399cfe70e6e38283653da 0000950660fed85b33e904a8d32554ec23904010593672beb9c930f181685283

```

The run-time of the program on the computer with following specs
```
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    2
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 60
Model name:            Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
Stepping:              3
CPU MHz:               2304.504
CPU max MHz:           3900.0000
CPU min MHz:           800.0000
BogoMIPS:              6799.96
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              8192K
NUMA node0 CPU(s):     0-7

We used command 
`time ./project1 4`
>real    0m15.906s
>user    1m52.804s
>sys     0m5.584s
```
**CPU TIME/REAL TIME = 7.044**

The largest key bitcoin we were able to generate using machines we had is **8**
```
karangoel16;d5dfcc9fa8a3791aeceb4125f4b1e5137caa614a6171d68326722313d320e88a 00000000bae601c3417f5b7dcb4272a5a80cf3a95f757a66299f1f4001748301
```


We were able to run code on **6 machines with 1 server and 5 client computer** each having that hardware capabilities mentioned earlier.
