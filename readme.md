## IMPORTANT NOTE

GoWin Programmer is not working with linux kernel version >=5.4 (gcc >=9.3). Showing error `libftd2xx.so: undefined symbol: stime`. Check your kernel version with `cat /proc/version` command. If it's less than 5.4 only then go ahead and install it. Tested and working on Ubuntu 18.04, Ubuntu 19.10. Not working on Ubuntu 20.04 and the latest Manjaro (arch). 

One good news: You can still upload code using an open source programmer OpenFPGALoader (provided with this repo).


## About

This is my development environment for GoWin FPGA on Linux (Arch). Setting up the GoWin IDE is not trivial and takes some trial-and-error steps to make it work. At least that's my experience on Linux. 
To solve this problem, I've written a script that automates all those critical steps so that the IDE can be launched with just one command: `./main_launcher`

## Steps

#### 1. Download

**Important: This repository uses Git Large File Storage (LFS) because some files are more than 100MB in size. Follow [these simple steps](https://git-lfs.github.com/) to install git lfs extension prior to cloning/downloading this repo**

Download this repository in you PC either by downloading the .zip file or using following command:
`git clone --recurse-submodules https://github.com/abhra0897/gowin-easy-linux.git`
Then go to the downloaded folder.

#### 2.A. Set up with own License files acquired officialy

If you have acquired proper license files based on your PC's MAC address (aka host address/id) from GoWin, then follow this step, else go to step 2.B.

- Rename the license file which is for GoWin IDE  (not for Synopsis synplify pro) to `gowin.lic` . Don't change any internal content of the file. (This file has much less content inside compared to the synplify's license)
- Copy the `gowin.lic` file and paste it to `IDE/bin/` directory replacing the original file.
- Now, rename the Synplify Pro's license file (this file has more texts inside it thsn IDE's license) to `gowin_Synplifypro.lic`.
- Copy the `gowin_Synplifypro.lic` and paste it to the license server's directory:  `GowinLicenseServerForLinux/SCLPortableVersion/linux64/bin/`, replacing the original one.

*[**Note:** Instead of renaming your license files and replacing the original ones, you can change `SYNPLIFY_LIC_DIR`, `IDE_LIC_DIR` values in the script with your licenses' directory, and `SYNPLIFY_LIC_FILE_NAME`, `IDE_LIC_FILE_NAME` values with the license file names.]*

#### 2.B. Set up with License files provided with this repo

If you don't have your own license files already, then follow this step to use the license files provided with this repository. If you have your machine's MAC based license, go to Step 2.A.

- To use the provided licenses, you need to change your PC's MAC address (host id) so that matches with the license files.
	- **Using `ifconfig`** :
		- `sudo ifconfig <interface_name> down`
		- `sudo ifconfig <interface_name> hw ether 94:C6:91:A9:1E:B6`
		- `sudo ifconfig <interface_name> up`
	- **Using `ip`** :
		- `sudo ip link set dev <interface_name> down`
		- `sudo ip link set dev <interface_name> address 94:C6:91:A9:1E:B6`
		- `sudo ip link set dev <interface_name> up`

*[**Note:** This change is temporary. After every reboot you need to change your MAC using the above commands. Either make the change permanent by editing /etc/network/interface file or get your own license files from [GoWin](https://www.gowinsemi.com/en/support/license/ "GoWin") and follow Step 2.A]*

#### 3. Run the launcher script

This is the last step. Open a terminal in the repo's directory and run the script with `./main_launcher` command.
You may run it with `sudo` too if facing permission related errors.


## Solving Problems

You may face some problems during the entire process. Some common problems and their possible solutions are discussed here. If you can't solve yours, open an issue.

1. **GoWin IDE/Synplify Pro can't find license**:

	Many things can possibly went wrong here.
	- If you're using your own license files, did you rename and place them in proper directories? Or did you modify the directory and file name variables in the script properly? (Described in step 2.A)
	- If you're using the licenses provided with this repo, did you change your machine's mac correctly? Use `ifconfig` or `ip a` command to see if the mac of your ethernet device is 94:C6:91:A9:1E:B6. (Described in step 2.B)
	- Did you edit anything inside the license files? Editing even a single character, no matter where you're editing it, makes the them completely invalid.

2. **Can't upload to FPGA using programmer**

	- This problem mainly occurs due to permission related issues. Running the script as `sudo ./main_launcher` solves it usually.
	- Make sure the device is connected. Use `watch lsusb` command and plug/unplug the USB cable to see if any device is added to/removed from the list. If not, restart your PC.
	- Another option to upload program to FPGA is using **openFPGALoader** program. Read the `readme.md` of openFPGALoader to know its usage.

3. **"No such file or directory" Problem**

	After running `sudo ./main_launcher`, the following error may be shown:
	`./GowinLicenseServerForLinux/SCLPortableVersion/linux64/bin/lmgrd: No such file or directory.`

	This problem mainly occurs due to missing `/lib64/ld-lsb-x86-64.so.3`. Installing `ld-lsb` will solve it.
	- Install using **apt**: `sudo apt-get install lsb`.
	- Install using **pacman**: `sudo pacman -Syu ld-lsb`.

4. **undefined symbol: FT_Done_MM_Var**

	This problem is related to the libfreetype.so.1 file stored in `IDE/lib/`. This file expects an older version of /usr/lib/libfontconfig.so.1. Deleting libfreetype.so.1 file or renaming to anything else solves this problem.

	It's recommended to update the installed freetype and fontconfig of your machine.
	- Install using **pacman**:
		- `sudo pacman -Syu freetype2`
		- `sudo pacman -Syu fontconfig`
	- Install using **apt**:
		- *Not tested yet*.

	[Note: I've already renamed the libfreetype.so.1 file to something else in the IDE/lib/ folder. So, the problem is not likely to occur]

5. **Other Problems**

	For other problems which are not covered here, you can simply google them. All the above solutions are found by googling extensively. If you're out of luck, open an issue and together we can try yo solve it.

## Important Links

If you want to download and install the GoWin SDK from official site, check the following links.

- [Dowload IDE and programmer for Windows/Linux](http://www.gowinsemi.com.cn/faq.aspx)
- [ Very helpful reddit post about IDE installaion on Ubuntu ](https://www.reddit.com/r/FPGA/comments/dx8yut/gowin_ide_has_anyone_managed_to_use_it/)
- [ Apply for licenses ](https://www.gowinsemi.com/en/support/license/)
- [ Sipeed's guide on IDE installation ](https://tangnano.sipeed.com/en/get_started/install-the-ide.html)
- [ Download everything including readymade licenses (needs to modify your machine's MAC) ](http://dl.sipeed.com/TANG/Nano/IDE)
