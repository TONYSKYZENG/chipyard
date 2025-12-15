## Features
- Standard rocket core under RV64IMFD, without MMU
- 2KB ICache + 2KB DCache
## Memory map
Generated Address Map

	         0 -       1000 ARWX  debug-controller@0
	      1000 -       2000 ARW   boot-address-reg@1000
	      3000 -       4000 ARWX  error-device@3000
	     10000 -      20000  R X  rom@10000
	    100000 -     101000 ARW   clock-gater@100000
	    110000 -     111000 ARW   tile-reset-setter@110000
	   2000000 -    2010000 ARW   clint@2000000
	   2010000 -    2011000 ARW   cache-controller@2010000
	   8000000 -    8010000 ARWXC memory@8000000
	   c000000 -   10000000 ARW   interrupt-controller@c000000
	  10020000 -   10021000 ARW   serial@10020000
	  80000000 -   90000000 ARWXC memory@80000000
	 100000000 - 2100000000  RWX  mmio-port-axi4@100000000

## Default behavior
1. after reset (10us), the core will by hardware jump to 0x80000000
2. So 0x80000000 must be AXI4 full device with your really boot code

## How to use in vivado
- create a new project
- add src to source file directories
- add chipyard_src to to source file directories
- add tb to simulation file directories
- make sure your top module is rocket_ip_top.v for synthsis
- make sure your top module is tb_rocket.v for simulation
- run make at software, you will see a xx.hex
- modify this at tb/tb_rocket.v for the absolute path of the generated hex
```
 $readmemh("<path>/prog.hex", u_ram.mem);
 ```
- run simulation for about 20us, as rocket will only really boot after 10us
- then you can use this to pack ip 
## What if I have changed chipyard?
- remove the vivdao xpr project
- replace chipyard_src by your new genration
- re-align rocket_ip_top.v with your new DigitalTop.v
- re-create vivado project